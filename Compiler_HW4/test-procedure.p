PROGRAM aa(input, output, error); 
VAR a, b: INTEGER;
VAR c: REAL;
var d: array [ 23 .. 57 ] of array [ 13 .. 57 ] of array [3 .. 57] of integer; 

FUNCTION s(x:array [3 .. 57] of array [11 .. 21] of integer) : INTEGER;
BEGIN
  a := 3;
  x[7][16] := 6;
  a := x[7][16];
  d[25][15][5] := 3;
  a := d[25][15][5];	
  s := 3+4*5
END;

FUNCTION ss(x:integer) : INTEGER;
BEGIN
  a := 5; 
  b := 16;
  d[25][15][a] := 3;
  d[25][15][5] := d[25][b-1+2-1-1][a] + 4;
  a := d[25][15][5];  
  writeln(a);
  ss := 3+4*5
END;

function  addition(e , f: integer) : integer;
     // var c: integer;  // local declaration
      begin
         addition := f + e   // this is the return value
      end;

procedure sort;
    var b: integer; 
    begin
       a := b
    end;

PROCEDURE tt;
BEGIN
    a := ss(2)+33*ss(2);
    c := 0.5
END;

BEGIN
    a := ss(2)*ss(2)+ss(2);
    tt;tt;tt
END.

