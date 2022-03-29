const std = @import("std");

pub fn main() anyerror!void {
    // Initialize the allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Get standard output handle
    var std_out = std.io.getStdOut().writer();

    var args_it = try std.process.argsWithAllocator(allocator);
    defer args_it.deinit();
    _ = args_it.next() orelse unreachable; // executable name
    const arg_a = args_it.next() orelse return error.MissingArgumentA;
    const arg_b = args_it.next() orelse return error.MissingArgumentB;

    const a = try std.fmt.parseInt(i128, arg_a, 10);
    const b = try std.fmt.parseInt(i128, arg_b, 10);

    var g_0 = b;
    var g_1 = a;
    var u_0: i128 = 1;
    var u_1: i128 = 0;
    var v_0: i128 = 0;
    var v_1: i128 = 1;

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

    if (v_0 < 0) {
        v_0 = v_0 + b;
    }

    std_out.print("{}\n", .{v_0}) catch unreachable;
}

// Hacer (g0, g1, u0, u1, v0, v1, i)
//     = (B, A, 1, 0, 0, 1, 1)
//
// Mientras g1 != 0 hacer:
//     Hacer y_i+1 = parte entera (g_i-1/g_i)
//     Hacer g_i+1 = g_i-1 - y_i+1 * g_i
//     Hacer u_i+1 = u_i-1 - y_i+1 * u_i
//     Hacer v_i+1 = v_i-1 - y_i+1 * v_i
//     Hacer i     = i+1
//
// Si (v_i-1 < 0)
//     Hacer v_i-1 = v_i-1 + B
//
// Hacer x = v_i-1