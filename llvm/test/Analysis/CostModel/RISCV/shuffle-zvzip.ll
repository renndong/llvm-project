; RUN: opt < %s -passes="print<cost-model>" -cost-kind=throughput 2>&1 -disable-output -mtriple=riscv64 -mattr=+v,+zvfh,+experimental-zvzip | FileCheck %s --check-prefix=ZVZIP
; RUN: opt < %s -passes="print<cost-model>" -cost-kind=throughput 2>&1 -disable-output -mtriple=riscv64 -mattr=+v,+zvfh | FileCheck %s --check-prefix=NOZVZIP

define <32 x i8> @vzip_v32i8(<16 x i8> %a, <16 x i8> %b) {
; ZVZIP-LABEL: 'vzip_v32i8'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <32 x i8>
;
  %concat = shufflevector <16 x i8> %a, <16 x i8> %b, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %res = shufflevector <32 x i8> %concat, <32 x i8> poison, <32 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23, i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
  ret <32 x i8> %res
}

define <16 x i16> @vzip_v16i16(<8 x i16> %a, <8 x i16> %b) {
; ZVZIP-LABEL: 'vzip_v16i16'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <16 x i16>
;
  %concat = shufflevector <8 x i16> %a, <8 x i16> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %res = shufflevector <16 x i16> %concat, <16 x i16> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  ret <16 x i16> %res
}

define <8 x i32> @vzip_v8i32(<4 x i32> %a, <4 x i32> %b) {
; ZVZIP-LABEL: 'vzip_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <8 x i32>
; NOZVZIP-LABEL: 'vzip_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i32>
;
  %concat = shufflevector <4 x i32> %a, <4 x i32> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %res = shufflevector <8 x i32> %concat, <8 x i32> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  ret <8 x i32> %res
}

define <8 x i64> @vzip_v8i64(<4 x i64> %a, <4 x i64> %b) {
; ZVZIP-LABEL: 'vzip_v8i64'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i64>
; NOZVZIP-LABEL: 'vzip_v8i64'
; NOZVZIP: Cost Model: Found an estimated cost of 22 for instruction: %res = shufflevector <8 x i64>
;
  %concat = shufflevector <4 x i64> %a, <4 x i64> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %res = shufflevector <8 x i64> %concat, <8 x i64> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  ret <8 x i64> %res
}

define <8 x half> @vzip_v8f16(<4 x half> %a, <4 x half> %b) {
; ZVZIP-LABEL: 'vzip_v8f16'
; ZVZIP: Cost Model: Found an estimated cost of 1 for instruction: %res = shufflevector <8 x half>
; NOZVZIP-LABEL: 'vzip_v8f16'
; NOZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <8 x half>
;
  %concat = shufflevector <4 x half> %a, <4 x half> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %res = shufflevector <8 x half> %concat, <8 x half> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  ret <8 x half> %res
}

define <8 x float> @vzip_v8f32(<4 x float> %a, <4 x float> %b) {
; ZVZIP-LABEL: 'vzip_v8f32'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <8 x float>
; NOZVZIP-LABEL: 'vzip_v8f32'
; NOZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x float>
;
  %concat = shufflevector <4 x float> %a, <4 x float> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %res = shufflevector <8 x float> %concat, <8 x float> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  ret <8 x float> %res
}

define <8 x double> @vzip_v8f64(<4 x double> %a, <4 x double> %b) {
; ZVZIP-LABEL: 'vzip_v8f64'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x double>
; NOZVZIP-LABEL: 'vzip_v8f64'
; NOZVZIP: Cost Model: Found an estimated cost of 22 for instruction: %res = shufflevector <8 x double>
;
  %concat = shufflevector <4 x double> %a, <4 x double> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %res = shufflevector <8 x double> %concat, <8 x double> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  ret <8 x double> %res
}

; Direct two-source interleave masks should also be costed as vzip.vv.

define <8 x i32> @vzip_2src_v8i32(<4 x i32> %a, <4 x i32> %b) {
; ZVZIP-LABEL: 'vzip_2src_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <4 x i32>
; NOZVZIP-LABEL: 'vzip_2src_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 19 for instruction: %res = shufflevector <4 x i32>
;
  %res = shufflevector <4 x i32> %a, <4 x i32> %b, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  ret <8 x i32> %res
}

