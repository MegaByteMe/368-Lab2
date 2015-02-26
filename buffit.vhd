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

entity buffit is
    Port ( 
			  RST       : in std_logic := '0';
           CLK 		: in std_logic := '0';
			  
           ASCII_BUS  : in std_logic_vector(7 downto 0);
           ASCII_RD   : in std_logic;
           ASCII_WE   : in std_logic := '0';
			  ASCII_OUT : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

           OPCODE    : out std_logic_vector(3 downto 0);
			  REGA		: out std_logic_vector(7 downto 0) := (others => '0');
			  REGB		: out std_logic_vector(7 downto 0) := (others => '0');
			  			  
			  WEN			: out STD_LOGIC := '0';
			  REN			: out STD_LOGIC := '0';
			  FIFOLOAD  : in STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			  FIFOSTORE : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0')
			  );
end buffit;

architecture Behavioral of buffit is

    -- Finite State Machine Setup
    type fsm_state is
		(
       idle,
		 store,
		 translate,
		 load
		 );
	 
    signal state: fsm_state := idle; -- set FSM init state
	 signal nonsense : STD_LOGIC_VECTOR(23 downto 0);
	 signal flag : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	 signal hold : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	 signal OP : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	 signal op1 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 signal op2 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 
begin

    ---------------------------------------------------
    -- FINITE STATE MACHINE
    ---------------------------------------------------
  fsm: process( CLK,rst,state, ASCII_BUS, ASCII_RD, flag )
 	 
    begin
        if(rst = '1') then -- Reset state, goto idle mode
            state <= idle;
				
        elsif(rising_edge(CLK)) then -- Process through States every rising edge of the clock

            --State Case - process through each state
            case state is
                when idle =>
							WEN <= '0';
							REN <= '0';
							
                    if(ASCII_RD = '1') then
                        state <= store;
                    elsif(ASCII_RD = '1' and ASCII_BUS = X"F20") then
                        state <= translate;
							elsif(ASCII_RD = '1' and ASCII_BUS = X"5A") then
								state <= load;
                    else
                        state <= idle;
                    end if;

                when store =>
								REN <= '0';
								WEN <= '1';
								FIFOSTORE <= ASCII_BUS;
                        state <= idle;

                when translate =>
								REN <= '1';
								
								if(flag = "00") then
									hold <= "00";
									while hold < "11" loop
										if(clk = '1' and hold = "00") then
											nonsense(23 downto 16) <= FIFOLOAD;
										elsif(clk = '1' and hold = "01") then
											nonsense(15 downto 8) <= FIFOLOAD;
										elsif(clk ='1' and hold = "10") then
											nonsense(7 downto 0) <= FIFOLOAD;
										end if;
										
										hold <= hold + 1;
									end loop;
								
									case nonsense is
										when x"535542" => --SUB
											OP <= x"1";
										when x"737562" => --sub
											OP <= x"1";
										when others =>
											OP <= x"0";
									end case;
								
									flag <= "01";
								elsif(flag = "01") then
									op1 <= FIFOLOAD - x"30";
									flag <= "10";
									
								elsif(flag = "10") then
									op2 <= FIFOLOAD - x"30";
									flag <= "00";
									
								end if;
								 state <= idle;
						
					 when load =>
							OPCODE <= OP;
							REGA <= op1;
							REGB <= op2;
							state <= idle;

                when others =>
                    state <= idle;
       
             end case;
        end if;
    end process fsm;

end Behavioral;
