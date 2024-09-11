----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Murat Alkan
-- Module Name: reset_synchronizer - Behavioral
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_synchronizer is
    port (
            clk         : in  std_logic;
            Async_RST   : in  std_logic;
            Sync_RST    : out std_logic   
    );
end reset_synchronizer;

architecture Behavioral of reset_synchronizer is

signal reg1 : std_logic;
    
begin

    process(clk, Async_Rst)
    begin
        if( Async_Rst = '0') then
            reg1        <= '0';
            Sync_RST    <= '0';
        else 
            reg1        <= '1';
            Sync_RST    <= reg1;
        end if;
    end process;

end Behavioral;
