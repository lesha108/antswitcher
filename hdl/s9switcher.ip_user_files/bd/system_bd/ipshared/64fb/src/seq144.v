
`timescale 1ns/1ps

module seq144 #
	(
        parameter integer SEQ_DELAY = 1500000
	)
(
  input clk, // Входной сигнал тактирования
  input reset, // Входной сигнал для асинхронный сброс
  input ptt, // Входной сигнал включения передачи. 0 активный
  output reg lna144, // Выходной сигнал включения LNA
  output reg pa144, // Выходной сигнал включения нижнего PA
  output reg a144 // Выходной сигнал включения предусилителя, реле, верхнего PA
);

// Возможные состояния FSM
localparam READY_STATE 				= 4'b0001;	// 1
localparam TRANSMIT_START_STATE		= 4'b0010;	// 2
localparam TRANSMIT_START2_STATE 	= 4'b0100;	// 4
localparam TRANSMIT_STATE			= 4'b1000;	// 8

reg        [3:0] State;
reg        [3:0] NextState;


// 50 МГц такт частота, период 20нс. При требуемой задержке 30мс
// счётчик должен считать до 1_500_000. 
parameter DELAY_CNT_SIZE = 21;
reg [DELAY_CNT_SIZE - 1 : 0] DCounter;

//parameter DELAY_SETUP  = 1500000; // типа 30 мс
//parameter DELAY_SETUP  = 3;

// Отработка сброса и перевод в следующее состояние
always @(posedge clk)
  begin
    if(reset)
      State <= READY_STATE;
    else
      State <= NextState;
  end

//задание выходов
always @(posedge clk)
  begin
    if(reset)
      begin
        lna144 <= 1'b1;
        a144   <= 1'b0;  
        pa144  <= 1'b0;
      end
    else
      begin
        //чтобы значение выхода изменялось вместе с изменением
        //состояния, а не на следующем такте, анализируем NextState
        case(NextState)
          READY_STATE: 
            begin
			  lna144 <= 1'b1;
			  a144   <= 1'b0;  
			  pa144  <= 1'b0;
            end
          TRANSMIT_START_STATE:
            begin
			  lna144 <= 1'b0;
			  a144   <= 1'b0;  
			  pa144  <= 1'b0;
            end
          TRANSMIT_START2_STATE:
            begin
			  lna144 <= 1'b0;
			  a144   <= 1'b1;  
			  pa144  <= 1'b0;
            end
          TRANSMIT_STATE:
            begin
			  lna144 <= 1'b0;
			  a144   <= 1'b1;  
			  pa144  <= 1'b1;
            end
        endcase
      end
  end
  
//выбор перехода 
always @(*)
  begin
    //по умолчанию сохраняем текущее состояние 
    NextState = State;
    
    case(State)
      //--------------------------------------
      READY_STATE: 
        begin
          if(ptt == 1'b0) //включена передача
            begin
              NextState = TRANSMIT_START_STATE;
            end
        end
    
    
      //--------------------------------------
      TRANSMIT_START_STATE:
        begin
          if ((DCounter == 0) && (ptt == 1'b0))
            begin
              NextState = TRANSMIT_START2_STATE;
            end
		  else if ((DCounter == 0) && (ptt == 1'b1))             
            begin
              NextState = READY_STATE;
            end
        end
        
      //--------------------------------------
      TRANSMIT_START2_STATE:
        begin
          if ((DCounter == 0) && (ptt == 1'b0))
            begin
              NextState = TRANSMIT_STATE;
            end
		  else if ((DCounter == 0) && (ptt == 1'b1))             
            begin
              NextState = TRANSMIT_START_STATE;
            end
        end

      //--------------------------------------
      TRANSMIT_STATE:
        begin
          if(ptt == 1'b1) //выключена передача
            begin
              NextState = TRANSMIT_START2_STATE;
            end                        
        end
      //--------------------------------------
      default: NextState = READY_STATE;
    endcase
  end  
  
//обработка счетчика паузы 
always @(posedge clk)
  begin
    if(reset)
      begin
        DCounter <= 0;
      end
    else
      begin
        //счетчик все время идет до 0, кроме
        //моментов смены состояния, когда задается величина
        //паузы для следующего состояния 
		//тут нужно установить время задержки для следующего состояния?
		//DELAY_SETUP
		if(ptt == 1'b0) //включена передача
			begin
				if ((State == READY_STATE) && (NextState == TRANSMIT_START_STATE))
					DCounter <= SEQ_DELAY;
				else if((State == TRANSMIT_START_STATE) && (NextState == TRANSMIT_START2_STATE))
					DCounter <= SEQ_DELAY;
			end
		else //выключена передача
			begin
				if ((State == TRANSMIT_STATE) && (NextState == TRANSMIT_START2_STATE))
					DCounter <= SEQ_DELAY;
				else if((State == TRANSMIT_START2_STATE) && (NextState == TRANSMIT_START_STATE))
					DCounter <= SEQ_DELAY;
			end
        //----------------------------------------------------------          
        if(DCounter != 0)
		begin
          DCounter <= DCounter - 1'b1;
		end
	  end
  end  
  
endmodule