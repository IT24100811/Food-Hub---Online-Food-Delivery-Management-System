<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Restaurant App</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <jsp:include page="common/navbar.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-4xl font-bold text-center mb-12 text-gray-900">Admin Dashboard</h1>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <!-- User Management Box -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                <div class="p-6">
                    <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mb-4 mx-auto">
                        <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z">
                            </path>
                        </svg>
                    </div>
                    <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">User Management</h2>
                    <p class="text-gray-600 text-center mb-6">Manage user accounts, roles, and permissions</p>
                    <a href="${pageContext.request.contextPath}/user-views/list" 
                       class="block w-full bg-blue-600 text-white text-center py-3 rounded-lg hover:bg-blue-700 transition duration-200">
                        View Users
                    </a>
                </div>
            </div>

            <!-- Feedback Management Box -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                <div class="p-6">
                    <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mb-4 mx-auto">
                        <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z">
                            </path>
                        </svg>
                    </div>
                    <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">Feedback Management</h2>
                    <p class="text-gray-600 text-center mb-6">View and manage customer feedback</p>
                    <a href="${pageContext.request.contextPath}/feedback-views/list" 
                       class="block w-full bg-green-600 text-white text-center py-3 rounded-lg hover:bg-green-700 transition duration-200">
                        View Feedback
                    </a>
                </div>
            </div>

            <!-- Restaurant Management Box -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                <div class="p-6">
                    <div class="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mb-4 mx-auto">
                        <svg class="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                  d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4">
                            </path>
                        </svg>
                    </div>
                    <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">Restaurant Management</h2>
                    <p class="text-gray-600 text-center mb-6">Manage restaurant details and settings</p>
                    <a href="${pageContext.request.contextPath}/restaurant-views/manage" 
                       class="block w-full bg-purple-600 text-white text-center py-3 rounded-lg hover:bg-purple-700 transition duration-200">
                        Manage Restaurant
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>

    </script>
</body>
</html>