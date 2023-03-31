`include "Defines.vh"
`include "ALU.v"
`include "Comparator.v"
`include "IF_ID_gate.v"
`include "ID_EX_gate.v"
`include "EX_MEM_gate.v"
`include "RegFile.v"
`include "imm_gen.v"
`include "CPU_Ctrl.v"
`include "ALU_ctrl.v"
`include "Cmp_Ctrl.v"
`include "Imem.v"
`include "memory.v"
`include "Branch_Ctrl.v"
`include "Branch_Pc_Ctrl.v"
`include "Rd_Ctrl.v"
`include "MEM_WB_gate.v"
`include "Stall_Ctrl.v"

module Core (
    `VGA_DBG_Core_Outputs
    input clk, rst,
    output wire [7:0] led
);

    reg  [31:0] pc;
    wire [31:0] branch_pc;
    wire [31:0] inst;
    wire [31:0] imem_data;
    wire [6:0]  inst_op;
    wire [31:0] alu_b_val;
    wire [3:0]  alu_ctrl;
    wire [2:0]  cmp_ctrl;

    wire [31:0] IF_pc;
    wire [31:0] IF_inst;
    
    wire [31:0] ID_pc;
    wire [31:0] ID_inst;
    wire [31:0] ID_imm;
    wire [31:0] ID_rs1_val;
    wire [31:0] ID_rs2_val;
    wire        ID_is_branch;
    wire        ID_mem_read;
    wire        ID_mem2reg;
    wire        ID_ALU_op;
    wire        ID_mem_wen;
    wire        ID_ALU_src;
    wire        ID_reg_wen;
    wire        ID_is_jal;
    wire        ID_is_jalr;
    wire        ID_is_lui;
    wire        ID_is_auipc;
    

    wire [31:0] EX_pc;
    wire [31:0] EX_inst;
    wire [31:0] EX_imm;
    wire [31:0] EX_rs1_val;
    wire [31:0] EX_rs2_val;
    wire [31:0] EX_alu_res;
    wire [31:0] EX_br_alu_res;
    wire [4:0]  EX_reg_addr;
    wire        EX_is_branch;
    wire        EX_mem2reg;
    wire        EX_mem_read;
    wire        EX_mem_wen;
    wire        EX_ALU_src;
    wire        EX_reg_wen;
    wire        EX_is_jal;
    wire        EX_is_jalr;
    wire        EX_is_auipc;
    wire        EX_is_lui;
    wire        EX_ALU_op;
    wire        EX_cmp_res;


    wire [31:0] MEM_inst;
    wire [31:0] MEM_alu_res;
    wire [31:0] MEM_br_alu_res;
    wire [31:0] MEM_mem_o_data;
    wire [31:0] MEM_rs2_val;
    wire [31:0] MEM_imm;
    wire [31:0] MEM_pc;
    wire [31:0] MEM_i_data;
    wire        MEM_cmp_res;
    wire        MEM_is_branch;
    wire        MEM_mem_wen;
    wire        MEM_is_jal;
    wire        MEM_is_jalr;
    wire        MEM_is_lui;
    wire        MEM_is_auipc;
    wire        MEM_do_branch;
    wire        MEM_mem2reg;
    wire        MEM_reg_wen;
    

    wire [31:0] WB_inst;
    wire [31:0] WB_i_data;
    wire        WB_reg_wen;
    

    wire        do_branch;
    wire        is_stall;


    initial begin
        pc <= 32'd0;
    end

    

/**************** IF_STAGE_*************************/
    // assign imem_addr = pc;
    // assign inst = imem_o_data;
    always @(posedge clk) begin
        if(!is_stall) begin
            pc <= MEM_do_branch ? branch_pc : pc + 32'd4;
        end else begin
            pc <= pc;
        end
    end

    assign IF_pc = pc;
    
    IMem i_mem(
        .addr(IF_pc),
        .data(IF_inst)
    );

/*--------------- IF_STAGE_END------------------------*/
    IF_ID_gate IF_ID(
        .clk(clk),
        .IF_inst(IF_inst),
        .IF_pc(IF_pc),
        .ID_inst(ID_inst),
        .ID_pc(ID_pc)
    );
/**************** ID_STAGE *************************/
    CPU_Ctrl cpu_ctrl(
        .inst_opt(ID_inst[6:0]),
        .is_branch(ID_is_branch),
        .mem2reg(ID_mem2reg),
        .ALU_op(ID_ALU_op),
        .mem_wen(ID_mem_wen),
        .ALU_src(ID_ALU_src),
        .reg_wen(ID_reg_wen),
        .is_jal(ID_is_jal),
        .is_jalr(ID_is_jalr),
        .is_lui(ID_is_lui),
        .is_auipc(ID_is_auipc)
    );

    ImmGen imm_gen(
        .inst(ID_inst),
        .imm(ID_imm)
    );

    RegFile reg_file(
        `VGA_DBG_RegFile_Arguments
        .clk(~clk),
        .wen(WB_reg_wen),
        .rs1(ID_inst[19:15]),
        .rs2(ID_inst[24:20]),
        .rd(WB_inst[11:7]),
        .i_data(WB_i_data),
        .rs1_val(ID_rs1_val),
        .rs2_val(ID_rs2_val)
    );

