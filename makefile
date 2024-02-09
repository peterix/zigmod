PLAYER := player
CONVERTER := converter

# For building on Windows using MinGW.
ifeq ($(OS), Windows_NT)
    LDFLAGS := -lmingw32
    PLAYER := $(PLAYER).exe
    CONVERTER := $(CONVERTER).exe
endif

.PHONY: help
help:
	@ echo "choose one:"
	@ echo "  'make converter' to build the MOD to WAV example"
	@ echo "  'make player' to build the SDL2 player example"
	@ echo "  'make clean' to remove build artifacts"

converter: examples/converter.c src/pocketmod.h
	$(CC) $(filter %.c, $^) -o $@ -Isrc -O2

player: examples/player.c src/pocketmod.h
	$(CC) $(filter %.c, $^) -o $@ -Isrc $(LDFLAGS) -lSDL2main -lSDL2

.PHONY: clean
clean:
	$(RM) $(CONVERTER)
	$(RM) $(PLAYER)