define <8 x i32> @non_vzip_2src_v8i32(<8 x i32> %a, <8 x i32> %b) {
; ZVZIP-LABEL: 'non_vzip_2src_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 19 for instruction: %res = shufflevector <8 x i32>
; NOZVZIP-LABEL: 'non_vzip_2src_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 19 for instruction: %res = shufflevector <8 x i32>
;
  %res = shufflevector <8 x i32> %a, <8 x i32> %b, <8 x i32> <i32 1, i32 8, i32 2, i32 9, i32 3, i32 10, i32 4, i32 11>
  ret <8 x i32> %res
}

define <8 x i32> @non_vzip_unaligned_2src_v8i32(<8 x i32> %a, <8 x i32> %b) {
; ZVZIP-LABEL: 'non_vzip_unaligned_2src_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 19 for instruction: %res = shufflevector <8 x i32>
; NOZVZIP-LABEL: 'non_vzip_unaligned_2src_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 19 for instruction: %res = shufflevector <8 x i32>
;
  %res = shufflevector <8 x i32> %a, <8 x i32> %b, <8 x i32> <i32 0, i32 9, i32 1, i32 10, i32 2, i32 11, i32 3, i32 12>
  ret <8 x i32> %res
}

; Interleave masks that do not start at zero or a half-vector boundary cannot
; be lowered to vzip.vv.

define <8 x i32> @non_vzip_interleave_v8i32(<8 x i32> %v) {
; ZVZIP-LABEL: 'non_vzip_interleave_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i32>
; NOZVZIP-LABEL: 'non_vzip_interleave_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i32>
;
  %res = shufflevector <8 x i32> %v, <8 x i32> poison, <8 x i32> <i32 1, i32 4, i32 2, i32 5, i32 3, i32 6, i32 4, i32 7>
  ret <8 x i32> %res
}

define <8 x i32> @non_vzip_unaligned_interleave_v8i32(<8 x i32> %v) {
; ZVZIP-LABEL: 'non_vzip_unaligned_interleave_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i32>
; NOZVZIP-LABEL: 'non_vzip_unaligned_interleave_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i32>
;
  %res = shufflevector <8 x i32> %v, <8 x i32> poison, <8 x i32> <i32 0, i32 1, i32 1, i32 2, i32 2, i32 3, i32 3, i32 4>
  ret <8 x i32> %res
}

; For SEW < ELEN, deinterleave still follows the existing shift-and-truncate
; lowering instead of vunzip.

define <4 x i32> @vunzipe_v4i32(<8 x i32> %v) {
; ZVZIP-LABEL: 'vunzipe_v4i32'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <8 x i32>
; NOZVZIP-LABEL: 'vunzipe_v4i32'
; NOZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = shufflevector <8 x i32>
;
  %res = shufflevector <8 x i32> %v, <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  ret <4 x i32> %res
}

define <4 x i32> @vunzipo_v4i32(<8 x i32> %v) {
; ZVZIP-LABEL: 'vunzipo_v4i32'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <8 x i32>
; NOZVZIP-LABEL: 'vunzipo_v4i32'
; NOZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = shufflevector <8 x i32>
;
  %res = shufflevector <8 x i32> %v, <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  ret <4 x i32> %res
}

; For e64, deinterleave can use vunzipe.v/vunzipo.v.

define <4 x i64> @vunzipe_v4i64(<8 x i64> %v) {
; ZVZIP-LABEL: 'vunzipe_v4i64'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i64>
; NOZVZIP-LABEL: 'vunzipe_v4i64'
; NOZVZIP: Cost Model: Found an estimated cost of 22 for instruction: %res = shufflevector <8 x i64>
;
  %res = shufflevector <8 x i64> %v, <8 x i64> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  ret <4 x i64> %res
}

