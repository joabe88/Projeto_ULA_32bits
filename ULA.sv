module	ULA_32( input logic [31:0] A, B, 	//Vetores de entradas
		input logic [1:0] F, 		//controle das operações
		output logic [31:0] Resultado, 	//resultado da operação
		output logic Zero,		//Flag de Zero
		output logic Overflow,		//Flag de Overflow
		output logic Negativo,		//Flag de Negativo
		output logic Carry );		//Flag de Carry

		logic [32:0]	Somador;
 
assign Somador = A + (F[0] ? ~B : B) + F[0]; 	//Somador da ULA. É ativado quando o LBS do controle F está em nivel alto
 

always @ (*)					// Saídas da ULA: Resultado, Negativo, Zero, Carry, Overflow.
	case (F[1:0])
		2'b00: Resultado = Somador;	
		2'b01: Resultado = Somador;
		2'b10: Resultado = A & B;
		2'b11: Resultado = A | B;
	endcase

assign Carry	= (F[1] == 1'b0) & Somador[32];
assign Negativo	= Resultado[31];
assign Zero	= (Resultado == 32'b0);
assign Overflow	= (F[1] == 1'b0) & ~(A[31] ^ B[31] ^ F[0]) & (A[31] ^ Somador[31]);

endmodule
