{ Compiler Settings }
{$B-}  // Complete Boolean Evaluation Off
{$O+} // Optimization On
{$P+} // Open String Params On
{$Q-}  // Overflow Checking Off
{$R-}  // Range Checking Off
{$S-}  // Stack-Overflow Checking
{$T-}  // Typed @ operator Off
{$V-}  // Var String Checking Off
{$X+} // Extended Syntax On

{$IFNDEF Win32}
  {$H+}  // Use long strings by default
  {$F-}    // Force Far Calls
  {$K-}   // Smart Callbacks
{$ENDIF}

{$IFDEF VER130}               { Delphi 5 }
  {$DEFINE VERSION5}       { Version 5 or greater }
  {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER140}               { Delphi 6 }
  {$DEFINE VERSION6}       { Version 6 or greater }
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER150}               { Delphi 7 }
  {$DEFINE VERSION6}       { Version 6 or greater }
  {$DEFINE VERSION7}       { Version 7 or greater }  
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER170}               { Delphi 9 }
  {$DEFINE VERSION6}       { Version 6 or greater }
  {$DEFINE VERSION7}       { Version 7 or greater }  
  {$DEFINE VERSION9}       { Version 9 or greater }  
  {$DEFINE SPLASH} 
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER180}               { Delphi 10 }
  {$DEFINE VERSION6}       { Version 6 or greater }
  {$DEFINE VERSION7}       { Version 7 or greater }  
  {$DEFINE VERSION9}       { Version 9 or greater }  
  {$DEFINE VERSION10}     { Version 10 or greater }  
  {$DEFINE SPLASH} 
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER185}               { Delphi 11 }
  {$DEFINE VERSION6}       { Version 6 or greater }
  {$DEFINE VERSION7}       { Version 7 or greater }  
  {$DEFINE VERSION9}       { Version 9 or greater }  
  {$DEFINE VERSION10}     { Version 10 or greater }  
  {$DEFINE VERSION11}     { Version 11 or greater }  
  {$DEFINE SPLASH} 
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER200}               { Delphi 12 }
  {$DEFINE VERSION6}       { Version 6 or greater }
  {$DEFINE VERSION7}       { Version 7 or greater }  
  {$DEFINE VERSION9}       { Version 9 or greater }  
  {$DEFINE VERSION10}     { Version 10 or greater }  
  {$DEFINE VERSION11}     { Version 11 or greater }  
  {$DEFINE VERSION12}     { Version 12 or greater }  
  {$DEFINE SPLASH} 
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER210}               { Delphi 14 }
  {$DEFINE VERSION6}       { Version 6 or greater }
  {$DEFINE VERSION7}       { Version 7 or greater }  
  {$DEFINE VERSION9}       { Version 9 or greater }  
  {$DEFINE VERSION10}     { Version 10 or greater }  
  {$DEFINE VERSION11}     { Version 11 or greater }  
  {$DEFINE VERSION12}     { Version 12 or greater }  
  {$DEFINE VERSION14}     { Version 14 or greater }  
  {$DEFINE SPLASH} 
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}