define <4 x i64> @vunzipo_v4i64(<8 x i64> %v) {
; ZVZIP-LABEL: 'vunzipo_v4i64'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <8 x i64>
; NOZVZIP-LABEL: 'vunzipo_v4i64'
; NOZVZIP: Cost Model: Found an estimated cost of 22 for instruction: %res = shufflevector <8 x i64>
;
  %res = shufflevector <8 x i64> %v, <8 x i64> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  ret <4 x i64> %res
}

define <8 x i64> @vunzipe_v8i64(<16 x i64> %v) {
; ZVZIP-LABEL: 'vunzipe_v8i64'
; ZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = shufflevector <16 x i64>
; NOZVZIP-LABEL: 'vunzipe_v8i64'
; NOZVZIP: Cost Model: Found an estimated cost of 74 for instruction: %res = shufflevector <16 x i64>
;
  %res = shufflevector <16 x i64> %v, <16 x i64> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  ret <8 x i64> %res
}

; vpaire.vv/vpairo.vv pair even/odd masks.

define <4 x i32> @vpaire_v4i32(<4 x i32> %a, <4 x i32> %b) {
; ZVZIP-LABEL: 'vpaire_v4i32'
; ZVZIP: Cost Model: Found an estimated cost of 1 for instruction: %res = shufflevector <4 x i32>
; NOZVZIP-LABEL: 'vpaire_v4i32'
; NOZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <4 x i32>
;
  %res = shufflevector <4 x i32> %a, <4 x i32> %b, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  ret <4 x i32> %res
}

define <4 x i32> @vpairo_v4i32(<4 x i32> %a, <4 x i32> %b) {
; ZVZIP-LABEL: 'vpairo_v4i32'
; ZVZIP: Cost Model: Found an estimated cost of 1 for instruction: %res = shufflevector <4 x i32>
; NOZVZIP-LABEL: 'vpairo_v4i32'
; NOZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = shufflevector <4 x i32>
  %res = shufflevector <4 x i32> %a, <4 x i32> %b, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  ret <4 x i32> %res
}

define <4 x i64> @vpaire_v4i64(<4 x i64> %a, <4 x i64> %b) {
; ZVZIP-LABEL: 'vpaire_v4i64'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <4 x i64>
; NOZVZIP-LABEL: 'vpaire_v4i64'
; NOZVZIP: Cost Model: Found an estimated cost of 5 for instruction: %res = shufflevector <4 x i64>
;
  %res = shufflevector <4 x i64> %a, <4 x i64> %b, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  ret <4 x i64> %res
}

define <4 x i64> @vpairo_v4i64(<4 x i64> %a, <4 x i64> %b) {
; ZVZIP-LABEL: 'vpairo_v4i64'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = shufflevector <4 x i64>
; NOZVZIP-LABEL: 'vpairo_v4i64'
; NOZVZIP: Cost Model: Found an estimated cost of 5 for instruction: %res = shufflevector <4 x i64>
;
  %res = shufflevector <4 x i64> %a, <4 x i64> %b, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  ret <4 x i64> %res
}

; Larger legal vzip, reaching an LMUL=8 destination.

define <16 x i64> @vzip_v16i64(<8 x i64> %a, <8 x i64> %b) {
; ZVZIP-LABEL: 'vzip_v16i64'
; ZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = shufflevector <16 x i64>
;
  %concat = shufflevector <8 x i64> %a, <8 x i64> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %res = shufflevector <16 x i64> %concat, <16 x i64> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  ret <16 x i64> %res
}

define <vscale x 8 x i32> @vzip_nxv8i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; ZVZIP-LABEL: 'vzip_nxv8i32'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = call <vscale x 8 x i32> @llvm.vector.interleave2.nxv8i32
; NOZVZIP-LABEL: 'vzip_nxv8i32'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call <vscale x 8 x i32> @llvm.vector.interleave2.nxv8i32
;
  %res = call <vscale x 8 x i32> @llvm.vector.interleave2.nxv8i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b)
  ret <vscale x 8 x i32> %res
}

