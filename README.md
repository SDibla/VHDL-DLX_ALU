# DLX Microprocessor: ALU

ALU is the core of all operations, it is collocated in the execution unit and elaborate two operands coming from the previous stage. It performs logical and arithmetic operations based on the instruction passed to it by the CU. ALU is also used to calculate memory addresses to perform DRAM accesses.

The operations that the ALU is able to do are:
* Addition and Subtraction. (Signed and Unsigned, with overflow detection)
* Logic Operations. (AND, OR, XOR)
* Comparison operations.
* Shift Operations. (Left or Right, Logic or Arith)

Each of this operations are performed by a different unit that is part of ALU environment, described in the PDF in the project.

![Alt text](/img/ALU.png?raw=true "ALU")
