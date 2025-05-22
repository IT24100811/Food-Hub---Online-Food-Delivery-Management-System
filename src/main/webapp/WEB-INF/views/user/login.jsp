<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login | FoodHub</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body class="bg-gray-100 min-h-screen">
    <jsp:include page="../common/navbar.jsp"/>

    <div class="container mx-auto px-4 py-8">
        <div class="max-w-md mx-auto bg-white rounded-lg shadow-lg overflow-hidden">
            <div class="py-4 px-6 bg-gray-800 text-white text-center">
                <h2 class="text-2xl font-bold">Login to FoodHub</h2>
            </div>

            <form id="loginForm" class="py-6 px-8" onsubmit="return validateForm(event)">
                <!-- Error message area -->
                <div id="errorMessage" class="hidden bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4"></div>

                <!-- Success message area -->
                <div id="successMessage" class="hidden bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4"></div>

                <!-- Email field -->
                <div class="mb-4">
                    <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email Address</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-envelope text-gray-400"></i>
                        </div>
                        <input type="email" id="email" name="email" class="pl-10 pr-4 py-2 w-full border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="you@example.com">
                    </div>
                    <p id="emailError" class="text-red-500 text-xs italic mt-1 hidden"></p>
                </div>

                <!-- Password field -->
                <div class="mb-6">
                    <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <input type="password" id="password" name="password" class="pl-10 pr-4 py-2 w-full border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="••••••••">
                        <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                            <i id="togglePassword" class="fas fa-eye text-gray-400 cursor-pointer"></i>
                        </div>
                    </div>
                    <p id="passwordError" class="text-red-500 text-xs italic mt-1 hidden"></p>
                </div>

                <!-- Remember me checkbox -->
                <div class="mb-6 flex items-center">
                    <input type="checkbox" id="remember" name="remember" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                    <label for="remember" class="ml-2 block text-sm text-gray-700">Remember me</label>
                </div>

                <!-- Submit button -->
                <div class="mb-6">
                    <button type="submit" class="w-full bg-black hover:bg-gray-800 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-gray-500 transition duration-150">
                        Sign In
                    </button>
                </div>

                <!-- Register link -->
                <div class="text-center pb-4">
                    <p class="text-sm text-gray-600">
                        Don't have an account?
                        <a href="${pageContext.request.contextPath}/user-views/register" class="text-gray-800 hover:text-black font-medium">Register now</a>
                    </p>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle password visibility
            const togglePassword = document.getElementById('togglePassword');
            const password = document.getElementById('password');

            togglePassword.addEventListener('click', function() {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });

            // Clear validation errors when user starts typing
            const email = document.getElementById('email');
            email.addEventListener('input', function() {
                document.getElementById('emailError').classList.add('hidden');
            });

            password.addEventListener('input', function() {
                document.getElementById('passwordError').classList.add('hidden');
            });
        });

        // Form validation and submission function
        async function validateForm(event) {
            event.preventDefault();

            let isValid = true;
            const errorMessage = document.getElementById('errorMessage');
            const successMessage = document.getElementById('successMessage');
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;

            // Hide previous messages
            errorMessage.classList.add('hidden');
            successMessage.classList.add('hidden');
            document.getElementById('emailError').classList.add('hidden');
            document.getElementById('passwordError').classList.add('hidden');

            // Email validation
            const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
            if (!email) {
                document.getElementById('emailError').textContent = 'Email is required';
                document.getElementById('emailError').classList.remove('hidden');
                isValid = false;
            } else if (!emailRegex.test(email)) {
                document.getElementById('emailError').textContent = 'Please enter a valid email address';
                document.getElementById('emailError').classList.remove('hidden');
                isValid = false;
            }

            // Password validation
            const passwordRegex = /^.{6,}$/;

            if (!password) {
                document.getElementById('passwordError').textContent = 'Password is required';
                document.getElementById('passwordError').classList.remove('hidden');
                isValid = false;
            } else if (!passwordRegex.test(password)) {
                document.getElementById('passwordError').textContent = 'Password must be at least 8 characters with at least one letter and one number';
                document.getElementById('passwordError').classList.remove('hidden');
                isValid = false;
            }

            if (isValid) {
                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/users/login', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            email: email,
                            password: password
                        })
                    });

                    if (!response.ok) {
                        throw new Error('Invalid credentials');
                    }

                    const data = await response.json();

                    // Store user data in localStorage
                    localStorage.setItem('userId', data.id);



                    // Show success message
                    successMessage.textContent = 'Login successful! Redirecting...';
                    successMessage.classList.remove('hidden');

                    // Redirect after a short delay
                    setTimeout(function() {
                    if(data.role === "CUSTOMER"){
                        window.location.href = "${pageContext.request.contextPath}/";
                    }else{
                        window.location.href = "${pageContext.request.contextPath}/admin";
                    }
                    }, 1500);
                } catch (error) {
                    errorMessage.textContent = error.message || 'Login failed. Please try again.';
                    errorMessage.classList.remove('hidden');
                }
            } else {
                errorMessage.textContent = 'Please fix the errors in the form';
                errorMessage.classList.remove('hidden');
            }

            return false;
        }
    </script>
    </body>
    </html>