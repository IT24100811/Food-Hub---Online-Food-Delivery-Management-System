<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment - Restaurant App</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <jsp:include page="../common/navbar.jsp" />
    
    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-white"></div>
    </div>

    <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-lg p-8">
            <h2 class="text-3xl font-bold mb-8 text-center text-gray-900">Payment Details</h2>
            
            <!-- Alert Container -->
            <div id="alertContainer" class="mb-4"></div>

            <!-- Order Summary -->
            <div class="mb-8 p-4 bg-gray-50 rounded-lg">
                <h3 class="text-xl font-semibold mb-4">Order Summary</h3>
                <div class="grid grid-cols-2 gap-4">
                    <p class="text-gray-600">Order ID: <span id="orderId" class="font-medium text-black">${order.id}</span></p>
                    <p class="text-gray-600">Total Amount: <span class="font-medium text-black">$${order.totalAmount}</span></p>
                </div>
            </div>
            
            <form id="paymentForm" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="col-span-2">
                    <label class="block text-gray-700 text-sm font-medium mb-2">Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod" 
                            class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                            required>
                        <option value="">Select Payment Method</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="UPI">UPI</option>
                        <option value="Cash on Delivery">Cash on Delivery</option>
                    </select>
                </div>

                <div id="cardDetails" class="col-span-2 grid grid-cols-1 md:grid-cols-2 gap-6 hidden">
                    <div>
                        <label class="block text-gray-700 text-sm font-medium mb-2">Card Number</label>
                        <input type="text" id="cardNumber" name="cardNumber"
                               class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                               pattern="[0-9]{16}" placeholder="1234 5678 9012 3456">
                    </div>
                    
                    <div>
                        <label class="block text-gray-700 text-sm font-medium mb-2">Card Holder Name</label>
                        <input type="text" id="cardHolderName" name="cardHolderName"
                               class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                               pattern="[A-Za-z\s]{2,50}">
                    </div>
                    
                    <div>
                        <label class="block text-gray-700 text-sm font-medium mb-2">Expiry Date</label>
                        <input type="text" id="expiryDate" name="expiryDate"
                               class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                               placeholder="MM/YY" pattern="(0[1-9]|1[0-2])\/([0-9]{2})">
                    </div>
                    
                    <div>
                        <label class="block text-gray-700 text-sm font-medium mb-2">CVV</label>
                        <input type="password" id="cvv" name="cvv"
                               class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                               pattern="[0-9]{3,4}" maxlength="4">
                    </div>
                </div>

                <div class="col-span-2 text-center">
                    <button type="submit" 
                            class="bg-black text-white px-8 py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                        Process Payment
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const paymentMethod = document.getElementById('paymentMethod');
        const cardDetails = document.getElementById('cardDetails');
        const cardInputs = cardDetails.querySelectorAll('input');

        paymentMethod.addEventListener('change', () => {
            if (paymentMethod.value === 'Credit Card' || paymentMethod.value === 'Debit Card') {
                cardDetails.classList.remove('hidden');
                cardInputs.forEach(input => input.required = true);
            } else {
                cardDetails.classList.add('hidden');
                cardInputs.forEach(input => input.required = false);
            }
        });

        document.getElementById('paymentForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const loadingOverlay = document.getElementById('loadingOverlay');
            loadingOverlay.style.display = 'flex';
            
            const paymentData = {
                orderId: document.getElementById('orderId').textContent,
                paymentMethod: paymentMethod.value,
                paymentStatus: 'Pending',
                totalAmount: ${order.totalAmount}
            };
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/payments', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(paymentData)
                });
                
                if (response.ok) {
                    showAlert('Payment processed successfully!', 'success');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/';
                    }, 2000);
                } else {
                    showAlert('Payment processing failed. Please try again.', 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showAlert('An error occurred. Please try again later.', 'error');
            } finally {
                loadingOverlay.style.display = 'none';
            }
        });

        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const alertClass = type === 'success' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';

            alertContainer.innerHTML =
                "<div class=\"p-4 rounded-lg " + alertClass + "\">" +
                message +
                "</div>";
            
            setTimeout(() => {
                alertContainer.innerHTML = '';
            }, 5000);
        }
    </script>
</body>
</html>