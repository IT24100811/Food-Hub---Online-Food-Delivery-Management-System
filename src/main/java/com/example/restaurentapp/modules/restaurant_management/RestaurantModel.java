package com.example.restaurentapp.modules.restaurant_management;

import com.example.restaurentapp.modules.common.BaseEntity;

/**
 * RestaurantModel class encapsulating restaurant properties
 */
public class RestaurantModel extends BaseEntity {

    private String name;
    private String cuisine;
    private String location;
    private String type; // "Veg" or "Non-Veg"
    private String username;
    private String password;

    public RestaurantModel() {
        // Default constructor
    }

    public RestaurantModel(String name, String cuisine, String location, String type, String username, String password) {
        this.name = name;
        this.cuisine = cuisine;
        this.location = location;
        this.type = type;
        this.username = username;
        this.password = password;
    }

    // Getters and Setters

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCuisine() {
        return cuisine;
    }

    public void setCuisine(String cuisine) {
        this.cuisine = cuisine;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    // Optional helper method
    public boolean isVegRestaurant() {
        return "Veg".equalsIgnoreCase(this.type);
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "RestaurantModel{" +
                "id='" + getId() + '\'' +
                ", name='" + name + '\'' +
                ", cuisine='" + cuisine + '\'' +
                ", location='" + location + '\'' +
                ", type='" + type + '\'' +
                ", username='" + username + '\'' +
                '}';
    }
}
