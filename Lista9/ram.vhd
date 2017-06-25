library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	port(
		we : in std_logic;
		en : in std_logic;
		address_bus : in std_logic_vector(8 downto 0);	--2^9 instructions
		conn_bus : inout std_logic_vector(8 downto 0)
		);
end ram;

architecture Behavioral of ram is
	type ram_type is array(0 to (2**address_bus'length) - 1) of std_logic_vector(8 downto 0);
	signal data : ram_type := (others => (others => '0'));
begin

	process(we)
	begin
		if we = '1' then
			data(to_integer(unsigned(address_bus))) <= conn_bus;
		end if;
	end process;
	
	conn_bus <= data(to_integer(unsigned(address_bus)))
				when en = '1' and we = '0' else "ZZZZZZZZZ";

end Behavioral;