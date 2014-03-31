program test;

{function f}
function f(x : integer) : integer;
var iterator : integer;
begin
	iterator := 0;
	f := 0;
	while iterator < x do
	begin
		if iterator mod 2 = 0 then
			f := f + iterator;
	end;
end;

{main program}
var x : integer;
begin
	readln(x);
	writeln(f(x));
end.