define { <vscale x 4 x i32>, <vscale x 4 x i32> } @vunzip_nxv8i32(<vscale x 8 x i32> %v) {
; ZVZIP-LABEL: 'vunzip_nxv8i32'
; ZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = call { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.vector.deinterleave2.nxv8i32
; NOZVZIP-LABEL: 'vunzip_nxv8i32'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.vector.deinterleave2.nxv8i32
;
  %res = call { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.vector.deinterleave2.nxv8i32(<vscale x 8 x i32> %v)
  ret { <vscale x 4 x i32>, <vscale x 4 x i32> } %res
}

define <vscale x 8 x half> @vzip_nxv8f16(<vscale x 4 x half> %a, <vscale x 4 x half> %b) {
; ZVZIP-LABEL: 'vzip_nxv8f16'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = call <vscale x 8 x half> @llvm.vector.interleave2.nxv8f16
; NOZVZIP-LABEL: 'vzip_nxv8f16'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call <vscale x 8 x half> @llvm.vector.interleave2.nxv8f16
;
  %res = call <vscale x 8 x half> @llvm.vector.interleave2.nxv8f16(<vscale x 4 x half> %a, <vscale x 4 x half> %b)
  ret <vscale x 8 x half> %res
}

define <vscale x 8 x float> @vzip_nxv8f32(<vscale x 4 x float> %a, <vscale x 4 x float> %b) {
; ZVZIP-LABEL: 'vzip_nxv8f32'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = call <vscale x 8 x float> @llvm.vector.interleave2.nxv8f32
; NOZVZIP-LABEL: 'vzip_nxv8f32'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call <vscale x 8 x float> @llvm.vector.interleave2.nxv8f32
;
  %res = call <vscale x 8 x float> @llvm.vector.interleave2.nxv8f32(<vscale x 4 x float> %a, <vscale x 4 x float> %b)
  ret <vscale x 8 x float> %res
}

define <vscale x 4 x double> @vzip_nxv4f64(<vscale x 2 x double> %a, <vscale x 2 x double> %b) {
; ZVZIP-LABEL: 'vzip_nxv4f64'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64
; NOZVZIP-LABEL: 'vzip_nxv4f64'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64
;
  %res = call <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double> %a, <vscale x 2 x double> %b)
  ret <vscale x 4 x double> %res
}

define { <vscale x 4 x half>, <vscale x 4 x half> } @vunzip_nxv8f16(<vscale x 8 x half> %v) {
; ZVZIP-LABEL: 'vunzip_nxv8f16'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = call { <vscale x 4 x half>, <vscale x 4 x half> } @llvm.vector.deinterleave2.nxv8f16
; NOZVZIP-LABEL: 'vunzip_nxv8f16'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call { <vscale x 4 x half>, <vscale x 4 x half> } @llvm.vector.deinterleave2.nxv8f16
;
  %res = call { <vscale x 4 x half>, <vscale x 4 x half> } @llvm.vector.deinterleave2.nxv8f16(<vscale x 8 x half> %v)
  ret { <vscale x 4 x half>, <vscale x 4 x half> } %res
}

define { <vscale x 4 x float>, <vscale x 4 x float> } @vunzip_nxv8f32(<vscale x 8 x float> %v) {
; ZVZIP-LABEL: 'vunzip_nxv8f32'
; ZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = call { <vscale x 4 x float>, <vscale x 4 x float> } @llvm.vector.deinterleave2.nxv8f32
; NOZVZIP-LABEL: 'vunzip_nxv8f32'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call { <vscale x 4 x float>, <vscale x 4 x float> } @llvm.vector.deinterleave2.nxv8f32
;
  %res = call { <vscale x 4 x float>, <vscale x 4 x float> } @llvm.vector.deinterleave2.nxv8f32(<vscale x 8 x float> %v)
  ret { <vscale x 4 x float>, <vscale x 4 x float> } %res
}

define { <vscale x 2 x double>, <vscale x 2 x double> } @vunzip_nxv4f64(<vscale x 4 x double> %v) {
; ZVZIP-LABEL: 'vunzip_nxv4f64'
; ZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64
; NOZVZIP-LABEL: 'vunzip_nxv4f64'
; NOZVZIP: Cost Model: Invalid cost for instruction: %res = call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64
;
  %res = call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %v)
  ret { <vscale x 2 x double>, <vscale x 2 x double> } %res
}

