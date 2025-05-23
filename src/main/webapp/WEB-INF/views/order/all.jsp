<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Management</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold mb-8">Order Management</h1>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" id="orders-container">
            <!-- Orders will be loaded here -->
        </div>
    </div>

    <!-- Status Update Toast -->
    <div id="statusToast" class="fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg hidden">
        Status updated successfully!
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            fetchOrders();
        });

        async function fetchOrders() {
            try {
                const response = await fetch("/api/orders");
                const orders = await response.json();
                displayOrders(orders);
            } catch (error) {
                console.error("Error fetching orders:", error);
            }
        }

        async function fetchUserDetails(userId) {
            try {
                const response = await fetch("/api/users/" + userId);
                const userData = await response.json();
                return userData;
            } catch (error) {
                console.error("Error fetching user details:", error);
                return null;
            }
        }

        async function displayOrders(orders) {
            const container = document.getElementById("orders-container");
            container.innerHTML = "";

            for (const order of orders) {
                const userDetails = await fetchUserDetails(order.userId);
                const orderCard = document.createElement("div");
                orderCard.className = "bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-all";

                orderCard.innerHTML =
                    "<div class=\"flex justify-between items-start mb-4\">" +
                    "<div>" +
                    "<h3 class=\"text-lg font-semibold\">Order #" + order.id.substring(0, 8) + "</h3>" +
                    "<p class=\"text-sm text-gray-600\">" + new Date(order.orderDateTime).toLocaleString() + "</p>" +
                    "</div>" +
                    "<select " +
                    "class=\"text-sm border rounded px-2 py-1\" " +
                    "onchange=\"updateOrderStatus('" + order.id + "', this.value)\" " +
                    ">" +
                    "<option value=\"Pending\" " + (order.orderStatus === "Pending" ? "selected" : "") + ">Pending</option>" +
                    "<option value=\"Preparing\" " + (order.orderStatus === "Preparing" ? "selected" : "") + ">Preparing</option>" +
                    "<option value=\"Dispatched\" " + (order.orderStatus === "Dispatched" ? "selected" : "") + ">Dispatched</option>" +
                    "<option value=\"Delivered\" " + (order.orderStatus === "Delivered" ? "selected" : "") + ">Delivered</option>" +
                    "<option value=\"Cancelled\" " + (order.orderStatus === "Cancelled" ? "selected" : "") + ">Cancelled</option>" +
                    "</select>" +
                    "</div>" +

                    "<div class=\"border-t border-b py-4 my-4\">" +
                    "<div class=\"mb-4\">" +
                    "<h4 class=\"font-medium mb-2\">Customer Details</h4>" +
                    "<p class=\"text-sm\">" + (userDetails ? userDetails.fullName : 'Unknown User') + "</p>" +
                    "<p class=\"text-sm text-gray-600\">" + (userDetails ? userDetails.email : '') + "</p>" +
                    "<p class=\"text-sm text-gray-600\">" + (userDetails ? userDetails.phoneNumber : '') + "</p>" +
                    "</div>" +

                    "<div class=\"mb-4\">" +
                    "<h4 class=\"font-medium mb-2\">Delivery Address</h4>" +
                    "<p class=\"text-sm text-gray-600\">" + order.deliveryAddress + "</p>" +
                    "</div>" +

                    "<div>" +
                    "<h4 class=\"font-medium mb-2\">Order Items</h4>" +
                    "<div class=\"space-y-2\">" +
                    order.foodItems.map((item, index) =>
                        "<div class=\"flex justify-between text-sm\">" +
                        "<span>" + item + "</span>" +
                        "<span>x" + order.quantities[index] + "</span>" +
                        "</div>"
                    ).join("") +
                    "</div>" +
                    "</div>" +
                    "</div>" +

                    "<div class=\"flex justify-between items-center\">" +
                    "<p class=\"text-sm text-gray-600\">" +
                    "<i class=\"fas fa-info-circle mr-1\"></i> " +
                    (order.specialInstructions || "No special instructions") +
                    "</p>" +
                    "<button onclick=\"deleteOrder('" + order.id + "')\" " +
                    "class=\"text-red-600 hover:text-red-900\">" +
                    "<i class=\"fas fa-trash\"></i>" +
                    "</button>" +
                    "</div>";
                
                container.appendChild(orderCard);
            }
        }

        async function updateOrderStatus(orderId, newStatus) {
            try {
                const response = await fetch("/api/orders/" + orderId + "/status?status=" + newStatus, {
                    method: "PUT"
                });
                
                if (response.ok) {
                    const toast = document.getElementById("statusToast");
                    toast.classList.remove("hidden");
                    setTimeout(() => {
                        toast.classList.add("hidden");
                    }, 3000);
                    fetchOrders();
                } else {
                    throw new Error("Failed to update status");
                }
            } catch (error) {
                console.error("Error updating order status:", error);
                alert("Failed to update order status");
            }
        }

        async function deleteOrder(orderId) {
            if (!confirm("Are you sure you want to delete this order?")) {
                return;
            }

            try {
                const response = await fetch("/api/orders/" + orderId, {
                    method: "DELETE"
                });
                
                if (response.ok) {
                    fetchOrders();
                } else {
                    throw new Error("Failed to delete order");
                }
            } catch (error) {
                console.error("Error deleting order:", error);
                alert("Failed to delete order");
            }
        }
    </script>
</body>
</html>