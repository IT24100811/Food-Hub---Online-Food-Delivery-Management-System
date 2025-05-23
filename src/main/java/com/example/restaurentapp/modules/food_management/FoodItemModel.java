package com.example.restaurentapp.modules.food_management;

import com.example.restaurentapp.modules.common.BaseEntity;

public class FoodItemModel extends BaseEntity {

    private String name;
    private double price;
    private String category;      // e.g., Main Course, Dessert, Beverage
    private String cuisine;
    private String description;
    private String restaurantId;  // Foreign key reference

    public FoodItemModel() {}

    public FoodItemModel(String name, double price, String category, String cuisine, String description, String restaurantId) {
        super();
        this.name = name;
        this.price = price;
        this.category = category;
        this.cuisine = cuisine;
        this.description = description;
        this.restaurantId = restaurantId;
    }

    public String getName() {

        return name;
    }

    public void setName(String name) {

        this.name = name;
    }

    public double getPrice() {

        return price;
    }

    public void setPrice(double price) {

        this.price = price;
    }

    public String getCategory() {

        return category;
    }

    public void setCategory(String category) {

        this.category = category;
    }

    public String getCuisine() {

        return cuisine;
    }

    public void setCuisine(String cuisine) {

        this.cuisine = cuisine;
    }

    public String getDescription() {

        return description;
    }

    public void setDescription(String description) {

        this.description = description;
    }

    public String getRestaurantId() {

        return restaurantId;
    }

    public void setRestaurantId(String restaurantId) {

        this.restaurantId = restaurantId;
    }

    @Override
    public String toString() {
        return "FoodItemModel{" +
                "id='" + getId() + '\'' +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", category='" + category + '\'' +
                ", cuisine='" + cuisine + '\'' +
                ", description='" + description + '\'' +
                ", restaurantId='" + restaurantId + '\'' +
                '}';
    }
}
