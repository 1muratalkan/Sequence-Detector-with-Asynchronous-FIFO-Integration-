----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Murat Alkan
-- Module Name: synchrone_bin_pointer - Behavioral
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchrone_bin_pointer is
    generic (
        WIDTH : integer := 10
    );
    port (
        SRC_CLK      : in  std_logic;   --Source Clock
        DST_CLK      : in  std_logic;   --Destination Clock
        SRC_BIN_PTR  : in  std_logic_vector(WIDTH-1 downto 0);
        DST_BIN_PTR  : out std_logic_vector(WIDTH-1 downto 0)
    );
end synchrone_bin_pointer;

architecture Behavioral of synchrone_bin_pointer is

    -- Gray code to Binary code
    function gray2bin_f(gray_i : std_logic_vector(WIDTH-1 downto 0)) return std_logic_vector is
        variable var_bin : std_logic_vector(WIDTH-1 downto 0);
    begin
        var_bin(WIDTH-1) := gray_i(WIDTH-1);
        for i in WIDTH-2 downto 0 loop
            var_bin(i) := var_bin(i+1) xor gray_i(i);
        end loop;
        return var_bin;
    end function gray2bin_f;

    -- Binary code to Gray code
    function bin2gray_f(bin_i : std_logic_vector(WIDTH-1 downto 0)) return std_logic_vector is
        variable var_gray : std_logic_vector(WIDTH-1 downto 0);
    begin
        var_gray(WIDTH-1) := bin_i(WIDTH-1);
        for i in WIDTH-2 downto 0 loop
            var_gray(i) := bin_i(i+1) xor bin_i(i);
        end loop;
        return var_gray;
    end function bin2gray_f;

    signal src_gray_pointer  : std_logic_vector(WIDTH-1 downto 0);
    signal dst_gray_pointer0 : std_logic_vector(WIDTH-1 downto 0);
    signal dst_gray_pointer1 : std_logic_vector(WIDTH-1 downto 0);
    
begin

    process(SRC_CLK) 
    begin
        if rising_edge(SRC_CLK) then
            src_gray_pointer <= bin2gray_f(SRC_BIN_PTR);
        end if;
    end process;

    process(DST_CLK)
    begin
        if rising_edge(DST_CLK) then
            dst_gray_pointer0 <= src_gray_pointer;
            dst_gray_pointer1 <= dst_gray_pointer0;
            DST_BIN_PTR <= gray2bin_f(dst_gray_pointer1);
        end if;
    end process;
    
end Behavioral;
