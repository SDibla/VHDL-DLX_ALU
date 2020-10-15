library IEEE;
use ieee.std_logic_1164.all;

entity MUX41_GENERIC is
	generic(NBIT: integer);
	Port(	a:in	std_logic_vector(NBIT-1 downto 0);
			b:  in  std_logic_vector(NBIT-1 downto 0);
			c:	in	std_logic_vector(NBIT-1 downto 0);
	      d:	in	std_logic_vector(NBIT-1 downto 0);
	      sel:	in	std_logic_vector(1 downto 0);
	      Y:	out	std_logic_vector(NBIT-1 downto 0));
end entity;

architecture BEHAVIORAL of MUX41_GENERIC is
begin
        process (a, b, c, d, sel)
			  begin
				if sel="11" then Y <= a;
				elsif sel="10" then Y<= b;
				elsif sel="01" then Y <= c;
				else Y <= d;
				end if;	
        end process;
end architecture;
