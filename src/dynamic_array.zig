const std = @import("std");

const Allocator = std.mem.Allocator;

/// [Dynamic Array] or [Vector] Struct. Is an array whose size can change at runtime, allows for insertions, removals and other related operations.
/// It's default growth is geometric (b * 2^n)
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

        /// Initializes allocator, acompany with `defer DynamicArray(T).deinit()`
        pub fn init(self: *Self, allocator: Allocator) !void {
            self._size = 0;
            self._allocator = allocator;
            const initialSize: usize = 1;
            self._limit = initialSize;
            self._data = try self._allocator.alloc(T, initialSize);
            errdefer self._allocator.free(self._data);
        }

        /// Frees vector data
        pub fn deinit(self: *Self) void {
            self._allocator.free(self._data);
        }

        /// Pushes data at index
        pub fn push(self: *Self, element: T, index: usize) !void {
            if (index < self._size) {
                const values = self._data[index..self._size];
                var values_copy = try self._allocator.dupe(T, values);
                defer self._allocator.free(values_copy);
                self.eraseBack(values_copy.len);
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

        /// Pushes at the start of the vector
        pub fn pushFront(self: *Self, element: T) !void {
            try self.push(element, 0);
        }

        /// Pushes at the end of the vector
        pub fn pushBack(self: *Self, element: T) !void {
            if (self._size == self._limit) {
                const newSize = self._data.len * 2;
                self._data = try self._allocator.realloc(self._data, newSize);
                self._limit = newSize;
            }
            self._data[self._size] = element;
            self._size += 1;
        }

        /// Removes and returns element at index
        pub fn pop(self: *Self, index: usize) !T {
            if (index == self._size - 1) {
                const returned = self._data[self._size - 1];
                self._size -= 1;
                return returned;
            } else if (index < self._size - 1) {
                const slice = self._data[index + 1 .. self._size];
                const values = try self._allocator.dupe(T, slice);
                const returned = try self._allocator.dupe(T, self._data[index .. index + 1]);
                defer self._allocator.free(values);
                defer self._allocator.free(returned);
                self.eraseBack(values.len + 1);
                for (values) |value| {
                    try self.pushBack(value);
                }
                return returned[0];
            } else {
                return error.BadInput;
            }
        }

        /// Removes and returns last element
        pub fn popBack(self: *Self) !T {
            const returned = try self.pop(self._size - 1);
            return returned;
        }

        /// Removes and returns first element
        pub fn popFront(self: *Self) !T {
            const returned = try self.pop(0);
            return returned;
        }

        /// Removes element at index
        pub fn delete(self: *Self, index: usize) !void {
            _ = try self.pop(index);
        }

        /// Removes N elements from the back
        pub fn eraseBack(self: *Self, amount: usize) void {
            if (amount <= self._size) {
                self._size -= amount;
            } else {
                self._size = 0;
            }
        }

        /// Removes N elements from the front
        pub fn eraseFront(self: *Self, amount: usize) !void {
            var i: u32 = 0;
            while (i < amount) {
                try self.delete(0);
                i += 1;
            }
        }

        /// Resizes vector to be of size N exactly, shrinking or growing if necessary
        pub fn resize(self: *Self, _size: usize) !void {
            self._data = try self._allocator.realloc(self._data, _size);
            self._limit = _size;
            if (self._size > _size) {
                self._size = _size;
            }
        }

        /// Reserves N extra spaces exactly
        pub fn reserve(self: *Self, _size: usize) !void {
            const newLimit = self._limit + _size;
            if (self._limit < newLimit) {
                self._data = try self._allocator.realloc(self._data, newLimit);
                self._limit = newLimit;
            }
        }

        /// Reserves N extra spaces geometrically
        pub fn expand(self: *Self, _size: usize) !void {
            var togo = _size;
            var newLimit = self._limit;

            while (togo > 0) {
                if (newLimit - self._size >= togo) {
                    togo = 0;
                } else {
                    togo -= newLimit;
                    newLimit *= 2;
                }
            }

            const resized = self._allocator.resize(self._data, self._limit);
            if (!resized) {
                return error.FailedResize;
            }
            self._limit = newLimit;
        }

        /// Returns the size of the vector
        pub fn size(self: *Self) usize {
            return self._size;
        }

        /// Returns the current capacity of the vector
        pub fn capacity(self: *Self) usize {
            return self._limit;
        }

        /// Gets element at index N
        pub fn get(self: *Self, index: usize) ?T {
            if (index < self._size) {
                return self._data[index];
            }
            return null;
        }

        /// Replaces the data at index with the provided data
        pub fn set(self: *Self, element: T, index: usize) !void {
            if (self._limit == index) {
                try self.pushBack(element);
            } else {
                self._data[index] = element;
            }
        }
    };
}
