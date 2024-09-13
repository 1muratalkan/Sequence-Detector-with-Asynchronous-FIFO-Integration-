library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_top_level is
--  Port ( );
end tb_top_level;

architecture Behavioral of tb_top_level is
 
 -- Parameters
 constant DW    : integer := 1;
 constant AW    : integer := 3;
 
 -- Clock periods
 constant WR_CLK_PERIOD : time := 10 ns; -- 100 MHz
 constant RD_CLK_PERIOD : time := 25 ns; -- 40 MHz
 
 signal ARSTN         : std_logic;                         
 --Write Part
 signal WR_CLK        : std_logic;                        
 signal WR_EN         : std_logic;                        
 signal DIN           : std_logic_vector(DW-1 downto 0);  
 signal FULL          : std_logic;                        
 --Read Part
 signal RD_CLK        : std_logic;                        
 signal RD_EN         : std_logic;                        
 signal DOUT          : std_logic_vector(DW-1 downto 0);  
 signal EMPTY         : std_logic;                        
 -- Sequence Detarts                             
 signal detector_out  : std_logic;                        


component top_level is
    generic (
        DW : integer := 1;
        AW : integer := 3
    );
    Port (        
        ARSTN           : in  std_logic;
        --Write Parts
        WR_CLK          : in  std_logic;
        WR_EN           : in  std_logic;
        DIN             : in  std_logic_vector(DW-1 downto 0);
        FULL            : out std_logic;
        --Read Parts
        RD_CLK          : in  std_logic;
        RD_EN           : in  std_logic;
        DOUT            : out std_logic_vector(DW-1 downto 0);
        EMPTY           : out std_logic;
        -- Sequence Detector Parts
        detector_out    : out std_logic
        
    );
end component;

begin

    inst_top_level : top_level
    generic map (
        DW => DW,
        AW => AW
    )
    Port map (               
        ARSTN        => ARSTN ,       
        --Write Part         
        WR_CLK       => WR_CLK,       
        WR_EN        => WR_EN ,       
        DIN          => DIN   ,       
        FULL         => FULL  ,       
        --Read Part           
        RD_CLK       => RD_CLK,       
        RD_EN        => RD_EN ,       
        DOUT         => DOUT  ,       
        EMPTY        => EMPTY ,       
        -- Sequence Detector Parts
        detector_out => detector_out        
    ); 

    -- WR_CLK (write clock)
    WR_CLK_Process : process
    begin
        WR_CLK <= '0';
        wait for WR_CLK_PERIOD / 2;
        WR_CLK <= '1';
        wait for WR_CLK_PERIOD / 2;
    end process WR_CLK_Process;

    -- RD_CLK (read clock)
    RD_CLK_Process : process
    begin
        RD_CLK <= '0';
        wait for RD_CLK_PERIOD / 2;
        RD_CLK <= '1';
        wait for RD_CLK_PERIOD / 2;
    end process RD_CLK_Process;

    Sim_process : process
    begin
        -- Apply reset
        ARSTN <= '0';
        WR_EN <= '0';
        RD_EN <= '0';
        DIN <= (others => '0');
        wait for 20 ns; -- Wait for reset duration
        
        -- Release reset
        ARSTN <= '1'; wait for 10 ns;

        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 0 write cycle
        WR_EN <= '1'; DIN <= "0"; wait for WR_CLK_PERIOD; -- 1 write cycle 
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 2 write cycle       
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 3 write cycle             
        WR_EN <= '1'; DIN <= "0"; wait for WR_CLK_PERIOD; -- 4 write cycle
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 5 write cycle         
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 6 write cycle
        WR_EN <= '1'; DIN <= "0"; wait for WR_CLK_PERIOD; -- 7 write cycle   
         
        WR_EN <= '0'; wait for 50 ns; -- Stop writing

        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 0 data     
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 1 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 2 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 3 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 4 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 5 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 6 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 7 data
      
       
        RD_EN <= '0'; wait for 10 ns;  -- Stop reading
        
        
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 0 write cycle
        WR_EN <= '1'; DIN <= "0"; wait for WR_CLK_PERIOD; -- 1 write cycle 
        WR_EN <= '1'; DIN <= "0"; wait for WR_CLK_PERIOD; -- 2 write cycle       
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 3 write cycle             
        WR_EN <= '1'; DIN <= "0"; wait for WR_CLK_PERIOD; -- 4 write cycle
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 5 write cycle         
        WR_EN <= '1'; DIN <= "1"; wait for WR_CLK_PERIOD; -- 6 write cycle
        WR_EN <= '1'; DIN <= "0"; wait for WR_CLK_PERIOD; -- 7 write cycle
                     
        WR_EN <= '0'; wait for 50 ns;-- Stop writing

        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 0 data     
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 1 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 2 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 3 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 4 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 5 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 6 data
        RD_EN <= '1'; wait for RD_CLK_PERIOD; --Read 7 data
      
        
        RD_EN <= '0'; wait for 100 ns;  -- Stop reading      
        
        wait;
    end process;

end Behavioral;
