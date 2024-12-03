module d02;
import std::io;
import std::collections;
import std::math;
import std::sort;

fn void! part1() {
	File f = file::open("d02.txt", "rb")!;

	usz total;
	while LINE: (true) {
		@pool() {
			String! line = io::treadline(&f);
			if (catch err = line) {
				if (err == IoError.EOF) break;
				return err?;
			}
			String[] xs = line.tsplit(" ");
			int prev_change = 0;
			for (int i = 0; i < xs.len - 1; i += 1) {
				int x = xs[i].to_int()!;
				int y = xs[i+1].to_int()!;
				int change = y - x;
				int abs_change = math::abs(change);
				if (abs_change >= 1 && abs_change <= 3 && math::sign(change) != -1 * math::sign(prev_change)) {
					prev_change = change;
				} else {
					continue LINE;
				}
			}
			// safe
			total += 1;
		};
	}
	io::printn(total);
}
