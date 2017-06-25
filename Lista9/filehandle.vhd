library std;
use std.textio.all;
library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_textio.all;

entity filehandle is
	Port(
		re : in std_logic;
		en : in std_logic;
		endoffile : out bit;
		conn_bus : inout std_logic_vector(8 downto 0)
		);
end filehandle;

architecture Behavioral of filehandle is
	signal dataread : std_logic_vector(8 downto 0) := (others => '0');
	begin
		process(re)
			file infile : text is in "datain.txt";
			variable inline : line;
			variable dataread2 : std_logic_vector(8 downto 0);
		begin
			if re = '1' then
				if (not endfile(infile)) then
					readline(infile, inline);
					read(inline, dataread2);
					dataread <= dataread2;
					endoffile <= '0';
				else
					endoffile <= '1';
				end if;
			end if;
		end process;

		conn_bus <= dataread when en = '1' else "ZZZZZZZZZ"; 

end Behavioral;