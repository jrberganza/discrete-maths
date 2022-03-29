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

    const a = try std.fmt.parseInt(i128, arg_a, 10);
    const b = try std.fmt.parseInt(i128, arg_b, 10);

    const x = invMult(i128, a, b);

    std_out.print("{}\n", .{x}) catch unreachable;
}

/// Calculates the multiplicative inverse or reciprocal of a number A within a modulo B.
/// Both ints have to be of type T and T must be a signed integer.
pub fn invMult(comptime T: type, a: T, b: T) T {
    if (@typeInfo(T).Int.signedness != .signed) {
        @compileError("Int must be signed");
    }

    // Initialize all variables
    var g_0 = b;
    var g_1 = a;
    var u_0: i128 = 1;
    var u_1: i128 = 0;
    var v_0: i128 = 0;
    var v_1: i128 = 1;

    // The pseudocode has a variable i that gets incremented after each loop
    // and it works with variables such as g_(i-1), g_i, g_(i+1)
    // In this code, we do the same thing by swapping values around
    while (g_1 != 0) {
        const y = @divTrunc(g_0, g_1);
        const g_2 = g_0 - y * g_1;
        g_0 = g_1;
        g_1 = g_2;
        const u_2 = u_0 - y * u_1;
        u_0 = u_1;
        u_1 = u_2;
        const v_2 = v_0 - y * v_1;
        v_0 = v_1;
        v_1 = v_2;
    }

    // Basically modulo
    if (v_0 < 0) {
        v_0 = v_0 + b;
    }

    // The result is in v_(i-1), which corresponds to v_0
    return v_0;
}