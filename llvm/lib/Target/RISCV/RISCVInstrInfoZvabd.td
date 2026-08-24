//===-- RISCVInstrInfoZvabd.td - 'Zvabd' instructions ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file describes the RISC-V instructions for 'Zvabd' (Vector Absolute
/// Difference).
///
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction Definitions
//===----------------------------------------------------------------------===//

// These instruction format definitions are defined for vwabda/vwabdau
// instructions. VMACVV/VMACVX cannot be reused because their vs1/rs1 and vs2
// operands are reversed.
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
class VWABDAVV<bits<6> funct6, RISCVVFormat opv, string opcodestr>
    : RVInstVV<funct6, opv, (outs VR:$vd_wb),
                (ins VR:$vd, VR:$vs2, VR:$vs1, VMaskOp:$vm),
                opcodestr, "$vd, $vs2, $vs1$vm"> {
  let Constraints = "@earlyclobber $vd_wb, $vd = $vd_wb";
}

class VWABDAVX<bits<6> funct6, RISCVVFormat opv, string opcodestr>
    : RVInstVX<funct6, opv, (outs VR:$vd_wb),
                (ins VR:$vd, VR:$vs2, GPR:$rs1, VMaskOp:$vm),
                opcodestr, "$vd, $vs2, $rs1$vm"> {
  let Constraints = "@earlyclobber $vd_wb, $vd = $vd_wb";
}
} // hasSideEffects = 0, mayLoad = 0, mayStore = 0

let Predicates = [HasStdExtZvabd], ElementsDependOn = EltDepsNone in {
  def VABD_VV  : VALUVV<0b010101, OPMVV, "vabd.vv">;
  def VABD_VX  : VALUVX<0b010101, OPMVX, "vabd.vx">;

  def VABDU_VV : VALUVV<0b010110, OPMVV, "vabdu.vv">;
  def VABDU_VX : VALUVX<0b010110, OPMVX, "vabdu.vx">;

  let VS1VS2Constraint = WidenV, DestEEW = EEWSEWx2 in {
    def VWABDA_VV  : VWABDAVV<0b111101, OPIVV, "vwabda.vv">;
    def VWABDA_VX  : VWABDAVX<0b111101, OPIVX, "vwabda.vx">;

    def VWABDAU_VV : VWABDAVV<0b111110, OPIVV, "vwabdau.vv">;
    def VWABDAU_VX : VWABDAVX<0b111110, OPIVX, "vwabdau.vx">;
  } // VS1VS2Constraint = WidenV, DestEEW = EEWSEWx2
} // Predicates = [HasStdExtZvabd], ElementsDependOn = EltDepsNone

let Predicates = [HasStdExtZvabd] in {
  def : InstAlias<"vabs.v $vd, $vs2$vm",
              (VABD_VX VR:$vd, VR:$vs2, X0, VMaskOp:$vm)>;
  def : InstAlias<"vabs.v $vd, $vs2",
                (VABD_VX VR:$vd, VR:$vs2, X0, zero_reg)>;
} // Predicates = [HasStdExtZvabd]

//===----------------------------------------------------------------------===//
// Pseudos
//===----------------------------------------------------------------------===//

multiclass VPseudoVWABDA_VV_VX {
  defvar constraint = "@earlyclobber $rd";
  foreach m = MxListW in {
    defvar mx = m.MX;
    defm _VV : VPseudoTernaryWithPolicy<m.wvrclass, m.vrclass, m.vrclass, m,
                                        constraint, Commutable=1,
                                        TargetConstraintType=3>,
               SchedTernary<"WriteVIWMulAddV", "ReadVIWMulAddV",
                            "ReadVIWMulAddV", "ReadVIWMulAddV", mx>;
    defm _VX : VPseudoTernaryWithPolicy<m.wvrclass, m.vrclass, GPR, m,
                                          constraint, TargetConstraintType = 3>,
               SchedTernary<"WriteVIWMulAddX", "ReadVIWMulAddV",
                            "ReadVIWMulAddV", "ReadVIWMulAddX", mx>;
  }
}

let Predicates = [HasStdExtZvabd] in {
  defm PseudoVABD : VPseudoVALU_VV_VX<Commutable = 1>;
  defm PseudoVABDU : VPseudoVALU_VV_VX<Commutable = 1>;
  defm PseudoVWABDA : VPseudoVWABDA_VV_VX;
  defm PseudoVWABDAU : VPseudoVWABDA_VV_VX;
} // Predicates = [HasStdExtZvabd]

//===----------------------------------------------------------------------===//
// CodeGen Patterns
//===----------------------------------------------------------------------===//
let HasPassthruOp = true, HasMaskOp = true in {
def riscv_abds_vl : RVSDNode<"ABDS_VL", SDT_RISCVIntBinOp_VL, [SDNPCommutative]>;
def riscv_abdu_vl : RVSDNode<"ABDU_VL", SDT_RISCVIntBinOp_VL, [SDNPCommutative]>;
} // let HasPassthruOp = true, HasMaskOp = true

let HasMaskOp = true in {
def rvv_vwabda_vl  : RVSDNode<"VWABDA_VL", SDT_RISCVVWIntTernOp_VL, [SDNPCommutative]>;
def rvv_vwabdau_vl : RVSDNode<"VWABDAU_VL", SDT_RISCVVWIntTernOp_VL, [SDNPCommutative]>;
} // HasMaskOp = true

// The widening instructions are defined for SEW=8 and SEW=16, otherwise the
// instruction encoding is reserved.
defvar WABDIntVectors = !filter(vtiTowti, AllWidenableIntVectors,
                                          !or(!eq(vtiTowti.Vti.SEW, 8),
                                              !eq(vtiTowti.Vti.SEW, 16)));

