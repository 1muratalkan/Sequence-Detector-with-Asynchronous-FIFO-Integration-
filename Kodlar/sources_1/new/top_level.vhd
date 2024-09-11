----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Murat Alkan
-- Module Name: top_level - Behavioral
-- Vivado (2008)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
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
end top_level;
 
architecture Behavioral of top_level is

component asynchrone_fifo is
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
end component;

component sequence_detector is 
	port (
		clk				: in std_logic;
		reset			: in std_logic;
		data_in			: in std_logic;
		enable          : in std_logic;
		--
		detector_out	: out std_logic
	);
end component;

begin

ins_async_fifo : asynchrone_fifo 
    generic map (
        DW => DW,
        AW => AW
    )
    port map (
        ARSTN   => ARSTN   ,
        --
        WR_CLK  => WR_CLK  ,
        WR_EN   => WR_EN   ,
        DIN     => DIN     ,
        FULL    => FULL    ,
        --
        RD_CLK  => RD_CLK  ,
        RD_EN   => RD_EN   ,
        DOUT    => DOUT    ,
        EMPTY   => EMPTY   
    );

ins_seq_dec : sequence_detector  
	port map (
		clk				=> RD_CLK   ,	  
		reset			=> ARSTN	,	
		data_in			=> DOUT(0)	,	
		enable           => rd_en    ,	
		--	                      
		detector_out	=> detector_out 
	);

end Behavioral;
