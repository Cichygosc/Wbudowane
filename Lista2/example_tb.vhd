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
 
    COMPONENT example
    PORT(
         a : IN  std_logic;
         b : IN  std_logic;
         c : IN  std_logic;
         x : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic := '0';
   signal b : std_logic := '0';
   signal c : std_logic := '0';
	
-- test out both declarations
   signal abc : std_logic_vector(2 downto 0) := (others => '0');
--    signal abc : unsigned(2 downto 0) := (others => '0');

   --Outputs
   signal x : std_logic;
 
   -- for display clarity only
   constant period : time := 10 ns;
 
    type pattern_array is array (0 to 7) of std_logic;
    --  The patterns to apply.
    constant patterns : pattern_array :=
      ('0', '0', '0', '0', '1', '0', '0', '0');

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: example PORT MAP (
          a => a,
          b => b,
          c => c,
          x => x
        );

   -- Stimulus process
   stim_proc: process

   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
 wait for 10*period;
    
    -- another way to do this... 
    for i in 0 to 7 loop
  -- depending on abc's type there are different ways
  -- for incrementing it
  -- see which is which 
      abc <= std_logic_vector( unsigned(abc) + 1 );
  -- or this:
     -- abc <= abc + 1;
      a <= abc(2);
      b <= abc(1);
      c <= abc(0);
      wait for period;
      assert x = patterns(i)
        report "bad value" severity error;
    end loop;

  assert false report "end of test" severity note;
      wait;
   end process;

END;
