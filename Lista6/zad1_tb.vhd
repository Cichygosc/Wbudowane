LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY statemachine_tb IS
END statemachine_tb;
 
ARCHITECTURE behavior OF statemachine_tb IS 
    COMPONENT statemachine
    GENERIC(n: natural;
            m: natural);
    PORT(
         clk_in : IN  std_logic;
         clk_out: OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_in : std_logic := '0';
   signal clk_out : std_logic;
   signal clk_out1 : std_logic;
   signal clk_out2 : std_logic;

   constant n : natural := 3;
   constant m : natural := 2;

   constant n1 : natural := 113637;
   constant m1 : natural := 113636;

   constant n2 : natural := 1250000;
   constant m2 : natural := 1250000;

   -- Clock period definitions
   constant clk_period : time := 8 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: statemachine GENERIC MAP(n => n,
                                 m => m)
   PORT MAP (
          clk_in => clk_in,
          clk_out => clk_out
        );

   uut1: statemachine GENERIC MAP(n => n1,
                                  m => m1)
   PORT MAP(
          clk_in => clk_in,
          clk_out => clk_out1
    );

   uut2: statemachine GENERIC MAP(n => n2,
                              m => m2)
   PORT MAP(
          clk_in => clk_in,
          clk_out => clk_out2
    );

   -- Clock process definitions
   clk_process :process
   begin
		clk_in <= '0';
		wait for clk_period/2;
		clk_in <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait;
   end process;

END;

		
