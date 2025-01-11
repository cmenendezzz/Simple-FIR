----------------------------------------------------------------------------------
-- Company: 
-- Engineer: CLAUDIA MENENDEZ CARDENES
-- 
-- Create Date: 01/11/2025 07:06:30 PM
-- Design Name: 
-- Module Name: FIR_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity top_FIR_module is
    Port (
      clk: in STD_LOGIC;
      rst: in STD_LOGIC;
      en: in STD_LOGIC; 
      x_in:in STD_LOGIC_VECTOR(15 downto 0);
      TREADY: in STD_LOGIC;
      TVALID : out STD_LOGIC;
      --TLAST : out STD_LOGIC;
      TDATA: out STD_LOGIC_VECTOR(31 downto 0);
     );
  end top_FIR_module;

architecture Behavioral of top_FIR_module is

    component FIR_module
        Port (
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            en: in STD_LOGIC; 
            x_in: in STD_LOGIC_VECTOR(15 downto 0);
            y_out: out STD_LOGIC_VECTOR(31 downto 0);
           );
    end component; 

    --signal x_in: STD_LOGIC_VECTOR(15 downto 0);
    signal y_out: STD_LOGIC_VECTOR(31 downto 0);
    signal ready_for_output : STD_LOGIC := '0';
    signal y_out_reg   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin     
    fir_instance: FIR_module
        port map(
            clk=>clk,
            rst=>rst,
            en=>en, 
            x_in=>x_in,
            y_out=>y_out
        );
    process(clk)
    begin
        if rising_edge(clk) then 

            if rst='0' then 
                TDATA<=(others => '0') ;
                TVALID<='0';
                --TLAST<='0';
                --x_in<=(others => '0') ;
                y_out<=(others => '0') ;
                ready_for_output <= '0';

            elsif en='1' then 
                if ready_for_output = '0' then
                    y_out_reg <= y_out; 
                    ready_for_output <= '1'; 
                end if;
                if TREADY = '1' and ready_for_output = '1' then
                    TDATA <= y_out_reg;
                    TVALID <= '1';
                    ready_for_output <= '0';
                else
                    TVALID <= '0'; 
                end if;
            end if; 
        end if; 
        end process; 
end Behavioral;
    