LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hamming_decoder is
	PORT(
		data_in : in std_logic_vector(6 downto 0);
		data_out : out std_logic_vector(3 downto 0)
		);
END hamming_decoder;

ARCHITECTURE Behavioral of hamming_decoder is
	type matrix is array (0 to 2, 0 to 6) of std_logic;
	constant decodeMatrix : matrix :=
	("1000111",
	 "0101011",
	 "0011101");

BEGIN

	PROCESS(data_in)

		VARIABLE sum : std_logic;
		VARIABLE syndrome : std_logic_vector(2 downto 0);
		VARIABLE decoded_data : std_logic_vector(6 downto 0);
		BEGIN
			for j in 0 to 2 loop
				sum := '0';
				for i in 0 to 6 loop
					sum := sum xor(data_in(i) and decodeMatrix(j, i));
				end loop;
				syndrome(j) := sum;
			end loop;

			if syndrome = "111" then
		        decoded_data := (not data_in(6)) & data_in(5 downto 0);
		    elsif syndrome = "011" then
		        decoded_data := data_in(6) & (not data_in(5)) & data_in(4 downto 0);
		    elsif syndrome = "101" then
		        decoded_data := data_in(6 downto 5) & (not data_in(4)) & data_in(3 downto 0);
		    elsif syndrome = "110" then
		        decoded_data := data_in(6 downto 4) & (not data_in(3)) & data_in(2 downto 0);
		    elsif syndrome = "001" then
		        decoded_data := data_in(6 downto 3) & (not data_in(2)) & data_in(1 downto 0);
		    elsif syndrome = "010" then 
		        decoded_data := data_in(6 downto 2) & (not data_in(1)) & data_in(0);
		    elsif syndrome = "100" then
		        decoded_data := data_in(6 downto 1) & (not data_in(0));
		    else 
		    	decoded_data := data_in;
		    end if;

	        data_out <= decoded_data(6 downto 3);


	END PROCESS;

END Behavioral;