<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi Restaurant App</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<nav class="bg-gray-800 shadow-lg">
    <div class="max-w-6xl mx-auto px-4">
        <div class="flex justify-between">
            <div class="flex space-x-4">
                <!-- Logo -->
                <div>
                    <a href="${pageContext.request.contextPath}/" class="flex items-center py-5 px-2">
                        <span class="font-bold text-white text-lg">FoodHub</span>
                    </a>
                </div>
            </div>

            <!-- Right section -->
            <div class="hidden md:flex items-center space-x-1" id="navbarRight">
                <!-- Will be populated by JavaScript -->
            </div>

            <!-- Mobile menu button -->
            <div class="md:hidden flex items-center">
                <button class="mobile-menu-button">
                    <i class="fas fa-bars text-white text-xl"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Mobile menu -->
    <div class="mobile-menu hidden md:hidden" id="mobileMenu">
        <!-- Will be populated by JavaScript -->
    </div>
</nav>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const navbarRight = document.getElementById('navbarRight');
        const mobileMenu = document.getElementById('mobileMenu');
        const mobileMenuButton = document.querySelector('.mobile-menu-button');

        // Toggle mobile menu
        mobileMenuButton.addEventListener('click', function() {
            mobileMenu.classList.toggle('hidden');
        });

        // Check if user is logged in
        const userId = localStorage.getItem('userId');

        // Function to create navbar items
        function createNavItems() {
            let desktopHTML = '';
            let mobileHTML = '';

            if (userId) {
                // User is logged in, show cart and
                desktopHTML =
                "<a href=\"" + "${pageContext.request.contextPath}" + "/cart\" class=\"py-5 px-3 text-white hover:text-gray-200\">" +
                "<i class=\"fas fa-shopping-cart\"></i>" +
                "<span class=\"ml-1\">Cart</span>" +
                "</a>" +
                "<a href=\"" + "${pageContext.request.contextPath}" + "/user-views/profile/" + localStorage.getItem("userId") + "\" class=\"py-5 px-3 text-white hover:text-gray-200\">" +
                "<i class=\"fas fa-user\"></i>" +
                "<span class=\"ml-1\">Profile</span>" +
                "</a>" +
                "<a href=\"javascript:void(0)\" onclick=\"logout()\" class=\"py-5 px-3 text-white hover:text-gray-200\">" +
                "<i class=\"fas fa-sign-out-alt\"></i>" +
                "<span class=\"ml-1\">Logout</span>" +
                "</a>";


                mobileHTML = `
                        <a href="${pageContext.request.contextPath}/cart" class="block py-2 px-4 text-sm text-white hover:bg-gray-700">Cart</a>
                        <a href="${pageContext.request.contextPath}/profile" class="block py-2 px-4 text-sm text-white hover:bg-gray-700">Profile</a>
                        <a href="javascript:void(0)" onclick="logout()" class="block py-2 px-4 text-sm text-white hover:bg-gray-700">Logout</a>
                    `;
            } else {
                // User is not logged in, show login
                desktopHTML = `
                        <a href="${pageContext.request.contextPath}/user-views/login" class="py-5 px-3 text-white hover:text-gray-200">
                            <i class="fas fa-sign-in-alt"></i>
                            <span class="ml-1">Login</span>
                        </a>
                    `;

                mobileHTML = `
                        <a href="${pageContext.request.contextPath}/user-views/login" class="block py-2 px-4 text-sm text-white hover:bg-gray-700">Login</a>
                    `;
            }

            navbarRight.innerHTML = desktopHTML;
            mobileMenu.innerHTML = mobileHTML;
        }

        // Function to handle logout
        window.logout = function() {
            localStorage.removeItem('userId');
            window.location.href = "${pageContext.request.contextPath}/";
        };

        // Initialize navigation
        createNavItems();
    });
</script>
</body>
</html>