/*--------------- ID_STAGE_END------------------------*/ 
    ID_EX_gate ID_EX(
        .clk(clk),
        .is_stall(is_stall),

        .ID_rs1_val(ID_rs1_val),
        .ID_rs2_val(ID_rs2_val),
        .ID_imm(ID_imm),
        .ID_inst(ID_inst),
        .ID_reg_addr(ID_inst[11:7]),
        .ID_is_branch(ID_is_branch),
        .ID_mem2reg(ID_mem2reg),
        .ID_ALU_op(ID_ALU_op),
        .ID_mem_read(ID_mem_read),
        .ID_ALU_src(ID_ALU_src),
        .ID_mem_wen(ID_mem_wen),
        .ID_reg_wen(ID_reg_wen),
        .ID_is_jalr(ID_is_jalr),
        .ID_is_auipc(ID_is_auipc),
        .ID_pc(ID_pc),

        .EX_is_branch(EX_is_branch),
        .EX_mem2reg(EX_mem2reg),
        .EX_mem_read(EX_mem_read),
        .EX_ALU_src(EX_ALU_src),
        .EX_reg_wen(EX_reg_wen),
        .EX_is_jal(EX_is_jal),
        .EX_is_jalr(EX_is_jalr),
        .EX_is_auipc(EX_is_auipc),
        .EX_is_lui(EX_is_lui),
        .EX_reg_addr(EX_reg_addr),
        .EX_pc(EX_pc),
        .EX_mem_wen(EX_mem_wen),
        .EX_ALU_op(EX_ALU_op),
        .EX_rs1_val(EX_rs1_val),
        .EX_rs2_val(EX_rs2_val),
        .EX_imm(EX_imm),
        .EX_inst(EX_inst)
    );

