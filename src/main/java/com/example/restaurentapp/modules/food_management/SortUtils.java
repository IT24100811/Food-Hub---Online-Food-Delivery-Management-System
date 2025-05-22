package com.example.restaurentapp.utils;

import com.example.restaurentapp.modules.food_management.FoodItemModel;

import java.util.List;

public class SortUtils {

    // QuickSort implementation for sorting FoodItemModel by price
    public static void quickSortByPrice(List<FoodItemModel> list, int low, int high, boolean ascending) {
        if (low < high) {
            int pi = partition(list, low, high, ascending);
            quickSortByPrice(list, low, pi - 1, ascending);
            quickSortByPrice(list, pi + 1, high, ascending);
        }
    }

    private static int partition(List<FoodItemModel> list, int low, int high, boolean ascending) {
        double pivot = list.get(high).getPrice();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            double currentPrice = list.get(j).getPrice();
            boolean condition = ascending ? currentPrice <= pivot : currentPrice >= pivot;
            if (condition) {
                i++;
                swap(list, i, j);
            }
        }
        swap(list, i + 1, high);
        return i + 1;
    }

    private static void swap(List<FoodItemModel> list, int i, int j) {
        FoodItemModel temp = list.get(i);
        list.set(i, list.get(j));
        list.set(j, temp);
    }
}