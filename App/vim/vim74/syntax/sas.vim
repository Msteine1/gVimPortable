" Vim syntax file
" Language:	SAS
" Maintainer:	James Kidd <james.kidd@covance.com>
" Last Change:
"		12 Nov 2011 by Jiangtang Hu <Jiangtanghu@gmail.com>

"		add kewborad shortcuts consistent with SAS system to run SAS codes and review log and output files 

"		1 Apr 2011 by Zhenhuan Hu <wildkeny@gmail.com>

"		Fixed mis-recognization of keywords and function names
"		Fixed when several comments put in the same line
"		Added highlighting for new statements and functions in SAS 9.1/9.2
"		Added highlighting for user defined macro functions
"		Added highlighting for ODS
"		Added highlighting for formats
"		Applied more efficient methods for highlighting macro vars

"		18 Jul 2008 by Paulo Tanimoto <ptanimoto@gmail.com>

"		Fixed comments with * taking multiple lines
"		Fixed highlighting of macro keywords
"		Added words to cases that didn't fit anywhere

"		02 Jun 2003 by Bob Heckel

"		Added highlighting for additional keywords and such
"		Attempted to match SAS default syntax colors
"		Changed syncing so it doesn't lose colors on large blocks

"		26 Sep 2001 by James Kidd

"		Added keywords for use in SAS SQL procedure and highlighting for
"		SAS base procedures, added logic to distinqush between versions
"		for SAS macro variable highlighting (Thanks to user Ronald
"		Höllwarth for pointing out bug)

"		For SAS 5: Clear all syntax items
"		For SAS 6: Quit when a syntax file was already loaded

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" SAS is case insensitive
syn case ignore

syn region sasString start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region sasString start=+'+ skip=+\\\\\|\\"+ end=+'+

" Want region from 'CARDS' to ';' to be captured (Bob Heckel)
syn region sasCards start="^\s*CARDS.*" end="^\s*;\s*$"
syn region sasCards start="^\s*DATALINES.*" end="^\s*;\s*$"

syn match sasNumber "-\=\<\d*\.\=[0-9_]\>"

" Block comment
syn region sasComment start="/\*" end="\*/" contains=sasTodo
" Ignore misleading //JCL SYNTAX... (Bob Heckel)
syn region sasComment start="[^/][^/]/\*" end="\*/" contains=sasTodo
" Previous code for comments was written by Bob Heckel
" Comments with * starting after a semicolon (Paulo Tanimoto)
syn region sasComment start=";\s*\*"hs=s+1 end=";" contains=sasTodo
" Several comments can be put in the same line (Zhenhuan Hu)
syn region sasComment start="^\s*\*" skip=";\s*\*" end=";" contains=sasTodo

" No need to specify PROC list if use this line (Bob Heckel).
" Match options contained in the PROC statement (Zhenhuan Hu);
syn match sasProcName "PROC \w\+" contained
syn keyword sasProcOption MAX MEDIAN MIN MISSING contained
syn keyword sasProcKwd DATA contained
syn region sasProc start="^\s*PROC" end=";" contains=sasProcName, sasProcOption, sasProcKwd, sasString, sasNumber, sasComment, sasMacro, sasMacroFunction, sasMacroVar
syn region sasProc start=";\s*PROC" end=";" contains=sasProcName, sasProcOption, sasProcKwd, sasString, sasNumber, sasComment, sasMacro, sasMacroFunction, sasMacroVar

" Base SAS Procs - version 8.1
syn keyword sasStep RUN QUIT DATA
syn keyword sasConditional DO ELSE END IF THEN UNTIL WHILE

syn keyword sasStatement ABORT ARRAY ATTRIB BY CALL CARDS CARDS4 CATNAME CLASS
syn keyword sasStatement CONTINUE DATALINES DATALINES4 DELETE DISPLAY
syn keyword sasStatement DM DROP ENDSAS ERROR FILE FILENAME FOOTNOTE
syn keyword sasStatement FORMAT GOTO INFILE INFORMAT INPUT KEEP
syn keyword sasStatement LABEL LEAVE LENGTH LIBNAME LINK LIST LOSTCARD
syn keyword sasStatement MERGE MISSING MODIFY OPTIONS OUTPUT PAGE PAGEBY
syn keyword sasStatement PUT REDIRECT REMOVE RENAME REPLACE RETAIN
syn keyword sasStatement RETURN SELECT SET SKIP STARTSAS STOP SUM SUMBY TITLE TEST TYPES
syn keyword sasStatement UPDATE VALUE VAR WAITSAS WAYS WEIGHT WHERE WINDOW X SYSTASK

