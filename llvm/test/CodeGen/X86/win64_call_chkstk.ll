; RUN: llc < %s -mtriple=x86_64-pc-win32 -code-model=small | FileCheck %s -check-prefix=WIN_X64_SMALL
; RUN: llc < %s -mtriple=x86_64-pc-win32 -code-model=kernel | FileCheck %s -check-prefix=WIN_X64_KERNEL
; RUN: llc < %s -mtriple=x86_64-pc-win32 -code-model=medium | FileCheck %s -check-prefix=WIN_X64_MEDIUM
; RUN: llc < %s -mtriple=x86_64-pc-win32 -code-model=large | FileCheck %s -check-prefix=WIN_X64_LARGE

; RUN: llc < %s -mtriple=x86_64-pc-mingw32 -code-model=small | FileCheck %s -check-prefix=MINGW_X64_SMALL
; RUN: llc < %s -mtriple=x86_64-pc-mingw32 -code-model=kernel | FileCheck %s -check-prefix=MINGW_X64_KERNEL
; RUN: llc < %s -mtriple=x86_64-pc-mingw32 -code-model=medium | FileCheck %s -check-prefix=MINGW_X64_MEDIUM
; RUN: llc < %s -mtriple=x86_64-pc-mingw32 -code-model=large | FileCheck %s -check-prefix=MINGW_X64_LARGE


declare void @bar(<2 x i64>* %n)

define void @foo(i32 %h) {
  %p = alloca <2 x i64>, i32 4096
  call void @bar(<2 x i64>* %p)
  ret void
}


; WIN_X64_SMALL:          callq   __chkstk
; WIN_X64_KERNEL:         callq   __chkstk
; WIN_X64_MEDIUM:         callq   __chkstk

; WIN_X64_LARGE-NOT:      callq   __chkstk
; WIN_X64_LARGE:          movabsq $__chkstk, %r11
; WIN_X64_LARGE-NEXT:     callq   *%r11


; MINGW_X64_SMALL:        callq   ___chkstk
; MINGW_X64_KERNEL:       callq   ___chkstk
; MINGW_X64_MEDIUM:       callq   ___chkstk

; MINGW_X64_LARGE-NOT:    callq   ___chkstk
; MINGW_X64_LARGE: 	      movabsq $___chkstk, %r11
; MINGW_X64_LARGE-NEXT:   callq   *%r11