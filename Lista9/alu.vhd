library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
	port(
		op : in std_logic;
		acc_bus : in std_logic_vector(8 downto 0);
		conn_bus : in std_logic_vector(8 downto 0);
		acc_result : out std_logic_vector(8 downto 0)
		);
end alu;

architecture behavior of alu is
begin
	acc_result <= std_logic_vector(unsigned(acc_bus) + unsigned(conn_bus)) when op = '1'
				else std_logic_vector(unsigned(conn_bus) - unsigned(acc_bus)) when op ='0'
				else "000000000";
end behavior;