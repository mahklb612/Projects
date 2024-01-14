----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 25.07.2023 13:23:38
-- Module Name: 4 BIT COMPARATOR 
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity COMPARATOR_4_BIT is
    port (
        NUM1:   in std_logic_vector(3 downto 0); --Counter Output
        NUM2:   in std_logic_vector(3 downto 0); --Random Number Output
        CLK2:   in std_logic;
        EN:     in std_logic;
        COMP:   out std_logic
    );
end COMPARATOR_4_BIT;

architecture BEHAVIORAL of COMPARATOR_4_BIT is
begin
    process(NUM1,NUM2,CLK2,EN)
    begin
        if (EN='1') then
            COMP <= '0';
        elsif (NUM1 >= NUM2) then
            COMP <= '1';
        else
            COMP <= '0';
        end if;
     
    end process;
end BEHAVIORAL;
