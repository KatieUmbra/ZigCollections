const std = @import("std");
const hashMap = @import("hash_map.zig");
const testing = std.testing;
const DynamicArray = @import("dynamic_array.zig").DynamicArray;

test "dynamic array pushing" {
    var allocator = std.testing.allocator;
    var myVector = DynamicArray(i32){};
    try myVector.init(allocator);
    defer myVector.deinit();
    try myVector.pushBack(16);
    try myVector.pushBack(15);
    try myVector.pushBack(14);
    try myVector.pushBack(1);
    try myVector.pushBack(15);
    try myVector.pushBack(10);

    try testing.expect(myVector.size() == @as(usize, 6));
}

test "dynamic array insert" {
    var allocator = std.testing.allocator;
    var myVector = DynamicArray(i32){};
    try myVector.init(allocator);
    defer myVector.deinit();
    try myVector.pushBack(20);
    try myVector.pushBack(21);
    try myVector.pushFront(1);
    if (myVector.get(2)) |value| {
        try testing.expect(value == 21);
    }
}

test "dynamic array popping" {
    var allocator = std.testing.allocator;
    var myVector = DynamicArray(i32){};
    try myVector.init(allocator);
    defer myVector.deinit();
    var i: i32 = 0;
    while (i < 200) {
        try myVector.pushBack(i);
        i += 1;
    }
    _ = try myVector.pop(100);
    try testing.expect(myVector.popLast() == 199);
}

test "dynamic array getting" {
    var allocator = std.testing.allocator;
    var myVector = DynamicArray(i32){};
    try myVector.init(allocator);
    defer myVector.deinit();
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
