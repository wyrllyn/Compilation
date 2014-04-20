program test;


{function f}
function f(e,e : boolean, z: integer) : integer;
var i, h : integer;
var j : integer;
begin
	i := 0;
	f := 0;
	while i < e do
	begin
		if i mod 2 = 0 then
			f := f + i;
			i := i + 1;
	end;
end;

function a(b : char, arg : integer) : integer;
var z2 : boolean;
begin
	z2 := true;
	a := z2;
end;

procedure poney(corne, sabots : integer);
var licorne : integer;
begin
	licorne := 3;
end;

{main program}
var x : char;
begin
	readln(x);
	writeln(f(x));
end.
