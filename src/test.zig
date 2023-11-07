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
// [x] Pop
// [X] PopBack
// [X] PopFront
// [X] Push
// [X] PushBack
// [X] PushFront
// [X] Reserve/Size
// [X] Resize
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

test "Dynamic Array PopBack" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);

    const value = try dynamicArray.popBack();
    try testing.expect(value == 2);
}

test "Dynamic Array PopFront" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);

    const value = try dynamicArray.popFront();
    try testing.expect(value == 1);
}

test "Dynamic Array Push" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(0);
    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(3);

    try dynamicArray.push(10, 1);

    const element = dynamicArray.get(1).?;
    try testing.expect(element == 10);
}

test "Dynamic Array PushBack" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(0);
    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(3);

    const last = dynamicArray.get(3).?;
    try testing.expect(last == 3);
}

test "Dynamic Array PushFront" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(0);
    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(3);

    try dynamicArray.pushFront(10);

    const first = dynamicArray.get(0).?;
    try testing.expect(first == 10);
}

test "Dynamic Array Reserve/Size" {
    const allocator = std.testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(0);
    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(3);

    try dynamicArray.reserve(20);

    try testing.expect(dynamicArray.capacity() == 24);
}

test "Dynamic Array Resize" {
    var allocator = testing.allocator;
    var dynamicArray = DynamicArray(i32){};
    try dynamicArray.init(allocator);
    defer dynamicArray.deinit();

    try dynamicArray.pushBack(0);
    try dynamicArray.pushBack(1);
    try dynamicArray.pushBack(2);
    try dynamicArray.pushBack(3);

    try dynamicArray.resize(2);

    try testing.expect(dynamicArray.size() == 2);
}
