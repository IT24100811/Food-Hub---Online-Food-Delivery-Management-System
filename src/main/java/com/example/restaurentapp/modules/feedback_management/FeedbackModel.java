package com.example.restaurentapp.modules.feedback_management;
import com.example.restaurentapp.modules.common.BaseEntity;

public class FeedbackModel extends BaseEntity {
    private String name;
    private String email;
    private String phone;
    private String satisfied; // Yes / No
    private int rating;       // Out of 10
    private String message;

    // Getters and Setters
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }
    public String getSatisfied() {
        return satisfied;
    }
    public void setSatisfied(String satisfied) {
        this.satisfied = satisfied;
    }
    public int getRating() {
        return rating;
    }
    public void setRating(int rating) {
        this.rating = rating;
    }
    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }
}
