library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port(
		 clk : in std_logic;
		 en : in std_logic;
		 state : in std_logic_vector(1 downto 0);
		 conn_bus : in std_logic_vector(8 downto 0);
		 address_bus : out std_logic_vector (8 downto 0)
		);
end pc;

--00 nothing
--01 inc
--10 assign
--11 reset

architecture behavior of pc is
	signal current_address : std_logic_vector(8 downto 0) := (others => '0');
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if en = '1' then
				case state is
					when "00" => null;
					when "01" => 
						current_address <= std_logic_vector(unsigned(current_address) + 1);
					when "10" =>
						current_address <= conn_bus;
					when "11" => 
						current_address <= std_logic_vector(to_unsigned(0, address_bus'length));
					when others => null;
				end case;
			end if;
		end if;
	end process;

	address_bus <= current_address;

end behavior;