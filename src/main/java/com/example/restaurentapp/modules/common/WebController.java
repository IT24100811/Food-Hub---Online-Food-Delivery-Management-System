package com.example.restaurentapp.modules.common;


import com.example.restaurentapp.modules.food_management.FoodItemService;
import com.example.restaurentapp.modules.order_management.OrderService;
import com.example.restaurentapp.modules.restaurant_management.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class WebController {
    @Autowired
    private  FoodItemService foodItemService;
    @Autowired
    private   RestaurantService restaurantService;
    @Autowired OrderService orderService;
    @GetMapping
    public  String index(Model model){
        model.addAttribute("foodItems",foodItemService.getAll());
        model.addAttribute("restaurants",restaurantService.getAllRestaurants());
        return  "index";
    }

    @GetMapping("/admin")
    public  String admin(){
        return "admin";
    }


    @GetMapping("/cart")
    public  String cart(){
        return "common/cart";
    }

    @GetMapping("/place-order")
    public  String placeOrder(){
        return "order/create";
    }

    @GetMapping("/my-orders")
    public  String myOrders(){
        return "order/my_orders ";
    }

    @GetMapping("/place-order/{id}")
    public String createPayment(@PathVariable String id, Model model) {
        model.addAttribute("order", orderService.getById(id));
        return "payment/create";
    }
}
