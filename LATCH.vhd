----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 31.07.2023 12:21:22
-- Module Name: 4- BIT LATCH
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LATCH is
    port (
        RAND_IN:  in std_logic_vector(3 downto 0);  --4-bit Random Number input for the data to be latched
        C:  in std_logic; --1 bit control 
        RAND_OUT:  out std_logic_vector(3 downto 0) -- 4-bit output for the latched data
    );
end LATCH;

architecture STRUCTURE of LATCH is  -- Architecture of 4-bit Latch
begin
    process(RAND_IN)  
    begin
        if (C='1') then                      -- Only perform the latching operation when control is high.
            if (RAND_IN = "0001") then       --Check if the input data equals "0001"
                RAND_OUT <= "0010";          -- If the input data is 1, set the output data to 2 (latching the new value)
            else
                RAND_OUT(0)<=RAND_IN (0);    -- Latch the individual bits of Random Number input data to the corresponding bits of the output data
                RAND_OUT(1)<=RAND_IN (1);
                RAND_OUT(2)<=RAND_IN (2);
                RAND_OUT(3)<=RAND_IN (3);
            end if;                             
        end if;                              -- If the  C is low, the latching operation is skipped and the output data remains unchanged.
    end process;
end STRUCTURE;
