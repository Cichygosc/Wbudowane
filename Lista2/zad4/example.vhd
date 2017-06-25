library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity example is
port (
  a,b : in std_logic_vector(3 downto 0);
  c   : out std_logic_vector(3 downto 0)
);
end example;

architecture Synthetic of example is

	component gateXAND
		port (X, Y: in std_logic_vector(3 downto 0);
			  Z: out std_logic_vector(3 downto 0));
	end component;

begin
 G1: gateXAND port map(a, b, c);
end Synthetic;


