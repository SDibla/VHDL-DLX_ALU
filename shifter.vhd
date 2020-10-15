library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity shifter is
	generic( NBIT : integer := NUMBIT_DATA);
	port(	A: in std_logic_vector(NBIT-1 downto 0);
			B: in std_logic_vector(NBIT-1 downto 0);
			logic_arith: in std_logic;										-- 0 logic 1 arith
			right_left: in std_logic; 										-- 0 right 1 left
			shifter_out: out std_logic_vector(NBIT-1 downto 0));
end entity;

architecture structural of shifter is

	component MUX21_GENERIC is
	generic(NBIT: integer := NBIT+8);
	Port (a:	In	std_logic_vector(NBIT-1 downto 0);
	      b:	In	std_logic_vector(NBIT-1 downto 0);
	      sel:	In	std_logic;
	      Y:	Out std_logic_vector(NBIT-1 downto 0));
	end component;
	
	component MUX41_GENERIC is
	generic(NBIT: integer := NBIT+8);
	Port(	a:in	std_logic_vector(NBIT-1 downto 0);
			b:  in  std_logic_vector(NBIT-1 downto 0);
			c:	in	std_logic_vector(NBIT-1 downto 0);
	      d:	in	std_logic_vector(NBIT-1 downto 0);
	      sel:	in	std_logic_vector(1 downto 0);
	      Y:	out	std_logic_vector(NBIT-1 downto 0));
	end component;
	
	component MUX81_GENERIC is
	generic(NBIT: integer := NBIT);
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
	end component;
	
	type first_masks_array is array(0 to NBIT/8-1) of std_logic_vector(NBIT+7 downto 0);
	type second_masks_array is array(0 to 7) of std_logic_vector(NBIT-1 downto 0);
	
	signal right_masks_array: first_masks_array;
	signal left_masks_array: first_masks_array;
	signal chosen_array: first_masks_array;
	signal chosen_mask: std_logic_vector(NBIT+7 downto 0);
	signal second_masks: second_masks_array;
	signal third_sel: std_logic_vector(2 downto 0);
	
begin

-- STEP 1: Mask preparation and Pre-Shift

-- 4 Mask generarion for Left and Right shift and take care about if it is logic operation or arithmetic
	STEP1_MASKS: for i in 1 to NBIT/8 generate 	
		right_masks_array(i-1)(NBIT+7 downto NBIT+8-8*i) <= (others => (A(NBIT-1) and logic_arith));
		right_masks_array(i-1)(NBIT+7-8*i downto 0) <= A(NBIT-1 downto 8*(i-1));
		left_masks_array(i-1)(NBIT+7 downto 8*i-1) <= '0' & A(NBIT-8*(i-1)-1 downto 0);
		left_masks_array(i-1)(8*i-2 downto 0) <= (others => '0');
	end generate;

-- Select Left Mask or Right Mask	
	STEP1: for i in 0 to NBIT/8-1 generate
		MUX21_i : MUX21_GENERIC port map(left_masks_array(i), right_masks_array(i), right_left, chosen_array(i));
	end generate;
	
-- STEP 2: Coarse Grain Shift

-- Use MSB(4 and 3) of B to chooses among the 4 masks the nearest to the shift to be operated 	
	STEP2: MUX41_GENERIC port map(chosen_array(3), chosen_array(2), chosen_array(1), chosen_array(0), B(4 downto 3), chosen_mask);

-- Prepare the 8 possible configuration of the chosen mask							
	STEP2_MASKS: for i in 0 to 7 generate
		second_masks(i) <= chosen_mask(NBIT+i-1 downto i);
	end generate;	
	
-- STEP 3: Fine Grain Shift

--	Use LSB(2, 1 and 0) of B to chooses among the 8 configuration the correct shift (implement the real shift) 
	third_sel(2) <= B(2) xor right_left;
	third_sel(1) <= B(1) xor right_left;
	third_sel(0) <= B(0) xor right_left;
	
	STEP3: MUX81_GENERIC port map(second_masks(7), second_masks(6), second_masks(5), second_masks(4), second_masks(3), second_masks(2), second_masks(1), second_masks(0), third_sel, shifter_out);
	
end architecture;
