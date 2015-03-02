---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: MR
-- 
-- Create Date:    SPRING 2014
-- Module Name:    SEL_1of2
-- Project Name:   
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description:    

---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEL_1of2 is
    Port ( 
		     SEL  : in  STD_LOGIC;
           IN_1 : in  STD_LOGIC_VECTOR(7 downto 0);
           IN_2 : in  STD_LOGIC_VECTOR(7 downto 0);
			  IN_3 : in STD_LOGIC;
			  OUT3 : out STD_LOGIC;
           SOUT : out STD_LOGIC_VECTOR(7 downto 0)
		   );
end SEL_1of2;

architecture Behavioral of SEL_1of2 is
		signal MIN : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin

	 OUT3 <= IN_3 when SEL='0' ELSE '1';

	 MIN <= IN_2 or X"30";
    SOUT <= IN_1 when SEL='0' ELSE MIN;
	 

end Behavioral;

