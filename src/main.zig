const std = @import("std");
const hashMap = @import("hash_map.zig");
const testing = std.testing;
const DynamicArray = @import("dynamic_array.zig").DynamicArray;

test "dynamic array pushing" {
    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();
    var myVector = DynamicArray(i32){};
    try myVector.init(allocator.allocator());
    try myVector.pushBack(16);
    try myVector.pushBack(15);
    try myVector.pushBack(14);
    try myVector.pushBack(1);
    try myVector.pushBack(15);
    try myVector.pushBack(10);

    try testing.expect(myVector.size() == @as(usize, 6));
}

test "dynamic array insert" {
    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();
    var myVector = DynamicArray(i32){};
    try myVector.init(allocator.allocator());
    try myVector.pushBack(20);
    try myVector.pushBack(21);
    try myVector.pushFront(1);
    std.debug.print("\n", .{});
    var i: u32 = 0;
    while (i < myVector.size()) {
        const element: i16 = @truncate(myVector.get(i).?);
        std.log.warn("element: {any}\n", .{element});
        i += 1;
    }
    std.debug.print("\n", .{});
    if (myVector.get(2)) |value| {
        const size: u16 = @truncate(myVector.size());
        const val: i16 = @truncate(value);
        std.log.warn("value: {any}\n", .{val});
        std.log.warn("size: {any}\n", .{size});
        try testing.expect(value == 21);
    }
}

test "dynamic array getting" {
    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();
    var myVector = DynamicArray(i32){};
    try myVector.init(allocator.allocator());
    try myVector.pushBack(16);
    try myVector.pushBack(15);
    try myVector.pushBack(14);
    try myVector.pushBack(1);
    try myVector.pushBack(15);
    try myVector.pushBack(10);

    const result = myVector.get(3);
    if (result) |value| {
        try testing.expect(value == 1);
    }
}
