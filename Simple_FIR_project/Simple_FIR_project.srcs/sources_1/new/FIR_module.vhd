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

entity FIR_module is
  Port ( 
    clk: in std_logic;
    rst: in STD_LOGIC;
    en: in STD_LOGIC; 
    x_in: in STD_LOGIC_VECTOR(15 downto 0);
    y_out: out STD_LOGIC_VECTOR(31 downto 0);
   );
end FIR_module;

architecture Behavioral of FIR_module is
-- translated into fixed point representation 
-- MSB=signed bit  
constant h_0  : signed(15 downto 0) := to_signed(-868, 16);  
constant h_1  : signed(15 downto 0) := to_signed(0, 16);     
constant h_2  : signed(15 downto 0) := to_signed(1445, 16);  
constant h_3  : signed(15 downto 0) := to_signed(0, 16);     
constant h_4  : signed(15 downto 0) := to_signed(-3796, 16); 
constant h_5  : signed(15 downto 0) := to_signed(0, 16);     
constant h_6  : signed(15 downto 0) := to_signed(10285, 16); 
constant h_7  : signed(15 downto 0) := to_signed(16384, 16); 
constant h_8  : signed(15 downto 0) := to_signed(10285, 16); 
constant h_9  : signed(15 downto 0) := to_signed(0, 16);     
constant h_10 : signed(15 downto 0) := to_signed(-3796, 16); 
constant h_11 : signed(15 downto 0) := to_signed(0, 16);     
constant h_12 : signed(15 downto 0) := to_signed(1445, 16);  
constant h_13 : signed(15 downto 0) := to_signed(0, 16);     
constant h_14 : signed(15 downto 0) := to_signed(-868, 16);  
constant N: INTEGER :=15;

signal y_temp: STD_LOGIC_VECTOR (31 downto 0);


signal index : integer range 0 to N-1 := 0;
signal y_out_reg       : std_logic_vector (31 downto 0) := (others => '0'); 
type signed_array is array (0 to N-1) of signed(15 downto 0);
signal circular_buffer : signed_array  := (others => (others => '0'));

begin
process(clk)
    variable acc : signed(63 downto 0):= (others => '0') ;
begin 
    if rst='0' then 
        circular_buffer<=(others => (others => '0')  );
        y_out<=(others => '0') ;
        index<=0;
        acc:=(others => '0') ;
    elsif rising_edge(clk) then
        if en='1' then
 
            circular_buffer(index)<=signed(x_in);
            if index=(N-1)then 
                index<=0; 
            else
                index<=index+1;
            end if; 
            acc :=  circular_buffer(0)*h_0+
            circular_buffer(1)*h_1+
            circular_buffer(2)*h_2+
            circular_buffer(3)*h_3+
            circular_buffer(4)*h_4+
            circular_buffer(5)*h_5+
            circular_buffer(6)*h_6+
            circular_buffer(7)*h_7+
            circular_buffer(8)*h_8+
            circular_buffer(9)*h_9+
            circular_buffer(10)*h_10+
            circular_buffer(11)*h_11+
            circular_buffer(12)*h_12+
            circular_buffer(13)*h_13+
            circular_buffer(14)*h_14;
            
            y_out_reg<=std_logic_vector(acc(31 downto 0));
        end if; 
    end if;  
    y_out<=y_out_reg;
    end process; 
end Behavioral;
