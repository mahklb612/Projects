----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops 
-- Create Date: 25.07.2023 14:30:12
-- Module Name: CLOCK DIVIDER
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CLOCK_DIVIDER is
    port (
        CLOCK_INPUT: in std_logic;  -- 100MHz Input Clock Signal
        CLOCK_DISP:  out std_logic; -- 2KHz Clock output for refreshing display every 0.5ms
        CLOCK_MILLI: out std_logic; -- 1KHz Clock ouput for Counting in milli seconds
        CLOCK_SEC:   out std_logic  -- 1Hz Clock ouput for counting in seconds
       
    );
end CLOCK_DIVIDER;

architecture BEHAVIORAL of CLOCK_DIVIDER is
    signal SECONDS:    std_logic := '0';
    signal MILLISECONDS:   std_logic := '0';
    signal DISPLAY_REFRESH:   std_logic := '0';
begin

        CLOCK_MILLI <= MILLISECONDS;
        CLOCK_DISP  <= DISPLAY_REFRESH;
        CLOCK_SEC   <= SECONDS;
        
CLOCK_1Hz: process(CLOCK_INPUT) 
           variable COUNT_100000000: unsigned (25 downto 0)  := "00000000000000000000000000";  -- Count to 100,000,000 for 1KHz Clock  
           begin
                 if ( rising_edge (CLOCK_INPUT)) then
                 if COUNT_100000000 = "10111110101111000010000000" then --counting to 100,000,000
                    SECONDS <= not SECONDS;
                    COUNT_100000000 := "00000000000000000000000000";
                 end if;
                    COUNT_100000000 := COUNT_100000000 + 1;
                 end if;
            end process;
    
CLOCK_1KHz: process(CLOCK_INPUT) 
            variable COUNT_50000: unsigned (15 downto 0)  := "0000000000000000";  -- Count to 50,000 for 1KHz Clock  
            begin
                 if ( rising_edge (CLOCK_INPUT)) then
                 if COUNT_50000 = "1100001101010000" then --counting to 50000
                    MILLISECONDS <= not MILLISECONDS;
                    COUNT_50000 := "0000000000000000";
                 end if;
                    COUNT_50000 := COUNT_50000 + 1;
                 end if;
            end process;
    

CLOCK_2KHz: process(CLOCK_INPUT) 
            variable COUNT_25000: unsigned (15 downto 0)  := "0000000000000000";  -- Count to 25,000 for 2KHz Clock to refresh displat every 0.5ms
            begin
                 if ( rising_edge (CLOCK_INPUT)) then
                 if COUNT_25000 = "110000110101000" then --counting to 25,000
                    DISPLAY_REFRESH <= not DISPLAY_REFRESH;
                    COUNT_25000 := "0000000000000000";
                 end if;
                    COUNT_25000 := COUNT_25000 + 1;
                 end if;
            end process;
    
end BEHAVIORAL;
