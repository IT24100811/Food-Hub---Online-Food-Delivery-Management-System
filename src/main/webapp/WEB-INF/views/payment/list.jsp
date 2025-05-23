<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold mb-8">Payment Management</h1>
        
        <div id="payments-container" class="grid grid-cols-1 gap-6">
            <!-- Payments will be loaded here -->
        </div>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden">
        <div class="animate-spin rounded-full h-16 w-16 border-t-2 border-b-2 border-white"></div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', loadPayments);

        async function loadPayments() {
            const loadingOverlay = document.getElementById('loadingOverlay');
            loadingOverlay.classList.remove('hidden');

            try {
                const response = await fetch('${pageContext.request.contextPath}/api/payments');
                const payments = await response.json();
                await displayPayments(payments);
            } catch (error) {
                console.error('Error loading payments:', error);
                showAlert('Failed to load payments', 'error');
            } finally {
                loadingOverlay.classList.add('hidden');
            }
        }

        async function fetchOrderDetails(orderId) {
            try {
                const response = await fetch("${pageContext.request.contextPath}/api/orders/" + orderId);
                return await response.json();
            } catch (error) {
                console.error("Error fetching order details:", error);
                return null;
            }
        }

        async function fetchUserDetails(userId) {
            try {
                const response = await fetch("${pageContext.request.contextPath}/api/users/" + userId);
                return await response.json();
            } catch (error) {
                console.error("Error fetching user details:", error);
                return null;
            }
        }

        async function displayPayments(payments) {
            const container = document.getElementById('payments-container');
            container.innerHTML = '';

            for (const payment of payments) {
                const orderDetails = await fetchOrderDetails(payment.orderId);
                const userDetails = await fetchUserDetails(payment.userId);
                
                const paymentCard = document.createElement('div');
                paymentCard.className = 'bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-all';

                paymentCard.innerHTML =
                    "<div class=\"flex justify-between items-start mb-4\">" +
                    "<div>" +
                    "<h3 class=\"text-lg font-semibold\">Payment #" + payment.id.substring(0, 8) + "</h3>" +
                    "<p class=\"text-sm text-gray-600\">" + new Date(payment.paymentDate).toLocaleString() + "</p>" +
                    "</div>" +
                    "<div class=\"flex gap-2\">" +
                    "<select " +
                    "class=\"text-sm border rounded px-2 py-1\" " +
                    "onchange=\"updatePaymentStatus('" + payment.id + "', this.value)\" " +
                    ">" +
                    "<option value=\"Pending\" " + (payment.paymentStatus === 'Pending' ? 'selected' : '') + ">Pending</option>" +
                    "<option value=\"Completed\" " + (payment.paymentStatus === 'Completed' ? 'selected' : '') + ">Completed</option>" +
                    "<option value=\"Failed\" " + (payment.paymentStatus === 'Failed' ? 'selected' : '') + ">Failed</option>" +
                    "</select>" +
                    "<button " +
                    "onclick=\"deletePayment('" + payment.id + "')\" " +
                    "class=\"text-red-600 hover:text-red-800\" " +
                    ">" +
                    "<svg class=\"w-5 h-5\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">" +
                    "<path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16\" />" +
                    "</svg>" +
                    "</button>" +
                    "</div>" +
                    "</div>" +
                    "<div class=\"grid grid-cols-2 gap-4 mb-4\">" +
                    "<div>" +
                    "<p class=\"text-sm text-gray-600\">Customer</p>" +
                    "<p class=\"font-medium\">" + (userDetails ? userDetails.name : 'Unknown') + "</p>" +
                    "</div>" +
                    "<div>" +
                    "<p class=\"text-sm text-gray-600\">Amount</p>" +
                    "<p class=\"font-medium\">$" + payment.totalAmount.toFixed(2) + "</p>" +
                    "</div>" +
                    "<div>" +
                    "<p class=\"text-sm text-gray-600\">Payment Method</p>" +
                    "<p class=\"font-medium\">" + payment.paymentMethod + "</p>" +
                    "</div>" +
                    "<div>" +
                    "<p class=\"text-sm text-gray-600\">Transaction ID</p>" +
                    "<p class=\"font-medium\">" + (new Date().valueOf() || 'N/A') + "</p>" +
                    "</div>" +
                    "</div>" +
                    "<div class=\"bg-gray-50 p-4 rounded\">" +
                    "<p class=\"text-sm text-gray-600 mb-2\">Order Details</p>" +
                    "<p class=\"font-medium\">Order #" + payment.orderId + "</p>" +
                    (orderDetails ?
                        "<p class=\"text-sm text-gray-600 mt-2\">Status: " + orderDetails.orderStatus + "</p>" +
                        "<p class=\"text-sm text-gray-600\">Items: " + orderDetails.foodItems.length + "</p>"
                        : 'Order details not available') +
                    "</div>";
                
                container.appendChild(paymentCard);
            }
        }

        async function updatePaymentStatus(paymentId, newStatus) {
            const loadingOverlay = document.getElementById('loadingOverlay');
            loadingOverlay.classList.remove('hidden');

            try {
                const response = await fetch(
                    "${pageContext.request.contextPath}" + "/api/payments/" + paymentId + "/status?status=" + newStatus,
                    {
                        method: 'PUT'
                    }
                );


                if (response.ok) {
                    showAlert('Payment status updated successfully', 'success');
                    await loadPayments();
                } else {
                    showAlert('Failed to update payment status', 'error');
                }
            } catch (error) {
                console.error('Error updating payment status:', error);
                showAlert('Error updating payment status', 'error');
            } finally {
                loadingOverlay.classList.add('hidden');
            }
        }

        async function deletePayment(paymentId) {
            if (!confirm('Are you sure you want to delete this payment?')) {
                return;
            }

            const loadingOverlay = document.getElementById('loadingOverlay');
            loadingOverlay.classList.remove('hidden');

            try {
                const response = await fetch(
                    `${pageContext.request.contextPath}/api/payments/`+paymentId,
                    {
                        method: 'DELETE'
                    }
                );
                
                if (response.ok) {
                    showAlert('Payment deleted successfully', 'success');
                    await loadPayments();
                } else {
                    showAlert('Failed to delete payment', 'error');
                }
            } catch (error) {
                console.error('Error deleting payment:', error);
                showAlert('Error deleting payment', 'error');
            } finally {
                loadingOverlay.classList.add('hidden');
            }
        }

        function showAlert(message, type) {
            const alertDiv = document.createElement('div');
            alertDiv.className = "fixed top-4 right-4 p-4 rounded-lg " +
                (type === "success" ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800");

            alertDiv.textContent = message;
            document.body.appendChild(alertDiv);
            setTimeout(() => alertDiv.remove(), 3000);
        }
    </script>
</body>
</html>