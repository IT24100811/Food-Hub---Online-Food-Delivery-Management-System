package com.example.restaurentapp.modules.order_management;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping
    public ResponseEntity<List<OrderModel>> getAll() {
        try {
            return ResponseEntity.ok(orderService.getAll());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping
    public ResponseEntity<OrderModel> create(@RequestBody OrderModel order) {
        try {
            OrderModel created = orderService.create(order);
            return created != null ? ResponseEntity.ok(created) : ResponseEntity.badRequest().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<OrderModel> getById(@PathVariable String id) {
        try {
            OrderModel order = orderService.getById(id);
            return order != null ? ResponseEntity.ok(order) : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        try {
            return orderService.delete(id)
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
    @PutMapping("/{id}/status")
    public ResponseEntity<Void> updateStatus(@PathVariable String id, @RequestParam String status) {
        try {
            boolean updated = orderService.updateStatus(id, status);
            if (updated) {
                return ResponseEntity.noContent().build(); // Status updated successfully
            } else {
                return ResponseEntity.notFound().build(); // Order not found
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build(); // Error updating status
        }
    }

}
