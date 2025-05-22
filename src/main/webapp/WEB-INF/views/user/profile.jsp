<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div id="alertContainer" class="mb-4"></div>
        <h2 class="text-3xl font-bold mb-6 text-gray-900">User Profile</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6" id="profileContent">
            <!-- Content will be loaded dynamically -->
        </div>
        
        <div class="mt-8 space-x-4">
            <button class="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 transition duration-200" 
                    onclick="editProfile()">Edit Profile</button>
            <button class="bg-red-500 text-white px-6 py-2 rounded-lg hover:bg-red-600 transition duration-200" 
                    onclick="confirmDelete()">Delete Account</button>
            <button class="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 transition duration-200" 
                    onclick="confirmLogout()">Logout</button>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-white"></div>
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
                "<path d=\"M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z\"/>" +
                "</svg>" +
                "</span>" +
                "</div>";

        }

        async function loadProfile() {
            showLoading();
            try {
                const response = await fetch(`${pageContext.request.contextPath}/api/users/`+userId);
                if (!response.ok) throw new Error('Failed to load profile');
                const user = await response.json();

                document.getElementById('profileContent').innerHTML =
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">Full Name</h4>" +
                    "<p class=\"text-gray-600\">" + user.fullName + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">Email</h4>" +
                    "<p class=\"text-gray-600\">" + user.email + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">Phone Number</h4>" +
                    "<p class=\"text-gray-600\">" + user.phoneNumber + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">Role</h4>" +
                    "<p class=\"text-gray-600\">" + user.role + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">Address</h4>" +
                    "<p class=\"text-gray-600\">" + user.address + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">Account Status</h4>" +
                    "<p class=\"text-gray-600\">" + user.accountStatus + "</p>" +
                    "</div>";

            } catch (error) {
                showAlert('Error loading profile: ' + error.message, 'danger');
            } finally {
                hideLoading();
            }
        }

        function editProfile() {
            window.location.href = "${pageContext.request.contextPath}/user-views/edit/" + userId;
        }

        async function deleteProfile() {
            showLoading();
            try {
                const response = await fetch(`${pageContext.request.contextPath}/api/users/`+userId, {
                    method: 'DELETE'
                });
                if (!response.ok) throw new Error('Failed to delete account');
                localStorage.removeItem('userId');
                window.location.href = "${pageContext.request.contextPath}/user-views/login";
            } catch (error) {
                showAlert('Error deleting account: ' + error.message, 'danger');
                hideLoading();
            }
        }

        function confirmDelete() {
            if (confirm("Are you sure you want to delete your account? This action cannot be undone.")) {
                deleteProfile();
            }
        }

        function confirmLogout() {
            if (confirm("Are you sure you want to logout?")) {
                localStorage.removeItem('userId');
                window.location.href = "${pageContext.request.contextPath}/user-views/login";
            }
        }

        // Load profile when page loads
        document.addEventListener('DOMContentLoaded', loadProfile);
    </script>
</body>
</html>