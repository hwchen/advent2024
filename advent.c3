module advent;
import std::io;
import std::time::clock;
import d01;
import d02;

def SolutionFn = fn void!();
struct Day {
	String label;
	SolutionFn solution;
}
const Day[] DAYS = {
	{ "d01-p1", &d01::part1 },
	{ "d01-p2", &d01::part2 },
	{ "d02-p1", &d02::part1 },
};

fn void! main() {
	Clock start = clock::now();
	Clock stopwatch = start;
	foreach (day : DAYS) {
		day.solution()!;
		io::printfn("%s: %dµs", day.label, stopwatch.mark().to_duration());
	}
	io::printfn("%dµs total", ((NanoDuration)(stopwatch - start)).to_duration());
}
