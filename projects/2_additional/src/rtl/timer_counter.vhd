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
                              clk_i         : IN STD_LOGIC;                    -- ulazni takt
                              rst_i         : IN STD_LOGIC;                    -- reset aktivan 
                              one_sec_i     : IN STD_LOGIC;                    -- signal koji predstavlja proteklu jednu sekundu vremena 
                              cnt_en_i      : IN STD_LOGIC;                    -- signal dozvole brojanja
                              cnt_rst_i     : IN STD_LOGIC;                    -- signal resetovanja brojaca (clear signal)

                              -- modul se prosiruje sa dva ulaza koji predstavljaju stanja tastera

                              button_min_i  : IN STD_LOGIC;                    -- taster koji cijim se aktiviranjem na LE diodama prikazuju protekle minute
                              button_hour_i : IN STD_LOGIC;                    -- taster koji cijim se aktiviranjem na LE diodama prikazuju protekli sati
                              led_o         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka LE diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS

SIGNAL counter_value_s   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_for_min_s : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_for_min_s_next : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_for_h_s   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_for_h_s_next   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_value_s_next:STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL neki_counter:STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL neki_counter_next:STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL jedna_sekunda: STD_LOGIC;
-- DODATI :

-- sistem za brojane sekundi,minuta i sata kao sistem za generisanje izlaza u odnosu na pritisnuti taster
-- ako nije pritisnut nijedan taster onda se prikazuju sekunde
BEGIN
process(clk_i, rst_i) begin
	if(rst_i='1') then
		counter_value_s<=(others=>'0');
		counter_for_min_s<=(others=>'0');
		counter_for_h_s<=(others=>'0');
		neki_counter<=(others=>'0');
	elsif(rising_edge(clk_i)) then
		counter_value_s<=counter_value_s_next;
		counter_for_min_s<=counter_for_min_s_next;
		counter_for_h_s<=counter_for_h_s_next;
		neki_counter<=neki_counter_next;
	end if;
end process;

neki_counter_next<=(others=>'0') when neki_counter=100 else neki_counter+1 when one_sec_i='1';
jedna_sekunda<='1' when neki_counter=100 else '0';
process(jedna_sekunda, counter_value_s, counter_for_min_s, counter_for_h_s) begin
	if(jedna_sekunda='1') then
		if(counter_value_s=59) then
			counter_value_s_next<=(others=>'0');
			if(counter_for_min_s=59) then
				counter_for_min_s_next<=(others=>'0');
				if(counter_for_h_s=23) then
					counter_for_h_s_next<=(others=>'0');
				else
				counter_for_h_s_next<=counter_for_h_s+1;
				end if;
			else
				counter_for_min_s_next<=counter_for_min_s+1;
			end if;
		else
			counter_value_s_next<=counter_value_s+1;
		end if;
	else
		counter_value_s_next<=counter_value_s;
	end if;
end process;
END rtl;