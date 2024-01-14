----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 2.08.2023 18:30:22
-- Module Name: MAIN
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity HUMAN_REACTION is 
    port (
        
        START: in std_logic;
        STOP:  in std_logic;
        CLEAR: in std_logic;
        CLOCK_INPUT: in std_logic;
        STIMULUS:        out std_logic_vector(2 downto 0);
        SEGMENT_CATHODE: out std_logic_vector(7 downto 0);
        SEGMENT_ANODE:   out std_logic_vector(7 downto 0)
    );
end HUMAN_REACTION;


architecture BEHAVIORAL of HUMAN_REACTION is

    component COMPARATOR_INTERFACE is
        Port (
            CLOCK_SEC:      in std_logic;
            RAND_NUMBER:    in std_logic_vector(3 downto 0);
            EN:             in std_logic;
            COUNT_T:  out std_logic
        );
    end component;

    component RANDOM_NUMBER_GENERATOR is
        Port ( CLOCK_INPUT : in STD_LOGIC;              -- System Clock input
               RAND1: out STD_LOGIC_VECTOR(3 downto 0); -- 4-bit random number output (2 to 15)
               --RAND2: out STD_LOGIC_VECTOR(3 downto 0)  -- 4-bit random number output (0 to 15)
    end component;

    component CLOCK_DIVIDER is
        port (
            CLOCK_INPUT: in std_logic;  -- 100MHz Input Clock Signal
            CLOCK_DISP:  out std_logic; -- 2KHz Clock output for refreshing display every 0.5ms
            CLOCK_MILLI: out std_logic; -- 1KHz Clock ouput for Counting in milli seconds
            CLOCK_SEC:   out std_logic  -- 1Hz Clock ouput for counting in seconds
           
        );
    end component;
 
     component SEVEN_SEGMENT_DISPLAY is
        Port (CLOCK_DISP : in std_logic;   
              STATE : in std_logic_vector(2 downto 0);   
              ONE_MS : in integer;  
              TEN_MS : in integer;  
              HUNDRED_MS : in integer;  
              THOUSAND_MS : in integer;  
              DISPLAY_ANODE : out std_logic_vector(7 downto 0);  
              DISPLAY_CATHODE : out std_logic_vector(7 downto 0)  
              );
    end component;
    
    component REACTION_TIME is
          Port (CLOCK_MILLI  : in std_logic;  -- 1KHz Clock Input
                STOP     : in std_logic;    --STOP BUTTON             
                CLEAR    : in std_logic;   --CLEAR BUTTON
                STATE    : in std_logic_vector(2 downto 0); --System State
                ONE_MS      : out integer;  -- 1 MILLISECOND
                TEN_MS      : out integer;  -- 10 MILLISECOND
                HUNDRED_MS  : out integer;  -- 100 MILLISECOND
                THOUSAND_MS : out integer; -- 1000 MILLISECOND/ 1 SECOND
                TIMER_STATE     : out std_logic    -- TIMER STATE
                );
 
    end component;
 
 
    type  STAGE is (INITIALIZE, RANDOM_TIME, COUNTING, ERROR, HOLD);
    signal STATE : STAGE := INITIALIZE;
    signal STATE_DECODE: std_logic_vector(2 downto 0); 
    signal RAND:   std_logic_vector(3 downto 0);
    signal CLOCK_IN_SEC:              std_logic;
    signal CLOCK_IN_MILLISECONDS:     std_logic;
    signal CLOCK_REFRESH_RATE:        std_logic;
    signal CLOCK_SYS:                 std_logic;
    signal ENABLE:   std_logic;    
    signal TRIGGER_COUNT:   std_logic;      
    signal RESPONSE:   std_logic_vector(11 downto 0);  

    signal COUNT_STATE : std_logic;
    signal ONE_SIG: integer;
    signal TEN_SIG: integer;
    signal HUNDRED_SIG: integer;
    signal THOUSAND_SIG: integer;
    
begin

    CLOCK_SYS <= CLOCK_INPUT;
    
COMPARE_BLOCK: COMPARATOR_INTERFACE port map(CLOCK_SEC => CLOCK_IN_SEC, RANDOM_NUMBER=>RAND, EN1=>ENABLE, COUNT_T=>TRIGGER_COUNT);
RANDON_TIME_BLOCK: RANDOM_NUMBER_GENERATOR port map(RAND1=>RAND, CLK=>CLOCK_SYS);
CLOCK_DIVIDER_BLOCK: CLOCK_DIVIDER port map(CLOCK_INPUT=>CLOCK_SYS, CLOCK_MILLI=>CLOCK_IN_MILLISECONDS, CLOCK_SEC=>CLOCK_IN_SEC, CLOCK_DISP=>CLOCK_REFRESH_RATE);
DISPLAY_BLOCK: SEVEN_SEGMENT_DISPLAY port map (CLOCK_DISP=>CLOCK_REFRESH_RATE, ONE_MS=>ONE_SIG, TEN_MS=>TEN_SIG, HUNDRED_MS=>HUNDRED_SIG, THOUSAND_MS=>THOUSAND_SIG, STATE=>STATE_DECODE, DISPLAY_CATHODE=>SEGMENT_CATHODE, DISPLAY_ANODE=>SEGMENT_ANODE);
REACTION_TIME_BLOCK: REACTION_TIME port map (CLOCK_MILLI =>CLOCK_IN_MILLISECONDS, CLEAR => CLEAR, STOP => STOP, STATE => STATE_DECODE,  ONE=>ONE_SIG, TEN=>TEN_SIG, HUNDRED=>HUNDRED_SIG, THOUSAND=>THOUSAND_SIG, TIMER_STATE => COUNT_STATE);

    
    

STATES: process (START, STOP, CLEAR, CLOCK_SYS)
    begin
        if (CLEAR ='1') then
            STATE <= INITIALIZE;
            STIMULUS <= "000";      
            
        elsif rising_edge(CLOCK_SYS)then
            case STATE is
                when INITIALIZE =>
                    ENABLE <= '1';
                    STATE_DECODE <= "000";
                    if (START='1') then
                        STATE <=RANDOM_TIME;
                       
                    end if;
                
                when RANDOM_TIME =>
                    STATE_DECODE <= "001";
                    ENABLE <= '0';   
                    
                    if (STOP='1') then
                       STATE <= ERROR;
                    elsif (CLEAR='1') then
                        STATE <= INITIALIZE;
                    elsif (TRIGGER_COUNT='1') then
                        STATE <= COUNTING;
                    end if;
                when COUNTING =>
                -- count-up circuitry is activated by 1kHz clock.
                -- See circuitry at MILLISECONDS_COUNT label
                    STIMULUS <= "111";
                   STATE_DECODE <= "010";
                    ENABLE <= '1';
                    if (STOP='1') then
                        STATE <= HOLD;
                    elsif (CLEAR='1') then
                        STATE <= INITIALIZE;
               
                    elsif (TRIGGER_COUNT = '1') then
                        STATE <= HOLD; 
                    end if;
                    
                when ERROR =>
                    STATE_DECODE <= "011";
                    ENABLE <= '1';
                    if (CLEAR='1') then
                        STATE <= INITIALIZE;
                    end if;
                when HOLD =>
                    STATE_DECODE <= "100";
                    STIMULUS <= "000";
                    ENABLE <= '1';
                    if (CLEAR='1') then
                        STATE <= INITIALIZE;
                    end if;
                when others =>
                    STATE <= INITIALIZE;
                    ENABLE <= '1';
            end case;
        end if;
    end process;
    

end BEHAVIORAL;