; Fixed-length interleave/deinterleave intrinsics are lowered through
; shufflevector and use the existing fixed-length shuffle cost model.

define <8 x i32> @vzip_intrinsic_v8i32(<4 x i32> %a, <4 x i32> %b) {
; ZVZIP-LABEL: 'vzip_intrinsic_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 2 for instruction: %res = call <8 x i32> @llvm.vector.interleave2.v8i32
; NOZVZIP-LABEL: 'vzip_intrinsic_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 37 for instruction: %res = call <8 x i32> @llvm.vector.interleave2.v8i32
;
  %res = call <8 x i32> @llvm.vector.interleave2.v8i32(<4 x i32> %a, <4 x i32> %b)
  ret <8 x i32> %res
}

define { <4 x i32>, <4 x i32> } @vunzip_intrinsic_v8i32(<8 x i32> %v) {
; ZVZIP-LABEL: 'vunzip_intrinsic_v8i32'
; ZVZIP: Cost Model: Found an estimated cost of 4 for instruction: %res = call { <4 x i32>, <4 x i32> } @llvm.vector.deinterleave2.v8i32
; NOZVZIP-LABEL: 'vunzip_intrinsic_v8i32'
; NOZVZIP: Cost Model: Found an estimated cost of 31 for instruction: %res = call { <4 x i32>, <4 x i32> } @llvm.vector.deinterleave2.v8i32
;
  %res = call { <4 x i32>, <4 x i32> } @llvm.vector.deinterleave2.v8i32(<8 x i32> %v)
  ret { <4 x i32>, <4 x i32> } %res
}

define { <4 x i64>, <4 x i64> } @vunzip_intrinsic_v8i64(<8 x i64> %v) {
; ZVZIP-LABEL: 'vunzip_intrinsic_v8i64'
; ZVZIP: Cost Model: Found an estimated cost of 8 for instruction: %res = call { <4 x i64>, <4 x i64> } @llvm.vector.deinterleave2.v8i64
; NOZVZIP-LABEL: 'vunzip_intrinsic_v8i64'
; NOZVZIP: Cost Model: Found an estimated cost of 37 for instruction: %res = call { <4 x i64>, <4 x i64> } @llvm.vector.deinterleave2.v8i64
;
  %res = call { <4 x i64>, <4 x i64> } @llvm.vector.deinterleave2.v8i64(<8 x i64> %v)
  ret { <4 x i64>, <4 x i64> } %res
}

; Mask vectors require additional widening and narrowing operations, so they
; cannot be costed as only the Zvzip instructions.

define <vscale x 32 x i1> @vzip_nxv32i1(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; ZVZIP-LABEL: 'vzip_nxv32i1'
; ZVZIP: Cost Model: Invalid cost for instruction: %res = call <vscale x 32 x i1> @llvm.vector.interleave2.nxv32i1
;
  %res = call <vscale x 32 x i1> @llvm.vector.interleave2.nxv32i1(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  ret <vscale x 32 x i1> %res
}

define <32 x i1> @vzip_intrinsic_v32i1(<16 x i1> %a, <16 x i1> %b) {
; ZVZIP-LABEL: 'vzip_intrinsic_v32i1'
; ZVZIP: Cost Model: Invalid cost for instruction: %res = call <32 x i1> @llvm.vector.interleave2.v32i1
;
  %res = call <32 x i1> @llvm.vector.interleave2.v32i1(<16 x i1> %a, <16 x i1> %b)
  ret <32 x i1> %res
}

define { <16 x i1>, <16 x i1> } @vunzip_intrinsic_v32i1(<32 x i1> %v) {
; ZVZIP-LABEL: 'vunzip_intrinsic_v32i1'
; ZVZIP: Cost Model: Invalid cost for instruction: %res = call { <16 x i1>, <16 x i1> } @llvm.vector.deinterleave2.v32i1
;
  %res = call { <16 x i1>, <16 x i1> } @llvm.vector.deinterleave2.v32i1(<32 x i1> %v)
  ret { <16 x i1>, <16 x i1> } %res
}

define <vscale x 8 x i32> @vzip_nxv8i32_poison(<vscale x 4 x i32> %a) {
; ZVZIP-LABEL: 'vzip_nxv8i32_poison'
; ZVZIP: Cost Model: Invalid cost for instruction: %res = call <vscale x 8 x i32> @llvm.vector.interleave2.nxv8i32
;
  %res = call <vscale x 8 x i32> @llvm.vector.interleave2.nxv8i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> poison)
  ret <vscale x 8 x i32> %res
}

