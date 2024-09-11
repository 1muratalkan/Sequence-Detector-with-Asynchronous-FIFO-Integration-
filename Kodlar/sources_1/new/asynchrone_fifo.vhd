----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Murat Alkan
-- Module Name: asynchrone_fifo - Behavioral 
-- Vivado 2008
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity asynchrone_fifo is
    generic (
        DW : integer := 1;
        AW : integer := 3
    );
    port (
        ARSTN   : in  std_logic;
        --
        WR_CLK  : in  std_logic;
        WR_EN   : in  std_logic;
        DIN     : in  std_logic_vector(DW-1 downto 0);
        FULL    : out std_logic;
        --
        RD_CLK  : in  std_logic;
        RD_EN   : in  std_logic;
        DOUT    : out std_logic_vector(DW-1 downto 0);
        EMPTY   : out std_logic
    );
end asynchrone_fifo;

architecture Behavioral of asynchrone_fifo is

signal wr_srstn, rd_srstn : std_logic;

component reset_synchronizer is
    port (
            clk         : in  std_logic;
            Async_RST   : in  std_logic;
            Sync_RST    : out std_logic   
    );
end component;

component synchrone_bin_pointer is
    generic (
        WIDTH : integer := 10
    );
    port (
        SRC_CLK      : in  std_logic;   --Source Clock
        DST_CLK      : in  std_logic;   --Destination Clock
        SRC_BIN_PTR  : in  std_logic_vector(WIDTH-1 downto 0);
        DST_BIN_PTR  : out std_logic_vector(WIDTH-1 downto 0)
    );
end component;

    type DPRAM_TYPE is array (0 to 2**AW-1) of std_logic_vector(DW-1 downto 0);
    signal DPRAM : DPRAM_TYPE;
    
    signal wr_pointer, rd_pointer               : std_logic_vector(AW downto 0);
    signal wr_pointer_synced, rd_pointer_synced : std_logic_vector(AW downto 0);

begin

    -- Sync resets instances
    sync_reset_wr: reset_synchronizer
        port map (
            clk => WR_CLK,
            Async_RST => ARSTN,
            Sync_RST => wr_srstn
        );

    sync_reset_rd: reset_synchronizer
        port map (
            clk => RD_CLK,
            Async_RST => ARSTN,
            Sync_RST => rd_srstn
        );
        
        
    -- Write operation-----------------------------------------------------------------------------------
    process (WR_CLK)
    begin
        if rising_edge(WR_CLK) then
            if wr_srstn = '0' then
                wr_pointer <= (others => '0');
            elsif (FULL = '0' and WR_EN = '1') then
                DPRAM(to_integer(unsigned(wr_pointer(AW-1 downto 0)))) <= DIN;
                wr_pointer <= std_logic_vector(unsigned(wr_pointer) + 1);
            end if;
        end if;
    end process;
    
    -- Synchronize write pointer to read clock domain
    synchrone_bin_pointer_wr2rd: synchrone_bin_pointer
        generic map (WIDTH => AW+1
        )
        port map (
            SRC_CLK => WR_CLK,
            DST_CLK => RD_CLK,
            SRC_BIN_PTR => wr_pointer,
            DST_BIN_PTR => wr_pointer_synced
        );


    -- Read operation-----------------------------------------------------------------------------------
    process (RD_CLK)
    begin
        if rising_edge(RD_CLK) then
            if rd_srstn = '0' then
                rd_pointer <= (others => '0');
            elsif (EMPTY = '0' and RD_EN = '1') then
                DOUT <= DPRAM(to_integer(unsigned(rd_pointer(AW-1 downto 0))));
                rd_pointer <= std_logic_vector(unsigned(rd_pointer) + 1);
            end if;
        end if;
    end process;
    
    -- Synchronize read pointer to write clock domain
    synchrone_bin_pointer_rd2wr: synchrone_bin_pointer
        generic map (WIDTH => AW+1
        )
        port map (
            SRC_CLK => RD_CLK,
            DST_CLK => WR_CLK,
            SRC_BIN_PTR => rd_pointer,
            DST_BIN_PTR => rd_pointer_synced
        );
    
    -- FIFO full/empty flags
    EMPTY <= '1' when wr_pointer_synced = rd_pointer else '0';
    FULL <= '1' when rd_pointer_synced(AW) /= wr_pointer(AW) and rd_pointer_synced(AW-1 downto 0) = wr_pointer(AW-1 downto 0) else '0';
    
end Behavioral;
