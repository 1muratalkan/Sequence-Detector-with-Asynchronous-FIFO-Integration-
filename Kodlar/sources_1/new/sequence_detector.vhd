----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Murat Alkan
-- Module Name: sequence_detector - Behavioral
-- Description: Overlapping sequence detector for the sequence "1011"
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sequence_detector is 
	port (
			clk				: in std_logic;
			reset			: in std_logic;
			data_in			: in std_logic;
			enable          : in std_logic;
			--
			detector_out	: out std_logic
	);
end entity;

architecture Behavioral of sequence_detector is

type state_type is (S0, S1, S2, S3);
signal current_state, next_state : state_type := S0;

begin 

	process( clk, reset)
	begin
		if reset = '0' then
			current_state <= S0;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process;	


	process( current_state, data_in, enable) 
	begin
		detector_out <= '0';
		next_state <= current_state;
		
		if enable = '1' then
            case current_state is
            
                when S0 =>
                    if data_in = '1' then
                        next_state <= S1;
                    else
                        next_state <= S0;
                    end if;
                    
                when S1 =>
                    if data_in = '1'  then
                        next_state <= S1;
                    else
                        next_state <= S2;
                    end if;
                    
                when S2 =>
                    if data_in = '1' then
                        next_state <= S3;
                    else
                        next_state <= S2;
                    end if;
                
                when S3 =>
                    if data_in = '1' then
                        next_state <= S1;
                        detector_out <= '1';	
                    else
                        next_state <= S2;
                    end if;
                
                when others =>
                    next_state <= S0; 
            end case;
        else
        detector_out <= '0';	
        end if;	
	end process;

end Behavioral;