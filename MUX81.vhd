library IEEE;
use ieee.std_logic_1164.all;

entity MUX81_GENERIC is
	generic(NBIT: integer);
	Port(	a:In	std_logic_vector(NBIT-1 downto 0);
			b: In  std_logic_vector(NBIT-1 downto 0);
			c: In std_logic_vector(NBIT-1 downto 0);
	      d: In	std_logic_vector(NBIT-1 downto 0);
			e: In std_logic_vector(NBIT-1 downto 0);
			f: In std_logic_vector(NBIT-1 downto 0);
			g: In std_logic_vector(NBIT-1 downto 0);
	      h:	In	std_logic_vector(NBIT-1 downto 0);
	      sel: In std_logic_vector(2 downto 0);
	      Y:	Out std_logic_vector(NBIT-1 downto 0));
end entity;

architecture BEHAVIORAL of MUX81_GENERIC is
begin
        process (a, b, c, d, e, f, g, h, sel)
			  begin
				if sel="111" then Y <= a;
				elsif sel="110" then Y<= b;
				elsif sel="101" then Y <= c;
				elsif sel="100" then Y <= d;
				elsif sel="011" then Y <= e;
				elsif sel="010" then Y<= f;
				elsif sel="001" then Y <= g;
				else Y <= h;
				end if;	
        end process;
end architecture;
