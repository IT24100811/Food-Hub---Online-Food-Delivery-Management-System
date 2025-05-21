package com.example.restaurentapp.modules.order_management;

import com.example.restaurentapp.utils.OrderQueue;
import com.example.restaurentapp.utils.OrderSorter;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class OrderService {

    private static final String FILE_NAME = "orders.txt";

    OrderService(){
        try {
            File file = new File(FILE_NAME);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<OrderModel> getAll() {
        try {
            return readFromFile();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public OrderModel create(OrderModel order) {
        try {
            order.setId(UUID.randomUUID().toString());
            List<OrderModel> list = readFromFile();
            list.add(order);
            writeToFile(list);
            return order;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean delete(String id) {
        try {
            List<OrderModel> list = readFromFile();
            boolean removed = list.removeIf(o -> o.getId().equals(id));
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

    private List<OrderModel> readFromFile() throws IOException {
        List<OrderModel> list = new ArrayList<>();
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

    private void writeToFile(List<OrderModel> list) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (OrderModel o : list) {
                bw.write(serialize(o));
                bw.newLine();
            }
        }
    }

    private String serialize(OrderModel o) {
        String foodItems = String.join(",", o.getFoodItems());
        String quantities = String.join(",", o.getQuantities().stream().map(String::valueOf).toArray(String[]::new));

        return String.join("|",
                o.getId(),
                o.getUserId(),
                foodItems,
                quantities,
                o.getDeliveryAddress(),
                o.getOrderStatus(),
                o.getOrderDateTime(),
                o.getEstimatedDeliveryTime(),
                o.getSpecialInstructions().replaceAll("\\|", "/"), // avoid pipe conflicts
                String.valueOf(o.getTotalAmount() != null ? o.getTotalAmount() : 0.0)
        );
    }

    private OrderModel parse(String line) {
        String[] parts = line.split("\\|");
        OrderModel o = new OrderModel();
        o.setId(parts[0]);
        o.setUserId(parts[1]);
        o.setFoodItems(List.of(parts[2].split(",")));
        o.setQuantities(List.of(parts[3].split(",")).stream().map(Integer::parseInt).toList());
        o.setDeliveryAddress(parts[4]);
        o.setOrderStatus(parts[5]);
        o.setOrderDateTime(parts[6]);
        o.setEstimatedDeliveryTime(parts[7]);
        o.setSpecialInstructions(parts[8]);
        o.setTotalAmount(parts.length > 9 ? Double.parseDouble(parts[9]) : 0.0);
        return o;
    }

    public boolean updateStatus(String id, String newStatus) {
        try {
            List<OrderModel> list = readFromFile();
            for (OrderModel order : list) {
                if (order.getId().equals(id)) {
                    order.setOrderStatus(newStatus); // Update the status
                    writeToFile(list); // Save changes to the file
                    return true;
                }
            }
            return false; // Order not found
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public OrderModel getById(String id) {
        try {
            return readFromFile().stream()
                    .filter(order -> order.getId().equals(id))
                    .findFirst()
                    .orElse(null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<OrderModel> getOrdersInProcessingQueue() {
        try {
            List<OrderModel> orders = readFromFile();

            // Filter only processing orders (e.g., status is "Pending" or "Preparing")
            List<OrderModel> processingOrders = orders.stream()
                    .filter(o -> o.getOrderStatus().equals("Pending") || o.getOrderStatus().equals("Preparing"))
                    .toList();

            // Sort them by amount (high first)
            OrderSorter.sortByAmountDescending(processingOrders);

            // Add sorted orders into queue
            OrderQueue queue = new OrderQueue();
            for (OrderModel order : processingOrders) {
                queue.enqueue(order);
            }

            return queue.getAllOrders(); // Return ordered list from queue
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
