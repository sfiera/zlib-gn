ifneq ($(TARGET_OS),win)

ZLIB_CPPFLAGS := $(shell pkg-config --cflags zlib)
ZLIB_LDFLAGS := $(shell pkg-config --libs zlib)

else

ZLIB_CPPFLAGS := -I $(ZLIB_ROOT)/include
ZLIB_LDFLAGS :=

ZLIB_A := $(OUT)/zlib.a
ZLIB_SRCS := \
	$(ZLIB_ROOT)/zlib-1.2.11/adler32.c \
	$(ZLIB_ROOT)/zlib-1.2.11/compress.c \
	$(ZLIB_ROOT)/zlib-1.2.11/crc32.c \
	$(ZLIB_ROOT)/zlib-1.2.11/deflate.c \
	$(ZLIB_ROOT)/zlib-1.2.11/gzclose.c \
	$(ZLIB_ROOT)/zlib-1.2.11/gzlib.c \
	$(ZLIB_ROOT)/zlib-1.2.11/gzread.c \
	$(ZLIB_ROOT)/zlib-1.2.11/gzwrite.c \
	$(ZLIB_ROOT)/zlib-1.2.11/infback.c \
	$(ZLIB_ROOT)/zlib-1.2.11/inffast.c \
	$(ZLIB_ROOT)/zlib-1.2.11/inflate.c \
	$(ZLIB_ROOT)/zlib-1.2.11/inftrees.c \
	$(ZLIB_ROOT)/zlib-1.2.11/trees.c \
	$(ZLIB_ROOT)/zlib-1.2.11/uncompr.c \
	$(ZLIB_ROOT)/zlib-1.2.11/zutil.c

ZLIB_OBJS := $(ZLIB_SRCS:%=$(OUT)/%.o)

$(ZLIB_A): $(ZLIB_OBJS)
	$(AR) rcs $@ $+

ZLIB_PRIVATE_CPPFLAGS := \
	$(ZLIB_CPPFLAGS) \
    -D HAVE_UNISTD_H=1 \
    -D HAVE_STDARG_H=1 \
	-Wall \
	-Werror

$(ZLIB_OBJS): $(OUT)/%.c.o: %.c
	@$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(ZLIB_PRIVATE_CPPFLAGS) -c $< -o $@

-include $(ZLIB_OBJS:.o=.d)

endif
