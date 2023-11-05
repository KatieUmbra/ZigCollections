const std = @import("std");
const hashMap = @import("hash_map.zig");
const dynamicArray = @import("dynamic_array.zig");
const testing = std.testing;
const DynamicArray = dynamicArray.DynamicArray;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

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

    const result = try myVector.get(3);
    try testing.expect(result == 1);
}
