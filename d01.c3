module d01;
import std::io;
import std::collections;
import std::math;
import std::sort;

fn void! part1(String input) {
	List(<long>) t0;
	List(<long>) t1;
	String[] lines = input.tsplit("\n");
	foreach (line : lines) {
		if (line.len == 0) continue;
		@pool() {
			String[] xs = line.tsplit("   ");
			assert(xs.len == 2);
			t0.push(xs[0].to_long()!);
			t1.push(xs[1].to_long()!);
		};
	}

	quicksort(t0);
	quicksort(t1);

	usz total = 0;
	while (t0.len()) {
		total += math::abs(t0.pop() - t1.pop())!;
	}
	io::printfn("%d", total);
}

fn void! part2(String input) {
	HashMap(<int, int>) l_counts;
	HashMap(<int, int>) r_counts;
	String[] lines = input.tsplit("\n");
	foreach (line : lines) {
		if (line.len == 0) continue;
		@pool() {
			String[] xs = line.tsplit("   ");
			assert(xs.len == 2);

			int left = xs[0].to_integer(int)!!;
			int right = xs[1].to_integer(int)!!;

			if (l_counts.has_key(left)) {
				int* count = l_counts.get_ref(left)!!;
				*count += 1;
			} else {
				l_counts.set(left, 1);
			}

			if (r_counts.has_key(right)) {
				int* count = r_counts.get_ref(right)!!;
				*count += 1;
			} else {
				r_counts.set(right, 1);
			}
		};
	}

	int total = 0;
	l_counts.@each(; int n, int l_count) {
		int r_count = r_counts.get(n) ?? 0;
		total += n * l_count * r_count;
	};
	io::printfn("%d", total);
}
