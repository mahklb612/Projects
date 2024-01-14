----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 1.08.2023 10:31:23
-- Module Name: REACTION TIME
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REACTION_TIME is
      Port (CLOCK_MILLI  : in std_logic;  -- 1KHz Clock Input
            STOP     : in std_logic;    --STOP BUTTON             
            CLEAR    : in std_logic;   --CLEAR BUTTON
            STATE    : in std_logic_vector(2 downto 0); --System State
            ONE      : out integer;  -- 1 MILLISECOND
            TEN      : out integer;  -- 10 MILLISECOND
            HUNDRED  : out integer;  -- 100 MILLISECOND
            THOUSAND : out integer; -- 1000 MILLISECOND/ 1 SECOND
            TIMER_STATE     : out std_logic    -- TIMER STATE
            );
end REACTION_TIME;

architecture Behavioral of REACTION_TIME is

begin

TIMER_MILLISECONDS: process (CLOCK_MILLI, STOP, CLEAR, STATE) -- count state depends on this clock
variable ONE_MS : integer := 0;
variable TEN_MS : integer := 0;
variable HUNDRED_MS : integer := 0;
variable THOUSAND_MS : integer := 0;
    begin
        if (CLEAR='1') then  -- IF USER RESETS THE TIMER
            ONE_MS := 0;
            TEN_MS := 0;
            HUNDRED_MS := 0;
            THOUSAND_MS := 0;
            ONE <= 0;
            TEN <= 0;
            HUNDRED <= 0;
            THOUSAND <= 0;
            TIMER_STATE <= '0';
        elsif rising_edge(CLOCK_MILLI) then
            if (STATE= "010") then  -- Hold State
            if (STOP='1') then   --User terminates TIMER by pressing stop button
                    TIMER_STATE <= '1';   -- Timer HOLD State when user presses stop.
            else                    -- Stop not pressed by user
                 ONE_MS := ONE_MS + 1; --count in milliconds less than 10
            if ONE_MS = 9 then    --Counts reaches 10 milliseconds
                 TEN_MS := TEN_MS + 1; --count in 10 milliseconds when count greater than 10ms
                 ONE_MS := 0;
             if TEN_MS = 9 then    --Count reaches 100 milliseconds
                 HUNDRED_MS := HUNDRED_MS + 1; ----Count in 100 milliseconds
                 TEN_MS := 0;
             if HUNDRED_MS = 9 then ----Count reaches 1000 milliseconds
                 THOUSAND_MS := THOUSAND_MS + 1; --Count in 1000 milliseconds
                 HUNDRED_MS := 0;
                 TIMER_STATE <= '1';   --Timer HOLD State when counter reaches 1000 milliseconds
             end if;
             end if;
             end if;
             end if;
             end if;
         end if;
        ONE      <= ONE_MS;
        TEN      <= TEN_MS;
        HUNDRED  <= HUNDRED_MS;
        THOUSAND <= THOUSAND_MS;
    end process;

end Behavioral;