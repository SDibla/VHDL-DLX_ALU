library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.constants.all;

-- Sel 100 AND
-- Sel 111 OR
-- Sel 011 XOR

entity logic is
	generic(NBIT: integer := NUMBIT_DATA);
	port(A, B: in std_logic_vector(NBIT-1 downto 0);
		  sel: in std_logic_vector(2 downto 0);
		  logic_out: out std_logic_vector(NBIT-1 downto 0));
end entity;

architecture structural of logic is

	signal nand1: std_logic_vector(NBIT-1 downto 0);
	signal nand2: std_logic_vector(NBIT-1 downto 0);
	signal nand3: std_logic_vector(NBIT-1 downto 0);
	signal final_nand: std_logic_vector(NBIT-1 downto 0);
	signal notA: std_logic_vector(NBIT-1 downto 0);
	signal notB: std_logic_vector(NBIT-1 downto 0);
	
begin

	notA <= not A;
	notB <= not B;
	
	block_gen : for i in NBIT-1 downto 0 generate
		nand1(i) <= not (sel(0) and notA(i) and B(i));
		nand2(i) <= not (sel(1) and A(i) and notB(i));
		nand3(i) <= not (sel(2) and A(i) and B(i));
	end generate;
	
	out_gen : for i in NBIT-1 downto 0 generate
		final_nand(i) <= not(nand1(i) and nand2(i) and nand3(i));
	end generate;
	
	logic_out <= final_nand;
	
end architecture;