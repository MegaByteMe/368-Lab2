---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: MR - Group 7
-- 
-- Create Date:    SPRING 2015
-- Module Name:    MAST
-- Project Name:   MASTER CONTROL UNIT (MCU)
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: MASTER CONTROL TO CONTROL SUBCOMPONENTS
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity MAST is
    Port ( 
			  CLK : in STD_LOGIC;
			  RST : in STD_LOGIC;
			  
			  -- Used for testing purposes - no real value to component
			  LED : out STD_LOGIC_VECTOR(7 downto 0);
			
			  -- VGR Sub:Keyboard Controller Signals
           PS2_CLK  : inout STD_LOGIC;
           PS2_DATA : inout STD_LOGIC;
			  
			  -- VGR Sub:VGA Controller
           HSYNC    : out   STD_LOGIC;
           VSYNC    : out   STD_LOGIC;
           VGARED   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGAGRN   : out   STD_LOGIC_VECTOR (2 downto 0);
           VGABLU   : out   STD_LOGIC_VECTOR (1 downto 0);
	 		
			  -- Seven Segment Ports
			  SEG : out STD_LOGIC_VECTOR (7 downto 0);
			  DP  : out STD_LOGIC;
			  AN  : out STD_LOGIC_VECTOR (3 downto 0)
			  );
end MAST;

architecture Structural of MAST is

	   -- VGR Sub:Keyboard Controller Signals
	   signal ASCII    : STD_LOGIC_VECTOR(7 downto 0);
	   signal ASCII_RD : STD_LOGIC;
	   signal ASCII_WE : STD_LOGIC;
		
		-- ALU Signals
		signal ALU_OUT : STD_LOGIC_VECTOR(7 downto 0);
		signal CCR  : STD_LOGIC_VECTOR(3 downto 0);
      signal SIG_1 : STD_LOGIC_VECTOR (7 downto 0);
      signal SIG_2 : STD_LOGIC_VECTOR (7 downto 0);
		signal OPBUS : STD_LOGIC_VECTOR (3 downto 0);
		signal SELO : STD_LOGIC := '0';
			 	
begin

VGR: entity work.VGA_TOPLEVEL
    Port map( 				
			  CLK    => CLK,
           RST     => RST,
           PS2_CLK  => PS2_CLK,
           PS2_DATA => PS2_DATA,
           HSYNC    => HSYNC,
           VSYNC    => VSYNC,
           VGARED   => VGARED,
           VGAGRN	  => VGAGRN,
           VGABLU   => VGABLU,
			  A_OUT => ASCII,
			  A_RD => ASCII_RD,
			  ALU_IN => ALU_OUT,
			  SELO => SELO
			  );

    ALU: entity work.ALU
    port map( 
			CLK => CLK,
			RA => SIG_1,
         RB => SIG_2,
         OPCODE => OPBUS,
         CCR => CCR,
         ALU_OUT => ALU_OUT
		);
				  
    DRV_7Seg: entity work.SSegDriver
    port map( 
				  CLK     => CLK,
              RST     => RST,
              EN      => '1',
              SEG_0   => ALU_OUT(3 downto 0),
              SEG_1   => OPBUS,
              SEG_2   => SIG_1(3 downto 0),
              SEG_3   => SIG_2(3 downto 0),
              DP_CTRL => "1111",
              SEG_OUT => SEG (6 downto 0),
              DP_OUT  => DP,
              AN_OUT  => AN
				  );

	BUFF: entity work.buffit_toplevel
	port map (
			  GO => LED,
			  RST => RST,
           CLK	=> CLK,
           ASCII_BUS  => ASCII,
           ASCII_RD   => ASCII_RD,
			  OPCODE => OPBUS,
			  REGA => SIG_1,
			  REGB => SIG_2,
			  SETO => SELO
			  );					
		
end Structural;

