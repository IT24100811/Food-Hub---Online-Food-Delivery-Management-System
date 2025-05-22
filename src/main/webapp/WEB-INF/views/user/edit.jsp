<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile - Restaurant App</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-gray-50">
    <jsp:include page="../common/navbar.jsp" />
    
    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-white"></div>
    </div>

    <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-lg p-8">
            <h2 class="text-3xl font-bold mb-8 text-center text-gray-900">Edit Profile</h2>
            
            <!-- Alert Container -->
            <div id="alertContainer" class="mb-4"></div>
            
            <form id="editForm" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Full Name</label>
                    <input type="text" id="fullName" name="fullName" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                           required pattern="^[a-zA-Z\s]{2,50}$">
                    <span class="text-red-500 text-xs italic mt-1 hidden" id="fullNameError">Please enter a valid name (2-50 characters)</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Email</label>
                    <input type="email" id="email" name="email" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                           required>
                    <span class="text-red-500 text-xs italic mt-1 hidden" id="emailError">Please enter a valid email address</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Phone Number</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                           required pattern="^\d{10}$">
                    <span class="text-red-500 text-xs italic mt-1 hidden" id="phoneError">Please enter a valid 10-digit phone number</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Address</label>
                    <textarea id="address" name="address" 
                            class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" 
                            required></textarea>
                    <span class="text-red-500 text-xs italic mt-1 hidden" id="addressError">Please enter your address</span>
                </div>
                
                <div class="md:col-span-2 flex justify-between">
                    <button type="button" onclick="window.history.back()" 
                            class="bg-gray-500 text-white py-3 px-6 rounded-lg font-medium hover:bg-gray-600 transition duration-200">
                        Cancel
                    </button>
                    <button type="submit" 
                            class="bg-blue-600 text-white py-3 px-6 rounded-lg font-medium hover:bg-blue-700 transition duration-200">
                        Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const userId = localStorage.getItem('userId');
        if (!userId) {
            window.location.href = "${pageContext.request.contextPath}/user-views/login";
        }

        function showLoading() {
            document.getElementById('loadingOverlay').classList.remove('hidden');
            document.getElementById('loadingOverlay').classList.add('flex');
        }

        function hideLoading() {
            document.getElementById('loadingOverlay').classList.add('hidden');
            document.getElementById('loadingOverlay').classList.remove('flex');
        }

        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const bgColor = type === 'danger' ? 'bg-red-100 border-red-400 text-red-700' : 'bg-green-100 border-green-400 text-green-700';
            alertContainer.innerHTML =
                "<div class=\"border " + bgColor + " px-4 py-3 rounded relative\" role=\"alert\">" +
                "<span class=\"block sm:inline\">" + message + "</span>" +
                "<span class=\"absolute top-0 bottom-0 right-0 px-4 py-3\">" +
                "<svg class=\"fill-current h-6 w-6\" role=\"button\" onclick=\"this.parentElement.parentElement.remove()\"" +
                " xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 20 20\">" +
                "<path d=\"M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697" +
                "l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697" +
                "l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z\"/>" +
                "</svg>" +
                "</span>" +
                "</div>";

        }

        // Load user data when page loads
        window.addEventListener('DOMContentLoaded', async () => {
            showLoading();
            try {
                const response = await fetch(`${pageContext.request.contextPath}/api/users/`+userId);
                if (!response.ok) throw new Error('Failed to load user data');
                const user = await response.json();
                
                document.getElementById('fullName').value = user.fullName;
                document.getElementById('email').value = user.email;
                document.getElementById('phoneNumber').value = user.phoneNumber;
                document.getElementById('address').value = user.address;
            } catch (error) {
                showAlert('Error loading user data: ' + error.message, 'danger');
            } finally {
                hideLoading();
            }
        });

        // Form validation and submission
        document.getElementById('editForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            // Reset error messages
            document.querySelectorAll('.text-red-500').forEach(el => el.classList.add('hidden'));
            
            let isValid = true;
            
            // Full Name validation
            const fullName = document.getElementById('fullName');
            if (!fullName.value.match(/^[a-zA-Z\s]{2,50}$/)) {
                document.getElementById('fullNameError').classList.remove('hidden');
                isValid = false;
            }
            
            // Email validation
            const email = document.getElementById('email');
            if (!email.value.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
                document.getElementById('emailError').classList.remove('hidden');
                isValid = false;
            }
            
            // Phone validation
            const phone = document.getElementById('phoneNumber');
            if (!phone.value.match(/^\d{10}$/)) {
                document.getElementById('phoneError').classList.remove('hidden');
                isValid = false;
            }
            
            // Address validation
            const address = document.getElementById('address');
            if (!address.value.trim()) {
                document.getElementById('addressError').classList.remove('hidden');
                isValid = false;
            }
            
            if (isValid) {
                showLoading();
                try {
                    const existingUserResponse = await fetch(`${pageContext.request.contextPath}/api/users/`+userId);
                    if (!existingUserResponse.ok) throw new Error('Failed to load user data');
                    const exUser = await existingUserResponse.json();
                    const userData = {
                        fullName: fullName.value,
                        email: email.value,
                        phoneNumber: phone.value,
                        address: address.value,
                        password:exUser?.password ?? "password1234",
                        role: exUser?.role ??"CUSTOMER"
                    };
                    
                    const response = await fetch(`${pageContext.request.contextPath}/api/users/`+userId, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(userData)
                    });

                    if (!response.ok) throw new Error('Failed to update profile');
                    
                    showAlert('Profile updated successfully!', 'success');

                } catch (error) {
                    showAlert('Error updating profile: ' + error.message, 'danger');
                } finally {
                    hideLoading();
                }
            }
        });
    </script>
</body>
</html>