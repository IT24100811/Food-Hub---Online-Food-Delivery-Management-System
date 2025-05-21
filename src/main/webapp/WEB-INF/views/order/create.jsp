<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Place Order</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <jsp:include page="../common/navbar.jsp" />

    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold mb-8">Place Order</h1>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <!-- Order Details -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h2 class="text-xl font-bold mb-4">Order Items</h2>
                <div id="orderItems" class="space-y-4 mb-6"></div>

                <div class="border-t pt-4">
                    <div class="flex justify-between mb-2">
                        <span>Subtotal</span>
                        <span id="subtotal">$0.00</span>
                    </div>
                    <div class="flex justify-between mb-2">
                        <span>Tax (10%)</span>
                        <span id="tax">$0.00</span>
                    </div>
                    <div class="flex justify-between font-bold">
                        <span>Total</span>
                        <span id="total">$0.00</span>
                    </div>
                </div>
            </div>

            <!-- Delivery Details Form -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h2 class="text-xl font-bold mb-4">Delivery Details</h2>
                <form id="orderForm" class="space-y-4">
                    <div>
                        <label class="block text-gray-700 text-sm font-medium mb-2">Delivery Address</label>
                        <textarea id="deliveryAddress" name="deliveryAddress" required
                                class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                rows="3"></textarea>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-medium mb-2">Special Instructions (Optional)</label>
                        <textarea id="specialInstructions" name="specialInstructions"
                                class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                rows="2"></textarea>
                    </div>

                    <div class="pt-4">
                        <button type="submit" 
                                class="w-full bg-black text-white py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                            Confirm Order
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            loadOrderItems();
            loadUserAddress();
            setupFormSubmission();
        });

        function loadOrderItems() {
            const cart = JSON.parse(localStorage.getItem('cart')) || {};
            const orderItems = document.getElementById('orderItems');

            orderItems.innerHTML = Object.entries(cart).map(function([id, item]) {
                return '<div class="flex justify-between items-center">' +
                    '<div>' +
                    '<h3 class="font-semibold">' + item.name + '</h3>' +
                    '<p class="text-gray-600">' + item.quantity + ' × $' + item.price + '</p>' +
                    '</div>' +
                    '<span class="font-semibold">$' + (item.price * item.quantity).toFixed(2) + '</span>' +
                    '</div>';
            }).join('');


            updateSummary();
        }

        function loadUserAddress() {
            const userId = localStorage.getItem('userId');

        }

        function updateSummary() {
            const cart = JSON.parse(localStorage.getItem('cart')) || {};
            const subtotal = Object.values(cart).reduce((sum, item) => sum + (item.price * item.quantity), 0);
            const tax = subtotal * 0.1;
            const total = subtotal + tax;

            document.getElementById('subtotal').textContent = '$' + subtotal.toFixed(2);
            document.getElementById('tax').textContent = '$' + tax.toFixed(2);
            document.getElementById('total').textContent = '$' + total.toFixed(2);

        }

        function setupFormSubmission() {
            document.getElementById('orderForm').addEventListener('submit', async function(e) {
                e.preventDefault();

                const cart = JSON.parse(localStorage.getItem('cart')) || {};
                const userId = localStorage.getItem('userId');
                
                if (!userId) {
                    alert('Please log in to place an order');
                    window.location.href = '${pageContext.request.contextPath}/login';
                    return;
                }

                const orderData = {
                    userId: userId,
                    foodItems: Object.values(cart).map(item => item.name),
                    quantities: Object.values(cart).map(item => item.quantity),
                    deliveryAddress: document.getElementById('deliveryAddress').value,
                    orderStatus: 'Pending',
                    orderDateTime: new Date().toISOString(),
                    estimatedDeliveryTime: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
                    specialInstructions: document.getElementById('specialInstructions').value || ''
                };

                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/orders', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify(orderData)
                    });

                    if (response.ok) {
                        const data = await response.json();
                        // Clear cart after successful order
                        localStorage.removeItem('cart');
                        alert('Order placed successfully!');
                        window.location.href = '${pageContext.request.contextPath}/place-order/'+data.id;
                    } else {
                        alert('Failed to place order. Please try again.');
                    }
                } catch (error) {
                    console.error('Error:', error);
                    alert('An error occurred while placing your order.');
                }
            });
        }
    </script>
</body>
</html>