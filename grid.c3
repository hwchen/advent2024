module grid(<Type>);

// Grid of bytes
struct Grid {
	Type[] data;
	usz n_cols;
	usz n_rows; // calculated
}

// We don't know the exact format
// - whether we need to parse to integer, etc.
// - whether input string has spaces between cells.
//
// So we do the processing beforehand and just init the
// grid with the final slice of data.
fn void Grid.init(&g, char[] data, usz n_cols) {
	g.data = data;
	g.n_cols = n_cols;
	assert(data.len % n_cols == 0);
	g.n_rows = data.len / n_cols;
}

fn Type[]! Grid.row(&g, usz row_idx) {
	usz data_idx = row_idx * g.n_cols;
	if (data_idx >= g.data.len) {
		return SearchResult.MISSING?;
	}
	return g.data[data_idx:g.n_cols];
}

fn Type[]! Grid.col(&g, usz col_idx, char[] col_buf) {
	if (col_buf.len < g.n_rows) {
		return GridResult.COL_BUFF_TOO_SHORT?;
	}
	if (col_idx >= g.n_cols) {
		return SearchResult.MISSING?;
	}
	for (int row_idx = 0; row_idx < g.n_rows; row_idx += 1) {
		col_buf[row_idx] = g.data[(row_idx * g.n_cols) + col_idx];
	}
	return col_buf[0:g.n_rows];
}

fault GridResult {
	COL_BUFF_TOO_SHORT,
}