// These VPat definitions are for vwabda/vwabdau because they have a different
// operand order with other ternary instructions (i.e. vop.vx vd, vs2, rs1)
multiclass VPatTernaryV_VX_AABX<string intrinsic, string instruction,
                                list<VTypeInfoToWide> vtilist> {
  foreach vtiToWti = vtilist in {
    defvar vti = vtiToWti.Vti;
    defvar wti = vtiToWti.Wti;
    let Predicates = !listconcat(GetVTypePredicates<vti>.Predicates,
                                 GetVTypePredicates<wti>.Predicates) in
    defm : VPatTernaryWithPolicy<intrinsic, instruction,
                                 "V"#vti.ScalarSuffix,
                                 wti.Vector, vti.Vector, vti.Scalar,
                                 vti.Mask, vti.Log2SEW, vti.LMul,
                                 wti.RegClass, vti.RegClass,
                                 vti.ScalarRegClass>;
  }
}

multiclass VPatTernaryV_VV_AABX<string intrinsic, string instruction,
                                list<VTypeInfoToWide> vtilist> {
  foreach vtiToWti = vtilist in {
    defvar vti = vtiToWti.Vti;
    defvar wti = vtiToWti.Wti;
    let Predicates = !listconcat(GetVTypePredicates<vti>.Predicates,
                                 GetVTypePredicates<wti>.Predicates) in
    defm : VPatTernaryWithPolicy<intrinsic, instruction,
                                 "VV",
                                 wti.Vector, vti.Vector, vti.Vector,
                                 vti.Mask, vti.Log2SEW, vti.LMul,
                                 wti.RegClass, vti.RegClass,
                                 vti.RegClass>;
  }
}

multiclass VPatTernaryV_VV_VX_AABX<string intrinsic, string instruction,
                                   list<VTypeInfoToWide> vtilist>
    : VPatTernaryV_VX_AABX<intrinsic, instruction, vtilist>,
      VPatTernaryV_VV_AABX<intrinsic, instruction, vtilist>;


multiclass VPatWidenAbsDiffAddVL_VV<SDNode op, string instruction,
                                   list<VTypeInfoToWide> vtilist> {
  foreach vtiToWti = vtilist in {
    defvar vti = vtiToWti.Vti;
    defvar wti = vtiToWti.Wti;
    let Predicates = !listconcat(GetVTypePredicates<vti>.Predicates,
                                 GetVTypePredicates<wti>.Predicates) in {
      def : Pat<(op (vti.Vector vti.RegClass:$vs2),
                    (vti.Vector vti.RegClass:$vs1),
                    (wti.Vector wti.RegClass:$rd), (vti.Mask VMV0:$vm),
                    VLOpFrag),
                (!cast<Instruction>(instruction#"_VV_"#vti.LMul.MX#"_MASK")
                   wti.RegClass:$rd, vti.RegClass:$vs2,
                   vti.RegClass:$vs1, (vti.Mask VMV0:$vm), GPR:$vl,
                   vti.Log2SEW, TAIL_AGNOSTIC)>;
    }
  }
}

multiclass VPatWidenAbsDiffAddVL_VV_VX<SDNode op, string instruction,
                                    list<VTypeInfoToWide> vtilist>
    : VPatWidenAbsDiffAddVL_VV<op, instruction, vtilist> {
  foreach vtiToWti = vtilist in {
    defvar vti = vtiToWti.Vti;
    defvar wti = vtiToWti.Wti;
    let Predicates = !listconcat(GetVTypePredicates<vti>.Predicates,
                                 GetVTypePredicates<wti>.Predicates) in {
      def : Pat<(op (SplatPat XLenVT:$rs1), (vti.Vector vti.RegClass:$vs2),
                    (wti.Vector wti.RegClass:$rd), (vti.Mask VMV0:$vm), VLOpFrag),
                (!cast<Instruction>(instruction#"_VX_"#vti.LMul.MX#"_MASK")
                   wti.RegClass:$rd, vti.RegClass:$vs2,
                   vti.ScalarRegClass:$rs1, (vti.Mask VMV0:$vm), GPR:$vl,
                   vti.Log2SEW, TAIL_AGNOSTIC)>;
    }
  }
}

let Predicates = [HasStdExtZvabd] in {
defm : VPatBinarySDNode_VV_VX<abds, "PseudoVABD">;
defm : VPatBinarySDNode_VV_VX<abdu, "PseudoVABDU">;

defm : VPatBinaryVL_VV_VX<riscv_abds_vl, "PseudoVABD">;
defm : VPatBinaryVL_VV_VX<riscv_abdu_vl, "PseudoVABDU">;

defm : VPatBinaryV_VV_VX<"int_riscv_vabd", "PseudoVABD", AllIntegerVectors>;
defm : VPatBinaryV_VV_VX<"int_riscv_vabdu", "PseudoVABDU", AllIntegerVectors>;

defm : VPatTernaryV_VV_VX_AABX<"int_riscv_vwabda", "PseudoVWABDA",
                               WABDIntVectors>;
defm : VPatTernaryV_VV_VX_AABX<"int_riscv_vwabdau", "PseudoVWABDAU",
                               WABDIntVectors>;

defm : VPatWidenAbsDiffAddVL_VV_VX<rvv_vwabda_vl, "PseudoVWABDA",
                                   WABDIntVectors>;
defm : VPatWidenAbsDiffAddVL_VV_VX<rvv_vwabdau_vl, "PseudoVWABDAU",
                                   WABDIntVectors>;
} // Predicates = [HasStdExtZvabd]
