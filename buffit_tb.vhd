----------------------------------------------------------------------------------
-- Company: Group 7
-- Engineer: MR
-- 
-- Create Date:    16:43:04 02/19/2015 
-- Design Name: 
-- Module Name:    buffit_tb - Behavioral 
-- Project Name: Finite State Machine Test Bench
-- Target Devices: Spartan 3
-- Tool versions: Xilinx 14.7
-- Description: Practice to evaluate operation of Finite State Machine Principles and test bench
--
-- Dependencies: 
--
-- Revision 0.01 - File Created
-- Additional Comments: This is all test code!
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.STD_LOGIC_unsigned.all;
USE ieee.numeric_std.ALL;

entity buffit_tb is
end buffit_tb;

architecture Behavioral of buffit_tb is

    COMPONENT buffit
    Port ( 
				CLK      : in    STD_LOGIC := '0';
           RST      : in    STD_LOGIC := '0';
           ASCII_BUS  : in std_logic_vector(7 downto 0) := (others=>'0');
           ASCII_RD   : in std_logic := '0';
  --       ASCII_WE   : in std_logic;
  --       OPCODE    : out std_logic_vector(3 downto 0);
	--		  REGA		: out std_logic_vector(7 downto 0);
	--		  REGB		: out std_logic_vector(7 downto 0);
			  ADDY 		: out std_logic_vector(7 downto 0) := (others => '0')
			  );
    END COMPONENT;
	 
	 signal SCLK : STD_LOGIC := '0';
    SIGNAL SASCII_BUS : STD_LOGIC_VECTOR(12 downto 0) := (others=>'0');
    SIGNAL SASCII_RD: STD_LOGIC := '0';
	 signal SRST : STD_LOGIC := '0';
	 signal ADDR : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 
 --   SIGNAL ASCII_WE   : STD_LOGIC := '0';
 --   SIGNAL OPCODE   : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
 --   SIGNAL REGA  : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
 --   SIGNAL REGB  : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
	 
constant period : time := 10 ns;
constant period2 : time := 50 ns;

begin

    uut: buffit PORT MAP( 
						CLK  => SCLK,
                  RST     => SRST,
						ASCII_RD => SASCII_RD,
						ASCII_BUS => SASCII_BUS,
						ADDY => ADDR
						);
						
    -- Generate clock
    gen_Clock : process
    begin
        SCLK <= '0'; wait for period;
        SCLK <= '1'; wait for period;
    end process;
	 
	 -- Generate ASCII Read pulse (simulate button pushes)
	  gen_RD : process
    begin
        SASCII_RD <= '0'; wait for period2;
        SASCII_RD <= '1'; wait for period2;
    end process;
	 
	 -- Setup test process to run through all possible values present on ASCII bus
	 -- there are some bus width issues, ignored for this test
	 test : PROCESS
	 
	 variable i : integer := 0;
	 variable w : integer := 0;
	 
    BEGIN    
        report "Start Test Bench" severity NOTE;
		  
		  SRST <= '0';

		for w in 0 to 64000 loop
			for i in 0 to 64000 loop
				SASCII_BUS <= SASCII_BUS + '1';
				wait until rising_edge(SCLK);
			end loop;
		end loop;
	
	end process;
end;

