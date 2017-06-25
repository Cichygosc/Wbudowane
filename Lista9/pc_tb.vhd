library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end pc_tb;

architecture behavior of pc_tb is

	component filehandle 
		port(
			 re : in std_logic;
			 en : in std_logic;
			 endoffile : out bit;
			 conn_bus : inout std_logic_vector(8 downto 0)
			);
	end component;

	component ram 
		port(
			 we : in std_logic;
			 en : in std_logic;
			 address_bus : in std_logic_vector(8 downto 0);	--2^9 instructions
			 conn_bus : inout std_logic_vector(8 downto 0)
			);
	end component;

	component pc
		port(
			 clk : in std_logic;
			 en : in std_logic;
			 state : in std_logic_vector(1 downto 0);
			 conn_bus : in std_logic_vector(8 downto 0);
			 address_bus : out std_logic_vector (8 downto 0)
			);
	end component;

	--buses
	signal conn_bus : std_logic_vector(8 downto 0) := (others => '0');
	signal address_bus : std_logic_vector(8 downto 0) := (others => '0');

	--file handle
   	signal f_re : std_logic := '0';
   	signal f_en : std_logic := '0';
   	signal endoffile : bit := '0';

   	--ram
   	signal mem_en : std_logic := '0';
   	signal we : std_logic := '0'; 

   	--pc
   	signal pc_en : std_logic := '0';
	signal pc_state : std_logic_vector(1 downto 0) := "00";

	--clock
	signal clk : std_logic := '0';
	constant clk_period : time := 20 ns;

begin

	filehandle_uut : filehandle port map(
		re => f_re,
		en => f_en,
		endoffile => endoffile,
		conn_bus => conn_bus
		);

	ram_uut : ram port map(
		we => we,
		en => mem_en,
		address_bus => address_bus,
		conn_bus => conn_bus
		);

	pc_uut : pc port map(
		clk => clk,
		en => pc_en,
		state => pc_state,
		conn_bus => conn_bus,
		address_bus => address_bus
		);

	clk_process : process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;

	stim_proc : process
	begin
		
		while endoffile = '0' loop
			f_re <= '1';
			f_en <= '1';
			wait for clk_period;
			f_en <= '0';
			f_re <= '0';
			we <= '1';
			wait for clk_period;
			we <= '0';
			pc_state <= "01";
			pc_en <= '1';
			wait for clk_period;
			pc_en <= '0';
			pc_state <= "00";
		end loop;

		wait for clk_period;
		pc_state <= "11";
		pc_en <= '1';
		wait for clk_period;
		pc_en <= '0';
		pc_state <= "00";

		for i in 0 to 15 loop
			mem_en <= '1';
			pc_state <= "01";
			pc_en <= '1';
			wait for clk_period;
			mem_en <= '0';
			pc_en <= '0';
			pc_state <= "00";
			wait for clk_period;
		end loop;

		wait;
	end process;

end;