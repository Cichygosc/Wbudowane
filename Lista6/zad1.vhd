
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity statemachine is
  generic(n: natural;
  		  m: natural);
  port(
	clk_in:     in std_logic;
	clk_out:	out std_logic
  );
  
end statemachine;

architecture Flow of statemachine is
	signal nAmount : natural := 0;
	signal mAmount : natural := 1; 
	signal curr : std_logic := '1';
begin

state_advance: process(clk_in)
begin
	if curr = '1' then
		nAmount <= nAmount + 1;
		clk_out <= '1';
		if nAmount >= n then
			curr <= '0';
			nAmount <= 1;
			clk_out <= '0';
		end if;
	elsif curr = '0' then
		mAmount <= mAmount + 1;
		clk_out <= '0';
		if mAmount >= m then
			curr <= '1';
			mAmount <= 1;
			clk_out <= '1';
		end if;
	end if;
end process;

end Flow;

