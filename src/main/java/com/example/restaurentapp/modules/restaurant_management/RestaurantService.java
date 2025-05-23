package com.example.restaurentapp.modules.restaurant_management;

import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class RestaurantService {

    private static final String FILE_NAME = "restaurants.txt";

    RestaurantService(){
        try {
            File file = new File(FILE_NAME);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Get all restaurants
    public List<RestaurantModel> getAllRestaurants() {
        return readFromFile();
    }

    // Get restaurant by ID
    public RestaurantModel getRestaurantById(String id) {
        try {
            return readFromFile().stream()
                    .filter(r -> r.getId().equals(id))
                    .findFirst()
                    .orElse(null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Create restaurant
    public RestaurantModel createRestaurant(RestaurantModel restaurant) {
        try {
            restaurant.setId(UUID.randomUUID().toString());
            List<RestaurantModel> list = readFromFile();
            list.add(restaurant);
            writeToFile(list);
            return restaurant;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Update restaurant
    public RestaurantModel updateRestaurant(String id, RestaurantModel updated) {
        try {
            List<RestaurantModel> list = readFromFile();
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getId().equals(id)) {
                    updated.setId(id); // keep the same ID
                    list.set(i, updated);
                    writeToFile(list);
                    return updated;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Delete restaurant
    public boolean deleteRestaurant(String id) {
        try {
            List<RestaurantModel> list = readFromFile();
            boolean removed = list.removeIf(r -> r.getId().equals(id));
            if (removed) {
                writeToFile(list);
            }
            return removed;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==== Helpers ====

    private List<RestaurantModel> readFromFile() {
        List<RestaurantModel> list = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_NAME))) {
            String line;
            while ((line = br.readLine()) != null) {
                try {
                    list.add(parse(line));
                } catch (Exception ex) {
                    System.err.println("Failed to parse line: " + line);
                    ex.printStackTrace();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    private void writeToFile(List<RestaurantModel> list) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (RestaurantModel r : list) {
                try {
                    bw.write(serialize(r));
                    bw.newLine();
                } catch (Exception ex) {
                    System.err.println("Failed to write restaurant: " + r.getId());
                    ex.printStackTrace();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public RestaurantModel login(String username, String password) {
        try {
            return readFromFile().stream()
                    .filter(r -> r.getUsername().equals(username) && r.getPassword().equals(password))
                    .findFirst()
                    .orElse(null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String serialize(RestaurantModel r) {
        try {
            return String.join("|",
                    r.getId(),
                    r.getName(),
                    r.getCuisine(),
                    r.getLocation(),
                    r.getType(),
                    r.getUsername(),
                    r.getPassword()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private RestaurantModel parse(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 7) throw new IllegalArgumentException("Incomplete data: " + line);

        RestaurantModel r = new RestaurantModel();
        r.setId(parts[0]);
        r.setName(parts[1]);
        r.setCuisine(parts[2]);
        r.setLocation(parts[3]);
        r.setType(parts[4]);
        r.setUsername(parts[5]);
        r.setPassword(parts[6]);
        return r;
    }
}
