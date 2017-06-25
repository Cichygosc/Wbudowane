library std;
use std.textio.all;
library ieee;
USE ieee.std_logic_1164.ALL;

entity filehandle_tb is
end filehandle_tb;

architecture Behavioral of filehandle_tb is
	component filehandle 
	port(
		 re : in std_logic;
		 en : in std_logic;
		 endoffile : out bit;
		 conn_bus : inout std_logic_vector(8 downto 0)
		);
	end component;

	signal re : std_logic := '0';
    signal en : std_logic := '0';
	-- clock stuff
    signal clk : std_logic := '0';
    -- clock period 
    constant clk_period : time := 20 ns;

   signal endoffile : bit := '0';
   signal conn_bus : std_logic_vector(8 downto 0) := (others => '0');

   begin
   		uut : filehandle port map(
   			re => re,
   			en => en,
   			endoffile => endoffile,
   			conn_bus => conn_bus
   			);

   		clk_process : process
   		begin
   			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
   		end process;

		-- Stimulus process
		stim_proc: process
		begin		

			while endoffile = '0' loop
				re <= '1';
				en <= '1';
				wait for clk_period;
				re <= '0';
				en <= '0';
				wait for clk_period;
			end loop;

			wait;
			
		end process;

end Behavioral;