" SAS/GRAPH statements (Zhenhuan Hu)
syn keyword sasStatement GOPTIONS LEGEND PATTERN PLOT

" SAS/CHART statements (Zhenhuan Hu)
syn keyword sasStatement BLOCK HBAR PIE STAR VBAR

" SAS/UNIVARIATE syntax (Zhenhuan Hu)
syn keyword sasStatement CDFPLOT HISTOGRAM INSET PPPLOT PROBPLOT QQPLOT

" Match declarations have to appear one per line (Paulo Tanimoto)
syn match sasStatement "FOOTNOTE\d"
syn match sasStatement "TITLE\d"
syn match sasStatement "AXIS\d\{1,2}"
syn match sasStatement "SYMBOL\d\{1,3}"

" ODS keywords (Zhenhuan Hu)
syn keyword sasODSKwd ODS CLOSE CHTML CSVALL contained
syn keyword sasODSKwd DOCBOOK DOCUMENT ESCAPECHAR EXCLUDE contained
syn keyword sasODSKwd GRAPHICS HTML HTMLCSS HTML3 IMODE LISTING contained
syn keyword sasODSKwd MAKEUP OUTPUT PACKAGESm PATH PCL PDF PHTML contained
syn keyword sasODSKwd PRINTER PROCLABEL PROCTITLE PS RESULTWS RTF contained
syn keyword sasODSKwd SELECT SHOW TAGSET TEXT TRACE USEGOPT VERIFY WML contained
syn region sasODS start="^\s*ODS " end=";" contains=sasODSKwd, sasString, sasNumber, sasComment, sasMacro, sasMacroFunction, sasMacroVar
syn region sasODS start=";\s*ODS " end=";" contains=sasODSKwd, sasString, sasNumber, sasComment, sasMacro, sasMacroFunction, sasMacroVar

" Keywords that are used in Proc SQL
" I left them as statements because SAS's enhanced editor highlights
" them the same as normal statements used in data steps (Jim Kidd)
syn keyword sasStatement ADD AND ALTER AS CASCADE CHECK CREATE
syn keyword sasStatement DELETE DESCRIBE DISTINCT DROP FOREIGN
syn keyword sasStatement FROM GROUP HAVING INDEX INSERT INTO IN
syn keyword sasStatement JOIN KEY LEFT LIKE MESSAGE MODIFY MSGTYPE NOT
syn keyword sasStatement NULL ON OR ORDER PRIMARY REFERENCES
syn keyword sasStatement RESET RESTRICT RIGHT SELECT SET TABLE TABLES
syn keyword sasStatement UNIQUE UPDATE VALIDATE VIEW WHERE

" SAS formats
syn match sasFormatValue "\w\+\." contained
syn region sasODS start="^\s*FORMAT " end=";" contains=sasFormatValue, sasStatement, sasString, sasNumber, sasStep, sasComment, sasMacro, sasMacroFunction, sasMacroVar
syn region sasODS start="^\s*INPUT " end=";" contains=sasFormatValue, sasStatement, sasString, sasNumber, sasStep, sasComment, sasMacro, sasMacroFunction, sasMacroVar
syn region sasODS start=";\s*FORMAT " end=";" contains=sasFormatValue, sasStatement, sasString, sasNumber, sasStep, sasComment, sasMacro, sasMacroFunction, sasMacroVar
syn region sasODS start=";\s*INPUT " end=";" contains=sasFormatValue, sasStatement, sasString, sasNumber, sasStep, sasComment, sasMacro, sasMacroFunction, sasMacroVar

