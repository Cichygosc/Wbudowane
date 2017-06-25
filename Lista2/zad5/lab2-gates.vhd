

-- bramka AND
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gateAND is
port (
	X: in std_logic;
	Y: in std_logic;
	Z: out std_logic
);
end gateAND;

architecture Behavioral of gateAND is
begin
 Z <= X and Y after 1 ns;
end Behavioral;



-- bramka OR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gateOR is
port (
	X: in std_logic;
	Y: in std_logic;
	Z: out std_logic
);
end gateOR;

architecture Behavioral of gateOR is
begin
 Z <= X or Y after 1 ns;
end Behavioral;




-- bramka XOR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gateXOR is
port (
	X: in std_logic;
	Y: in std_logic;
	Z: out std_logic
);
end gateXOR;

architecture Behavioral of gateXOR is
begin
 Z <= X xor Y after 1 ns;
end Behavioral;



-- bramka NOT
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gateNOT is
port (
   X: in std_logic;
	Z: out std_logic
);
end gateNOT;

architecture Behavioral of gateNOT is
begin
  Z <= not X after 1 ns;
end Behavioral;



-- multiplekser czterowejisciowy
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
	generic(width: integer:=4);
	port (
	  a,b: in std_logic_vector(width - 1 downto 0);
	  s  : in std_logic;
	  x  : out std_logic_vector(width - 1 downto 0)
	);
end mux;

architecture zachowanie of mux is
begin
process (a, b, s)
  variable sel: integer;
  begin
     if s = '0' then
	   sel := 0;
	 else
	   sel := 1;
	 end if;
	 case sel is 
	   when 0 =>
		    x <= a;
	   when others =>
		    x <= b;
	 end case;
  end process;
end zachowanie;

	
