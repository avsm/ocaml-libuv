# This makefile is jank. We will redo.
all:
	corebuild -Is src examples/cat.native -pkg ctypes.stubs -pkg ctypes.foreign -lflags -cclib,-luv -tag debug -cflag -g

tests:
	corebuild -Is src test/test_runner.native -pkg oUnit -pkg ctypes.foreign -lflags -cclib,-luv && ./test_runner.native

clean:
	ocamlbuild -clean
