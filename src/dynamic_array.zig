const std = @import("std");

const Allocator = std.mem.Allocator;

pub fn DynamicArray(comptime T: type) type {
    return struct {
        const Self = @This();
        /// This field is for internal use of DynamicArray only
        _data: []T = undefined,
        /// This field is for internal use of DynamicArray only
        _size: usize = 1,
        /// This field is for internal use of DynamicArray only
        _limit: usize = undefined,
        /// This field is for internal use of DynamicArray only
        _allocator: Allocator = undefined,

        pub fn init(self: *Self, allocator: Allocator) !void {
            self._size = 0;
            self._allocator = allocator;
            const initialSize: usize = 1;
            self._limit = initialSize;
            self._data = try self._allocator.alloc(T, initialSize);
            errdefer self._allocator.free(self._data);
        }

        pub fn deinit(self: *Self) !void {
            self._data = self._allocator.free(self._data);
        }

        pub fn set(self: *Self, element: T, index: usize) !void {
            if (self._limit == index) {
                try self.pushBack(element);
            } else {
                self._data[index] = element;
            }
        }

        pub fn push(self: *Self, element: T, index: usize) !void {
            if (index < self._size) {
                const values = self._data[index..self._size];
                var values_copy = try self._allocator.dupe(T, values);
                self.erase(values_copy.len);
                try self.pushBack(element);
                for (values_copy) |value| {
                    try self.pushBack(value);
                }
            } else if (index == self._size) {
                try self.pushBack(element);
            } else {
                return error.BadInput;
            }
        }

        pub fn pushFront(self: *Self, element: T) !void {
            try self.push(element, 0);
        }

        pub fn pushBack(self: *Self, element: T) !void {
            if (self._size == self._limit) {
                self._limit *= 2;
                self._data = try self._allocator.realloc(self._data, self._limit);
            }
            self._data[self._size] = element;
            self._size += 1;
        }

        pub fn size(self: *Self) usize {
            return self._size;
        }

        pub fn pop(self: *Self) T {
            const last = self._data[self._size];
            self._size -= 1;
            return last;
        }

        pub fn erase(self: *Self, amount: usize) void {
            self._size -= amount;
        }

        pub fn get(self: *Self, index: usize) ?T {
            if (index <= self._size) {
                return self._data[index];
            }
            return null;
        }
    };
}
