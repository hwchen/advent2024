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
	NanoDuration total = 0;
	foreach (day : DAYS) {
		String input = (String)file::load_temp(day.input_path)!;
		Clock start = clock::now();
		day.solution(input)!;
		NanoDuration stop = start.to_now();
		total += stop;
		io::printfn("%s: %dµs", day.label, stop.to_duration());
	}
	io::printfn("%dµs total", total.to_duration());
}
