program test;

{function f}
function f(x : integer) : integer;
var i : integer;
begin
	i := 0;
	f := 0;
	while i < x do
	begin
		if i mod 2 = 0 then
			f := f + iterator;
			i := i + 1;
	end;
end;

{main program}
var x : integer;
begin
	readln(x);
	writeln(f(x));
end.
