<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant App - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        @keyframes fadeInOut {
            0% { opacity: 0; transform: translateY(-20px); }
            15% { opacity: 1; transform: translateY(0); }
            85% { opacity: 1; transform: translateY(0); }
            100% { opacity: 0; transform: translateY(-20px); }
        }
        .animate-fade-in-out {
            animation: fadeInOut 2s ease-in-out forwards;
        }
    </style>
</head>
<body class="bg-gray-50">
    <jsp:include page="common/navbar.jsp" />

    <div class="container mx-auto px-4 py-8">
        <!-- Search Section -->
        <div class="mb-8">
            <div class="flex gap-4">
                <input type="text" id="searchInput" 
                       class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-black"
                       placeholder="Search restaurants or food items...">
                <select id="filterType" class="px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-black">
                    <option value="all">All</option>
                    <option value="restaurants">Restaurants</option>
                    <option value="food">Food Items</option>
                </select>
            </div>
        </div>

        <!-- Restaurants Section -->
        <div class="mb-12">
            <h2 class="text-2xl font-bold mb-6">Restaurants</h2>
            <div id="restaurantsGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach items="${restaurants}" var="restaurant">
                    <div class="restaurant-card bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                        <div class="p-6">
                            <h3 class="text-xl font-semibold mb-2">${restaurant.name}</h3>
                            <p class="text-gray-600 mb-2">${restaurant.cuisine}</p>
                            <p class="text-gray-600 mb-2">${restaurant.location}</p>
                            <span class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700">
                                ${restaurant.type}
                            </span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Food Items Section -->
        <div>
            <h2 class="text-2xl font-bold mb-6">Food Items</h2>
            <div id="foodItemsGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach items="${foodItems}" var="item">
                    <div class="food-item-card bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                        <div class="p-6">
                            <h3 class="text-xl font-semibold mb-2">${item.name}</h3>
                            <p class="text-gray-600 mb-2">${item.description}</p>
                            <p class="text-lg font-bold mb-2">$${item.price}</p>
                            <div class="flex justify-between items-center">
                                <span class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700">
                                    ${item.category}
                                </span>
                                <button onclick="addToCart('${item.id}', '${item.name}', ${item.price})" 
                                        class="bg-black text-white px-4 py-2 rounded-lg hover:bg-gray-800 transition duration-200">
                                    Add to Cart
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <section>
            <jsp:include page="./feedbacks/feedbacks.jsp"/>
        </section>
        <!-- Cart Preview -->
        <div id="cartPreview" class="fixed bottom-4 right-4 bg-white rounded-lg shadow-lg p-4 w-80 hidden">
            <h3 class="text-lg font-bold mb-4">Shopping Cart</h3>
            <div id="cartItems" class="max-h-60 overflow-y-auto mb-4"></div>
            <div class="border-t pt-4">
                <div class="flex justify-between mb-4">
                    <span class="font-bold">Total:</span>
                    <span id="cartTotal" class="font-bold">$0.00</span>
                </div>
                <button onclick="toggleCart()" class="w-full bg-black text-white py-2 rounded-lg hover:bg-gray-800 transition duration-200">
                    Close Cart
                </button>
            </div>
        </div>

        <!-- Cart Icon -->
        <button onclick="toggleCart()" class="fixed bottom-4 right-4 bg-black text-white p-4 rounded-full shadow-lg hover:bg-gray-800 transition duration-200">
            <i class="fas fa-shopping-cart"></i>
            <span id="cartCount" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm">0</span>
        </button>
    </div>

    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const filterType = document.getElementById('filterType').value;
            
            const restaurantCards = document.querySelectorAll('.restaurant-card');
            const foodItemCards = document.querySelectorAll('.food-item-card');

            if (filterType === 'all' || filterType === 'restaurants') {
                restaurantCards.forEach(card => {
                    const text = card.textContent.toLowerCase();
                    card.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            }

            if (filterType === 'all' || filterType === 'food') {
                foodItemCards.forEach(card => {
                    const text = card.textContent.toLowerCase();
                    card.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            }
        });

        document.getElementById('filterType').addEventListener('change', function() {
            document.getElementById('searchInput').dispatchEvent(new Event('input'));
        });

        // Cart functionality
        let cart = JSON.parse(localStorage.getItem('cart')) || {};
        updateCartDisplay();

        function addToCart(id, name, price) {
            if (cart[id]) {
                cart[id].quantity += 1;
            } else {
                cart[id] = {
                    name: name,
                    price: price,
                    quantity: 1
                };
            }
            localStorage.setItem('cart', JSON.stringify(cart));
            updateCartDisplay();
        }

        function removeFromCart(id) {
            delete cart[id];
            localStorage.setItem('cart', JSON.stringify(cart));
            updateCartDisplay();
        }

        function updateQuantity(id, delta) {
            cart[id].quantity += delta;
            if (cart[id].quantity <= 0) {
                removeFromCart(id);
            } else {
                localStorage.setItem('cart', JSON.stringify(cart));
                updateCartDisplay();
            }
        }

        function updateCartDisplay() {
            const cartItems = document.getElementById('cartItems');
            const cartTotal = document.getElementById('cartTotal');
            const cartCount = document.getElementById('cartCount');
            
            let total = 0;
            let count = 0;
            
            cartItems.innerHTML = Object.entries(cart).map(([id, item]) => {
                total += item.price * item.quantity;
                count += item.quantity;
                return (
                    '<div class="flex justify-between items-center mb-4">' +
                    '<div>' +
                    '<h4 class="font-semibold">' + item.name + '</h4>' +
                    '<p class="text-gray-600">$' + item.price + ' × ' + item.quantity + '</p>' +
                    '</div>' +
                    '<div class="flex items-center gap-2">' +
                    '<button onclick="updateQuantity(\'' + id + '\', -1)" class="text-gray-500 hover:text-black">-</button>' +
                    '<button onclick="updateQuantity(\'' + id + '\', 1)" class="text-gray-500 hover:text-black">+</button>' +
                    '<button onclick="removeFromCart(\'' + id + '\')" class="text-red-500 hover:text-red-700">' +
                    '<i class="fas fa-trash"></i>' +
                    '</button>' +
                    '</div>' +
                    '</div>'
                );

            }).join('');

            cartTotal.textContent = '$' + total.toFixed(2);

            cartCount.textContent = count;
        }

        function toggleCart() {
            const cartPreview = document.getElementById('cartPreview');
            cartPreview.classList.toggle('hidden');
        }
    </script>
</body>
</html>