<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Restaurant - Restaurant App</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <jsp:include page="../common/navbar.jsp" />
    
    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-white"></div>
    </div>

    <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-lg p-8">
            <h2 class="text-3xl font-bold mb-8 text-center text-gray-900">Create Restaurant</h2>
            
            <!-- Alert Container -->
            <div id="alertContainer" class="mb-4"></div>
            
            <form id="createRestaurantForm" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Restaurant Name</label>
                    <input type="text" id="name" name="name" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required pattern="^[a-zA-Z0-9\s]{2,50}$">
                    <span class="text-red-500 text-sm hidden mt-1" id="nameError">Please enter a valid restaurant name (2-50 characters)</span>
                </div>
                
                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Cuisine</label>
                    <input type="text" id="cuisine" name="cuisine" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required pattern="^[a-zA-Z\s]{2,30}$">
                    <span class="text-red-500 text-sm hidden mt-1" id="cuisineError">Please enter a valid cuisine type (2-30 characters)</span>
                </div>

                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Location</label>
                    <input type="text" id="location" name="location" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required pattern="^[a-zA-Z0-9\s,.-]{5,100}$">
                    <span class="text-red-500 text-sm hidden mt-1" id="locationError">Please enter a valid location (5-100 characters)</span>
                </div>

                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Type</label>
                    <select id="type" name="type" 
                            class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                            required>
                        <option value="">Select Type</option>
                        <option value="Veg">Vegetarian</option>
                        <option value="Non-Veg">Non-Vegetarian</option>
                    </select>
                    <span class="text-red-500 text-sm hidden mt-1" id="typeError">Please select a restaurant type</span>
                </div>

                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Username</label>
                    <input type="text" id="username" name="username" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required pattern="^[a-zA-Z0-9]{4,20}$">
                    <span class="text-red-500 text-sm hidden mt-1" id="usernameError">Username must be 4-20 characters (letters and numbers only)</span>
                </div>

                <div>
                    <label class="block text-gray-700 text-sm font-medium mb-2">Password</label>
                    <input type="password" id="password" name="password" 
                           class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black focus:border-transparent" 
                           required pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$">
                    <span class="text-red-500 text-sm hidden mt-1" id="passwordError">Password must be at least 8 characters with letters and numbers</span>
                </div>

                <div class="col-span-2 text-center">
                    <button type="submit" 
                            class="bg-black text-white px-8 py-3 rounded-lg hover:bg-gray-800 transition duration-200">
                        Create Restaurant
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('createRestaurantForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            // Show loading overlay
            const loadingOverlay = document.getElementById('loadingOverlay');
            loadingOverlay.style.display = 'flex';
            
            // Reset all error messages
            document.querySelectorAll('span[id$="Error"]').forEach(span => span.classList.add('hidden'));
            
            // Get form data
            const formData = {
                name: document.getElementById('name').value,
                cuisine: document.getElementById('cuisine').value,
                location: document.getElementById('location').value,
                type: document.getElementById('type').value,
                username: document.getElementById('username').value,
                password: document.getElementById('password').value
            };
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/restaurants', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(formData)
                });
                
                if (response.ok) {
                    // Show success message
                    showAlert('Restaurant created successfully!', 'success');
                    // Reset form
                    e.target.reset();
                } else {
                    showAlert('Failed to create restaurant. Please try again.', 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showAlert('An error occurred. Please try again later.', 'error');
            } finally {
                // Hide loading overlay
                loadingOverlay.style.display = 'none';
            }
        });

        // Form validation
        const inputs = document.querySelectorAll('input[pattern]');
        inputs.forEach(input => {
            input.addEventListener('input', () => {
                const errorSpan = document.getElementById(input.id + "Error");
                if (input.validity.patternMismatch || input.validity.valueMissing) {
                    errorSpan.classList.remove('hidden');
                } else {
                    errorSpan.classList.add('hidden');
                }
            });
        });

        // Show alert function
        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const alertClass = type === 'success' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';

            alertContainer.innerHTML =
                "<div class=\"p-4 rounded-lg " + alertClass + "\">" +
                message +
                "</div>";


            // Clear alert after 5 seconds
            setTimeout(() => {
                alertContainer.innerHTML = '';
            }, 5000);
        }
    </script>
</body>
</html>