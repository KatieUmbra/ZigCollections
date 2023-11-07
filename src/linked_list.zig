const std = @import("std");

const Allocator = std.mem.Allocator;

fn LinkedNode(comptime T: type) type {
    return struct {
        const Self = @This();
        _prev: ?*T,
        _next: ?*T,
        _data: *T,
        _allocator: *Allocator,
        pub fn init(self: *Self, allocator: *Allocator, data: T) void {
            self.allocator = allocator;
            self._data = self._allocator.create(T);
            self._data.* = data;
        }
        pub fn deinit(self: *Self) void {
            self._allocator.destroy(self._data);
        }
    };
}

fn _freeNode(node: *LinkedNode) void {
    node.deinit();
}

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
        const NodeType = LinkedNode(T);
        _allocator: Allocator = undefined,
        _first: *NodeType = undefined,
        _last: *NodeType = undefined,
        pub fn init(self: *Self, allocator: Allocator) void {
            self._allocator = allocator;
            self._first = null;
        }
        pub fn deinit(self: *Self) void {
            self.forEach(_freeNode);
        }
        pub fn push(self: *Self, data: T, index: usize) void {
            _ = index;
            _ = data;
            _ = self;
        }
        pub fn set(self: *Self, data: T, index: usize) void {
            const element = self._get_ptr(index);
            if (element) |it| {
                it._data = data;
            }
        }
        pub fn get(self: *Self, index: usize) ?T {
            const returned = self._get_ptr(index);
            if (returned) |data| {
                return data._data;
            } else {
                return null;
            }
        }
        fn _get_ptr(self: *Self, index: usize) ?*T {
            var i: i32 = 0;
            var returned = self._first;
            while (i < index) {
                if (returned) |value| {
                    returned = value._next;
                } else {
                    return null;
                }
                i += 1;
            }
            return returned;
        }
        pub fn forEach(func: fn (*LinkedNode) void) void {
            _ = func;
        }
    };
}
