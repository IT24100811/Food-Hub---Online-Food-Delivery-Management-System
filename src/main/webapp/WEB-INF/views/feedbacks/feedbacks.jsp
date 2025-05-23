<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Feedback Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .star-rating {
            font-size: 24px;
            cursor: pointer;
        }
        .star-rating .fa-star {
            color: #ddd;
        }
        .star-rating .fa-star.active {
            color: #ffd700;
        }
        .feedback-card {
            transition: transform 0.2s;
        }
        .feedback-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Feedback Management</h2>
        <button class="btn btn-primary" onclick="openFeedbackModal()">
            <i class="fas fa-plus me-2"></i>Add Feedback
        </button>
    </div>

    <!-- Feedback Cards Grid -->
    <div id="feedbackGrid" class="row g-4">
        <!-- Feedback cards will be loaded here -->
    </div>
</div>

<!-- Feedback Modal -->
<div class="modal fade" id="feedbackModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Add Feedback</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="feedbackForm" onsubmit="handleSubmit(event)" class="row g-3">
                    <input type="hidden" id="feedbackId">
                    <div class="col-md-6">
                        <label for="name" class="form-label">Name</label>
                        <input type="text" class="form-control" id="name" required pattern="[A-Za-z\s]{2,50}">
                        <div class="invalid-feedback">Name must be 2-50 characters long and contain only letters</div>
                    </div>
                    <div class="col-md-6">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" required>
                        <div class="invalid-feedback">Please enter a valid email address</div>
                    </div>
                    <div class="col-md-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="phone" required pattern="[0-9]{10}">
                        <div class="invalid-feedback">Please enter a valid 10-digit phone number</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Satisfied?</label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="satisfied" id="satisfiedYes" value="Yes" required>
                                <label class="form-check-label" for="satisfiedYes">Yes</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="satisfied" id="satisfiedNo" value="No">
                                <label class="form-check-label" for="satisfiedNo">No</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Rating</label>
                        <div class="star-rating" id="starRating">
                            <i class="fas fa-star" data-rating="1"></i>
                            <i class="fas fa-star" data-rating="2"></i>
                            <i class="fas fa-star" data-rating="3"></i>
                            <i class="fas fa-star" data-rating="4"></i>
                            <i class="fas fa-star" data-rating="5"></i>
                            <i class="fas fa-star" data-rating="6"></i>
                            <i class="fas fa-star" data-rating="7"></i>
                            <i class="fas fa-star" data-rating="8"></i>
                            <i class="fas fa-star" data-rating="9"></i>
                            <i class="fas fa-star" data-rating="10"></i>
                        </div>
                        <input type="hidden" id="rating" required>
                    </div>
                    <div class="col-12">
                        <label for="message" class="form-label">Message</label>
                        <textarea class="form-control" id="message" rows="3" required minlength="10" maxlength="500"></textarea>
                        <div class="invalid-feedback">Message must be between 10 and 500 characters</div>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let feedbackModal;
    let currentFeedbackId = null;
    
    document.addEventListener('DOMContentLoaded', function() {
        feedbackModal = new bootstrap.Modal(document.getElementById('feedbackModal'));
        setupStarRating();
        loadFeedbacks();
    });

    function setupStarRating() {
        const stars = document.querySelectorAll('.star-rating .fa-star');
        stars.forEach(star => {
            star.addEventListener('mouseover', function() {
                const rating = this.dataset.rating;
                updateStars(rating);
            });
            star.addEventListener('click', function() {
                const rating = this.dataset.rating;
                document.getElementById('rating').value = rating;
                updateStars(rating);
            });
        });

        document.querySelector('.star-rating').addEventListener('mouseleave', function() {
            const currentRating = document.getElementById('rating').value || 0;
            updateStars(currentRating);
        });
    }

    function updateStars(rating) {
        document.querySelectorAll('.star-rating .fa-star').forEach(star => {
            star.classList.toggle('active', star.dataset.rating <= rating);
        });
    }

    function openFeedbackModal(feedback = null) {
        document.getElementById('feedbackForm').reset();
        document.getElementById('modalTitle').textContent = feedback ? 'Edit Feedback' : 'Add Feedback';
        document.getElementById('rating').value = '';
        updateStars(0);
        
        if (feedback) {
            currentFeedbackId = feedback.id;
            document.getElementById('name').value = feedback.name;
            document.getElementById('email').value = feedback.email;
            document.getElementById('phone').value = feedback.phone;
            document.querySelector('input[name="satisfied"][value="' + feedback.satisfied + '"]').checked = true;

            document.getElementById('rating').value = feedback.rating;
            document.getElementById('message').value = feedback.message;
            updateStars(feedback.rating);
        } else {
            currentFeedbackId = null;
        }
        
        feedbackModal.show();
    }

    async function loadFeedbacks() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/api/feedbacks');
            const feedbacks = await response.json();
            const grid = document.getElementById('feedbackGrid');

            grid.innerHTML = feedbacks.map(function(feedback) {
                return (
                    '<div class="col-md-6 col-lg-4">' +
                    '<div class="card feedback-card h-100">' +
                    '<div class="card-body">' +
                    '<div class="d-flex justify-content-between align-items-start mb-3">' +
                    '<h5 class="card-title">' + feedback.name + '</h5>' +
                    '<span class="badge bg-' + (feedback.satisfied === 'Yes' ? 'success' : 'warning') + '">' +
                    feedback.satisfied +
                    '</span>' +
                    '</div>' +
                    '<p class="card-text">' + feedback.message + '</p>' +
                    '<div class="mb-3">' +
                    Array(10).fill().map(function(_, i) {
                        return (
                            '<i class="fas fa-star ' + (i < feedback.rating ? 'active' : '') + '" style="color: ' + (i < feedback.rating ? '#ffd700' : '#ddd') + '"></i>'
                        );
                    }).join('') +
                    '</div>' +
                    '<div class="text-muted small mb-3">' +
                    '<div>' + feedback.email + '</div>' +
                    '<div>' + feedback.phone + '</div>' +
                    '</div>' +
                    '<div class="d-flex justify-content-end gap-2">' +
                    '<button class="btn btn-outline-primary btn-sm" onclick=\'openFeedbackModal(' + JSON.stringify(feedback) + ')\'' +
                    '><i class="fas fa-edit me-1"></i>Edit</button>' +
                    '<button class="btn btn-outline-danger btn-sm" onclick="deleteFeedback(\'' + feedback.id + '\')">' +
                    '<i class="fas fa-trash me-1"></i>Delete</button>' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>'
                );
            }).join('');

        } catch (error) {
            console.error('Error loading feedbacks:', error);
            alert('Failed to load feedbacks');
        }
    }

    async function handleSubmit(event) {
        event.preventDefault();
        const form = event.target;
        
        if (!form.checkValidity()) {
            event.stopPropagation();
            form.classList.add('was-validated');
            return;
        }

        const feedback = {
            name: document.getElementById('name').value,
            email: document.getElementById('email').value,
            phone: document.getElementById('phone').value,
            satisfied: document.querySelector('input[name="satisfied"]:checked').value,
            rating: parseInt(document.getElementById('rating').value),
            message: document.getElementById('message').value
        };

        try {
            const url = currentFeedbackId 
                ? `${pageContext.request.contextPath}/api/feedbacks/`+currentFeedbackId
                : `${pageContext.request.contextPath}/api/feedbacks`;
                
            const response = await fetch(url, {
                method: currentFeedbackId ? 'PUT' : 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(feedback)
            });

            if (response.ok) {
                feedbackModal.hide();
                loadFeedbacks();
                form.reset();
                form.classList.remove('was-validated');
            } else {
                throw new Error('Failed to save feedback');
            }
        } catch (error) {
            console.error('Error saving feedback:', error);
            alert('Failed to save feedback');
        }
    }

    async function deleteFeedback(id) {
        if (!confirm('Are you sure you want to delete this feedback?')) {
            return;
        }

        try {
            const response = await fetch(`${pageContext.request.contextPath}/api/feedbacks/`+id, {
                method: 'DELETE'
            });

            if (response.ok) {
                loadFeedbacks();
            } else {
                throw new Error('Failed to delete feedback');
            }
        } catch (error) {
            console.error('Error deleting feedback:', error);
            alert('Failed to delete feedback');
        }
    }
</script>

</body>
</html>