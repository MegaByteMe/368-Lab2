---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: MR
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Buff IT!
-- Project Name:   N/A
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Finite State Machine practice code for use with test benches
-- Notes:
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity buffit_toplevel is
    Port ( 
			  GO : out std_logic_vector(7 downto 0);
			  RST       : in std_logic;
           CLK 		: in std_logic;
           ASCII_BUS  : in std_logic_vector(7 downto 0);
           ASCII_RD   : in std_logic;
           ASCII_WE   : in std_logic;
           OPCODE    : out std_logic_vector(3 downto 0);
			  REGA		: out std_logic_vector(7 downto 0);
			  REGB		: out std_logic_vector(7 downto 0);
			  								
			  full : OUT STD_LOGIC;						--words till full or words from full
			  data_count : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 	--data in fifo
			  );
end buffit_toplevel;

architecture Structural of buffit_toplevel is

signal STOREOUT : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal STOREBUS : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal WEN : STD_LOGIC;
signal REN : STD_LOGIC;
signal val :STD_LOGIC;

begin
	fifo_generator : ENTITY work.fifo_generator
  PORT map(
    clk => CLK,
    rst => RST,
    din => STOREBUS,							-- input
    wr_en => WEN,							--write enable
    rd_en => REN,							--read enable
    dout => STOREOUT,						 --output
    full => full,						--words till full or words from full
	 valid => val,
    data_count => data_count 	--data in fifo
  );

BUFFEST: entity work.buffit
	port map (
		val => val,
		go => go,
		CLK => CLK,
		RST => RST,
		ASCII_BUS => ASCII_BUS,
		ASCII_WE => ASCII_WE,
		ASCII_RD => ASCII_RD,
		OPCODE => OPCODE,
		REGA => REGA,
		REGB => REGB,
		WEN => WEN,
		REN => REN,
		FIFOLOAD => STOREOUT,
		FIFOSTORE => STOREBUS
	);

end Structural;
