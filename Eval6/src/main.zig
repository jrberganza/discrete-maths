const std = @import("std");

pub fn main() anyerror!void {
    // Initialize the allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Get standard output handle
    var std_out = std.io.getStdOut().writer();

    // Get process arguments. This function returns an iterator.
    var args_it = try std.process.argsWithAllocator(allocator);
    defer args_it.deinit();
    // In zig 0.9.1, ArgIterator#next(Allocator) gives us the memory, so we must free it
    // In zig 0.10.x, with ArgIterator#next(), the iterator still owns the memory, so deinit takes care of everything
    const exec_name = try args_it.next(allocator) orelse unreachable; // executable name
    allocator.free(exec_name); // We don't really care about it
    // If we don't get enough arguments we just error out
    const arg_a = try args_it.next(allocator) orelse return error.MissingArgumentA;
    defer allocator.free(arg_a);
    const arg_b = try args_it.next(allocator) orelse return error.MissingArgumentB;
    defer allocator.free(arg_b);
    const arg_n = try args_it.next(allocator) orelse return error.MissingArgumentN;
    defer allocator.free(arg_n);

    const a = try std.fmt.parseInt(u128, arg_a, 10);
    const b = try std.fmt.parseInt(u128, arg_b, 10);
    const n = try std.fmt.parseInt(u128, arg_n, 10);

    const x = pow(u128, a, b, n);

    std_out.print("{}\n", .{x}) catch unreachable;
}

/// Calculates the power of a^b withing a modulo n.
/// All ints have to be of type T and T must be a unsigned integer.
pub fn pow(comptime T: type, a: T, b: T, n: T) T {
    if (@typeInfo(T).Int.signedness != .unsigned) {
        @compileError("Int must be unsigned");
    }
    const int_bits = @typeInfo(T).Int.bits;

    var x: T = 1;
    // We need to read all bits from most significant to least significant
    // So we get the the position of the most significant bit. In a u128, this is position 127
    // Shifting right requires the shifting amount to be of just the correct int type so we do some
    // math to calculate what size int we need.
    var i: std.meta.Int(.unsigned, std.math.log2_int(u16, int_bits)) = int_bits - 1;
    while (i >= 0) : (i -= 1) {
        const digit = @truncate(u1, b >> i);

        if (digit == 1) {
            x = (std.math.pow(T, x, 2) * a) % n;
        } else {
            x = std.math.pow(T, x, 2) % n;
        }

        // i is unsigned. If we don't break here, the while loop will underflow.
        if (i == 0) break;
    }

    return x;
}