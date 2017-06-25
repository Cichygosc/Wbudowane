library ieee;
use ieee.std_logic_1164.all;

entity marie_tb is
end marie_tb;

architecture behavior of marie_tb is
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

	component reg
		port(
			 clk : in std_logic;
			 ld : in std_logic;
			 from_alu : in std_logic;
			 en : in std_logic;
			 clr : in std_logic;
			 alu_bus : in std_logic_vector(8 downto 0);
			 conn_bus : inout std_logic_vector(8 downto 0);
			 curr_reg : out std_logic_vector(8 downto 0)
			);
	end component;

	component alu
		port(
			 op : in std_logic;
			 acc_bus : in std_logic_vector(8 downto 0);
			 conn_bus : in std_logic_vector(8 downto 0);
			 acc_result : out std_logic_vector(8 downto 0)
			);
	end component;

	component controller 
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
	end component;

	--buses
	signal conn_bus : std_logic_vector(8 downto 0) := (others => '0');
	signal address_bus : std_logic_vector(8 downto 0) := (others => '0');
	signal alu_bus : std_logic_vector(8 downto 0) := (others => '0');

	--file handle
   	signal f_re : std_logic := '0';
   	signal f_en : std_logic := '0';
   	signal endoffile : bit := '0';

   	--ram
   	signal mem_en : std_logic := '0';
   	signal mem_we : std_logic := '0'; 

   	--pc
   	signal pc_en : std_logic := '0';
	signal pc_state : std_logic_vector(1 downto 0) := "00";

	--register
	signal reg_ld : std_logic := '0';
	signal reg_en : std_logic := '0';
	signal reg_clr : std_logic := '0';
	signal reg_val : std_logic_vector(8 downto 0) := (others => '0');
	signal reg_from_alu : std_logic := '0';

	--alu
	signal alu_op : std_logic := '0';

	--controller
	signal con_state : std_logic_vector(5 downto 0) := (others => '0');
	signal con_q : std_logic_vector(8 downto 0) := (others => '0');
	signal con_curr_cmd : std_logic_vector(3 downto 0) := (others => '0');

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
		we => mem_we,
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

	reg_uut : reg port map(
		clk => clk,
		ld => reg_ld,
		from_alu => reg_from_alu,
		en => reg_en,
		clr => reg_clr,
		alu_bus => alu_bus,
		conn_bus => conn_bus,
		curr_reg => reg_val
		);

	alu_uut : alu port map(
		op => alu_op,
		acc_bus => reg_val,
		conn_bus => conn_bus,
		acc_result => alu_bus
		);

	con_uut : controller port map(
		clk => clk,
		conn_bus => conn_bus,
		state => con_state,
		vq => con_q,
		v_current_cmd => con_curr_cmd,
		f_re => f_re,
		f_en => f_en,
		end_of_file => endoffile,
		mem_we => mem_we,
		mem_en => mem_en,
		pc_en => pc_en,
		pc_state => pc_state,
		acc_val => reg_val,
		acc_en => reg_en,
		acc_ld => reg_ld,
		acc_from_alu => reg_from_alu,
		alu_op => alu_op
		);

	clk_process : process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;
end;