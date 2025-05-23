package com.example.restaurentapp.modules.restaurant_management;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/restaurants")
public class RestaurantController {

    @Autowired
    private RestaurantService restaurantService;

    @GetMapping
    public ResponseEntity<List<RestaurantModel>> getAll() {
        try {
            return ResponseEntity.ok(restaurantService.getAllRestaurants());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<RestaurantModel> getById(@PathVariable String id) {
        try {
            RestaurantModel r = restaurantService.getRestaurantById(id);
            return r != null ? ResponseEntity.ok(r) : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping
    public ResponseEntity<RestaurantModel> create(@RequestBody RestaurantModel restaurant) {
        try {
            RestaurantModel created = restaurantService.createRestaurant(restaurant);
            return created != null ? ResponseEntity.ok(created) : ResponseEntity.badRequest().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<RestaurantModel> update(@PathVariable String id, @RequestBody RestaurantModel restaurant) {
        try {
            RestaurantModel updated = restaurantService.updateRestaurant(id, restaurant);
            return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        try {
            return restaurantService.deleteRestaurant(id)
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/login")
    public ResponseEntity<RestaurantModel> login(@RequestParam String username, @RequestParam String password) {
        try {
            RestaurantModel restaurant = restaurantService.login(username, password);
            if (restaurant != null) {
                return ResponseEntity.ok(restaurant);
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}
