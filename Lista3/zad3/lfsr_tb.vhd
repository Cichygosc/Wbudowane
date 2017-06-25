LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY lfsr_tb IS
END lfsr_tb;
 
ARCHITECTURE behavior OF lfsr_tb IS 
 
    -- UUT (Unit Under Test)
    COMPONENT lfsr
    PORT(
         clk : IN  std_logic;
         show : IN std_logic;
         q : INOUT  STD_LOGIC_VECTOR(15 downto 0)
        );
    END COMPONENT;
    
   -- input signals
   signal clk : std_logic := '0';
   signal show : std_logic := '0';

   -- input/output signal
   signal qq : STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');

   -- set clock period 
   constant clk_period : time := 20 ns;
 
BEGIN
	-- instantiate UUT
   uut: lfsr PORT MAP (
          clk => clk,
          q   => qq,
          show => show
        );
   
   -- clock management process
   -- no sensitivity list, but uses 'wait'
   clk_process :PROCESS
   BEGIN
		clk <= '0';
		WAIT FOR clk_period/2;
		clk <= '1';
		WAIT FOR clk_period/2;
   END PROCESS;
 

   -- stimulating process
   stim_proc: PROCESS
   BEGIN		
      wait for 20 ns;
      for i in 0 to 19 loop
        -- let it run 
         wait for 20 ns;
        -- apply reset 
  		   show <= '1';
        -- wait for 50 ns;
         wait for 20 ns;
        -- and let it go
         show <= '0';
       end loop;
      wait;
   END PROCESS;	
END;
