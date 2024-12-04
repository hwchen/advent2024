module util;
import std::collections;

macro String.to_integers(line, $Type, base = 10, sep = " ", Allocator alloc = allocator::heap()) {
	@pool(alloc) { 
		List(<$Type>) xs;
		xs.temp_init();
		String[] split = line.tsplit(sep);
		foreach (n : split) {
			$Type x = n.to_integer($Type)!!;
			xs.push(x);
		}
		return xs.to_new_array(alloc);
	};
}

fn void test_to_integers() @test {
	String input = "1 2 3";
	assert(input.to_integers(int) == {1,2,3});
}
