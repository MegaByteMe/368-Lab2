---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: 
-- 
-- Create Date:    SPRING 2015
-- Module Name:    
-- Project Name:   
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: 
-- Notes:
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity buffit_toplevel is
    Port ( 
				RST       : in std_logic;
           CLK 		: in std_logic;
           ASCII_BUS  : in std_logic_vector(7 downto 0);
           ASCII_RD   : in std_logic;
           ASCII_WE   : in std_logic;
           OPCODE    : out std_logic_vector(3 downto 0);
			  REGA		: out std_logic_vector(7 downto 0);
			  REGB		: out std_logic_vector(7 downto 0)
			  );
end buffit_toplevel;

architecture Structural of buffit_toplevel is

signal OPS : STD_LOGIC_VECTOR(3 downto 0);
signal REGAL : STD_LOGIC_VECTOR(7 downto 0);
signal REGBL : STD_LOGIC_VECTOR(7 downto 0);
signal ADD	 : STD_LOGIC_VECTOR(12 downto 0);

begin
BUFFEST: entity work.buffit
	port map (
		CLK => CLK,
		RST => RST,
		ASCII_BUS => ASCII_BUS,
		ASCII_WE => ASCII_WE,
		ASCII_RD => ASCII_RD,
		OPCODE => OPS,
		REGA => REGAL,
		REGB => REGBL,
		ADDY => ADD
	);

end Structural;
