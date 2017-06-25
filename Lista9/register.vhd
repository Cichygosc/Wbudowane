library ieee;
use ieee.std_logic_1164.all;

entity reg is
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
end reg;

architecture behavior of reg is
	signal acc_reg : std_logic_vector(8 downto 0) := (others => '0');
begin
	process(clk)
	begin
		if clk = '1' and rising_edge(clk) then
			if clr = '1' then
				acc_reg <= "000000000";
			elsif ld = '1' and from_alu ='1' then
				acc_reg <= alu_bus;
			elsif ld = '1' and from_alu = '0' then
				acc_reg <= conn_bus;
			end if;
		end if;
	end process;

	conn_bus <= acc_reg when en = '1' else "ZZZZZZZZZ";
	curr_reg <= acc_reg;

end behavior;
