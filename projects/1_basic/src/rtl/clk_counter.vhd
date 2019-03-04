-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                          
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul odogvaran za indikaciju o proteku sekunde
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk_counter IS GENERIC(
                              -- maksimalna vrednost broja do kojeg brojac broji
                              max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "10111110101111000010000000" -- 50 000 000
                             );
                      PORT   (
                               clk_i     : IN  STD_LOGIC; -- ulazni takt
                               rst_i     : IN  STD_LOGIC; -- reset signal
                               cnt_en_i  : IN  STD_LOGIC; -- signal dozvole brojanja
                               cnt_rst_i : IN  STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               one_sec_o : OUT STD_LOGIC  -- izlaz koji predstavlja proteklu jednu sekundu vremena
                             );
END clk_counter;

ARCHITECTURE rtl OF clk_counter IS

SIGNAL   counter_r	   : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL   counter_r_next : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL 	reset_query    : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL 	cmp_query      : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL 	cmp				: STD_LOGIC;
SIGNAL 	adder    		: STD_LOGIC_VECTOR(25 DOWNTO 0);

BEGIN

---- DODATI:
---- brojac koji kada izbroji dovoljan broj taktova generise SIGNAL one_sec_o koji
---- predstavlja jednu proteklu sekundu, brojac se nulira nakon toga
--	process(clk_i, rst_i, cnt_en_i)
--		begin
--			if(rst_i=1) then
--				counter_r<=(others=>'0');
--			elsif(rising_edge(clk_i)) then
--				if(cnt_en_i=1) then
--					if(cnt_rst_i=1) then
--						counter_r<=(others=>'0');
--					elsif(counter_r/=max_cnt) then
--						counter_r<=counter_r+1;
--					else
--						counter_r<=(others=>'0');
--					end if;
--				end if;
--			end if;
--	end process;

	process(clk_i, rst_i)
		begin
			if(rst_i='1') then
				counter_r<=(others=>'0');
			elsif(rising_edge(clk_i)) then
				counter_r<=counter_r_next;
			end if;
	end process;
	
	--mux za next
	counter_r_next<= reset_query when (cnt_en_i='1') else counter_r;
	--mux za reset
	reset_query<= cmp_query when cnt_rst_i='0' else (others=>'0');
	--mux za cmp
	cmp_query<= adder when cmp='0' else (others=>'0');
	--cmp
	cmp<='1' when counter_r=max_cnt else '0';
	--adder
	adder<=counter_r+1;
	
	one_sec_o<=cmp;
END rtl;