<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Restaurant App</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <%@ include file="../common/navbar.jsp" %>
    
    <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-lg p-8">
            <h2 class="text-3xl font-bold mb-8 text-center text-gray-900">Create Account</h2>
            
            <form id="registerForm" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Full Name</label>
                    <input type="text" id="fullName" name="fullName" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required pattern="^[a-zA-Z\s]{2,50}$">
                    <span class="text-red-500 text-sm hidden mt-1" id="fullNameError">Please enter a valid name (2-50 characters)</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Email</label>
                    <input type="email" id="email" name="email" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required>
                    <span class="text-red-500 text-sm hidden mt-1" id="emailError">Please enter a valid email address</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Phone Number</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required pattern="^\d{10}$">
                    <span class="text-red-500 text-sm hidden mt-1" id="phoneError">Please enter a valid 10-digit phone number</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Password</label>
                    <input type="password" id="password" name="password" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required minlength="6">
                    <span class="text-red-500 text-sm hidden mt-1" id="passwordError">Password must be at least 6 characters</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required>
                    <span class="text-red-500 text-sm hidden mt-1" id="confirmPasswordError">Passwords do not match</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Address</label>
                    <textarea id="address" name="address" 
                             class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                             required></textarea>
                    <span class="text-red-500 text-sm hidden mt-1" id="addressError">Please enter your address</span>
                </div>
                
                <div class="md:col-span-2">
                    <button type="submit" 
                            class="w-full bg-black text-white py-3 px-4 rounded-lg font-medium hover:bg-gray-800 transition duration-200">
                        Register
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Reset error messages
            document.querySelectorAll('.text-red-500').forEach(el => el.classList.add('hidden'));
            
            // Validate form
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
            
            // Password validation (simplified to 6 characters minimum)
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            if (password.value.length < 6) {
                document.getElementById('passwordError').classList.remove('hidden');
                isValid = false;
            }
            if (password.value !== confirmPassword.value) {
                document.getElementById('confirmPasswordError').classList.remove('hidden');
                isValid = false;
            }
            
            // Address validation
            const address = document.getElementById('address');
            if (!address.value.trim()) {
                document.getElementById('addressError').classList.remove('hidden');
                isValid = false;
            }
            
            if (isValid) {
                // Create user object
                const userData = {
                    fullName: fullName.value,
                    email: email.value,
                    phoneNumber: phone.value,
                    password: password.value,
                    role: 'CUSTOMER',
                    address: address.value,
                    accountStatus: 'ACTIVE'
                };
                
                // Send POST request to create user
                fetch('${pageContext.request.contextPath}/api/users', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(userData)
                })
                .then(response => response.json())
                .then(data => {
                    localStorage.setItem('userId', data.id);
                    window.location.href = '${pageContext.request.contextPath}/';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Registration failed. Please try again.');
                });
            }
        });
    </script>
</body>
</html>