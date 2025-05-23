<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen">


    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8 text-center">Restaurant Dashboard</h1>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <!-- Profile Management Card -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                <div class="p-6">
                    <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4 mx-auto">
                        <svg class="w-8 h-8 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z">
                            </path>
                        </svg>
                    </div>
                    <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">Profile Management</h2>
                    <p class="text-gray-600 text-center mb-6">Update your restaurant's information, contact details, and settings</p>
                    <a href="#" 
                       onclick="navigateToProfile(event)"
                       class="block w-full bg-black text-white text-center py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                        Manage Profile
                    </a>
                </div>
            </div>

            <!-- Food Item Management Card -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                <div class="p-6">
                    <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4 mx-auto">
                        <svg class="w-8 h-8 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M12 6v6m0 0v6m0-6h6m-6 0H6">
                            </path>
                        </svg>
                    </div>
                    <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">Food Items</h2>
                    <p class="text-gray-600 text-center mb-6">Manage your menu items, prices, and availability</p>
                    <a href="${pageContext.request.contextPath}/restaurant-views/food-items" 
                       class="block w-full bg-black text-white text-center py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                        Manage Food Items
                    </a>
                </div>
            </div>

            <!-- Order Management Card -->
            <div class="mt-8">
                <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                    <div class="p-6">
                        <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4 mx-auto">
                            <svg class="w-8 h-8 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2">
                                </path>
                            </svg>
                        </div>
                        <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">Order Management</h2>
                        <p class="text-gray-600 text-center mb-6">View and manage customer orders, track deliveries, and handle order status</p>
                        <a href="${pageContext.request.contextPath}/restaurant-views/orders" 
                           class="block w-full bg-black text-white text-center py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                            Manage Orders
                        </a>
                    </div>
                </div>
            </div>

            <!-- Payment Management Card -->
            <div class="mt-8">
                <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                    <div class="p-6">
                        <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4 mx-auto">
                            <svg class="w-8 h-8 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                      d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z">
                                </path>
                            </svg>
                        </div>
                        <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">Payment Management</h2>
                        <p class="text-gray-600 text-center mb-6">View and manage payments, track transactions, and handle refunds</p>
                        <a href="${pageContext.request.contextPath}/restaurant-views/payments" 
                           class="block w-full bg-black text-white text-center py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                            Manage Payments
                        </a>
                    </div>
                </div>
            </div>
   
    </div>

    <script>
        // Check if restaurant is logged in
        document.addEventListener('DOMContentLoaded', function() {
            const restaurantId = localStorage.getItem('restaurantId');
            if (!restaurantId) {
                window.location.href = "${pageContext.request.contextPath}/restaurant-views/login";
            }

            // Fetch restaurant stats
            fetchStats(restaurantId);
        });

        async function fetchStats(restaurantId) {

        }
    
        // Add this function to your existing script
        function navigateToProfile(event) {
            event.preventDefault();
            const restaurantId = localStorage.getItem('restaurantId');
            if (restaurantId) {
                window.location.href = `${pageContext.request.contextPath}/restaurant-views/profile/`+restaurantId;
            } else {
                window.location.href = "${pageContext.request.contextPath}/restaurant-views/login";
            }
        }
    </script>
</body>
</html>