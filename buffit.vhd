---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: MR
-- 
-- Create Date:    SPRING 2015
-- Module Name:    Buff IT!
-- Project Name:   
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Finite State Machine Debug Unit
-- Notes:
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity buffit is
    Port ( 
				go : out std_logic_vector(7 downto 0) := (others => '0');
			  RST       : in std_logic := '0';
           CLK 		: in std_logic := '0';
			  
           ASCII_BUS  : in std_logic_vector(7 downto 0);
           ASCII_RD   : in std_logic;

           OPCODE    : out std_logic_vector(3 downto 0);
			  REGA		: out std_logic_vector(7 downto 0);
			  REGB		: out std_logic_vector(7 downto 0);
			  SETO		: out STD_LOGIC := '0';
			  			  
			  WEN			: out STD_LOGIC := '0';
			  REN			: out STD_LOGIC := '0';
			  FIFOLOAD  : in STD_LOGIC_VECTOR(7 downto 0);
			  FIFOSTORE : out STD_LOGIC_VECTOR(7 downto 0);
			  VAL			: in STD_LOGIC
			  );
end buffit;

architecture Behavioral of buffit is

    -- Finite State Machine Setup
    type fsm_state is
		(
       idle,
		 store,
		 translate,
		 load,
		 strobe
		 );
	 
    signal state: fsm_state := idle; -- set FSM init state
	 signal flag : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	 signal tri : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	 signal OP : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	 signal op1 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 signal op2 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 signal nonsense : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	 
begin
go(0) <= val;
go(1) <= ASCII_RD;

    ---------------------------------------------------
    -- FINITE STATE MACHINE
    ---------------------------------------------------
  fsm: process( CLK,rst,state, ASCII_BUS, ASCII_RD, flag, VAL )
	 
    begin
        if(rst = '1') then -- Reset state, goto idle mode
            state <= idle;
				
        elsif(clk'event and clk = '1') then -- Process through States every rising edge of the clock

            --State Case - process through each state
            case state is
                when idle =>
							WEN <= '0';
							REN <= '0';
							SETO <= '0';
					      if(ASCII_RD = '1') then
								if(ASCII_BUS = X"20") then
									state <= strobe;
								elsif(ASCII_BUS = X"0D") then
									SETO <= '1';
									state <= load;
								else
									state <= store;
								end if;
							elsif(VAL = '1') then
								state <= strobe;
							else
								state <= idle;
                    end if;

                when store =>
								REN <= '0';
								WEN <= '1';
								FIFOSTORE <= ASCII_BUS;
                        state <= idle;

                when translate =>
								WEN <= '0';
								REN <= '0';
								
								if(flag = "00") then
										if(tri = "00") then
										REN <= '1';
											nonsense(23 downto 16) <= FIFOLOAD;
											go(7) <= '1';
											tri <= "01";
											state <= strobe;
										elsif(tri = "01") then
										ren <= '1';
											nonsense(15 downto 8) <= FIFOLOAD;
											go(6) <= '1';
											tri <= "10";
											state <= strobe;
										elsif(tri = "10") then
										ren <= '1';
											nonsense(7 downto 0) <= FIFOLOAD;
											go(5) <= '1';
											state <= idle;
										end if;
								REN <= '0';
									case nonsense is
										when x"535542" => --SUB
											OP <= "0001";
											flag <= "01";
											state <= idle;
										when x"737562" => --sub
										go(3) <= '1';
											OP <= "0001";
											flag <= "01";
											state <= idle;
										when x"616464" => --add
											OP <= "0000";
											flag <= "01";
										go(3) <= '1';
											state <= idle;
										when x"414444" => --ADD
											OP <= "0000";
											flag <= "01";
											state <= idle;
										when x"414E44" => --AND
											OP <= "0010";
											flag <= "01";
											state <= idle;
										when x"616E64" => --and
											OP <= "0010";
											flag <= "01";
											state <= idle;
										when x"4F5200" => --OR
											OP <= "0011";
											flag <= "01";
											state <= idle;
										when x"6F7200" => --or
											OP <= "0011";
											flag <= "01";
											state <= idle;											
										when others =>
											OP <= x"0";
											state <= idle;
									end case;
																		
								elsif(flag = "01") then
								--	REN <= '1';
									op1 <= FIFOLOAD - x"30";
									flag <= "10";
									state <= idle;
									
								elsif(flag = "10") then
								--	REN <= '1';
									op2 <= FIFOLOAD - x"30";
								--	flag <= "00";
									state <= idle;
									
								end if;
						
					 when load =>
					 		OPCODE <= OP;
							REGA <= op1;
							REGB <= op2;
							
					 		WEN <= '0';
							REN <= '0';
							nonsense <= X"000000";
							flag <= "00";
							tri <= "00";
							state <= idle;
							
					 when strobe =>
							REN <= '0';
							REN <= '1';
							state <= translate;

                when others =>
                     state <= idle;
       
             end case;
        end if;
    end process fsm;

end Behavioral;
