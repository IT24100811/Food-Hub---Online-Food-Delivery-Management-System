package com.example.restaurentapp.modules.user_management;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // Get all users
    @GetMapping
    public List<UserModel> getAllUsers() {
        return userService.getAllUsers();
    }

    // Get a user by ID
    @GetMapping("/{id}")
    public ResponseEntity<UserModel> getUserById(@PathVariable String id) {
        UserModel user = userService.getUserById(id);
        return user != null ? ResponseEntity.ok(user) : ResponseEntity.notFound().build();
    }

    // Create a new user
    @PostMapping
    public ResponseEntity<UserModel> createUser(@RequestBody UserModel user) {
        UserModel createdUser = userService.createUser(user);
        return ResponseEntity.ok(createdUser);
    }

    // Update an existing user
    @PutMapping("/{id}")
    public ResponseEntity<UserModel> updateUser(@PathVariable String id, @RequestBody UserModel user) {
        UserModel updatedUser = userService.updateUser(id, user);
        return updatedUser != null ? ResponseEntity.ok(updatedUser) : ResponseEntity.notFound().build();
    }

    // Delete a user
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable String id) {
        boolean deleted = userService.deleteUser(id);
        return deleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    // Login endpoint
    @PostMapping("/login")
    public ResponseEntity<UserModel> login(@RequestBody LoginRequest loginRequest) {
        UserModel user = userService.login(loginRequest.getEmail(), loginRequest.getPassword());
        return user != null ? ResponseEntity.ok(user) : ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}



