library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.constants.all;

entity comparator is 
  generic (NBIT: integer := NUMBIT_DATA);
  port(  sum: in std_logic_vector(NBIT-1 downto 0);
			cout: in std_logic;
			a_msb: in std_logic;
			b_msb: in std_logic;
			sel: in std_logic_vector(3 downto 0);
			comp_out: out std_logic_vector(NBIT-1 downto 0));
end comparator;

architecture behavior of comparator is 
	
	signal zero: std_logic;
	signal zero_nor: std_logic_vector(NBIT/2-1 downto 0);
	signal zero_and: std_logic_vector(NBIT/2-2 downto 0);

	begin
	
	-- Generate the Zero signal, used to make the comparison 
		
		ZERO_NOR_CHAIN: for i in 0 to NBIT/2-1 generate
			zero_nor(i) <= sum(2*i) nor sum(2*i+1);
		end generate;
		
		ZERO_AND_CHAIN: for i in 0 to NBIT/2-2 generate
			zero_0 : if i=0 generate zero_and(i) <= (zero_nor(i) and zero_nor(i+1));
			end generate;
			zero_i : if i>0 generate  zero_and(i) <= (zero_nor(i+1) and zero_and(i-1));
			end generate;
		end generate;
		
		zero <= zero_and(NBIT/2-2);
		
	-- Set the LSB according to the comparison required
	
		process(sum, cout, a_msb, b_msb, sel, zero)
			
			begin

			case sel is 
			
				when "0000" => -- SEQ/SEQI
					comp_out(0) <= zero;
				when "0001" => -- SNE/SNEI
					comp_out(0) <= not zero;
				when "0010" => -- SGEU/SGEUI
					comp_out(0) <= cout;
				when "0011" => -- SLEU/SLEUI
					comp_out(0) <= (not cout) or zero;
				when "0100" => -- SGTU/SGTUI
					comp_out(0) <= (not zero) and cout; 
				when "0101" => -- SLTU/SLTUI
					comp_out(0) <= not cout;
				when "0110" => -- SGE/SGEI
					comp_out(0) <= (cout and (a_msb xnor b_msb)) or (not a_msb and b_msb);
				when "0111" => -- SLE/SLEI
					comp_out(0) <= ((not cout or zero) and (a_msb xnor b_msb)) or (a_msb and not b_msb);
				when "1000" => -- SGT/SGTI
					comp_out(0) <= ((not zero and cout) and (a_msb xnor b_msb)) or (not a_msb and b_msb);
				when "1001" => -- SLT/SLTI
					comp_out(0) <= (not cout and (a_msb xnor b_msb)) or (a_msb and not b_msb);
					
				when others => comp_out(0) <= '0';
			end case;
			
		end process;
		
		-- Set all the MSBs to 0 in order to extend at NBIT
	
		comp_out(NBIT-1 downto 1) <= (others => '0');	
		
end behavior;