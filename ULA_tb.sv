module ULA_32_tb;
	logic [1:0] F;
	logic [31:0] A, B;
	logic [31:0] Resultado;
	logic Zero, Overflow, Negativo, Carry;

	logic  [100:0]  VetorTeste[10000:0];
	logic  [31:0]   ResultadoEsp;	
	logic           ZeroEsp, OverflowEsp, NegativoEsp, CarryEsp;
	logic  Clock;
	logic  [31:0]   VetorNum;

	ULA_32 DUT(.A(A), .B(B), .F(F), .Resultado(Resultado), .Zero(Zero), 
		.Overflow(Overflow), .Negativo(Negativo), .Carry(Carry));
	
	always							// Gerador de clock
		begin
		Clock = 1; #5; Clock = 0; #5;
     		end

	initial							// Carrega os vetores do arquivo de teste
		begin
		$readmemh("ULA_32_VetorTeste.txt", VetorTeste);
		VetorNum = 0;
     		end
 
	always @(posedge Clock)					// Quando o clock for positivo, concatena o vetor de teste
   		begin
 		#1; 
		{CarryEsp, NegativoEsp, OverflowEsp, ZeroEsp, F, A, B, ResultadoEsp} = VetorTeste[VetorNum];
    		end

  	always @(negedge Clock)					// Confere os resultados no clock negativo
     		begin
     		if ({Resultado, Zero, Overflow, Negativo, 	//Informa se no testes houve falha
			Carry} !== {ResultadoEsp, ZeroEsp, OverflowEsp, NegativoEsp, CarryEsp})
	  		begin
	   		$display("Falha no teste numero: %.2d" , VetorNum);
           		$display("Entradas:       F = %b |    A = %h |        B = %h ", F, A, B);
           		$display("Saídas:      Resultado = %h | Zero = %b | Overflow = %b | Negativo = %b | Carry = %b", 
						Resultado, Zero, Overflow, Negativo, Carry);
	   		$display("Esperado:	               %h |        %b |            %b |            %b |         %b \n", 
						ResultadoEsp, ZeroEsp, OverflowEsp, NegativoEsp, CarryEsp);
      	  		end
     		else						//Informa se o teste foi bem sucedido
	  		begin					
	    		$display("   Teste numero: %.2d bem sucedido", VetorNum);
           		$display("   Entradas:       F = %b |    A = %h |        B = %h ", F, A, B);
           		$display("   Saídas:      Resultado = %h | Zero = %b | Overflow = %b | Negativo = %b | Carry = %b", 
						Resultado, Zero, Overflow, Negativo, Carry);
	   		$display("   Esperado:	               %h |        %b |            %b |            %b |         %b \n", 
						ResultadoEsp, ZeroEsp, OverflowEsp, NegativoEsp, CarryEsp);

	  		end

		VetorNum = VetorNum + 1;
     
		if (VetorTeste[VetorNum] === 101'hx) 		//Encerra os testes caso não haja mais vetores para testar
          		begin
          		$finish;
          		end
  		end
endmodule
