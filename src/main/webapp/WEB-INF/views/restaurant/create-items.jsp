<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Food Items</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body class="bg-light">
<div class="container py-5">
    <h1 class="mb-4">Manage Food Items</h1>

    <button type="button" class="btn btn-dark mb-3" data-bs-toggle="modal" data-bs-target="#foodModal">
        <i class="fas fa-plus"></i> Add Food Item
    </button>

    <div class="modal fade" id="foodModal" tabindex="-1" aria-labelledby="foodModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="foodItemForm">
                    <div class="modal-header">
                        <h5 class="modal-title" id="foodModalLabel">Add/Edit Food Item</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Name</label>
                            <input type="text" id="name" name="name" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Price</label>
                            <input type="number" id="price" name="price" step="0.01" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <select id="category" name="category" class="form-select" required>
                                <option value="">Select Category</option>
                                <option value="Main Course">Main Course</option>
                                <option value="Appetizer">Appetizer</option>
                                <option value="Dessert">Dessert</option>
                                <option value="Beverage">Beverage</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Cuisine</label>
                            <input type="text" id="cuisine" name="cuisine" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="3"></textarea>
                        </div>
                        <input type="hidden" id="restaurantId" name="restaurantId">
                        <input type="hidden" id="itemId" name="itemId">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="loadingState" class="text-center my-4 d-none">
        <div class="spinner-border text-dark" role="status"></div>
        <p class="mt-2">Loading...</p>
    </div>

    <div id="itemsList" class="row g-3"></div>
</div>

<script>
    let currentRestaurantId = '';

    document.addEventListener('DOMContentLoaded', function () {
        currentRestaurantId = localStorage.getItem('restaurantId');
        if (!currentRestaurantId) {
            window.location.href = "${pageContext.request.contextPath}/restaurant-views/login";
            return;
        }
        document.getElementById('restaurantId').value = currentRestaurantId;
        loadFoodItems();
        document.getElementById('foodItemForm').addEventListener('submit', handleFormSubmit);
    });

    function showLoading(show) {
        document.getElementById('loadingState').classList.toggle('d-none', !show);
    }

    async function loadFoodItems() {
        try {
            showLoading(true);
            const response = await fetch("${pageContext.request.contextPath}/api/food/restaurant/" + currentRestaurantId);
            const items = await response.json();
            renderFoodItems(items);
        } catch (error) {
            console.error("Error loading food items:", error);
        } finally {
            showLoading(false);
        }
    }

    function renderFoodItems(items) {
        const container = document.getElementById('itemsList');
        container.innerHTML = items.map(function(item) {
            return "<div class=\"col-md-4\">" +
                "<div class=\"card shadow-sm\">" +
                "<div class=\"card-body\">" +
                "<h5 class=\"card-title\">" + item.name + "</h5>" +
                "<p class=\"card-text\">" + (item.description || "No description") + "</p>" +
                "<p class=\"card-text fw-bold\">$" + item.price.toFixed(2) + "</p>" +
                "<p>" +
                "<span class=\"badge bg-secondary\">" + item.category + "</span> " +
                "<span class=\"badge bg-info text-dark\">" + item.cuisine + "</span>" +
                "</p>" +
                "<div class=\"d-flex justify-content-end gap-2\">" +
                "<button class=\"btn btn-outline-primary btn-sm\" onclick='editItem(" + JSON.stringify(item) + ")'>" +
                "<i class=\"fas fa-edit\"></i> Edit</button>" +
                "<button class=\"btn btn-outline-danger btn-sm\" onclick=\"deleteItem('" + item.id + "')\">" +
                "<i class=\"fas fa-trash\"></i> Delete</button>" +
                "</div></div></div></div>";
        }).join("");
    }

    async function handleFormSubmit(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData.entries());
        try {
            showLoading(true);
            const url = data.itemId
                ? "${pageContext.request.contextPath}/api/food/" + data.itemId
                : "${pageContext.request.contextPath}/api/food";
            const method = data.itemId ? "PUT" : "POST";

            const response = await fetch(url, {
                method: method,
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(data)
            });

            if (response.ok) {
                bootstrap.Modal.getInstance(document.getElementById("foodModal")).hide();
                resetForm();
                loadFoodItems();
            }
        } catch (error) {
            console.error("Error saving food item:", error);
        } finally {
            showLoading(false);
        }
    }

    function editItem(item) {
        document.getElementById("itemId").value = item.id;
        document.getElementById("name").value = item.name;
        document.getElementById("price").value = item.price;
        document.getElementById("category").value = item.category;
        document.getElementById("cuisine").value = item.cuisine;
        document.getElementById("description").value = item.description || "";
        new bootstrap.Modal(document.getElementById("foodModal")).show();
    }

    async function deleteItem(id) {
        if (!confirm("Are you sure you want to delete this item?")) return;
        try {
            showLoading(true);
            const response = await fetch("${pageContext.request.contextPath}/api/food/" + id, {
                method: "DELETE"
            });
            if (response.ok) loadFoodItems();
        } catch (error) {
            console.error("Error deleting food item:", error);
        } finally {
            showLoading(false);
        }
    }

    function resetForm() {
        document.getElementById("foodItemForm").reset();
        document.getElementById("itemId").value = "";
    }
</script>
</body>
</html>
