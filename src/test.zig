const std = @import("std");
const testing = std.testing;

const collections = @import("zig_collections.zig");
const DynamicArray = collections.DynamicArray;

// ==========================================
//              Dynamic Array
// ==========================================
// [X] Expand/Capacity
// [X] Delete
// [X] Erase Back/Front
// [X] Set/Get
// [ ] Pop
// [ ] PopBack
// [ ] PopFront
// [ ] Push
// [ ] PushBack
// [ ] PushFront
// [ ] Reserve/Size
// ==========================================

test "Dynamic Array Expand/Capacity" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.expand(20);

    const finalLimit = dynamicArray.capacity();
    try testing.expect(finalLimit == @as(usize, 16));
}

test "Dynamic Array Delete" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(3);

    try dynamicArray.delete(1);

    const lastElement = try dynamicArray.popBack();
    try testing.expect(lastElement == 3);
}

test "Dynamic Array Erase Back/Front" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);

    try dynamicArray.eraseFront(1);
    dynamicArray.eraseBack(1);

    const finalSize = dynamicArray.size();
    try testing.expect(finalSize == 0);
}

test "Dynamic Array Set/Get" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(1);
    try dynamicArray.set(2, 0);

    const result = dynamicArray.get(0);
    if (result) |value| {
        try testing.expect(value == 2);
    }
}

test "Dynamic Array Pop" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(2);

    const value = try dynamicArray.pop(3);
    try testing.expect(value == 2);
}
