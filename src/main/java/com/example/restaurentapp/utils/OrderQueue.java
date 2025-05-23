package com.example.restaurentapp.utils;

import com.example.restaurentapp.modules.order_management.OrderModel;
import java.util.ArrayList;
import java.util.List;

public class OrderQueue {
    private List<OrderModel> queue;

    public OrderQueue() {
        queue = new ArrayList<>();
    }

    public void enqueue(OrderModel order) {
        queue.add(order);
    }

    public OrderModel dequeue() {
        if (isEmpty()) return null;
        return queue.remove(0);
    }

    public boolean isEmpty() {
        return queue.isEmpty();
    }

    public int size() {
        return queue.size();
    }

    public List<OrderModel> getAllOrders() {
        return new ArrayList<>(queue); // Return copy to prevent external modification
    }
}