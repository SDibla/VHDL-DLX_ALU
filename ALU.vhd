library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.myTypes.all;
use WORK.Constants.all;

entity ALU is 
	generic(NBIT: integer:=NUMBIT_DATA);
	port(
		--inputs:
	 	A,B: in std_logic_vector(NBIT-1 downto 0);		-- operands
		FUNC: in aluOp;											-- operation
      --outputs:
		ALU_OUT: out std_logic_vector(NBIT-1 downto 0);	-- result
		OVF: out std_logic
	);
end entity;		
		
architecture behaviour of ALU is 
	
	component comparator
	generic(	NBIT: integer := NUMBIT_DATA);
	port( sum: in std_logic_vector(NBIT-1 downto 0);
			cout: in std_logic;
			a_msb: in std_logic;
			b_msb: in std_logic;
			sel: in std_logic_vector(3 downto 0);
			comp_out: out std_logic_vector(NBIT-1 downto 0));
	end component;
	
	component Pentium4_Adder 
	generic(	NBIT: integer := NUMBIT_DATA;
				NBIT_PER_BLOCK: integer := NumBit_per_Block_P4);
	port( a: in std_logic_vector(NBIT-1 downto 0);
			b: in std_logic_vector(NBIT-1 downto 0);
			addsub: in std_logic;
			c_out: out std_logic;
			s: out std_logic_vector(NBIT-1 downto 0));
	end component;
	
	component logic
	generic(	NBIT: integer := NUMBIT_DATA);
	port(	A, B: in std_logic_vector(NBIT-1 downto 0);
			sel: in std_logic_vector(2 downto 0);
			logic_out: out std_logic_vector(NBIT-1 downto 0));
	end component;
	
	component shifter
	generic( NBIT : integer := NUMBIT_DATA);
	port(	A: in std_logic_vector(NBIT-1 downto 0);
			B: in std_logic_vector(NBIT-1 downto 0);
			logic_arith: in std_logic;										-- 0 logic 1 arith
			right_left: in std_logic; 										-- 0 right 1 left
			shifter_out: out std_logic_vector(NBIT-1 downto 0));
	end component;	

-- Adder_subtractor signals	
	signal addsub_sel: std_logic;
	signal addsub_out: std_logic_vector(NBIT-1 downto 0);
	signal addsub_cout: std_logic;
-- Comparator unit signals
	signal comparator_sel: std_logic_vector(3 downto 0);
	signal comparator_out: std_logic_vector(NBIT-1 downto 0);
-- Logic unit signals
	signal logic_sel: std_logic_vector(3 downto 0);
	signal logic_out: std_logic_vector(NBIT-1 downto 0);
-- Shifter signals
	signal shift_type_sel: std_logic;
	signal shift_direction_sel: std_logic;
	signal shift_out: std_logic_vector(NBIT-1 downto 0);

	
	begin
	
	ADDSUB_UNIT: 		Pentium4_Adder  port map(A, B, addsub_sel, addsub_cout, addsub_out);
	COMPARATOR_UNIT: 	Comparator port map(addsub_out, addsub_cout, A(NBIT-1), B(NBIT-1), comparator_sel, comparator_out);
	LOGIC_UNIT: 		Logic port map(A, B, logic_sel, logic_out);
	SHIFT_UNIT: 		Shifter port map(A, B, shift_type_sel, shift_direction_sel, shift_out);

