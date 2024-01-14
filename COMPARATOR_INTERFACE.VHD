----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 25.07.2023 14:30:12
-- Module Name: COMPARATOR_INTERFACE
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMPARATOR_INTERFACE is
    Port (
        CLOCK_SEC:      in std_logic;
        RANDOM_NUMBER:  in std_logic_vector(3 downto 0);
        EN1:        in std_logic;
        COUNT_T:  out std_logic
    );
end COMPARATOR_INTERFACE;



architecture BEHAVIORAL of COMPARATOR_INTERFACE is


component RANDOM_NUMBER_GENERATOR is
    port (
        RAND1:   out std_logic_vector(3 downto 0); --4-bit output for the random number
        CLOCK:  in std_logic  -- Input clock signal
        -- RAND2: out STD_LOGIC_VECTOR(3 downto 0)  -- 4-bit random number output (0 to 15)
    );
            
end component;

component LATCH is
    port (
        RAND_IN:  in std_logic_vector(3 downto 0);  --4-bit Random Number input for the data to be latched
        C:  in std_logic --1 bit control 
        --RAND_OUT:  out std_logic_vector(3 downto 0) -- 4-bit output for the latched data
    );
end component;
component COMPARATOR_4_BIT is
    port (
            NUM1:   in std_logic_vector(3 downto 0); --Counter Output
            NUM2:   in std_logic_vector(3 downto 0); --Random Number Output
            CLK2:   in std_logic;
            EN:     in std_logic;
            COMP:   out std_logic
        );
    end component;
    
    component COUNTER_BLOCK is
        port (
            CLK:    in STD_LOGIC;
            RESET:   in STD_LOGIC;
            C_OUT:      out STD_LOGIC_VECTOR ( 3 downto 0 )
        );
    end component;
    
    signal RAND_OUT_TO_NUM2:     std_logic_vector(3 downto 0);
    signal C_OUT_TO_NUM1:     std_logic_vector(3 downto 0); 
begin

-- When control is 1
--  counter will have its SCLR high so it resets.
--  compare register will have its E high so random number is loaded.
--  comparator will have its pause high so gtoe is forced to remain 0.
-- When contol is 0
--  counter will have SCLR low so it begins counting up.
--  compare register will have its E low so its Q maintains last D value.
--  comparator will have its pause high so gtoe will be 1 when its A > B
    
    

COUNTER_COMPARATOR: COUNTER_BLOCK  port map(CLK=>CLOCK_SEC, C_OUT=>C_OUT_TO_NUM1, RESET=>EN1);
COMPARATOR: COMPARATOR_4_BIT port map(NUM1=>C_OUT_TO_NUM1, NUM2=>RAND1_TO_NUM2, COMP=>COUNT_T, CLK2=>CLOCK_SEC, EN=>EN1); 
CCOMPARE: LATCH port map(RAND_IN=>RANDOM_NUMBER, C=>EN1, RAND_OUT=>RAND_OUT_TO_NUM2);       

end BEHAVIORAL;