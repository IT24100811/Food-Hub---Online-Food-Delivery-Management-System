<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <jsp:include page="navbar.jsp" />

    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold mb-8">Shopping Cart</h1>

        <!-- Cart Items Container -->
        <div id="cartContainer" class="bg-white rounded-lg shadow-lg p-6 mb-8">
            <div id="cartItems" class="space-y-4"></div>
            
            <!-- Empty Cart Message -->
            <div id="emptyCartMessage" class="text-center py-8 hidden">
                <i class="fas fa-shopping-cart text-gray-400 text-4xl mb-4"></i>
                <p class="text-gray-500 text-lg">Your cart is empty</p>
                <a href="${pageContext.request.contextPath}/" 
                   class="inline-block mt-4 bg-black text-white px-6 py-2 rounded-lg hover:bg-gray-800 transition duration-200">
                    Continue Shopping
                </a>
            </div>
        </div>

        <!-- Cart Summary -->
        <div id="cartSummary" class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold mb-4">Order Summary</h2>
            <div class="space-y-2 mb-4">
                <div class="flex justify-between">
                    <span>Subtotal</span>
                    <span id="subtotal">$0.00</span>
                </div>
                <div class="flex justify-between">
                    <span>Tax (10%)</span>
                    <span id="tax">$0.00</span>
                </div>
                <div class="border-t pt-2 mt-2">
                    <div class="flex justify-between font-bold">
                        <span>Total</span>
                        <span id="total">$0.00</span>
                    </div>
                </div>
            </div>
            <button onclick="proceedToCheckout()" 
                    class="w-full bg-black text-white py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                Proceed to Checkout
            </button>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            loadCart();
        });

        function loadCart() {
            const cart = JSON.parse(localStorage.getItem('cart')) || {};
            const cartItems = document.getElementById('cartItems');
            const emptyCartMessage = document.getElementById('emptyCartMessage');
            const cartSummary = document.getElementById('cartSummary');
            
            if (Object.keys(cart).length === 0) {
                emptyCartMessage.classList.remove('hidden');
                cartSummary.classList.add('hidden');
                return;
            }

            emptyCartMessage.classList.add('hidden');
            cartSummary.classList.remove('hidden');

            cartItems.innerHTML = Object.entries(cart).map(function([id, item]) {
                return '<div class="flex items-center justify-between border-b pb-4">' +
                    '<div class="flex-1">' +
                    '<h3 class="font-semibold">' + item.name + '</h3>' +
                    '<p class="text-gray-600">$' + item.price + ' each</p>' +
                    '</div>' +
                    '<div class="flex items-center gap-4">' +
                    '<div class="flex items-center border rounded-lg">' +
                    '<button onclick="updateQuantity(\'' + id + '\', -1)" ' +
                    'class="px-3 py-1 hover:bg-gray-100 transition duration-200">' +
                    '<i class="fas fa-minus"></i>' +
                    '</button>' +
                    '<span class="px-4 py-1 border-x">' + item.quantity + '</span>' +
                    '<button onclick="updateQuantity(\'' + id + '\', 1)" ' +
                    'class="px-3 py-1 hover:bg-gray-100 transition duration-200">' +
                    '<i class="fas fa-plus"></i>' +
                    '</button>' +
                    '</div>' +
                    '<span class="font-semibold w-24 text-right">' +
                    '$' + (item.price * item.quantity).toFixed(2) +
                    '</span>' +
                    '<button onclick="removeItem(\'' + id + '\')" ' +
                    'class="text-red-500 hover:text-red-700 transition duration-200">' +
                    '<i class="fas fa-trash"></i>' +
                    '</button>' +
                    '</div>' +
                    '</div>';
            }).join('');


            updateSummary();
        }

        function updateQuantity(id, delta) {
            const cart = JSON.parse(localStorage.getItem('cart')) || {};
            if (cart[id]) {
                cart[id].quantity += delta;
                if (cart[id].quantity <= 0) {
                    removeItem(id);
                    return;
                }
                localStorage.setItem('cart', JSON.stringify(cart));
                loadCart();
            }
        }

        function removeItem(id) {
            if (!confirm('Are you sure you want to remove this item?')) return;
            
            const cart = JSON.parse(localStorage.getItem('cart')) || {};
            delete cart[id];
            localStorage.setItem('cart', JSON.stringify(cart));
            loadCart();
        }

        function updateSummary() {
            const cart = JSON.parse(localStorage.getItem('cart')) || {};
            const subtotal = Object.values(cart).reduce((sum, item) => sum + (item.price * item.quantity), 0);
            const tax = subtotal * 0.1;
            const total = subtotal + tax;

            document.getElementById('subtotal').textContent = "$" + subtotal.toFixed(2);
            document.getElementById('tax').textContent = "$" + tax.toFixed(2);
            document.getElementById('total').textContent = "$" + total.toFixed(2);

        }

        function proceedToCheckout() {
            window.location.href = "${pageContext.request.contextPath}/place-order";
        }
    </script>
</body>
</html>