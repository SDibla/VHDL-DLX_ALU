library ieee;
use ieee.std_logic_1164.all;

package myTypes is

	type aluOp is (
		NOP, ADDS, ADDI, ADDU, ADDUI, SUBS, SUBI, SUBU, SUBUI, ANDS, ANDI, ORS, ORI, XORS, XORI, SEQ, SEQI, SNE, SNEI, SGEU, SGEUI, SLEU, SLEUI, SGTU, SGTUI, SLTU, SLTUI, SGE, SGEI, SLE, SLEI, SGT, SGTI, SLT, SLTI, SRLS, SRLI, SLLS, SLLI, SRAS, SRAI, MULT);

end myTypes;


package Constants is
   constant NUMBIT_DATA : integer := 32;
	constant NumBit_per_Block_P4 : integer := 4;
	function log2( i : integer) return integer;
end Constants;

package body Constants is
	
	function log2( i : integer) return integer is
		variable temp    : integer := i;
		variable ret_val : integer := 1; 
	begin
		while temp > 2 loop
			ret_val := ret_val + 1;
			temp    := temp / 2;
		end loop;
		return ret_val;
	end function log2;

end package body Constants;