package com.example.restaurentapp.modules.restaurant_management;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/restaurant-views")
public class RestaurantViews {

@Autowired
RestaurantService restaurantService;
    

    @GetMapping("/manage")
    public  String manage(){
        return  "restaurant/all";
    }

    @GetMapping("/create")
    public  String create(){
        return  "restaurant/create";
    }

    @GetMapping("/edit/{id}")
    public  String edit(@PathVariable String id, Model model){
        return  "restaurant/all";
    }

    @GetMapping("/profile/{id}")
    public  String profile(@PathVariable String id,Model model){
        restaurantService.getRestaurantById(id);
        model.addAttribute("restaurant", restaurantService.getRestaurantById(id));
        return  "restaurant/profile";
    }

    @GetMapping("/login")
    public  String login(){
        return  "restaurant/login";
    }

    @GetMapping("/dashboard")
    public  String dashboard(){
        return  "restaurant/dashboard";
    }

    @GetMapping("/food-items")
    public  String createFoodItems(){
        return  "restaurant/create-items";
    }

    @GetMapping("/orders")
    public  String orders(){
        return  "order/all";
    }

    @GetMapping("/payments")
    public  String payments(){
        return  "payment/list";
    }
}