" Thanks to Ronald Höllwarth for this fix to an intra-versioning
" problem with this little feature
" Used a more efficient way to match macro vars (Zhenhuan Hu)
if version < 600
	syn match sasMacroVar "\&\+\w\+"
else
	syn match sasMacroVar "&\+\w\+"
endif

" Match declarations have to appear one per line (Paulo Tanimoto)
syn match sasMacro "%BQUOTE"
syn match sasMacro "%BY"
syn match sasMacro "%NRBQUOTE"
syn match sasMacro "%CMPRES"
syn match sasMacro "%QCMPRES"
syn match sasMacro "%COMPSTOR"
syn match sasMacro "%DATATYP"
syn match sasMacro "%DISPLAY"
syn match sasMacro "%DO"
syn match sasMacro "%ELSE"
syn match sasMacro "%END"
syn match sasMacro "%EVAL"
syn match sasMacro "%GLOBAL"
syn match sasMacro "%GOTO"
syn match sasMacro "%IF"
syn match sasMacro "%INDEX"
syn match sasMacro "%INPUT"
syn match sasMacro "%INCLUDE"
syn match sasMacro "%KEYDEF"
syn match sasMacro "%LABEL"
syn match sasMacro "%LEFT"
syn match sasMacro "%LENGTH"
syn match sasMacro "%LET"
syn match sasMacro "%LOCAL"
syn match sasMacro "%LOWCASE"
syn match sasMacro "%MACRO"
syn match sasMacro "%MEND"
syn match sasMacro "%NRBQUOTE"
syn match sasMacro "%NRQUOTE"
syn match sasMacro "%NRSTR"
syn match sasMacro "%PUT"
syn match sasMacro "%QCMPRES"
syn match sasMacro "%QLEFT"
syn match sasMacro "%QLOWCASE"
syn match sasMacro "%QSCAN"
syn match sasMacro "%QSUBSTR"
syn match sasMacro "%QSYSFUNC"
syn match sasMacro "%QTRIM"
syn match sasMacro "%QUOTE"
syn match sasMacro "%QUPCASE"
syn match sasMacro "%SCAN"
syn match sasMacro "%STR"
syn match sasMacro "%SUBSTR"
syn match sasMacro "%SUPERQ"
syn match sasMacro "%SYSCALL"
syn match sasMacro "%SYSEVALF"
syn match sasMacro "%SYSEXEC"
syn match sasMacro "%SYSFUNC"
syn match sasMacro "%SYSGET"
syn match sasMacro "%SYSLPUT"
syn match sasMacro "%SYSPROD"
syn match sasMacro "%SYSRC"
syn match sasMacro "%SYSRPUT"
syn match sasMacro "%THEN"
syn match sasMacro "%TO"
syn match sasMacro "%TRIM"
syn match sasMacro "%UNQUOTE"
syn match sasMacro "%UNTIL"
syn match sasMacro "%UPCASE"
syn match sasMacro "%VERIFY"
syn match sasMacro "%WHILE"
syn match sasMacro "%WINDOW"

" User defined macro functions (Zhenhuan Hu)
syn match sasMacroFunction "%\w\+("he=e-1

" Used this to avoid highlighting in options of SAS statements (Zhenhuan Hu)
syn keyword sasOptionKwd MISSING NCOL NOPCT NOROW contained
syn region sasStatementOption start="\/\s*[A-Za-z_]" end=";" contains=sasOptionKwd, sasString, sasNumber, sasComment, sasMacro, sasMacroFunction, sasMacroVar

