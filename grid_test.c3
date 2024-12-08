// separate module from `grid`, is it because generic
// modules need to be imported to be instantiated?
module grid_test;
import grid;

fn void test_grid_basic() @test {
	Grid(<char>) g;
	g.init({1,2,3,4,5,6}, n_cols: 2);

	// check rows
	assert(g.row(0)!! == {1,2});
	assert(g.row(1)!! == {3,4});
	assert(g.row(2)!! == {5,6});

	// check cols
	char[3] colbuf;
	assert(g.col(0, &colbuf)!! == {1,3,5});
	assert(g.col(1, &colbuf)!! == {2,4,6});

	char[2] badbuf;
	if (try g.col(0, &badbuf)) {
		assert(false);
	}
}
