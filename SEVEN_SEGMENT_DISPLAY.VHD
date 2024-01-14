----------------------------------------------------------------------------------
-- Project Name: FPGA Coursework
-- Group: Flip Flops
-- Create Date: 25.07.2023 14:30:12
-- Module Name: DISPLAY
-- Target Devices: Nexys-4-DDR
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SEVEN_SEGMENT_DISPLAY is
    Port (CLOCK_DISP : in std_logic;  
          ONE_MS : in integer; 
          TEN_MS : in integer; 
          HUNDRED_MS : in integer; 
          THOUSAND_MS : in integer; 
          STATE : in std_logic_vector(2 downto 0);   
          DISPLAY_ANODE : out std_logic_vector(7 downto 0); 
          DISPLAY_CATHODE : out std_logic_vector(7 downto 0)
          );
end SEVEN_SEGMENT_DISPLAY;

architecture display_behav of SEVEN_SEGMENT_DISPLAY is

begin
process(CLOCK_DISP)    
variable SEGMENTS: unsigned(1 downto 0) := "00";
begin
    if rising_edge(CLOCK_DISP) then
        if STATE = "000" then 
                case (SEGMENTS) is
                    when "00"  => 
                        DISPLAY_ANODE <= "11110111";
                        DISPLAY_CATHODE <= "11111111";
                    when "01" =>    --Displays a 'H' in the second segment - Archie [NEW]
                        DISPLAY_ANODE <= "11111011";
                        DISPLAY_CATHODE <= "10010001";
                    when "10" =>    --Displays an 'I' on the third segment - Archie [NEW].
                        DISPLAY_ANODE <= "11111101";
                        DISPLAY_CATHODE <= "11110011";
                    when "11" =>    --Displays nothing on the fourth segment - Archie [NEW].
                        DISPLAY_ANODE <= "11111110";
                        DISPLAY_CATHODE <= "11111111";
                    when others =>  --This should never happen [NEW].
                        DISPLAY_ANODE <= "11110000";
                        DISPLAY_CATHODE <= "11111110";
                end case;
                SEGMENTS := SEGMENTS + 1;
        elsif STATE = "001" then 
                DISPLAY_ANODE <= "11110000"; --Selects all seven segment displays - Archie [1st commit].
                DISPLAY_CATHODE <= "11111111"; --Turns all seven segments LEDs off - Archie [1st commit].
        elsif ((STATE = "010") or (STATE = "100")) then --state is count or hold -Archie [1st commit].
            case (SEGMENTS) is
                when "00" =>
                    DISPLAY_ANODE <= "11110111"; --Display seconds - Archie [1st commit].
                    case (ONE_MS) is
                        when 0 =>
                            DISPLAY_CATHODE <= "00000011";
                        when 1 =>
                            DISPLAY_CATHODE <= "10011111"; --Should never display a value above 1 in left most seven segment display during count or hold - Archie [1st commit].
                        when others =>
                            DISPLAY_CATHODE <= "11111110";  --Seven segment display will output only the decimal point if it gets a value here it shouldn't - Archie [1st commit].
                        end case;
                when "01" =>
                    DISPLAY_ANODE <= "11111011"; --Display 100s of milliseconds - Archie [1st commit].
                    case (HUNDRED_MS) is
                        when 0 =>
                            DISPLAY_CATHODE <= "00000011";  --Seven segment display will output 0 - Archie [1st commit].
                        when 1 =>
                            DISPLAY_CATHODE <= "10011111"; --Seven segment display will output 1 - Archie [1st commit].
                        when 2 =>
                            DISPLAY_CATHODE <= "00100101"; --Seven segment display will output 2 - Archie [1st commit].
                        when 3 =>
                            DISPLAY_CATHODE <= "00001101"; --Seven segment display will output 3 - Archie [1st commit].
                        when 4 =>
                            DISPLAY_CATHODE <= "10011001"; --Seven segment display will output 4 - Archie [1st commit].
                        when 5 =>
                            DISPLAY_CATHODE <= "01001001"; --Seven segment display will output 5 - Archie [1st commit].
                        when 6 =>
                            DISPLAY_CATHODE <= "11000001";  --Seven segment display will output 6 - Archie [1st commit].
                        when 7 =>
                             DISPLAY_CATHODE <= "00011111";  --Seven segment display will output 7 - Archie [1st commit].
                        when 8 =>
                             DISPLAY_CATHODE <= "00000001";  --Seven segment display will output 8 - Archie [1st commit].
                        when 9 =>
                             DISPLAY_CATHODE <= "00011001";  --Seven segment display will output 9 - Archie [1st commit].
                        when others =>
                              DISPLAY_CATHODE <= "11111110";  
                        end case;
                when "10" =>
                    DISPLAY_ANODE <= "11111101"; --Display 10s of milliseconds - Archie [1st commit].
                        case (TEN_MS) is
                            when 0 =>
                                DISPLAY_CATHODE <= "00000011";
                            when 1 =>
                                DISPLAY_CATHODE <= "10011111";
                            when 2 =>
                                DISPLAY_CATHODE <= "00100101";
                            when 3 =>
                                DISPLAY_CATHODE <= "00001101";
                            when 4 =>
                                 DISPLAY_CATHODE <= "10011001";
                            when 5 =>
                                 DISPLAY_CATHODE <= "01001001";
                            when 6 =>
                                  DISPLAY_CATHODE <= "11000001";
                            when 7 =>
                                  DISPLAY_CATHODE <= "00011111";
                            when 8 =>
                                  DISPLAY_CATHODE <= "00000001";
                            when 9 =>
                                  DISPLAY_CATHODE <= "00011001";
                            when others =>
                                   DISPLAY_CATHODE <= "11111110";
                            end case;
                when "11" =>
                    DISPLAY_ANODE <= "11111110"; --Display 1s of milliseconds - Archie [1st commit].
                    case (ONE_MS) is
                        when 0 =>
                            DISPLAY_CATHODE <= "00000011";
                        when 1 =>
                             DISPLAY_CATHODE <= "10011111";
                        when 2 =>
                             DISPLAY_CATHODE <= "00100101";
                        when 3 =>
                              DISPLAY_CATHODE <= "00001101";
                        when 4 =>
                              DISPLAY_CATHODE <= "10011001";
                        when 5 =>
                              DISPLAY_CATHODE<= "01001001";
                        when 6 =>
                              DISPLAY_CATHODE <= "11000001";
                        when 7 =>
                              DISPLAY_CATHODE <= "00011111";
                        when 8 =>
                              DISPLAY_CATHODE <= "00000001";
                        when 9 =>
                              DISPLAY_CATHODE <= "00011001";
                        when others =>
                              DISPLAY_CATHODE <= "11111110";
                         end case;             
                when others =>
                    DISPLAY_ANODE <= "11110000";
                    DISPLAY_CATHODE <= "11111110";
            end case;
            SEGMENTS := SEGMENTS + 1; --seg_sel interates to select the next seven segment display - Archie [1st commit]  
        elsif STATE = "011" then --Display during the error state.
                    DISPLAY_ANODE <=  "11110000"; --Selects all seven segment displays - Archie [1st commit].
                    DISPLAY_CATHODE <= "00011001"; --Sets seven segment display to 9 - Archie [1st commit].
       end if;
    end if;
    
end process;
end display_behav;