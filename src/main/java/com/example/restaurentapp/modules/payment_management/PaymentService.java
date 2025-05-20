package com.example.restaurentapp.modules.payment_management;

import org.springframework.stereotype.Service;

import java.io.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class PaymentService {

    private static final String FILE_NAME = "payments.txt";

    PaymentService(){
        try {
            File file = new File(FILE_NAME);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Get all payments
    public List<PaymentModel> getAll() {
        try {
            return readFromFile();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Create a new payment
    public PaymentModel create(PaymentModel payment) {
        try {
            payment.setId(UUID.randomUUID().toString());
            payment.setPaymentDate(LocalDateTime.now()); // Set the payment date to current time
            List<PaymentModel> list = readFromFile();
            list.add(payment);
            writeToFile(list);
            return payment;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Update payment status
    public boolean updateStatus(String id, String newStatus) {
        try {
            List<PaymentModel> list = readFromFile();
            for (PaymentModel payment : list) {
                if (payment.getId().equals(id)) {
                    payment.setPaymentStatus(newStatus); // Update the status
                    writeToFile(list); // Save changes to the file
                    return true;
                }
            }
            return false; // Payment not found
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete payment
    public boolean delete(String id) {
        try {
            List<PaymentModel> list = readFromFile();
            boolean removed = list.removeIf(payment -> payment.getId().equals(id));
            if (removed) {
                writeToFile(list);
            }
            return removed;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==== File I/O Helpers ====

    private List<PaymentModel> readFromFile() throws IOException {
        List<PaymentModel> list = new ArrayList<>();
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

    private void writeToFile(List<PaymentModel> list) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (PaymentModel p : list) {
                bw.write(serialize(p));
                bw.newLine();
            }
        }
    }

    private String serialize(PaymentModel p) {
        return String.join("|",
                p.getId(),
                p.getUserId(),
                p.getOrderId(),
                p.getPaymentMethod(),
                p.getTransactionId(),
                p.getPaymentStatus(),
                p.getPaymentDate().toString(),
                String.valueOf(p.getTotalAmount())
        );
    }

    private PaymentModel parse(String line) {
        String[] parts = line.split("\\|");
        PaymentModel p = new PaymentModel();
        p.setId(parts[0]);
        p.setUserId(parts[1]);
        p.setOrderId(parts[2]);
        p.setPaymentMethod(parts[3]);
        p.setTransactionId(parts[4]);
        p.setPaymentStatus(parts[5]);
        p.setPaymentDate(LocalDateTime.parse(parts[6]));
        p.setTotalAmount(Double.parseDouble(parts[7]));
        return p;
    }
}
