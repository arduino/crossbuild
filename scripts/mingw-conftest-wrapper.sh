#!/bin/sh
# Wrapper for the mingw cross-compiler, needed only to run libelf-0.8.13's
# ./configure (a pre-AC_EXEEXT autoconf 2.13 script).
#
# That configure's compiler sanity check links a test program with
# `-o conftest` and then checks for a file literally named `conftest`.
# mingw-gcc always appends `.exe` to linker output, so the file it actually
# produces is `conftest.exe`, and the check fails with a false
# "C compiler cannot create executables" error. This wrapper runs the real
# compiler and, if it produced "<name>.exe" but "<name>" doesn't exist,
# copies it into place under the bare name too.
#
# Usage: MINGW_CC_REAL=/path/to/real/x86_64-w64-mingw32-gcc \
#          scripts/mingw-conftest-wrapper.sh <compiler args...>

: "${MINGW_CC_REAL:?set MINGW_CC_REAL to the real cross-compiler path}"

"$MINGW_CC_REAL" "$@"
status=$?

out="" prev=""
for a in "$@"; do
  [ "$prev" = "-o" ] && out="$a"
  prev="$a"
done
if [ -n "$out" ] && [ -f "$out.exe" ] && [ ! -e "$out" ]; then
  cp -f "$out.exe" "$out"
fi

exit $status
