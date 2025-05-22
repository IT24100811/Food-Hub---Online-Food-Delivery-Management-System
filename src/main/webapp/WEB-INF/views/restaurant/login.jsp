<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Restaurant Login - Restaurant App</title>
    <link
      href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
      rel="stylesheet"
    />
  </head>
  <body class="bg-gray-100 min-h-screen">
    <jsp:include page="../common/navbar.jsp" />

    <!-- Loading Overlay -->
    <div
      id="loadingOverlay"
      class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50"
    >
      <div
        class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-white"
      ></div>
    </div>

    <div class="container mx-auto px-4 py-8">
      <div
        class="max-w-md mx-auto bg-white rounded-lg shadow-lg overflow-hidden"
      >
        <div class="py-4 px-6 bg-gray-800 text-white text-center">
          <h2 class="text-2xl font-bold">Restaurant Login</h2>
        </div>

        <form id="loginForm" class="py-6 px-8">
          <!-- Error message area -->
          <div
            id="errorMessage"
            class="hidden bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4"
          ></div>

          <!-- Success message area -->
          <div
            id="successMessage"
            class="hidden bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4"
          ></div>

          <!-- Username field -->
          <div class="mb-4">
            <label
              for="username"
              class="block text-gray-700 text-sm font-bold mb-2"
              >Username</label
            >
            <input
              type="text"
              id="username"
              name="username"
              class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black"
              required
            />
          </div>

          <!-- Password field -->
          <div class="mb-6">
            <label
              for="password"
              class="block text-gray-700 text-sm font-bold mb-2"
              >Password</label
            >
            <input
              type="password"
              id="password"
              name="password"
              class="w-full border border-gray-300 rounded px-4 py-3 focus:outline-none focus:ring-2 focus:ring-black"
              required
            />
          </div>

          <!-- Submit button -->
          <div class="mb-6">
            <button
              type="submit"
              class="w-full bg-black hover:bg-gray-800 text-white font-bold py-3 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-gray-500 transition duration-200"
            >
              Sign In
            </button>
          </div>

          <!-- Register link -->
          <div class="text-center">
            <p class="text-sm text-gray-600">
              Don't have a restaurant account?
              <a
                href="${pageContext.request.contextPath}/restaurant-views/create"
                class="text-gray-800 hover:text-black font-medium"
                >Register now</a
              >
            </p>
          </div>
        </form>
      </div>
    </div>

    <script>
      document
        .getElementById("loginForm")
        .addEventListener("submit", async (e) => {
          e.preventDefault();

          // Show loading overlay
          const loadingOverlay = document.getElementById("loadingOverlay");
          loadingOverlay.style.display = "flex";

          // Reset messages
          document.getElementById("errorMessage").classList.add("hidden");
          document.getElementById("successMessage").classList.add("hidden");

          const username = document.getElementById("username").value;
          const password = document.getElementById("password").value;

          try {
            const response = await fetch(
            
                "/api/restaurants/login?username=" +
                encodeURIComponent(username) +
                "&password=" +
                encodeURIComponent(password),
              {
                method: "POST",
                headers: {
                  "Content-Type": "application/x-www-form-urlencoded",
                },
              }
            );

            if (!response.ok) {
              throw new Error("Invalid credentials");
            }

            const data = await response.json();

            // Store restaurant ID in localStorage
            localStorage.setItem("restaurantId", data.id);

            // Show success message
            const successMessage = document.getElementById("successMessage");
            successMessage.textContent = "Login successful! Redirecting...";
            successMessage.classList.remove("hidden");

            // Redirect after a short delay
            setTimeout(() => {
              window.location.href =
                "${pageContext.request.contextPath}/restaurant-views/dashboard";
            }, 1500);
          } catch (error) {
            const errorMessage = document.getElementById("errorMessage");
            errorMessage.textContent =
              error.message || "Login failed. Please try again.";
            errorMessage.classList.remove("hidden");
          } finally {
            // Hide loading overlay
            loadingOverlay.style.display = "none";
          }
        });
    </script>
  </body>
</html>
