<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">

    
    <div class="container mx-auto px-4 py-8">
        <div id="alertContainer" class="mb-4"></div>
        <h2 class="text-3xl font-bold mb-6 text-gray-900">Restaurant Profile</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6" id="profileContent">
            <!-- Content will be loaded dynamically -->
        </div>
        
        <div class="mt-8 space-x-4">
            <button class="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 transition duration-200" 
                    onclick="openEditModal()">
                <i class="fas fa-edit mr-2"></i>Edit Profile
            </button>
            <button class="bg-red-500 text-white px-6 py-2 rounded-lg hover:bg-red-600 transition duration-200" 
                    onclick="confirmDelete()">
                <i class="fas fa-trash mr-2"></i>Delete Account
            </button>
            <button class="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 transition duration-200" 
                    onclick="confirmLogout()">
                <i class="fas fa-sign-out-alt mr-2"></i>Logout
            </button>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Restaurant Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editForm">
                        <div class="mb-3">
                            <label class="form-label">Restaurant Name</label>
                            <input type="text" class="form-control" id="name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Cuisine</label>
                            <input type="text" class="form-control" id="cuisine" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Location</label>
                            <input type="text" class="form-control" id="location" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Type</label>
                            <select class="form-control" id="type" required>
                                <option value="Veg">Vegetarian</option>
                                <option value="Non-Veg">Non-Vegetarian</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="updateProfile()">Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-white"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const restaurantId = localStorage.getItem('restaurantId');
        if (!restaurantId) {
            window.location.href = "${pageContext.request.contextPath}/restaurant-views/login";
        }

        let editModal;

        document.addEventListener('DOMContentLoaded', () => {
            editModal = new bootstrap.Modal(document.getElementById('editModal'));
            loadProfile();
        });

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
                const response = await fetch("${pageContext.request.contextPath}" + "/api/restaurants/" + restaurantId);
                if (!response.ok) throw new Error("Failed to load profile");
                const restaurant = await response.json();

                document.getElementById("profileContent").innerHTML =
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">" +
                    "<i class=\"fas fa-store mr-2\"></i>Restaurant Name" +
                    "</h4>" +
                    "<p class=\"text-gray-600\">" + restaurant.name + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">" +
                    "<i class=\"fas fa-utensils mr-2\"></i>Cuisine" +
                    "</h4>" +
                    "<p class=\"text-gray-600\">" + restaurant.cuisine + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">" +
                    "<i class=\"fas fa-map-marker-alt mr-2\"></i>Location" +
                    "</h4>" +
                    "<p class=\"text-gray-600\">" + restaurant.location + "</p>" +
                    "</div>" +
                    "<div class=\"bg-white p-6 rounded-lg shadow-md\">" +
                    "<h4 class=\"text-lg font-semibold text-gray-700 mb-2\">" +
                    "<i class=\"fas fa-leaf mr-2\"></i>Type" +
                    "</h4>" +
                    "<p class=\"text-gray-600\">" + restaurant.type + "</p>" +
                    "</div>";


            } catch (error) {
                showAlert('Error loading profile: ' + error.message, 'danger');
            } finally {
                hideLoading();
            }
        }

        function openEditModal() {
            showLoading();
            fetch(`${pageContext.request.contextPath}/api/restaurants/`+restaurantId)
                .then(response => response.json())
                .then(restaurant => {
                    document.getElementById('name').value = restaurant.name;
                    document.getElementById('cuisine').value = restaurant.cuisine;
                    document.getElementById('location').value = restaurant.location;
                    document.getElementById('type').value = restaurant.type;
                    hideLoading();
                    editModal.show();
                })
                .catch(error => {
                    hideLoading();
                    showAlert('Error loading restaurant data: ' + error.message, 'danger');
                });
        }

        async function updateProfile() {
            showLoading();
            try {
                const exisyingRes =await       fetch(`${pageContext.request.contextPath}/api/restaurants/`+restaurantId);
                if (!exisyingRes.ok) throw new Error('Failed to load user data');
                const exRes = await exisyingRes.json();


                const updatedData = {
                    name: document.getElementById('name').value,
                    cuisine: document.getElementById('cuisine').value,
                    location: document.getElementById('location').value,
                    type: document.getElementById('type').value,
                    password:exRes?.password ?? "",
                    username : exRes?.username ?? ""
                };

                const response = await fetch(`${pageContext.request.contextPath}/api/restaurants/`+restaurantId, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(updatedData)
                });

                if (!response.ok) throw new Error('Failed to update profile');
                
                editModal.hide();
                showAlert('Profile updated successfully!', 'success');
                loadProfile();
            } catch (error) {
                showAlert('Error updating profile: ' + error.message, 'danger');
            } finally {
                hideLoading();
            }
        }

        function confirmDelete() {
            if (confirm("Are you sure you want to delete your restaurant account? This action cannot be undone.")) {
                deleteProfile();
            }
        }

        async function deleteProfile() {
            showLoading();
            try {
                const response = await fetch(`${pageContext.request.contextPath}/api/restaurants/`+restaurantId, {
                    method: 'DELETE'
                });
                if (!response.ok) throw new Error('Failed to delete account');
                localStorage.removeItem('restaurantId');
                window.location.href = "${pageContext.request.contextPath}/restaurant-views/login";
            } catch (error) {
                showAlert('Error deleting account: ' + error.message, 'danger');
                hideLoading();
            }
        }

        function confirmLogout() {
            if (confirm("Are you sure you want to logout?")) {
                localStorage.removeItem('restaurantId');
                window.location.href = "${pageContext.request.contextPath}/restaurant-views/login";
            }
        }
    </script>
</body>
</html>