const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zigmod = b.addStaticLibrary(.{
        .name = "zigmod",
        .root_source_file = .{ .path = "src/zigmod.zig" },
        .target = target,
        .optimize = optimize,
    });
    zigmod.c_std = .C11;
    zigmod.addCSourceFiles(&.{
        "src/pocketmod.c",
    }, &.{
        "-fno-sanitize=shift",
    });
    zigmod.addIncludePath(std.build.LazyPath.relative("src/"));
    zigmod.linkLibC();

    b.installArtifact(zigmod);

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/zigmod.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_main_tests = b.addRunArtifact(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}

// TODO: zig-ify the library
// TODO: zig-igy the examples
// TODO: set this up to be usable as a zig package

// exe.linkSystemLibrary("m");
// exe.linkSystemLibrary("SDL2");
// exe.linkSystemLibrary("SDL2main");
// exe.linkSystemLibrary("SDL2_mixer");
