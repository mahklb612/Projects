----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 1.08.2023 10:31:23
-- Module Name: RANDOM NUMBER GENERATOR
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RANDOM_NUMBER_GENERATOR is
    port (
        RAND1:   out std_logic_vector(3 downto 0); --4-bit output for the random number
        CLOCK:  in std_logic  -- Input clock signals
    );
end RANDOM_NUMBER_GENERATOR;

architecture BEHAVIORAL of RANDOM_NUMBER_GENERATOR is
    signal LFSR_REG1:   std_logic_vector(3 downto 0) := "1010"; -- 4-bit signal for the first LFSR (Linear Feedback Shift Register)
    signal LFSR_REG2:   std_logic_vector(3 downto 0) := "1010"; -- 4-bit signal for the second LFSR
    signal RES :      std_logic; -- Single bit signal for the feedback XOR result
    signal CLOCK1:    std_logic; -- Internal signal to hold the CLOCK value        
begin
    process(CLOCK1, LFSR_REG1, LFSR_REG2)
    begin
        if rising_edge(CLOCK1) then 
            LFSR_REG1 <= LFSR_REG2; -- Shift the value of LFSR_REG2 into LFSR_REG1 on the rising edge of CLOCK1
        end if;
    end process;
    RAND1 <= LFSR_REG1;                          -- Output the value of LFSR_REG1 as the random number
    CLOCK1 <= CLOCK;                             --Assign the value of the input CLOCK signal to the internal signal CLOCK1
    RES <= LFSR_REG1(1) xor LFSR_REG1(0);        -- Perform XOR operation between the two least significant bits of LFSR_REG1 and store the result in RES
    LFSR_REG2 <= RES & LFSR_REG1(3 downto 1);    -- Concatenate the value of RTN with the three most significant bits of LFSR_REG1, and store the result in LFSR_REG2
                                                 -- This line effectively performs the feedback and shift operations of the LFSR to generate the next random value.
end BEHAVIORAL;