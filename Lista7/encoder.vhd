LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hamming_encoder is
	port (
		data_in : in std_logic_vector(3 downto 0);
		data_out : out std_logic_vector(6 downto 0)
		);
end hamming_encoder;

ARCHITECTURE Behavioral of hamming_encoder is
	type matrix is array (0 to 3, 0 to 6) of std_logic;
	constant encodeMatrix : matrix := 
	("0111000",
	 "1010100",
	 "1100010",
	 "1110001");

BEGIN
	PROCESS(data_in)
	VARIABLE sum : std_logic;
	BEGIN
		for j in 0 to 6 loop
			sum := '0';
			for i in 0 to 3 loop
				sum := sum xor (data_in(i) and encodeMatrix(i, j));
			end loop;
			data_out(j) <= sum;
		end loop;
	END PROCESS;
END Behavioral;		

