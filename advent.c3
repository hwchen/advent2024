module advent;
import std::io;
import std::time::clock;
import d01;
import d02;

def SolutionFn = fn void!(String);
struct Day {
	String label;
	String input_path;
	SolutionFn solution;
}
const Day[] DAYS = {
	{ "d01-p1", "d01.txt", &d01::part1 },
	{ "d01-p2", "d01.txt", &d01::part2 },
	{ "d02-p1", "d02.txt", &d02::part1 },
};

fn void! main() {
	Clock start = clock::now();
	Clock stopwatch = start;
	foreach (day : DAYS) {
		String input = (String)file::load_temp(day.input_path)!;
		day.solution(input)!;
		io::printfn("%s: %dµs", day.label, stopwatch.mark().to_duration());
	}
	io::printfn("%dµs total", ((NanoDuration)(stopwatch - start)).to_duration());
}
