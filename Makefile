SRCS=$(wildcard src/*.cpp) $(wildcard src/*/*.cpp)
OBJS=$(SRCS:.cpp=.o)

DRIVERS_OBJS=drivers/MidiFileWriter.o drivers/MidiRt.cpp

#CFLAGS_OPT=-g -ffast-math -fsingle-precision-constant -DPTHREAD=1
CFLAGS_OPT=-g -Wall
CFLAGS=$(CFLAGS_OPT) -I src/ -I src/structuregenerators/ -I src/rythmgenerators/ -I src/renderers/ -I src/melodycreators/ -I src/ornamentors/ -I src/innerstructuregenerators/ -I src/arrangers/ -I src/harmonygenerators/ -I/usr/local/jdksmidi-20121102-dev/include -L/usr/local/jdksmidi-20121102-dev/lib/

all: $(OBJS) $(DRIVERS_OBJS)
	g++ $(CFLAGS) -Idrivers/ -DTARGET_PLATFORM_LINUX=1 -DTARGET_PLATFORM_LINUX_I386=1 -DTARGET_PLATFORM_LINUX_X86_64=1 -DTARGET_PLATFORM_POSIX=1 -I/usr/include/jdksmidi \
	ccgmusic.cpp -c -o ccgmusic.o
	g++ $(CFLAGS) -Wall $? ccgmusic.o -lrtmidi -ljdksmidi -pthread -o ccgmusic

drivers/MidiFileWriter.o: drivers/MidiFileWriter.cpp
	g++ $(CFLAGS) -DTARGET_PLATFORM_LINUX=1 -DTARGET_PLATFORM_LINUX_I386=1 -DTARGET_PLATFORM_LINUX_X86_64=1 -DTARGET_PLATFORM_POSIX=1 -I/usr/include/jdksmidi $< -c -o $@

drivers/MidiRt.o: drivers/MidiRt.cpp
	g++ $(CFLAGS) -I /usr/local/include $< -c -o $@

%.o: %.cpp
	g++ $(CFLAGS) $< -c -o $@

test: $(OBJS) $(DRIVERS_OBJS)
	g++ $(CFLAGS) -Idrivers/ -DTARGET_PLATFORM_LINUX=1 -DTARGET_PLATFORM_LINUX_I386=1 -DTARGET_PLATFORM_LINUX_X86_64=1 -DTARGET_PLATFORM_POSIX=1 -I/usr/include/jdksmidi \
	test.cpp -c -o test.o
	g++ $(CFLAGS) -Wall $(OBJS) test.o -lrtmidi -ljdksmidi -o test

clean:
	rm *.o
	rm */*.o
	rm */*/*.o
	rm ccgmusic
	rm test
	rm massif.out
	rm massif.log

massif: test
	valgrind --tool=massif  --heap-admin=1 --depth=50 --peak-inaccuracy=0.0 --detailed-freq=1 --threshold=0.0 --time-unit=B --massif-out-file=massif.out ./test
	ms_print massif.out > massif.log

callgrind: test
	valgrind --tool=callgrind --callgrind-out-file=callgrind.out ./test
