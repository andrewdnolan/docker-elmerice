if version < 600
	syn clear
elseif exists("b:current_syntax")
	finish
endif

syn case    ignore


syn keyword SifType Real Integer Logical String File Procedure MATC

syn match  SifNumber            display "[+-]\=\<\d\+\>"
syn match  SifFloat           "\<\d\+\(\.\d*\)\=\([edED][-+]\=\d\+\)\=[ij]\=\>"
syn match  SifFloat           "\.\d\+\([edED][-+]\=\d\+\)\=[ij]\=\>"
syn region  SifString         start=+"+ end=+"+ oneline


syn match SifComment "!.*"

syn region SifSolvers start="Linear" end="="
syn region SifSolvers start="nonlinear" end="="

syn match SifSolverHeader "Exec\s*Solver\s*="
syn match SifSolverHeader "Variable\s*="
syn match SifSolverHeader "Variable\s*Dofs\s*="
syn match SifSolverHeader "Equation\s*="
syn match SifSolverHeader "procedure\s*="

syn match SiftargetBC "Target\s*Boundaries\s*="

syntax match MatcFunction "\$\sfunction"

syn keyword SifUnit Simulation Header End
syn match  SifUnit "Body\s*\d\+"
syn match  SifUnit "Material\s*\d\+"
syn match  SifUnit "Solver\s*\d\+"
syn match  SifUnit "Equation\s*\d\+"
syn match  SifUnit "Initial\s*Condition\s*\d\+"
syn match  SifUnit "Body\s*Force\s*\d\+"
syn match  SifUnit "Boundary\s*Condition\s*\d\+"


hi def SifBold cterm=bold

if version >= 508 || !exists("did_sif_syntax_inits")
	if version < 508
		let did_sif_syntax_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

   HiLink SifNumber          Number
   HiLink SifFloat           Float
   HiLink SifString          String
   HiLink SifComment         Comment
   HiLink SifUnit            Special
   HiLink SifSolvers         Keyword
   HiLink SifSolverHeader    SifBold
   HiLink MatcFunction       SifBold
   HiLink SiftargetBC        SifBold
   HiLink SifType            Type

   delcommand HiLink
endif

let b:current_syntax = "sif"