" List of SAS function names
syn keyword sasFunctionName ABS ADDR AIRY ARCOS ARSIN ATAN ATTRC ATTRN contained
syn keyword sasFunctionName ANYALNUM ANYALPHA ANYDIGIT ANYPUNCT ANYSPACE contained
syn keyword sasFunctionName BAND BETAINV BLSHIFT BNOT BOR BRSHIFT BXOR contained
syn keyword sasFunctionName BYTE COMPARE COMPGED COMPLEV CAT CATS CATT CATX contained
syn keyword sasFunctionName CDF CEIL CEXIST CINV CLOSE CNONCT COLLATE contained
syn keyword sasFunctionName COMPBL COMPOUND COMPRESS COS COSH COUNT COUNTC CUROBS contained
syn keyword sasFunctionName CSS CV DACCDB DACCDBSL DACCSL DACCSYD DACCTAB contained
syn keyword sasFunctionName DAIRY DATE DATEJUL DATEPART DATETIME DAY contained
syn keyword sasFunctionName DCLOSE DEPDB DEPDBSL DEPDBSL DEPSL DEPSL contained
syn keyword sasFunctionName DEPSYD DEPSYD DEPTAB DEPTAB DEQUOTE DHMS contained
syn keyword sasFunctionName DIF DIGAMMA DIM DINFO DNUM DOPEN DOPTNAME contained
syn keyword sasFunctionName DOPTNUM DREAD DROPNOTE DSNAME ERF ERFC EXIST contained
syn keyword sasFunctionName EXP FAPPEND FCLOSE FCOL FDELETE FETCH FETCHOBS contained
syn keyword sasFunctionName FEXIST FGET FILEEXIST FILENAME FILEREF FIND FINDC FINFO contained
syn keyword sasFunctionName FINV FIPNAME FIPNAMEL FIPSTATE FLOOR FNONCT contained
syn keyword sasFunctionName FNOTE FOPEN FOPTNAME FOPTNUM FPOINT FPOS contained
syn keyword sasFunctionName FPUT FREAD FREWIND FRLEN FSEP FUZZ FWRITE contained
syn keyword sasFunctionName GAMINV GAMMA GETOPTION GETVARC GETVARN HBOUND contained
syn keyword sasFunctionName HMS HOSTHELP HOUR IBESSEL ID IDLABEL INDEX INDEXC contained
syn keyword sasFunctionName INDEXW INPUT INPUTC INPUTN INT INTCK INTNX contained
syn keyword sasFunctionName INTRR IRR JBESSEL JULDATE KURTOSIS LAG LBOUND contained
syn keyword sasFunctionName LEFT LENGTH LENGTHC LENGTHM LENGTHN contained
syn keyword sasFunctionName LGAMMA LIBNAME LIBREF LOG LOG10 contained
syn keyword sasFunctionName LOG2 LOGPDF LOGPMF LOGSDF LOWCASE MAX MDY contained
syn keyword sasFunctionName MEAN MIN MINUTE MISSING MOD MONTH MOPEN MORT N contained
syn keyword sasFunctionName NETPV NMISS NORMAL NOTALNUM NOTAPLHA NOTDIGIT contained
syn keyword sasFunctionName NOTUPPER NOTE NPV OPEN ORDINAL contained
syn keyword sasFunctionName PATHNAME PDF PEEK PEEKC PMF POINT POISSON POKE contained
syn keyword sasFunctionName PROBBETA PROBBNML PROBCHI PROBF PROBGAM contained
syn keyword sasFunctionName PROBHYPR PROBIT PROBNEGB PROBNORM PROBT PROPCASE contained
syn keyword sasFunctionName PRXCHANGE PRXMATCH PRXNEXT PRXPAREN PRXPARSE PRXPOSN contained
syn keyword sasFunctionName PRXSUBSTR PUT PUTC PUTN QTR QUOTE RANBIN RANCAU RANEXP contained
syn keyword sasFunctionName RANGAM RANGE RANK RANNOR RANPOI RANTBL RANTRI contained
syn keyword sasFunctionName RANUNI REPEAT RESOLVE REVERSE REWIND RIGHT contained
syn keyword sasFunctionName ROUND SAVING SCAN SCANQ SDF SECOND SIGN SIN SINH contained
syn keyword sasFunctionName SKEWNESS SOUNDEX SPEDIS SQRT STD STDERR STFIPS contained
syn keyword sasFunctionName STNAME STNAMEL STRIP SUBSTR SUM SYMGET SYSGET SYSMSG contained
syn keyword sasFunctionName SYSPROD SYSRC SYSTEM TAN TANH TIME TIMEPART contained
syn keyword sasFunctionName TINV TNONCT TODAY TRANSLATE TRANWRD TRIGAMMA contained
syn keyword sasFunctionName TRIM TRIMN TRUNC UNIFORM UPCASE USS VAR contained
syn keyword sasFunctionName VARFMT VARINFMT VARLABEL VARLEN VARNAME contained
syn keyword sasFunctionName VARNUM VARRAY VARRAYX VARTYPE VERIFY VFORMAT contained
syn keyword sasFunctionName VFORMATD VFORMATDX VFORMATN VFORMATNX VFORMATW contained
syn keyword sasFunctionName VFORMATWX VFORMATX VINARRAY VINARRAYX VINFORMAT contained
syn keyword sasFunctionName VINFORMATD VINFORMATDX VINFORMATN VINFORMATNX contained
syn keyword sasFunctionName VINFORMATW VINFORMATWX VINFORMATX VLABEL contained
syn keyword sasFunctionName VLABELX VLENGTH VLENGTHX VNAME VNAMEX VTYPE contained
syn keyword sasFunctionName VTYPEX WEEKDAY YEAR YYQ ZIPFIPS ZIPNAME ZIPNAMEL contained
syn keyword sasFunctionName ZIPSTATE contained

