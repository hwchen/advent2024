run *args="-O5":
    c3c compile-run -l pcre2-posix {{args}} .

test:
    c3c compile-test -l pcre2-posix .
