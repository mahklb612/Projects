----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 31.07.2023 13:22:22
-- Module Name: COUNTER BLOCK
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity COUNTER_BLOCK is
    port (
        CLK:    in STD_LOGIC;
        RESET:   in STD_LOGIC;
        C_OUT:      out STD_LOGIC_VECTOR ( 3 downto 0 )
    );
end COUNTER_BLOCK;


architecture STRUCTURAL of COUNTER_BLOCK is

component FOUR_BIT_COUNTER is
       port (
               RESET:   in STD_LOGIC; -- Reset input
               CLK:    in STD_LOGIC; -- Clock input
               C_OUT:      out STD_LOGIC_VECTOR ( 3 downto 0 ) -- 4-bit output
              );
   
       end component FOUR_BIT_COUNTER;

begin
    
COUNTER: component FOUR_BIT_COUNTER port map (CLK => CLK, C_OUT(3 downto 0) => C_OUT(3 downto 0), RESET=> RESET);

end STRUCTURAL;
