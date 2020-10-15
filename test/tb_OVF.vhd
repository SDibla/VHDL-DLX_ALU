library IEEE;
use IEEE.std_logic_1164.all;
use WORK.myTypes.all;

entity tb_ALU is 
end entity;

architecture test of tb_ALU is 

	component ALU
	generic(NBIT: integer:=32);
	port(
	 	A,B: in std_logic_vector(NBIT-1 downto 0);		
		FUNC: in aluOp;											
		ALU_OUT: out std_logic_vector(31 downto 0);
		OVF: out std_logic);
	end component;
	
	constant clk_period: time := 1 ns;
	signal in_A: std_logic_vector(31 downto 0);
	signal in_B: std_logic_vector(31 downto 0);
	signal op: aluOp;
	signal output: std_logic_vector(31 downto 0);
	signal ovf: std_logic;
	
	begin
	
	ALU1: ALU port map (in_A, in_B, op, output, ovf);
	
		test_proc: process
			begin
			
			in_A <= "11111111111111111111111111111111"; -- 
			in_B <= "00000000000000000000000000000001"; -- 1
			op <= ADDS;
			wait for clk_period; 
			op <= ADDI;
			wait for clk_period;
			op <= SUBS;
			wait for clk_period;
			op <= SUBI;
			wait for clk_period;
			op <= ADDU;
			wait for clk_period; -- OVF
			op <= ADDUI;
			wait for clk_period; -- OVF
			op <= SUBU;
			wait for clk_period; 
			op <= SUBUI;
			wait for clk_period; 
			
			in_A <= "00000000000000000000000000000000"; -- 0
			in_B <= "00000000000000000000000000000001"; -- 1
			op <= ADDS;
			wait for clk_period; 
			op <= ADDI;
			wait for clk_period;
			op <= SUBS;
			wait for clk_period;
			op <= SUBI;
			wait for clk_period;
			op <= ADDU;
			wait for clk_period;
			op <= ADDUI;
			wait for clk_period;
			op <= SUBU;
			wait for clk_period; -- OVF
			op <= SUBUI;
			wait for clk_period; -- OVF
			
			in_A <= "01111111111111111111111111111111"; -- +2147483647
			in_B <= "00000000000000000000000000000001"; -- +1 
			op <= ADDS;
			wait for clk_period; -- OVF
			op <= ADDI;
			wait for clk_period; -- OVF
			op <= SUBS;
			wait for clk_period;
			op <= SUBI;
			wait for clk_period;
			op <= ADDU;
			wait for clk_period;
			op <= ADDUI;
			wait for clk_period;
			op <= SUBU;
			wait for clk_period;
			op <= SUBUI;
			wait for clk_period;
			
			in_A <= "01111111111111111111111111111110"; -- +2147483646
			in_B <= "00000000000000000000000000000001"; -- +1
			op <= ADDS;
			wait for clk_period;
			op <= ADDI;
			wait for clk_period;
			op <= SUBS;
			wait for clk_period;
			op <= SUBI;
			wait for clk_period;
			op <= ADDU;
			wait for clk_period;
			op <= ADDUI;
			wait for clk_period;
			op <= SUBU;
			wait for clk_period;
			op <= SUBUI;
			wait for clk_period;
			
			in_A <= "10000000000000000000000000000000"; -- -2147483648
			in_B <= "11111111111111111111111111111111"; -- -1
			op <= ADDS;
			wait for clk_period; -- OVF
			op <= ADDI;
			wait for clk_period; -- OVF
			op <= SUBS;
			wait for clk_period;
			op <= SUBI;
			wait for clk_period;
			op <= ADDU;
			wait for clk_period; -- OVF
			op <= ADDUI;
			wait for clk_period; -- OVF
			op <= SUBU;
			wait for clk_period; -- OVF
			op <= SUBUI;
			wait for clk_period; -- OVF
			
			
			in_A <= "10000000000000000000000000000000"; -- -2147483648
			in_B <= "00000000000000000000000000000001"; -- +1
			op <= ADDS;
			wait for clk_period;
			op <= ADDI;
			wait for clk_period;
			op <= SUBS;
			wait for clk_period; -- OVF
			op <= SUBI;
			wait for clk_period; -- OVF
			op <= ADDU;
			wait for clk_period; 
			op <= ADDUI;
			wait for clk_period; 
			op <= SUBU;
			wait for clk_period;
			op <= SUBUI;
			wait for clk_period;
			
		end process;
end architecture test;	