package com.example.restaurentapp.modules.feedback_management;

import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class FeedbackService {

    private static final String FILE_NAME = "feedbacks.txt";

    FeedbackService(){
        try {
            File file = new File(FILE_NAME);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<FeedbackModel> getAll() {
        try {
            return readFromFile();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public FeedbackModel create(FeedbackModel feedback) {
        try {
            feedback.setId(UUID.randomUUID().toString());
            List<FeedbackModel> list = readFromFile();
            list.add(feedback);
            writeToFile(list);
            return feedback;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public FeedbackModel update(FeedbackModel feedback) {
        try {
            List<FeedbackModel> list = readFromFile();
            int index = -1;
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getId().equals(feedback.getId())) {
                    index = i;
                    break;
                }
            }
            
            if (index != -1) {
                list.set(index, feedback);
                writeToFile(list);
                return feedback;
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean delete(String id) {
        try {
            List<FeedbackModel> list = readFromFile();
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

    // ==== File I/O Helpers ====

    private List<FeedbackModel> readFromFile() throws IOException {
        List<FeedbackModel> list = new ArrayList<>();
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

    private void writeToFile(List<FeedbackModel> list) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (FeedbackModel f : list) {
                bw.write(serialize(f));
                bw.newLine();
            }
        }
    }

    private String serialize(FeedbackModel f) {
        return String.join("|",
                f.getId(),
                f.getName(),
                f.getEmail(),
                f.getPhone(),
                f.getSatisfied(),
                String.valueOf(f.getRating()),
                f.getMessage().replaceAll("\\|", "/") // avoid pipe conflicts
        );
    }

    private FeedbackModel parse(String line) {
        String[] parts = line.split("\\|");
        FeedbackModel f = new FeedbackModel();
        f.setId(parts[0]);
        f.setName(parts[1]);
        f.setEmail(parts[2]);
        f.setPhone(parts[3]);
        f.setSatisfied(parts[4]);
        f.setRating(Integer.parseInt(parts[5]));
        f.setMessage(parts[6]);
        return f;
    }
}
