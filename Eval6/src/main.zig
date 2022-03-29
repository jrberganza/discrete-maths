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

    var x: u128 = 1;
    var i: u7 = 127;
    while (i >= 0) : (i -= 1) {
        const digit = @truncate(u1, b >> i);

        if (digit == 1) {
            x = (std.math.pow(u128, x, 2) * a) % n;
        } else {
            x = std.math.pow(u128, x, 2) % n;
        }

        if (i == 0) break;
    }

    std_out.print("{}\n", .{x}) catch unreachable;
}

// A^B mod n
// Representar B en binario = b_k-1 b_k-2 ... b_i ... b_1 b_0
// Hacer x = 1
// Para i = k-1, ... 0 hacer
//     Si (b_i = 1) entonces
//         x = x^2 * A mod n
//     si no
//         x = x^2 mod n