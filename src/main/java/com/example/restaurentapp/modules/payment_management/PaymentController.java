package com.example.restaurentapp.modules.payment_management;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    // Get all payments
    @GetMapping
    public ResponseEntity<List<PaymentModel>> getAllPayments() {
        try {
            return ResponseEntity.ok(paymentService.getAll());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    // Create a new payment
    @PostMapping
    public ResponseEntity<PaymentModel> createPayment(@RequestBody PaymentModel payment) {
        try {
            PaymentModel createdPayment = paymentService.create(payment);
            return createdPayment != null ? ResponseEntity.ok(createdPayment) : ResponseEntity.badRequest().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    // Update payment status
    @PutMapping("/{id}/status")
    public ResponseEntity<Void> updatePaymentStatus(@PathVariable String id, @RequestParam String status) {
        try {
            boolean updated = paymentService.updateStatus(id, status);
            if (updated) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    // Delete a payment
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePayment(@PathVariable String id) {
        try {
            return paymentService.delete(id)
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.notFound().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}
