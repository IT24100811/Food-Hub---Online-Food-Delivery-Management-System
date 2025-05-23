package com.example.restaurentapp.utils;

import com.example.restaurentapp.modules.order_management.OrderModel;

import java.util.Comparator;
import java.util.List;

public class OrderSorter {

    // Sort by total amount descending
    public static void sortByAmountDescending(List<OrderModel> orders) {
        orders.sort(Comparator.comparingDouble(OrderModel::getTotalAmount).reversed());
    }

    // Sort by date ascending (assumes ISO format like "2025-04-05T14:30")
    public static void sortByDateAscending(List<OrderModel> orders) {
        orders.sort(Comparator.comparing(OrderModel::getOrderDateTime));
    }
}