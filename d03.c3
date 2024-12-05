module d03;
import std::io;
import std::collections;
import std::core::mem;
import std::math;
import std::sort;
import pcre2;
import util;

fn void! part1(String input) {
	int total = 0;
	@pool() {
		ZString input_z = input.zstr_copy();
		Mul[] muls = match_muls(input_z)!!;
		foreach (mul : muls) {
			total += mul[0] * mul[1];
		}
	};
	io::printn(total);
}

fn void! part2(String input) {
	int total = 0;
	@pool() {
		ZString input_z = input.zstr_copy();
		Mul[] muls = match_muls_cond(input_z)!!;
		foreach (mul : muls) {
			total += mul[0] * mul[1];
		}
	};
	io::printn(total);
}

def Mul = int[2];
fn Mul[]! match_muls(ZString s, Allocator alloc = allocator::heap()) {
	char[1024] errbuf;

	Regex_t re;
	ZString pattern = `mul\(([0-9]+),([0-9]+)\)`;
	CInt result = pcre2::regcomp(&re, pattern, pcre2::REG_ICASE);
	defer pcre2::regfree(&re);
	if (result != 0) {
		pcre2::regerror(result, &re, &errbuf, 1024);
		io::printfn("regcomp error: %s", (ZString)&errbuf);
		return RegexError.ERROR?;
	}

	@pool(alloc) {
		List(<Mul>) muls;
		muls.temp_init();
		usz start_offset = 0;
		while (true) {
			ZString haystack = (ZString)s[start_offset..s.len()];
			Regmatch_t[3] matches;
			result = pcre2::regexec(&re, haystack, matches.len, &matches, 0);
			if (result == pcre2::REG_NOMATCH) break;
			if (result != 0) {
				pcre2::regerror(result, &re, &errbuf, 1024);
				io::printfn("regexec error: %s", (ZString)&errbuf);
				return RegexError.ERROR?;
			}

			//foreach (i, match : matches[0..]) {
			//	if (match.rm_so == -1) continue;
			//	io::printfn("Match group %s [%s]", i+1, (String)haystack[match.rm_so..match.rm_eo-1]);
			//}

			// extract the two ints
			Mul mul;
			mul[0] = ((String)haystack[matches[1].rm_so..matches[1].rm_eo-1]).to_int()!;
			mul[1] = ((String)haystack[matches[2].rm_so..matches[2].rm_eo-1]).to_int()!;
			muls.push(mul);
			
			// Update offset for the next round
			start_offset += matches[0].rm_eo;
		}
		return muls.to_new_array(alloc);
	};
}

fault RegexError {
	ERROR,
}

fn void test_regex() @test {
	ZString input = "mul(1,2)mul(3,4)";
	assert(match_muls(input)!! == {{1,2},{3,4}});
}

fn Mul[]! match_muls_cond(ZString s, Allocator alloc = allocator::heap()) {
	char[1024] errbuf;

	Regex_t re;
	ZString pattern = `mul\(([0-9]+),([0-9]+)\)|(do\(\))|(don't\(\))`;
	CInt result = pcre2::regcomp(&re, pattern, pcre2::REG_ICASE);
	defer pcre2::regfree(&re);
	if (result != 0) {
		pcre2::regerror(result, &re, &errbuf, 1024);
		io::printfn("regcomp error: %s", (ZString)&errbuf);
		return RegexError.ERROR?;
	}

	bool do_it = true;
	@pool(alloc) {
		List(<Mul>) muls;
		muls.temp_init();
		usz start_offset = 0;
		while (true) {
			ZString haystack = (ZString)s[start_offset..s.len()];
			Regmatch_t[3] matches;
			result = pcre2::regexec(&re, haystack, matches.len, &matches, 0);
			if (result == pcre2::REG_NOMATCH) break;
			if (result != 0) {
				pcre2::regerror(result, &re, &errbuf, 1024);
				io::printfn("regexec error: %s", (ZString)&errbuf);
				return RegexError.ERROR?;
			}

			//foreach (i, match : matches[0..]) {
			//	if (match.rm_so == -1) continue;
			//	io::printfn("Match group %s [%s]", i+1, (String)haystack[match.rm_so..match.rm_eo-1]);
			//}

			// check do/don't
			if (haystack[matches[0].rm_so..matches[0].rm_eo-1] == "do()") {
				do_it = true;
			} else if (haystack[matches[0].rm_so..matches[0].rm_eo-1] == "don't()") {
				do_it = false;
			} else if (do_it) {
				// extract the two ints if not do/don't
				Mul mul;
				mul[0] = ((String)haystack[matches[1].rm_so..matches[1].rm_eo-1]).to_int()!;
				mul[1] = ((String)haystack[matches[2].rm_so..matches[2].rm_eo-1]).to_int()!;
				muls.push(mul);
			}
			
			// Update offset for the next round
			start_offset += matches[0].rm_eo;
		}
		return muls.to_new_array(alloc);
	};
}

fn void test_regex_cond() @test {
	ZString input = "mul(1,2)don't()mul(3,4)do()mul(5,6)";
	assert(match_muls_cond(input)!! == {{1,2},{5,6}});
}
