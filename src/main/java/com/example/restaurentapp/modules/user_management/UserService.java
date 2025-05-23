package com.example.restaurentapp.modules.user_management;

import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class UserService {

    private static final String DATA_FILE = "users.txt";

    UserService(){
        try {
            File file = new File(DATA_FILE);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Get all users
    public List<UserModel> getAllUsers() {
        return readFromFile();
    }

    // Get user by ID
    public UserModel getUserById(String id) {
        return readFromFile().stream()
                .filter(user -> user.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Create new user
    public UserModel createUser(UserModel user) {
        user.setId(UUID.randomUUID().toString());
        List<UserModel> users = readFromFile();
        users.add(user);
        writeToFile(users);
        return user;
    }

    // Update user
    public UserModel updateUser(String id, UserModel updatedUser) {
        List<UserModel> users = readFromFile();
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId().equals(id)) {
                updatedUser.setId(id); // ensure ID remains the same
                users.set(i, updatedUser);
                writeToFile(users);
                return updatedUser;
            }
        }
        return null;
    }

    // Delete user
    public boolean deleteUser(String id) {
        List<UserModel> users = readFromFile();
        boolean removed = users.removeIf(user -> user.getId().equals(id));
        if (removed) {
            writeToFile(users);
        }
        return removed;
    }

    // ===== Helper methods =====

    private List<UserModel> readFromFile() {
        List<UserModel> users = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(DATA_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                users.add(parseUser(line));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return users;
    }

    private void writeToFile(List<UserModel> users) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(DATA_FILE))) {
            for (UserModel user : users) {
                bw.write(serializeUser(user));
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String serializeUser(UserModel user) {
        // Simple CSV-like format (escaping not handled for simplicity)
        return String.join("|",
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                user.getPhoneNumber(),
                user.getPassword(),
                user.getRole(),
                user.getAddress(),
                user.getProfilePicture() != null ? user.getProfilePicture() : "",
                user.getAccountStatus()
        );
    }

    private UserModel parseUser(String line) {
        String[] parts = line.split("\\|");
        UserModel user = new UserModel();
        user.setId(parts[0]);
        user.setFullName(parts[1]);
        user.setEmail(parts[2]);
        user.setPhoneNumber(parts[3]);
        user.setPassword(parts[4]);
        user.setRole(parts[5]);
        user.setAddress(parts[6]);
        user.setProfilePicture(parts.length > 7 ? parts[7] : null);
        user.setAccountStatus(parts.length > 8 ? parts[8] : UserModel.STATUS_ACTIVE);
        return user;
    }

    // Login user
    public UserModel login(String email, String password) {
        return readFromFile().stream()
                .filter(user -> user.getEmail().equals(email) 
                    && user.getPassword().equals(password)
                    && user.isActive())
                .findFirst()
                .orElse(null);
    }
}