; Types larger than LMUL=8 are split into multiple Zvzip operations.

define <vscale x 16 x i64> @vzip_nxv16i64(<vscale x 8 x i64> %a, <vscale x 8 x i64> %b) {
; ZVZIP-LABEL: 'vzip_nxv16i64'
; ZVZIP: Cost Model: Found an estimated cost of 16 for instruction: %res = call <vscale x 16 x i64> @llvm.vector.interleave2.nxv16i64
;
  %res = call <vscale x 16 x i64> @llvm.vector.interleave2.nxv16i64(<vscale x 8 x i64> %a, <vscale x 8 x i64> %b)
  ret <vscale x 16 x i64> %res
}

define { <vscale x 8 x i64>, <vscale x 8 x i64> } @vunzip_nxv16i64(<vscale x 16 x i64> %v) {
; ZVZIP-LABEL: 'vunzip_nxv16i64'
; ZVZIP: Cost Model: Found an estimated cost of 32 for instruction: %res = call { <vscale x 8 x i64>, <vscale x 8 x i64> } @llvm.vector.deinterleave2.nxv16i64
;
  %res = call { <vscale x 8 x i64>, <vscale x 8 x i64> } @llvm.vector.deinterleave2.nxv16i64(<vscale x 16 x i64> %v)
  ret { <vscale x 8 x i64>, <vscale x 8 x i64> } %res
}

declare <vscale x 8 x i32> @llvm.vector.interleave2.nxv8i32(<vscale x 4 x i32>, <vscale x 4 x i32>)
declare { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.vector.deinterleave2.nxv8i32(<vscale x 8 x i32>)
declare <vscale x 8 x half> @llvm.vector.interleave2.nxv8f16(<vscale x 4 x half>, <vscale x 4 x half>)
declare <vscale x 8 x float> @llvm.vector.interleave2.nxv8f32(<vscale x 4 x float>, <vscale x 4 x float>)
declare <vscale x 4 x double> @llvm.vector.interleave2.nxv4f64(<vscale x 2 x double>, <vscale x 2 x double>)
declare { <vscale x 4 x half>, <vscale x 4 x half> } @llvm.vector.deinterleave2.nxv8f16(<vscale x 8 x half>)
declare { <vscale x 4 x float>, <vscale x 4 x float> } @llvm.vector.deinterleave2.nxv8f32(<vscale x 8 x float>)
declare { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.vector.deinterleave2.nxv4f64(<vscale x 4 x double>)
declare <8 x i32> @llvm.vector.interleave2.v8i32(<4 x i32>, <4 x i32>)
declare { <4 x i32>, <4 x i32> } @llvm.vector.deinterleave2.v8i32(<8 x i32>)
declare { <4 x i64>, <4 x i64> } @llvm.vector.deinterleave2.v8i64(<8 x i64>)
declare <vscale x 32 x i1> @llvm.vector.interleave2.nxv32i1(<vscale x 16 x i1>, <vscale x 16 x i1>)
declare <32 x i1> @llvm.vector.interleave2.v32i1(<16 x i1>, <16 x i1>)
declare { <16 x i1>, <16 x i1> } @llvm.vector.deinterleave2.v32i1(<32 x i1>)
declare <vscale x 16 x i64> @llvm.vector.interleave2.nxv16i64(<vscale x 8 x i64>, <vscale x 8 x i64>)
declare { <vscale x 8 x i64>, <vscale x 8 x i64> } @llvm.vector.deinterleave2.nxv16i64(<vscale x 16 x i64>)
