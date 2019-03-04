-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul broji sekunde i prikazuje na LED diodama                                         
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_counter IS PORT (
                               clk_i     : IN STD_LOGIC; -- ulazni takt
                               rst_i     : IN STD_LOGIC; -- reset signal 
                               one_sec_i : IN STD_LOGIC; -- signal koji predstavlja proteklu jednu sekundu vremena 
                               cnt_en_i  : IN STD_LOGIC; -- signal dozvole brojanja                              
                               cnt_rst_i : IN STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               led_o     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka led diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS
SIGNAL counter_value_r : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_value_r_next : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL en_query:STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL rst_query:STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL one_query:STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN

-- DODATI :
-- brojac koji na osnovu izbrojanih sekundi pravi izlaz na LE diode
	process(clk_i, rst_i) begin
		if(rst_i='1') then
			counter_value_r<=(others=>'0');
		elsif(rising_edge(clk_i)) then
			counter_value_r<=counter_value_r_next;
		end if;
	end process;
	--mux en
	counter_value_r_next<=rst_query when cnt_en_i='1' else (others=>'0');
	--mux rst
	rst_query<=one_query when cnt_rst_i='0' else (others=>'0');
	--mux one
	one_query<=counter_value_r when one_sec_i='0' else counter_value_r+1;
	
	led_o<=counter_value_r;
	
END rtl;