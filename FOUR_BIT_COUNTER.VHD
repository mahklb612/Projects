----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 27.07.2023 18:10:12
-- Module Name: 4 BIT COUNTER
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity FOUR_BIT_COUNTER is
     port (
           RESET:   in STD_LOGIC; -- Reset input
           CLK:    in STD_LOGIC; -- Clock input
           C_OUT:      out STD_LOGIC_VECTOR ( 3 downto 0 ) -- 4-bit output
          );
end FOUR_BIT_COUNTER;

architecture BEHAVIORAL of FOUR_BIT_COUNTER is

    signal COUNT_REG : std_logic_vector(0 to 3); -- Internal counter register

    begin
        process(RESET,CLK)--  Process to update the counter
            begin
                if (RESET = '1')-- Check if reset is High 
                 then COUNT_REG <= "0000"; -- Reset the counter to 0
                elsif (CLK'event and CLK = '1')
                 then COUNT_REG <= COUNT_REG + 1; -- Increment the counter on the rising edge of the clock
                end if;
        end process;
        
         C_OUT <= COUNT_REG;  -- Output the 4-bit counter value
         
end BEHAVIORAL;