library std;
use std.textio.all;
library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity ram_tb is
end ram_tb;

architecture behavior of ram_tb is

	component ram 
		port(
			 we : in std_logic;
			 en : in std_logic;
			 address_bus : in std_logic_vector(8 downto 0);	--2^9 instructions
			 conn_bus : inout std_logic_vector(8 downto 0)
			);
	end component;

	component filehandle 
	port(
		 re : in std_logic;
		 en : in std_logic;
		 endoffile : out bit;
		 conn_bus : inout std_logic_vector(8 downto 0)
		);
	end component;

	-- clock stuff
   	signal clk : std_logic := '0';
   	-- clock period 
   	constant clk_period : time := 20 ns;

   	signal conn_bus : std_logic_vector(8 downto 0) := (others => '0');

   	--file handle
   	signal f_re : std_logic := '0';
   	signal f_en : std_logic := '0';
   	signal endoffile : bit := '0';

   	--ram
   	signal mem_en : std_logic := '0';
   	signal we : std_logic := '0';
   	signal address_bus : std_logic_vector(8 downto 0) := (others => '0');

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

   		clk_process : process
   		begin
   			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
   		end process;

		-- Stimulus process
		stim_proc: process
			variable li : line;
		begin		

			while endoffile = '0' loop
				f_re <= '1';
				f_en <= '1';
				wait for clk_period;
				f_en <= '0';
				f_re <= '0';
				we <= '1';
				wait for clk_period;
				address_bus <= std_logic_vector(unsigned(address_bus) + 1);
				we <= '0';
			end loop;

			for i in 0 to 15 loop
				address_bus <= std_logic_vector(to_unsigned(i, address_bus'length));
				mem_en <= '1';
				wait for clk_period;
				mem_en <= '0';
			end loop;

			wait;
			
		end process;

end behavior;