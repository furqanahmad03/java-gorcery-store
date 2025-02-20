<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Online Grocery Store</title>
  <link rel="stylesheet" href="style.css">
  <link rel="shortcut icon" type="image/x-icon" href="images/logo.svg" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <%@ page language="java" import="javax.servlet.*,javax.servlet.http.*,java.sql.*" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" session="false" %>
</head>

<body>
  <div class="wrapper">
    <!-- Login Form -->
    <form id="loginForm" action="getAuthentication" method="POST">
      <h2>Login</h2>
      <div class="input-field">
        <input type="text" name="email" required>
        <label>Enter your email</label>
      </div>
      <div class="input-field">
        <input type="password" name="password" required>
        <label>Enter your password</label>
      </div>
      <div style="color: white; text-align: start; margin: 5px 0px; margin-bottom: 20px;">
        <label>
          <input type="radio" name="userType" value="Customer" required> As Customer
        </label>
        <br>
        <label>
          <input type="radio" name="userType" value="Admin"> As admin
        </label>
      </div>
      <button type="submit" name="actionType" value="login">Log In</button>
      <div class="login">
        <p>Don't have an account? <button class="toggleButton" type="button">Register</button></p>
      </div>

    </form>

    <!-- Register Form -->
    <form class="hidden" id="registerForm" action="getAuthentication" method="POST">
      <h2>Sign Up</h2>
      <div style="display: flex;">
        <div class="input-field" style="width: 48%; margin-right: 3px;">
          <input type="text" name="fname" required>
          <label>First Name</label>
        </div>
        <div class="input-field" style="width: 48%; margin-left: 3px;">
          <input type="text" name="lname" required>
          <label>Last Name</label>
        </div>
      </div>
      <div class="input-field">
        <input type="text" name="address" required>
        <label>Address</label>
      </div>
      <div class="input-field">
        <input type="text" name="email" required>
        <label>Enter your email</label>
      </div>
      <div class="input-field">
        <input type="password" name="password" required>
        <label>Enter your password</label>
      </div>
      <button type="submit" name="actionType" value="register">Sign Up</button>
      <div class="register">
        <p>Already have an account? <button class="toggleButton" type="button">Sign In</button></p>
      </div>
    </form>

  </div>
</body>

<!-- <script type="module" src="index.js"></script> -->
<script>
  $(document).ready(function () {
    $('.toggleButton').click(function () {
      if ($('#loginForm').is(':visible')) {
        $('#loginForm').fadeOut(300, function () {
          $('#registerForm').fadeIn(300);
        });
      } else {
        $('#registerForm').fadeOut(300, function () {
          $('#loginForm').fadeIn(300);
        });
      }
    });
  });
</script>

</html>