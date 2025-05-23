package com.example.restaurentapp.modules.food_management;

import com.example.restaurentapp.utils.SortUtils;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class FoodItemService {

    private static final String FILE_NAME = "food_items.txt";

    FoodItemService(){
        try {
            File file = new File(FILE_NAME);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<FoodItemModel> getAll() {
        try {
            return readFromFile();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public FoodItemModel getById(String id) {
        try {
            return readFromFile().stream()
                    .filter(f -> f.getId().equals(id))
                    .findFirst()
                    .orElse(null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<FoodItemModel> getByRestaurantId(String restaurantId) {
        try {
            List<FoodItemModel> all = readFromFile();
            List<FoodItemModel> filtered = new ArrayList<>();
            for (FoodItemModel item : all) {
                if (item.getRestaurantId().equals(restaurantId)) {
                    filtered.add(item);
                }
            }
            return filtered;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public FoodItemModel create(FoodItemModel item) {
        try {
            item.setId(UUID.randomUUID().toString());
            List<FoodItemModel> list = readFromFile();
            list.add(item);
            writeToFile(list);
            return item;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public FoodItemModel update(String id, FoodItemModel updated) {
        try {
            List<FoodItemModel> list = readFromFile();
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getId().equals(id)) {
                    updated.setId(id);
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

    public boolean delete(String id) {
        try {
            List<FoodItemModel> list = readFromFile();
            boolean removed = list.removeIf(f -> f.getId().equals(id));
            if (removed) {
                writeToFile(list);
            }
            return removed;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // === File Helpers ===

    private List<FoodItemModel> readFromFile() throws IOException {
        List<FoodItemModel> list = new ArrayList<>();
        File file = new File(FILE_NAME);
        if (!file.exists()) file.createNewFile();

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                list.add(parse(line));
            }
        }
        return list;
    }

    private void writeToFile(List<FoodItemModel> list) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (FoodItemModel item : list) {
                bw.write(serialize(item));
                bw.newLine();
            }
        }
    }

    private String serialize(FoodItemModel f) {
        return String.join("|",
                f.getId(),
                f.getName(),
                String.valueOf(f.getPrice()),
                f.getCategory(),
                f.getCuisine(),
                f.getDescription(),
                f.getRestaurantId()
        );
    }

    private FoodItemModel parse(String line) {
        String[] parts = line.split("\\|");
        FoodItemModel f = new FoodItemModel();
        f.setId(parts[0]);
        f.setName(parts[1]);
        f.setPrice(Double.parseDouble(parts[2]));
        f.setCategory(parts[3]);
        f.setCuisine(parts[4]);
        f.setDescription(parts[5]);
        f.setRestaurantId(parts[6]);
        return f;
    }
    public List<FoodItemModel> getSortedByPrice(boolean ascending) {
        try {
            List<FoodItemModel> list = readFromFile();
            SortUtils.quickSortByPrice(list, 0, list.size() - 1, ascending);
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