/**************** EX_STAGE *************************/

    ALU_Ctrl alu_c(
        .inst(EX_inst),
        .alu_op(EX_ALU_op),
        .alu_ctrl(alu_ctrl)
    );

    Cmp_Ctrl Cmp_ctrl(
        .inst(EX_inst),
        .is_branch(EX_is_branch),
        .cmp_ctrl(cmp_ctrl)
    );

    assign alu_b_val = EX_ALU_src ? EX_rs1_val : EX_imm;


    Alu ALU(
        .a_val(EX_rs1_val),
        .b_val(alu_b_val),
        .ctrl(alu_ctrl),
        .result(EX_alu_res)
    );

    Alu pc_ALU(
        .a_val(EX_pc),
        .b_val(EX_imm),
        .ctrl(`ALU_ADD),
        .result(EX_br_alu_res)
    );

    Comparator comp(
        .a_val(EX_rs1_val),
        .b_val(alu_b_val),
        .ctrl(cmp_ctrl),
        .result(EX_cmp_res)
    );

/*--------------- EX_STAGE_END------------------------*/ 

    EX_MEM_gate EX_MEM(
        .clk(clk),
        .EX_pc(EX_pc),
        .EX_alu_res(EX_alu_res),
        .EX_br_alu_res(EX_br_alu_res),
        .EX_imm(EX_imm),
        .EX_rs2_val(EX_rs2_val),
        .EX_inst(EX_inst),
        .EX_cmp_res(EX_cmp_res),
        .EX_is_jal(EX_is_jal),
        .EX_is_jalr(EX_is_jalr),
        .EX_is_auipc(EX_is_auipc),
        .EX_is_lui(EX_is_lui),
        .EX_is_branch(EX_is_branch),
        .EX_mem2reg(EX_mem2reg),
        .EX_reg_wen(EX_reg_wen),

        .MEM_pc(MEM_pc),
        .MEM_alu_res(MEM_alu_res),
        .MEM_br_alu_res(MEM_br_alu_res),
        .MEM_imm(MEM_imm),
        .MEM_rs2_val(MEM_rs2_val),
        .MEM_inst(MEM_inst),
        .MEM_cmp_res(MEM_cmp_res),
        .MEM_is_jalr(MEM_is_jalr),
        .MEM_is_jal(MEM_is_jal),
        .MEM_is_auipc(MEM_is_auipc),
        .MEM_is_lui(MEM_is_lui),
        .MEM_is_branch(MEM_is_branch),
        .MEM_mem2reg(MEM_mem2reg),
        .MEM_reg_wen(MEM_reg_wen)
    );

/**************** MEM_STAGE *************************/
    Branch_Ctrl br_ctrl(
        .cmp_res(MEM_cmp_res),
        .is_branch(MEM_is_branch),
        .is_jal(MEM_is_jal),
        .is_jalr(MEM_is_jalr),
        .do_branch(MEM_do_branch)
    );

    Branch_Pc_ctrl br_pc_ctrl(
        .alu_res(MEM_alu_res),
        .br_alu_res(MEM_br_alu_res),
        .is_jalr(MEM_is_jalr),
        .br_pc(branch_pc)
    );

    memory Dmem(
        .clk(~clk),
        .wen(MEM_mem_wen),
        .addr(MEM_alu_res),
        .i_data(MEM_rs2_val),
        .o_data(MEM_mem_o_data),
        .led_out(led)
    );

    Rd_Ctrl rd_ctrl(
        .mem2reg(MEM_mem2reg),
        .is_jal(MEM_is_jal),
        .is_jalr(MEM_is_jalr),
        .is_auipc(MEM_is_auipc),
        .is_lui(MEM_is_lui),
        .alu_res(MEM_alu_res),
        .imm(MEM_imm),
        .dmem_o_data(MEM_mem_o_data),
        .pc(MEM_pc),
        .alu_res(MEM_alu_res),
        .imm(MEM_imm),
        .reg_i_data(MEM_i_data)
    );
/*--------------- MEM_STAGE_END------------------------*/ 
    MEM_WB_gate MEM_WB(
        .clk(clk),
        .MEM_inst(MEM_inst),
        .MEM_i_data(MEM_i_data),
        .MEM_reg_wen(MEM_reg_wen),
        
        .WB_reg_wen(WB_reg_wen),
        .WB_inst(WB_inst),
        .WB_i_data(WB_i_data)
    );

/**************** WB_STAGE *************************/

    Stall_Ctrl stall_ctrl(
        .ID_rs1(ID_inst[19:15]),
        .ID_rs2(ID_inst[24:20]),
        .EX_rd(EX_inst[11:7]),
        .MEM_rd(MEM_inst[11:7]),

        .EX_reg_wen(EX_reg_wen),
        .MEM_reg_wen(MEM_reg_wen),

        .EX_is_branch(EX_is_branch),
        .EX_is_jal(EX_is_jal),
        .EX_is_jalr(EX_is_jalr),

        .MEM_is_branch(MEM_is_branch),
        .MEM_is_jalr(MEM_is_jalr),
        .MEM_is_jal(MEM_is_jal),

        .is_stall(is_stall)
    );
    
    
    assign dbg_pc               = IF_pc;
    assign dbg_inst             = IF_inst; 
    assign dbg_IfId_pc          = ID_pc;
    assign dbg_IfId_inst        = ID_inst; 
    assign dbg_IfId_valid       = is_stall;
    assign dbg_IdEx_pc          = EX_pc;
    assign dbg_IdEx_inst        = EX_inst;
    assign dbg_IdEx_valid       = is_stall;
    assign dbg_IdEx_rd          = EX_inst[11:7];
    assign dbg_IdEx_rs1         = EX_inst[19:15];
    assign dbg_IdEx_rs2         = EX_inst[24:20]; 
    assign dbg_IdEx_rs1_val     = EX_rs1_val;
    assign dbg_IdEx_rs2_val     = EX_rs2_val; 
    assign dbg_IdEx_reg_wen     = EX_reg_wen;
    assign dbg_IdEx_is_imm      = ~EX_ALU_src;
    assign dbg_IdEx_imm         = EX_imm;
    assign dbg_IdEx_mem_wen     = EX_mem_wen;
    assign dbg_IdEx_mem_ren     = EX_mem_read;
    assign dbg_IdEx_is_branch   = EX_is_branch;
    assign dbg_IdEx_is_jal      = EX_is_jal;
    assign dbg_IdEx_is_jalr     = EX_is_jalr; 
    assign dbg_IdEx_is_auipc    = EX_is_auipc;
    assign dbg_IdEx_is_lui      = EX_is_lui;
    assign dbg_IdEx_alu_ctrl    = alu_ctrl;
    assign dbg_IdEx_cmp_ctrl    = cmp_ctrl; 
    assign dbg_ExMa_pc          = MEM_pc;
    assign dbg_ExMa_inst        = MEM_inst;
    assign dbg_ExMa_valid       = MEM_inst == `NOP_INST;
    assign dbg_ExMa_rd          = MEM_inst[11:7];
    assign dbg_ExMa_reg_wen     = MEM_reg_wen;
    assign dbg_ExMa_mem_w_data  = MEM_rs2_val; 
    assign dbg_ExMa_alu_res     = MEM_alu_res; 
    assign dbg_ExMa_mem_wen     = MEM_mem_wen; 
    assign dbg_ExMa_mem_ren     = ~MEM_mem_wen; 
    assign dbg_ExMa_is_jal      = MEM_is_jal; 
    assign dbg_ExMa_is_jalr     = MEM_is_jalr; 
    assign dbg_MaWb_pc          = MEM_pc;
    assign dbg_MaWb_inst        = WB_inst;
    assign dbg_MaWb_valid       = MaWb_valid; 
    assign dbg_MaWb_rd          = WB_inst[11:7]; 
    assign dbg_MaWb_reg_wen     = WB_reg_wen;
    assign dbg_MaWb_reg_w_data  = WB_i_data;




   
endmodule

