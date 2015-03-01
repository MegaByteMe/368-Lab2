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
	 go : out std_logic_vector(7 downto 0) := (others => '0');
			  RST       : in std_logic := '0';
           CLK 		: in std_logic := '0';
			  
           ASCII_BUS  : in std_logic_vector(7 downto 0) :=(others => '0');
           ASCII_RD   : in std_logic;
           ASCII_WE   : in std_logic := '0';
			  ASCII_OUT : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

           OPCODE    : out std_logic_vector(3 downto 0);
			  REGA		: out std_logic_vector(7 downto 0) := (others => '0');
			  REGB		: out std_logic_vector(7 downto 0) := (others => '0');
			  			  
			  WEN			: out STD_LOGIC := '0';
			  REN			: out STD_LOGIC := '0'
			  );
    END COMPONENT;
	 
	 signal CLK : STD_LOGIC := '0';
    SIGNAL ASCII_RD: STD_LOGIC := '0';
	 signal RST : STD_LOGIC := '0';
	  signal ASCII_BUS : STD_LOGIC_VECTOR(7 downto 0);
	 
	 signal LOAD : STD_LOGIC_VECTOR(7 downto 0);
	 signal STORE : STD_LOGIC_VECTOR(7 downto 0);
	 signal OPCODE	: STD_LOGIC_VECTOR(3 downto 0);
	 signal REGA : STD_LOGIC_VECTOR(7 downto 0);
	 signal REGB : STD_LOGIC_VECTOR(7 downto 0);
	 signal go : std_logic_vector(7 downto 0);
	 signal wen : Std_logic := '0';
	 signal ren : std_logic := '0';
	 	 
constant period : time := 10 ns;
constant period2 : time := 50 ns;

begin

    uut: buffit 
			PORT MAP( 
					go => go,
						CLK  => CLK,
                  RST     => RST,
						ASCII_RD => ASCII_RD,
						OPCODE => OPCODE,
						REGA => REGA,
						REGB => REGB,
						ASCII_BUS => ASCII_BUS,
						WEN => WEN,
						REN => REN
						);
						
--		 uut: fifo_generator
--			port map(
--				CLK => SCLK,
--				RST => SRST,
--				DIN => STORE,
--				DOUT => LOAD
--				);
						
    -- Generate clock
    gen_Clock : process
    begin
        CLK <= '0'; wait for period;
        CLK <= '1'; wait for period;
    end process;
	 
	 -- Generate ASCII Read pulse (simulate button pushes)
	  gen_RD : process
    begin
        ASCII_RD <= '0'; wait for period2;
        ASCII_RD <= '1'; wait for period2;
    end process;
	 
	 -- Setup test process to run through all possible values present on ASCII bus
	 -- there are some bus width issues, ignored for this test
	 test : PROCESS
	 
	 variable i : integer := 0;
	 variable w : integer := 0;
	 
    BEGIN    
        report "Start Test Bench" severity NOTE;
		  
		  RST <= '0';

		for w in 0 to 64000 loop
			for i in 0 to 64000 loop
				ASCII_BUS <= ASCII_BUS + '1';
				wait until rising_edge(CLK);
			end loop;
		end loop;
	
	end process;
end;

