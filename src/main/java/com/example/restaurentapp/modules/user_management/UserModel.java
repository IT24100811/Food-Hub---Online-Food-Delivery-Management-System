package com.example.restaurentapp.modules.user_management;

import java.io.Serializable;

/**
 * Base UserModel class representing common user attributes
 * and behaviors in the restaurant application
 */
public class UserModel implements Serializable {

    // Constants for user roles
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_CUSTOMER = "CUSTOMER";
    public static final String ROLE_STAFF = "STAFF";

    // Constants for account status
    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_INACTIVE = "INACTIVE";

    // Private fields with encapsulation
    private String id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String password;
    private String role;
    private String address;
    private String profilePicture; // Optional - path to the image file
    private String accountStatus;

    // Default constructor
    public UserModel() {
        this.accountStatus = STATUS_ACTIVE;
    }

    // Parameterized constructor
    public UserModel(String fullName, String email, String phoneNumber,
                     String password, String role, String address) {
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.role = role;
        this.address = address;
        this.accountStatus = STATUS_ACTIVE;
    }

    // Getters and setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public String getAccountStatus() {
        return accountStatus;
    }

    public void setAccountStatus(String accountStatus) {
        this.accountStatus = accountStatus;
    }

    // Helper methods for account status
    public boolean isActive() {
        return STATUS_ACTIVE.equals(this.accountStatus);
    }

    public void activate() {
        this.accountStatus = STATUS_ACTIVE;
    }

    public void deactivate() {
        this.accountStatus = STATUS_INACTIVE;
    }

    @Override
    public String toString() {
        return "UserModel{" +
                "id='" + id + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", role='" + role + '\'' +
                ", address='" + address + '\'' +
                ", accountStatus='" + accountStatus + '\'' +
                '}';
    }
}
