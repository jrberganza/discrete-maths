const std = @import("std");
const builtin = @import("builtin");

/// There's a placeholder where the letter Ñ should be due to limitations with console I/O
const cypher = [_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'N', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };

pub fn main() anyerror!void {
    // Initialize the allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    // Get standard input & output handles
    var std_in = std.io.getStdIn().reader();
    var std_out = std.io.getStdOut().writer();

    // Get the line of text that we intend to cypher
    std_out.print("Texto a cifrar: ", .{}) catch unreachable;
    const text = try readUntilEolAlloc(allocator, std_in, std.math.maxInt(usize));
    defer allocator.free(text);

    // Get the key
    std_out.print("Clave: ", .{}) catch unreachable;
    // NOTE: Should probably lift this logic into another function
    const key: u32 = blk: while (true) {
        const _key = try readUntilEolAlloc(allocator, std_in, std.math.maxInt(usize));
        if (std.fmt.parseInt(u32, _key, 10)) |num| {
            allocator.free(_key);
            break :blk num;
        } else |_| {
            std_out.print("Pon un numero valido\nClave: ", .{}) catch unreachable;
            allocator.free(_key);
        }
    } else 0;

    // Start cypher'ing
    for (text) |*char| {
        if (std.ascii.isAlpha(char.*)) {
            // Ignores uppercase letters
            const lower_char = std.ascii.toLower(char.*);
            const index = std.mem.indexOfScalar(u8, &cypher, lower_char) orelse 0;

            // index is a usize, chars are u8, so we need to truncate.
            const new_char = @truncate(u8, modMult(u32, @truncate(u32, index), key, 27));
            char.* = cypher[new_char];
        }
    }

    std_out.print("Cifrado: {s}\n", .{text}) catch unreachable;
}

/// Multiply with a modulo
/// Overflows with large enough numbers.
fn modMult(comptime T: type, a: T, b: T, mod: T) T {
    return ((a % mod) * (b % mod)) % mod;
}

/// Takes a Reader and reads a line excluding the EOL sequence ("\r\n" or "\n")
fn readUntilEolAlloc(allocator: std.mem.Allocator, reader: std.fs.File.Reader, max_size: usize) ![]u8 {
    const buf = try reader.readUntilDelimiterAlloc(allocator, '\n', max_size);
    defer allocator.free(buf);

    // Dupes the buffer. Efficient enough for this case, but I should maybe find a better
    // way to do this
    const cut_buf = if (buf[buf.len - 1] == '\r') buf[0 .. buf.len - 1] else buf;
    return allocator.dupe(u8, cut_buf);
}