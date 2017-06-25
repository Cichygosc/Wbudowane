library std;
use std.textio.all;
library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity controller is
	port(
		 clk : in std_logic;
		 conn_bus : inout std_logic_vector(8 downto 0);
		 --debug
		 state : out std_logic_vector(5 downto 0);
		 vq : out std_logic_vector(8 downto 0);
		 v_current_cmd : out std_logic_vector(3 downto 0);
		 --filehandle
		 f_re : out std_logic;
		 f_en : out std_logic;
		 end_of_file : in bit;
		 --memory
		 mem_we : out std_logic;
		 mem_en : out std_logic;
		 --pc
		 pc_en : out std_logic;
		 pc_state : out std_logic_vector(1 downto 0);
		 --accumlator
		 acc_val : in std_logic_vector(8 downto 0);
		 acc_en : out std_logic;
		 acc_ld : out std_logic;
		 acc_from_alu : out std_logic;
		 --alu
		 alu_op : out std_logic
		);
end controller;

architecture behavior of controller is
	type state_type is (
		IDLE,
		FETCH,
		DECODE,
		EXECUTE,
		STORE);
	signal current_state : state_type := IDLE;
	signal next_state : state_type := IDLE;
	signal v_state : std_logic_vector(5 downto 0) := (others => '0');
	signal v_twobit : std_logic_vector(1 downto 0) := (others => '0');

	type cmd_type is (NOP, LOAD, STORE, ADD, SUBT, INP, OUTP, HALT, SKIPCOND, JUMP);
	attribute enum_encoding : string;
	attribute enum_encoding of cmd_type : type is
		"0000 0001 0010 0011 0100 0101 0110 0111 1000 1001";
	signal current_cmd : cmd_type := NOP;

	signal q : std_logic_vector(8 downto 0) := (others => '0');

	signal en : std_logic := '1';

	signal result_reg : std_logic_vector(8 downto 0) := (others => '0');
	signal sending : std_logic := '0';
	--reading from file
	signal reading : bit := '0';

	--currently read instruction
	signal instruction_number : std_logic_vector(8 downto 0) := (others => '0');
	signal restore_address : std_logic := '0';

	signal current_reg : std_logic_vector(8 downto 0) := (others => '0');

begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			q <= conn_bus;
			current_state <= next_state;
		end if;
	end process;

	process(current_state, q)
		variable fourbit : std_logic_vector(3 downto 0) := "0000";
		variable twobit : std_logic_vector(1 downto 0) := "00";
		variable l : line;
		variable loaded_data : std_logic_vector(8 downto 0) := "000000000";
	begin
		case current_state is
			when IDLE => 
				v_state <= "000001";
				--stop all components
				mem_en <= '0';
				acc_en <= '0';
				acc_ld <= '0';
				pc_en <= '0';
				acc_from_alu <= '0';
				if en = '1' then
					--after changing address we need to restore previous address to read nex instruction
					if restore_address = '1' then
						pc_state <= "10";
						pc_en <= '1';
						result_reg <= instruction_number;
						sending <= '1';
					end if;
					next_state <= FETCH;
				else
					next_state <= IDLE;
				end if;
			when FETCH =>
				v_state <= "000010";
				next_state <= DECODE;
				--start reading file
				if end_of_file = '0' then
					f_re <= '1';
					f_en <= '1';
					reading <= '1';
				elsif reading = '1' then
					--stop reading
					next_state <= IDLE;
					pc_en <= '0';
					reading <= '0';
				else
					--stop changing the address
					if restore_address = '1' then
						pc_en <= '0';
						pc_state <= "00";
						restore_address <= '0';
						sending <= '0';
					end if;
					--read from memory
					mem_en <= '1';
				end if;
			when DECODE =>
				v_state <= "000100"; 
				next_state <= EXECUTE;
				if reading = '1' then
					--stop reading from file
					f_en <= '0';
					f_re <= '0';
					if end_of_file = '1' then
						--end of file, reset address
						next_state <= FETCH;
						pc_state <= "11";
						pc_en <= '1';
					else
						--load to memory from file
						mem_we <= '1';
					end if;
				else
					--stop reading from memory
					mem_en <= '0';
					current_reg <= q;
					--increase instruction number
					instruction_number <= std_logic_vector(unsigned(instruction_number) + 1);
					
					--check command
					fourbit := q(8 downto 5);
					case fourbit is
						when "0000" => current_cmd <= NOP;
						when "0001" => current_cmd <= LOAD;
						when "0010" => current_cmd <= STORE;
						when "0011" => current_cmd <= ADD;
						when "0100" => current_cmd <= SUBT;
						when "0101" => 
							current_cmd <= INP;
							--increase address
							pc_state <= "01";
							pc_en <= '1';
						when "0110" => 
							current_cmd <= OUTP;
							--increase address
							pc_state <= "01";
							pc_en <= '1';
						when "0111" => current_cmd <= HALT;
						when "1000" => 
							current_cmd <= SKIPCOND;
							--increase address
							pc_state <= "01";
							pc_en <= '1';
						when "1001" => current_cmd <= JUMP;
						when others => current_cmd <= NOP;
					end case;
				end if;
			when EXECUTE => 
				v_state <= "001000";
				if reading = '1' then
					--stop writing to memory
					mem_we <= '0';
					--increase address
					pc_state <= "01";
					pc_en <= '1';
					next_state <= STORE;
				else
					--stop increasing address
					pc_en <= '0';
					pc_state <= "00";
					next_state <= IDLE;
					case current_cmd is
						when NOP => 
							result_reg <= result_reg;
						when LOAD =>
							--move counter to given address
							pc_state <= "10";
							pc_en <= '1';		
							result_reg <= std_logic_vector(resize(signed(current_reg(4 downto 0)), result_reg'length));
							sending <= '1';
							next_state <= STORE;	
						when STORE =>
							--load value from register
							--acc_en <= '1';
							--move counter to given address
							pc_en <= '1';
							pc_state <= "10";
							result_reg <= std_logic_vector(resize(signed(current_reg(4 downto 0)), result_reg'length));
							sending <= '1';
							next_state <= STORE;
						when ADD =>
							--move counter to given address
							pc_en <= '1';
							pc_state <= "10";
							result_reg <= std_logic_vector(resize(signed(current_reg(4 downto 0)), result_reg'length));
							sending <= '1';
							next_state <= STORE;
						when SUBT =>
							--move counter to given address
							pc_en <= '1';
							pc_state <= "10";
							result_reg <= std_logic_vector(resize(signed(current_reg(4 downto 0)), result_reg'length));
							sending <= '1';
							next_state <= STORE;
						when INP =>
							--read from keyboard
							readline(input, l);
							read(l, loaded_data);
							result_reg <= loaded_data;
							--show value on conn_bus
							sending <= '1';
							--load to accumlator
							acc_ld <= '1';
							next_state <= STORE;
						when OUTP =>
							--show value from accumlator on conn_bus
							acc_en <= '1';
							next_state <= STORE;
						when HALT =>
							en <= '0';
						when SKIPCOND =>
							twobit := current_reg(1 downto 0);
							v_twobit <= twobit;
							case twobit is
								when "00" =>
									if to_integer(unsigned(acc_val)) < 0 then
										--increase address
										pc_state <= "01";
										pc_en <= '1';
									end if;
								when "01" =>
									if 0 = to_integer(unsigned(acc_val)) then
										--increase address
										pc_state <= "01";
										pc_en <= '1';
									end if;
								when "10" =>
									if to_integer(unsigned(acc_val)) > 0 then
										--increase address
										pc_state <= "01";
										pc_en <= '1';
									end if;
								when others =>
							end case;
						when JUMP =>
							pc_en <= '1';
							pc_state <= "10";
							result_reg <= std_logic_vector(resize(signed(current_reg(4 downto 0)), result_reg'length));
							sending <= '1';
							instruction_number <= std_logic_vector(resize(signed(current_reg(4 downto 0)), instruction_number'length));
							next_state <= STORE;
						when others => 
							result_reg <= result_reg;
					end case;
				end if;
			when STORE => 
				v_state <= "010000";
				next_state <= IDLE;
				if reading = '1' then
					--stop increasing address
					pc_en <= '0';
					pc_state <= "00";
					reading <= '0';
				else

					case current_cmd is
						when NOP =>
							result_reg <= result_reg;
						when LOAD =>
							--load from memory to acc
							pc_en <= '0'; 
							mem_en <= '1';
							acc_ld <= '1';
							sending <= '0';
							--move address to next instruction
							restore_address <= '1';
						when STORE =>
							--load from acc to memory
							sending <= '0';
							pc_en <= '0';
							acc_en <= '1';
							mem_we <= '1';
							--move address to next instruction
							restore_address <= '1';
						when ADD =>
							pc_en <= '0';
							mem_en <= '1';
							alu_op <= '1';	--add operation
							acc_from_alu <= '1';
							acc_ld <= '1';
							sending <= '0';
							--move address to next instruction
							restore_address <= '1';
						when SUBT =>
							pc_en <= '0';
							mem_en <= '1';
							alu_op <= '0';	--add operation
							acc_from_alu <= '1';
							acc_ld <= '1';
							sending <= '0';
							--move address to next instruction
							restore_address <= '1';
						when INP =>
							--stop sending and loading to accumlator
							sending <= '0';
							acc_ld <= '0';
						when OUTP =>
							--write value from conn_bus on console
							write(l, q);
							writeline(output, l);
						when HALT => 
							--no store state in halt
						when SKIPCOND =>
						when JUMP =>
							pc_en <= '0';
							pc_state <= "00";
						when others =>
							result_reg <= result_reg;
					end case;

				end if;
			when others => 
				v_state <= "111111";
				next_state <= IDLE;
		end case;
	end process;

	conn_bus <= result_reg when sending = '1' else "ZZZZZZZZZ";

	state <= v_state;
	vq <= q;
	with current_cmd select 
		v_current_cmd <= "0001" when LOAD,
						"0010" when STORE,
						"0011" when ADD,
						"0100" when SUBT,
						"0101" when INP,
						"0110" when OUTP,
						"0111" when HALT,
						"1000" when SKIPCOND,
						"1001" when JUMP,
						"0000" when others;

end behavior;