`timescale 1ns / 1ps
module test_bench();

  
    reg clk;
    reg reset;
    wire [31:0] instruction1;    // instruction memory outputs
    wire [31:0] instruction2;
    
    wire [31:0] issue_instr1;    //instruction issuing unit outputs
    wire [31:0] issue_instr2;
    
    wire [7:0] pcout;   // PC related inputs
    wire rollback;
    
    wire [6:0] opcode_1;  // decoder o/p's set 1
    wire [4:0] rd_1;
    wire [2:0] funct3_1;
    wire [4:0] rs1_1;
    wire [4:0] rs2_1;
    wire [6:0] funct7_1;
    
    wire [6:0] opcode_2;   // decoder o/p's set 2
    wire [4:0] rd_2;
    wire [2:0] funct3_2;
    wire [4:0] rs1_2;
    wire [4:0] rs2_2;
    wire [6:0] funct7_2;
    
    // control signals set1
    wire memread1;    // control signal to allow data mem to read
    wire memtoreg1;   // control sig to mux to decide between alu result or data from data mem to writeback to RF
    wire memwrite1;   // control signal to allow data mem to write
    wire aluSrc1;     // control signal to mux to switch between forwaded inputs and imm data for second i/p of alu
    wire regwrite1;   // allows reg to write into it
    wire [1:0] Aluop1;// control sognal for alu control
    
    // control signals set2
    wire memread2;  
    wire memtoreg2;
    wire memwrite2;
    wire aluSrc2;
    wire regwrite2;
    wire [1:0] Aluop2;
    
    // reg signals set 1
    wire [31:0] writedata_1;
    wire [31:0] readdata1_1;
    wire [31:0] readdata2_1;
    
    // reg signals set 2
    wire [31:0] writedata_2;
    wire [31:0] readdata1_2;
    wire [31:0] readdata2_2;
    
    // imm data extractor o/p's
    wire [31:0] imm_data_1;
    wire [31:0] imm_data_2;
    
    
    wire [31:0] y1; // mux o/p for second opearnd of alu1
    wire [31:0] y2; // mux o/p for second opearnd of alu2
    wire [4:0] aluopc1; //alu control i/p's
    wire [4:0] aluopc2;
    wire [31:0] result_alu_1; // alu o/p
    wire [31:0] result_alu_2;
    
    // IF/ID latch signals
    wire [31:0] ifid_inst1;
    wire [31:0] ifid_inst2;
    wire ifidflush; // comes from hazard unit
    
    wire [31:0] imm; // for branch target addr calculation, i/p to nextPC logic, selects b/w imm_data1 and imm_data2
                     // whether the first issued instruction is a branch or the next one     
    
    //branch unit signals
    wire branchout1, branchout2;
    wire branch1, branch2; // comes from control unit
    
    
    // ID/EX Latch signals
    
    wire idex_memwrite1;    // control signals for memory stage
    wire idex_memread1;     // control signals for memory stage
    wire idex_memwrite2;    // control signals for memory stage
    wire idex_memread2;     // control signals for memory stage
    
    wire idex_memtoreg1;    // control signals for writeback stage
    wire idex_regwrite2;    // control signals for writeback stage
    wire idex_regwrite1;    // control signals for writeback stage
    wire idex_memtoreg2;    // control signals for writeback stage 
    
    wire [4:0] idex_rd_1;   //address signal for rf at writeback stage, also forwading unit i/p
    wire [4:0] idex_rd_2;   //address signal for rf at writeback stage, also forwading unit i/p
    
    wire idex_Alusrc1;            // control signals for execution stage
    wire [1:0] idex_Aluop1;       // control signals for execution stage
    wire [2:0] idex_funct3_1;     // control signals for execution stage
    wire [6:0] idex_funct7_1;     // control signals for execution stage
    wire idex_Alusrc2;            // control signals for execution stage
    wire [1:0] idex_Aluop2;       // control signals for execution stage
    wire [2:0] idex_funct3_2;     // control signals for execution stage
    wire [6:0] idex_funct7_2;     // control signals for execution stage
    
    wire [31:0] idex_readdata1_1; // data signals for execution stage
    wire [31:0] idex_readdata2_1; // data signals for execution stage
    wire [31:0] idex_imm_data_1;  // data signals for execution stage
    wire [31:0] idex_readdata1_2; // data signals for execution stage
    wire [31:0] idex_readdata2_2; // data signals for execution stage
    wire [31:0] idex_imm_data_2;  // data signals for execution stage
    
    wire [4:0] rs1_idex_1;        // forwading unit inputs
    wire [4:0] rs2_idex_1;
    wire [4:0] rs1_idex_2;
    wire [4:0] rs2_idex_2;
    
    // EX/MEM Latch signals
    
    wire [31:0] exmem_result_alu_1;  // address for data mem
    wire [31:0] writedata_out_1;     // write data for data mem
    wire [31:0] exmem_result_alu_2;  // address for data mem
    wire [31:0] writedata_out_2;     // address for data mem
    wire exmem_memread1;            // control signals for data mem
    wire exmem_memwrite1;
    wire exmem_memread2;
    wire exmem_memwrite2;
    wire [31:0] readdata_1;         //  output ports for data memory
    wire [31:0] readdata_2;

    wire [4:0] exmem_rd_1;          // address signal for rf after writeback stage, also for forwading inputs
    wire [4:0] exmem_rd_2;          // address signal for rf after writeback stage, also for forwading inputs
    wire exmem_regwrite1;           //control signal at writeback stage
    wire exmem_regwrite2;           //control signal at writeback stage
    wire exmem_memtoreg1;           //control signal at writeback stage
    wire exmem_memtoreg2;           //control signal at writeback stage
    

   // MEM/WB Latch signals
    wire [4:0] memwb_rd_1;     // rd to register file
    wire [4:0] memwb_rd_2;     // rd to register file
    wire [31:0] memwb_readdata_1;  // for forwading
    wire [31:0] memwb_result_alu_1; 
    wire [31:0] memwb_readdata_2;
    wire [31:0] memwb_result_alu_2;
    wire memwb_memtoreg1;
    wire memwb_memtoreg2;
    wire memwb_regwrite_1;
    wire memwb_regwrite_2;
         

    wire stall;
    wire [4:0] reg_rd_1;
    wire [31:0] wrd_reg_1;
    wire rgw_reg_1;
    wire [4:0] reg_rd_2;
    wire [31:0] wrd_reg_2;
    wire rgw_reg_2;
   
    // forwading unit o/p's
    wire [2:0] fa1;  
    wire [2:0] fb1;
    wire [2:0] fa2;
    wire [2:0] fb2;
   
    // forwading unit mux o/p's 
    wire [31:0] outa1; 
    wire [31:0] outb1;
    wire [31:0] outa2;
    wire [31:0] outb2;
  
  
  
  
    ////////////////EXMEM && MEMWB////////////////////////////
  
  
  
    // Instantiate the modules
    mux immdata(imm_data_1,imm_data_2,branchout1,imm);
    CCT pccount (pcout,clk,reset,stall,rollback,branchout1, branchout2, imm);
   
    instruc_mem A (pcout,instruction1,instruction2);
     
    
   //IFID pipeline module
   IF_ID ifid(clk,issue_instr1,issue_instr2,reset,stall,ifid_inst1,ifid_inst2,ifidflush);
   InstructionIssuingUnit ISU (clk,reset,
     instruction1,  // First instruction from I-Cache
     instruction2,  // Second instruction from I-Cache
     issue_instr1, // First instruction to be issued
     issue_instr2, // Second instruction to be issued
     rollback
);
    
    instruction_splitter parser1 (ifid_inst1,opcode_1,rd_1,funct3_1,rs1_1,rs2_1,funct7_1);
     instruction_splitter parser2 (ifid_inst2,opcode_2,rd_2,funct3_2,rs1_2,rs2_2,funct7_2);
     control_unit CU (opcode_1,opcode_2,stall, 
memread1,
memtoreg1,
memwrite1,
aluSrc1,
regwrite1,
Aluop1,
memread2,
memtoreg2,
memwrite2,
aluSrc2,
regwrite2,Aluop2,
branch1,
branch2
);
     
     
//     //IDEX pipeline module //////////////////////////////////////////////////////////
     registerFile RF (clk,reset,rs1_1,rs2_1,memwb_rd_1,writedata_1,memwb_regwrite_1,
                      
                      readdata1_1,readdata2_1
                      ,reg_rd_1,wrd_reg_1,rgw_reg_1,
                      rs1_2,rs2_2,memwb_rd_2,writedata_2,memwb_regwrite_2,
                      
                      readdata1_2,readdata2_2
                      ,reg_rd_2,wrd_reg_2,rgw_reg_2
                      );
                      
     imm_data IMM1 (ifid_inst1,imm_data_1);
     imm_data IMM2 (ifid_inst2,imm_data_2);
     ID_EX idex(clk,reset,memwrite1,memread1,memtoreg1,aluSrc1,regwrite1,
                  Aluop1,memwrite2,memread2,memtoreg2,aluSrc2,regwrite2,
                  Aluop2,rd_1,rd_2,readdata1_1,readdata2_1,readdata1_2,readdata2_2,imm_data_1,imm_data_2,funct3_1,funct7_1,
                  funct3_2,funct7_2,
                  rs1_1,rs2_1,rs1_2,rs2_2,
                  
                  
                  idex_memwrite1,idex_memread1,idex_memtoreg1,idex_Alusrc1,idex_regwrite1,
                  idex_Aluop1,idex_memwrite2,idex_memread2,idex_memtoreg2,idex_Alusrc2,idex_regwrite2,
                  idex_Aluop2,
                  idex_rd_1,idex_rd_2,
                  idex_readdata1_1,idex_readdata2_1,
                  idex_readdata1_2,idex_readdata2_2,
                  idex_imm_data_1,idex_funct3_1,idex_funct7_1,idex_imm_data_2,idex_funct3_2,idex_funct7_2,
                  rs1_idex_1,rs2_idex_1,rs1_idex_2,rs2_idex_2);
      ALU_control Cualu1 (idex_funct3_1,idex_funct7_1,idex_Aluop1,
                         aluopc1);
      ALU_control Cualu2 (idex_funct3_2,idex_funct7_2,idex_Aluop2,
                         aluopc2);   
      ALU calc1(outa1,y1,aluopc1,
      
               result_alu_1);
      ALU calc2(outa2,y2,aluopc2,
      
               result_alu_2);         
      mux rd2_1(idex_imm_data_1,outb1,idex_Alusrc1,y1);
      mux rd2_2(idex_imm_data_2,outb2,idex_Alusrc2,y2);
               
               
     branch_unit bu(branch1,branch2,funct3_1,funct3_2,readdata1_1,readdata1_2,readdata2_1,
     readdata2_2,branchout1,branchout2);
     hazard_unit hu(branchout1||branchout2,clk,ifidflush);      
     ////////////////hazard detection////////////////////////
     
     hazard_detector hd(idex_memread1,idex_rd_1,ifid_inst1,stall);
     
     ////////////////hazard detection////////////////////////



//////////////////////EXMEM && MEMWB//////////////////////


EX_MEM exmem(clk,reset,result_alu_1,result_alu_2,idex_readdata2_1,idex_readdata2_2,idex_rd_1,idex_rd_2,
       idex_memread1,idex_memtoreg1,idex_memwrite1,idex_regwrite1, 
  idex_memread2,idex_memtoreg2,idex_memwrite2,idex_regwrite2,
       exmem_result_alu_1,
       writedata_out_1,
       exmem_rd_1,
       exmem_memread1,exmem_memtoreg1,exmem_memwrite1,exmem_regwrite1,
              exmem_result_alu_2,
       writedata_out_2,
       exmem_rd_2,
       exmem_memread2,exmem_memtoreg2,exmem_memwrite2,exmem_regwrite2);
       
data_mem dmem(writedata_out_1,exmem_result_alu_1,exmem_memwrite1,clk,exmem_memread1,
             readdata_1,writedata_out_2,exmem_result_alu_2,exmem_memwrite2,exmem_memread2,
             readdata_2);
       
MEM_WB memwb(clk,reset,readdata_1,exmem_result_alu_1,exmem_rd_1,
              exmem_memtoreg1,exmem_regwrite1,
              
              memwb_readdata_1,
              memwb_result_alu_1,
              memwb_rd_1,
              memwb_memtoreg1,memwb_regwrite_1,
              readdata_2,exmem_result_alu_2,exmem_rd_2,
              exmem_memtoreg2,exmem_regwrite2,
              
              memwb_readdata_2,
              memwb_result_alu_2,
              memwb_rd_2,
              memwb_memtoreg2,memwb_regwrite_2);
              
mux read1(memwb_readdata_1,memwb_result_alu_1,memwb_memtoreg1,
         writedata_1);
mux read2(memwb_readdata_2,memwb_result_alu_2,memwb_memtoreg2,
         writedata_2);         

///forwarding unit///////

forwarding_unit fu2(rs1_idex_2,rs2_idex_2,
                   exmem_rd_1,exmem_rd_2,
                   memwb_rd_1,memwb_rd_2,
                   reg_rd_1,reg_rd_2,
                   
                   exmem_regwrite1,exmem_regwrite2,
                   memwb_regwrite_1,memwb_regwrite_2,
                   rgw_reg_1,rgw_reg_2,
                   
                   
                   fa2,fb2);
                   
eight_by_one_mux ebm1_2(idex_readdata1_2,
                        exmem_result_alu_2,
                        exmem_result_alu_1,
                        writedata_2,
                        writedata_1,
                        wrd_reg_1,
                        wrd_reg_2,
                        fa2,
                        outa2);
                        
                        
eight_by_one_mux ebm2_2(idex_readdata2_2,
                        exmem_result_alu_2,
                        exmem_result_alu_1,
                        writedata_2,
                        writedata_1,
                        wrd_reg_1,
                        wrd_reg_2,
                        fb2,
                        outb2);

/////////////////////////


/////////////////////////////

forwarding_unit fu1(rs1_idex_1,rs2_idex_1,
                   exmem_rd_1,exmem_rd_2,
                   memwb_rd_1,memwb_rd_2,
                   reg_rd_1,reg_rd_2,
                   
                   exmem_regwrite1,exmem_regwrite2,
                   memwb_regwrite_1,memwb_regwrite_2,
                   rgw_reg_1,rgw_reg_2,
                   
                   
                   fa1,fb1);
                   
eight_by_one_mux ebm1_1(idex_readdata1_1,
                        exmem_result_alu_2,
                        exmem_result_alu_1,
                        writedata_2,
                        writedata_1,
                        wrd_reg_1,
                        wrd_reg_2,
                        fa1,
                        outa1);
                        
                        
eight_by_one_mux ebm2_1(idex_readdata2_1,
                        exmem_result_alu_2,
                        exmem_result_alu_1,
                        writedata_2,
                        writedata_1,
                        wrd_reg_1,
                        wrd_reg_2,
                        fb1,
                        outb1);

////////////////////////////////
    
    // Generate clock signal
   
    always #5 clk = ~clk;
    
    
    initial begin
        
        reset = 1;
        #6 reset=0;
        clk = 0;
        #220 $finish;
    end
endmodule
