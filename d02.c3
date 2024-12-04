module d02;
import std::io;
import std::collections;
import std::core::mem;
import std::math;
import std::sort;
import util;

fn void! part1(String input) {
	usz total;
	String[] lines = input.tsplit("\n");
	foreach LINE: (line : lines) {
		if (line.len == 0) continue;
		@pool() {
			int[] xs = line.to_integers(int, allocator::temp());
			if (is_safe(xs)) total += 1;
		};
	}
	io::printn(total);
}

fn void! part2(String input) {
	usz total;
	String[] lines = input.tsplit("\n");
	foreach LINE: (line : lines) {
		if (line.len == 0) continue;
		@pool() {
			int[] xs = line.to_integers(int, allocator::temp());
			if (is_safe_damped(xs)) total += 1;
		};
	}
	io::printn(total);
}

fn bool is_safe(int[] record) {
	int prev_change = 0;
	for (int i = 0; i < record.len - 1; i += 1) {
		int x = record[i];
		int y = record[i+1];
		int change = y - x;
		int abs_change = math::abs(change);
		if (abs_change >= 1 && abs_change <= 3 && math::sign(change) != -1 * math::sign(prev_change)) {
			prev_change = change;
		} else {
			return false;
		}
	}
	return true;
}

fn bool is_safe_damped(int[] record) {
	if (is_safe(record)) return true;
	@pool() {
		int[] new_record = mem::temp_new_array(int, record.len - 1);
		for (int i = 0; i < record.len; i += 1) {
			new_record[0..] = record[0..^2];
			new_record[i..] = record[i+1..];
			if (is_safe(new_record)) return true;
		}
	};
	return false;
}

fn void test_is_safe() @test {
	String[] safe_inputs = {
		"1 2 3 4",
	};
	foreach (line : safe_inputs) {
		int[] xs = line.to_integers(int, allocator::temp());
		assert(is_safe(xs), "got unsafe, expected safe: %s", line);
	}
}

fn void test_is_safe_damped() @test {
	String[] safe_inputs = {
		"9 1 2 3 4",
		"1 9 2 3 4",
		"1 2 9 3 4",
		"1 2 3 9 4",
		"1 2 3 4 9",
		"16 14 12 13 9",
		// edge cases from
		// https://old.reddit.com/r/adventofcode/comments/1h4shdu/2024_day_2_part2_edge_case_finder/
		"48 46 47 49 51 54 56",
		"1 1 2 3 4 5",
		"1 2 3 4 5 5",
		"5 1 2 3 4 5",
		"1 4 3 2 1",
		"1 6 7 8 9",
		"1 2 3 4 3",
		"9 8 7 6 7",
		"7 10 8 10 11",
		"29 28 27 25 26 25 22 20",
	};
	foreach (line : safe_inputs) {
		int[] xs = line.to_integers(int, allocator::temp());
		assert(is_safe_damped(xs), "got unsafe, expected safe: %s", line);
	}
}
