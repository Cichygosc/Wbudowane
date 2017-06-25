LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- don't use std_logic_unsigned!
--USE ieee.std_logic_unsigned.ALL;
-- use numeric_std instead
use ieee.numeric_std.all;
 
 
ENTITY example_tb IS
END example_tb;
 
ARCHITECTURE behavior OF example_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Xand IS
    GENERIC (width: integer);
    PORT(
         clk : in std_logic;
         A, B : IN  std_logic_vector(width - 1 downto 0);
         C : OUT  std_logic_vector(width - 1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal WIDTH : integer := 4;

   signal clk : std_logic := '0';
   signal A : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
   signal B : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
	
-- test out both declarations
   signal atest : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
   signal btest : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');

   --Outputs
   signal C : std_logic_vector(WIDTH - 1 downto 0);

   signal pattern : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
 
   -- for display clarity only
   constant period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: Xand GENERIC MAP (width => WIDTH)
        PORT MAP (
          clk => clk,
          A => A,
          B => B,
          C => C
        );

   -- Stimulus process
   stim_proc: process

   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
 wait for 10*period;
    
    -- another way to do this... 
    for i in 0 to WIDTH ** 2 - 1 loop
      for j in 0 to WIDTH ** 2 - 1 loop       
        A <= atest;
        B <= btest;
        wait for period;
        pattern <= atest and btest;
        assert C = pattern
          report "bad value" severity error;
        btest <= std_logic_vector(unsigned(btest) + 1); 
      end loop;
      atest <= std_logic_vector(unsigned(atest) + 1);
    end loop;

  assert false report "end of test" severity note;
      wait;
   end process;

END;
