package com.example.restaurentapp.modules.user_management;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user-views")
public class UserViews {

    @Autowired
    UserService userService;

    @GetMapping("/list")
    public String list() {
        return "user/list";
    }

    @GetMapping("/login")
    public String login() {
        return "user/login";
    }

    @GetMapping("/register")
    public String register() {
        return "user/register";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable String id) {
        return "user/edit";
    }

    @GetMapping("/create")
    public String create() {
        return "user/create";
    }

    @GetMapping("/profile/{id}")
    public String profile(@PathVariable String id, Model model) {
        model.addAttribute("user",userService.getUserById(id));
        return "user/profile";
    }
}