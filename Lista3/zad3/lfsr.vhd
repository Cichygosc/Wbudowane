library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_textio.all;
USE ieee.std_logic_arith.ALL;

library STD;
use STD.TEXTIO.all;

entity lfsr is
    Port ( clk : in  STD_LOGIC;
           show : in STD_LOGIC;
           q : inout  STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0')
			);
end lfsr;

ARCHITECTURE Behavioral OF lfsr IS
BEGIN
  PROCESS(clk, show)
    VARIABLE started : STD_LOGIC := '0';
    VARIABLE number : STD_LOGIC_VECTOR(15 downto 0);
    VARIABLE l : line;
    VARIABLE good : boolean;
  BEGIN
    IF (clk'event AND clk='1') THEN
      IF started = '0' THEN
        write (l, String'("Podaj wartosc poczatkowa"));
        writeline (output, l);
        readline(input, l);
        hread(l, number, good);
        IF good = true THEN
          q <= number;
          started := '1';
        END IF;
      ELSIF started = '1' THEN
        IF show = '1' THEN
          hwrite (l, q);
          writeline (output, l);
        ELSE
          q(15 downto 1) <= q(14 downto 0);
          q(0) <= (q(15) XOR q(14) XOR q(13) XOR q(4));
        END IF;
      END IF;
    END IF;
  END PROCESS;
END Behavioral;