-- CONTROL PROCESS
	
	process(FUNC) is
		
		begin
		
		addsub_sel <=  '1';
		comparator_sel <= "0000";
		logic_sel <= "0001";
		shift_type_sel <= '0';
		shift_direction_sel <= '0';
		
		case FUNC is 
			when ADDS | ADDI | ADDU | ADDUI => 					-- ADD/ADDI
				addsub_sel <= '0';
			when SUBS | SUBI | SUBU | SUBUI => 					-- SUB/SUBI
				addsub_sel <= '1';
				
			when ANDS | ANDI => 					-- AND/ANDI
				logic_sel <= "100"; 
			when ORS | ORI => 					-- OR/ORI
				logic_sel <= "111";
			when XORS | XORI => 					-- XOR/XORI
				logic_sel <= "011";
				
			when SEQ | SEQI => 					-- SEQ/SEQI
				addsub_sel <= '1';
				comparator_sel <= "0000";
			when SNE | SNEI => 					-- SNE/SNEI
				addsub_sel <= '1';
				comparator_sel <= "0001";
			when SGEU | SGEUI => 				-- SGEU/SGEUI
				addsub_sel <= '1';
				comparator_sel <= "0010";
			when SLEU | SLEUI => 				-- SLEU/SLEUI
				addsub_sel <= '1';
				comparator_sel <= "0011";
			when SGTU | SGTUI => 				-- SGTU/SGTUI
				addsub_sel <= '1';
				comparator_sel <= "0100"; 
			when SLTU | SLTUI => 				-- SLTU/SLTUI
				addsub_sel <= '1';
				comparator_sel <= "0101";
			when SGE | SGEI => 					-- SGE/SGEI
				addsub_sel <= '1';
				comparator_sel <= "0110";
			when SLE | SLEI => 					-- SLE/SLEI
				addsub_sel <= '1';
				comparator_sel <= "0111";
			when SGT | SGTI => 					-- SGT/SGTI
				addsub_sel <= '1';
				comparator_sel <= "1000";
			when SLT | SLTI => 					-- SLT/SLTI
				addsub_sel <= '1';
				comparator_sel <= "1001";
				
			when SRLS | SRLI => 					-- SRL/SRLI
				shift_type_sel <= '0';
				shift_direction_sel <= '0';
			when SLLS | SLLI => 					-- SLL/SLLI
				shift_type_sel <= '0';
				shift_direction_sel <= '1';
			when SRAS | SRAI => 					-- SRA/SRAI
				shift_type_sel <= '1';
				shift_direction_sel <= '0';
				
			when others => 
		end case;
	
	end process;

-- OUTPUT PROCESS	
		process(addsub_out, addsub_cout, comparator_out, logic_out, shift_out, FUNC) is
		
		begin
		
		case FUNC is 
			when ADDS | ADDI => 					-- ADD/ADDI
				ALU_OUT <= addsub_out;
				OVF <= addsub_cout xor (A(NBIT-1) xor B(NBIT-1) xor addsub_out(NBIT-1));
			when SUBS | SUBI => 					-- SUB/SUBI
				ALU_OUT <= addsub_out;
				OVF <= not(addsub_cout xor (A(NBIT-1) xor B(NBIT-1) xor addsub_out(NBIT-1)));
			when ADDU | ADDUI => 				-- ADDU/ADDUI
				ALU_OUT <= addsub_out;
				OVF <= addsub_cout;
			when SUBU | SUBUI => 				-- SUBU/SUBUI
				ALU_OUT <= addsub_out;
				OVF <= not(addsub_cout);
				
			when ANDS | ANDI => 					-- AND/ANDI
				ALU_OUT <= logic_out;
				OVF <= '0';
			when ORS | ORI => 					-- OR/ORI
				ALU_OUT <= logic_out;
				OVF <= '0';
			when XORS | XORI => 					-- XOR/XORI
				ALU_OUT <= logic_out;
				OVF <= '0';
				
			when SEQ | SEQI => 					-- SEQ/SEQI
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SNE | SNEI => 					-- SNE/SNE
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SGEU | SGEUI => 				-- SGEU/SGEUI
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SLEU | SLEUI => 				-- SLEU/SLEUI
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SGTU | SGTUI => 				-- SGTU/SGTUI
				ALU_OUT <= comparator_out;
				OVF <= '0';	
			when SLTU | SLTUI => 				-- SLTU/SLTUI
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SGE | SGEI => 					-- SGE/SGEI
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SLE | SLEI => 					-- SLE/SLEI
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SGT | SGTI => 					-- SGT/SGTI
				ALU_OUT <= comparator_out;
				OVF <= '0';
			when SLT | SLTI => 					-- SLT/SLTI
				ALU_OUT <= comparator_out;
				OVF <= '0';	
				
			when SRLS | SRLI => 					-- SRL/SRLI
				ALU_OUT <= shift_out;
				OVF <= '0';
			when SLLS | SLLI => 					-- SLL/SLLI
				ALU_OUT <= shift_out;
				OVF <= '0';
			when SRAS | SRAI => 					-- SRA/SRAI
				ALU_OUT <= shift_out;
				OVF <= '0';
				
			when others => ALU_OUT <= (others => '0');
								OVF <= '0';
		end case;
	
	end process;
	
end architecture;