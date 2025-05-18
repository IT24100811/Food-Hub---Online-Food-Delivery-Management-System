package com.example.restaurentapp.modules.food_management;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/food")
public class FoodItemController {

    @Autowired
    private FoodItemService foodItemService;

    @GetMapping
    public ResponseEntity<List<FoodItemModel>> getAll() {
        try {
            return ResponseEntity.ok(foodItemService.getAll());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<FoodItemModel> getById(@PathVariable String id) {
        try {
            FoodItemModel item = foodItemService.getById(id);
            return item != null ? ResponseEntity.ok(item) : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<FoodItemModel>> getByRestaurantId(@PathVariable String restaurantId) {
        try {
            return ResponseEntity.ok(foodItemService.getByRestaurantId(restaurantId));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping
    public ResponseEntity<FoodItemModel> create(@RequestBody FoodItemModel foodItem) {
        try {
            FoodItemModel created = foodItemService.create(foodItem);
            return created != null ? ResponseEntity.ok(created) : ResponseEntity.badRequest().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<FoodItemModel> update(@PathVariable String id, @RequestBody FoodItemModel foodItem) {
        try {
            FoodItemModel updated = foodItemService.update(id, foodItem);
            return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        try {
            return foodItemService.delete(id)
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
    @GetMapping("/food-items/sorted-by-price")
    public ResponseEntity<List<FoodItemModel>> getSortedFoodItems(@RequestParam boolean ascending) {
        List<FoodItemModel> sorted = foodItemService.getSortedByPrice(ascending);
        return ResponseEntity.ok(sorted);
    }
}