" Function names must be followed by a left parenthesis (Zhenhuan Hu)
syn match sasFunction "\w\+(" contains=sasFunctionName

" End of SAS functions

" Handy settings for using vim with log files
syn keyword sasLogMsg NOTE
syn keyword sasWarnMsg WARNING
syn keyword sasErrMsg ERROR

" Always contained in a comment (Bob Heckel)
syn keyword sasTodo TODO TBD FIXME contained

" These don't fit anywhere else (Bob Heckel).
" Added others that were missing.
syn match sasInternalVariable	"_ALL_"
syn match sasInternalVariable "_AUTOMATIC_"
syn match sasInternalVariable	"_CHARACTER_"
syn match sasInternalVariable	"_INFILE_"
syn match sasInternalVariable	"_N_"
syn match sasInternalVariable "_NAME_"
syn match sasInternalVariable	"_NULL_"
syn match sasInternalVariable	"_NUMERIC_"
syn match sasInternalVariable "_USER_"
syn match sasInternalVariable	"_WEBOUT_"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet

if version >= 508 || !exists("did_sas_syntax_inits")
	if version < 508
		let did_sas_syntax_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	hi Procedure term=bold ctermfg=Green gui=bold guifg=Orange
	hi Fixed term=none ctermfg=Magenta gui=none guifg=#95e454
	hi Log term=none ctermfg=Yellow gui=none guifg=LightYellow1

	HiLink sasComment Comment
	HiLink sasConditional Statement
	HiLink sasStep Statement
	HiLink sasFunctionName Function
	HiLink sasMacro Function
	HiLink sasMacroVar Function
	HiLink sasMacroFunction Function
	HiLink sasNumber Fixed
	HiLink sasStatement Statement
	HiLink sasProcKwd Statement
	HiLink sasODSKwd Statement
	HiLink sasFormatValue Fixed
	HiLink sasString Fixed
	HiLink sasProcName Procedure
	
	HiLink sasTodo Todo
	HiLink sasErrMsg ErrorMsg
	HiLink sasWarnMsg WarningMsg
	HiLink sasLogMsg Log
	HiLink sasCards MoreMsg
	HiLink sasInternalVariable PreProc
	
	delcommand HiLink
endif

" Syncronize from beginning to keep large blocks from losing
" syntax coloring while moving through code.
syn sync fromstart

let b:current_syntax = "sas"

" vim: ts=8


" begin SAS configuration

"F3 run 
map <F3> :w<CR>:!SAS % -CONFIG "C:\Program Files\SAS\SASFoundation\9.2\nls\en\SASV9.CFG"<CR>:sp  %<.lst<CR>:sp  %<.log<CR>

"F4 close other two window
"the current active window is Log window after F3 running; F4 jump to SAS file with full window
map <F4> :close<CR>:close<CR>

"F8 keep only one current window
map <F8> : only<CR>

"F5 jump to the SAS file
"F6 jump to the log file
"F7 jump to the list file (list output)
map <F5> :e %<.sas<CR>
map <F6> :e %<.log<CR>
map <F7> :e %<.lst<CR>

" end SAS configuration
