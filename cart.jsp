<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="style.css">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="shortcut icon" type="image/x-icon" href="images/logo.svg" />
  <%@ page language="java" import="javax.servlet.*,javax.servlet.http.*,java.sql.*,java.util.*" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8" session="false" %>
      <title>Cart</title>
</head>

<body style="display: block; padding: 0%;">
  <% try { HttpSession session=request.getSession(false); if (session==null) { response.sendRedirect("index.jsp"); }
    else if (session.getAttribute("userType").toString().equals("Admin")) { response.sendRedirect("home.jsp"); } else if (session.getAttribute("userType").toString().equals("Customer")) {
      HashMap<Integer, HashMap<String, Object>> cart = (HashMap<Integer, HashMap<String, Object>>) session.getAttribute("cart"); double totalAmount = 0.0;
      %>

      <nav class="navbar border-bottom border-body"
        style="height: 8vh; background: linear-gradient(to bottom, rgba(0, 0, 0, 0.894), rgba(0, 0, 0, 0.718));"
        data-bs-theme="dark">
        <div class="container-fluid">
          <div class="d-flex justify-content-center align-items-center">
            <a href="home.jsp"><img style="height: 30px; width: 30px; margin-right: 7px;" src="images/home.png"
                alt="home"></a>
            <a class="navbar-brand" style="font-weight: 900;">
              <%= session.getAttribute("name").toString() %>
            </a>
          </div>
          <form class="d-flex flex-row" role="search">
            <input class="form-control me-2" style="width: 400px;" type="search" placeholder="Search product category"
              aria-label="Search" disabled>
            <button class="btn btn-outline-success" type="button" disabled>Search</button>
          </form>
          <div class="d-flex align-items-center">
            <a style="margin-right: 15px;" href="cart.jsp"><img style="height: 30px;" src="images/cart.png"
                alt="cart"></a>
            <form action="Logout" method="POST">
              <button class="btn btn-outline-danger" type="submit">Logout</button>
            </form>
          </div>
        </div>
      </nav>
      <section class="container my-5" style="max-height: 80vh; overflow: scroll;">
        <table class="table table-dark table-striped" style="text-align: center; border: 1px solid black;">
          <thead style="font-size: large;">
            <tr>
              <th scope="col">#</th>
              <th scope="col">Name</th>
              <th scope="col">Category</th>
              <th scope="col">Quantity Ordered</th>
              <th scope="col">Price</th>
              <th scope="col">Total Amount</th>
              <th scope="col">Action</th>
            </tr>
          </thead>
          <tbody>
            <% if (cart !=null) { int i=1; for (Integer productID : cart.keySet()) { HashMap<String, Object> details =
              cart.get(productID); totalAmount += ((Number) details.get("price")).doubleValue() * ((Number)
              details.get("count")).doubleValue();
              %>
              <tr>
                <th scope="row" style="vertical-align: middle;">
                  <%= i++ %>
                </th>
                <td style="vertical-align: middle;">
                  <%= details.get("name") %>
                </td>
                <td style="vertical-align: middle;">
                  <%= details.get("category") %>
                </td>
                <td style="vertical-align: middle;">
                  <%= details.get("count") %>
                </td>
                <td style="vertical-align: middle;">
                  $<%= details.get("price") %>
                </td>
                <td style="vertical-align: middle;">
                  $<%= Math.ceil(((Number) details.get("price")).doubleValue() * ((Number)
                    details.get("count")).doubleValue()) %>
                </td>
                <td>
                  <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="modal"
                    data-bs-target="#editModal<%=productID%>">Edit</button>
                  <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal"
                    data-bs-target="#deleteModal<%=productID%>">Delete</button>

                  <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="editModal<%=productID%>"
                    tabindex="-1" aria-labelledby="editModalLabel<%=productID%>" aria-hidden="true">
                    <div class="modal-dialog">
                      <form action="EditOrDelete" method="POST">
                        <input type="hidden" name="productID" value="<%=productID%>">
                        <div class="modal-content" style="background-color: rgb(43, 38, 38);">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="editModalLabel<%=productID%>">Edit quantity of
                              <%=details.get("name")%>
                            </h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <div class="d-flex justify-content-center align-items-center">
                              <button type="button" class="btn btn-outline-danger d-flex align-items-center"
                                style="height: 25px; padding: 8px;"
                                onclick="document.getElementById('count<%=productID%>').value = parseInt(document.getElementById('count<%=productID%>').value) > 1 ? parseInt(document.getElementById('count<%=productID%>').value) - 1 : 1">-</button>
                              <input class="m-2"
                                style="width: 50px; padding: 0px 3px; outline: none; border: 1px solid floralwhite; border-radius: 5px; background: rgb(43 38 38); color: white; font-weight: 400;"
                                type="number" name="count" id="count<%=productID%>" value=<%=details.get("count")%>
                              min="1">
                              <button type="button" class="btn btn-outline-success d-flex align-items-center"
                                style="height: 25px; padding: 8px;"
                                onclick="document.getElementById('count<%=productID%>').value = parseInt(document.getElementById('count<%=productID%>').value) + 1">+</button>
                            </div>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" name="actionType" value="update" class="btn btn-success">Update
                              Quantity</button>
                          </div>
                        </div>
                      </form>
                    </div>
                  </div>

                  <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="deleteModal<%=productID%>"
                    tabindex="-1" aria-labelledby="deleteModalLabel<%=productID%>" aria-hidden="true">
                    <div class="modal-dialog">
                      <form action="EditOrDelete" method="POST">
                        <input type="hidden" name="productID" value="<%=productID%>">
                        <div class="modal-content" style="background-color: rgb(43, 38, 38);">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="deleteModalLabel<%=productID%>">Delete product
                              <%=details.get("name")%> from cart
                            </h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <h6>Are you sure you want to delete it?</h6>
                            <p>This operation can't be undone.</p>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" name="actionType" value="delete" class="btn btn-danger">Delete
                              Product</button>
                          </div>
                        </div>
                      </form>
                    </div>
                  </div>


                </td>
              </tr>
              <% } } else { %>
                <tr>
                  <td colspan="8" style="vertical-align: middle;">No items in cart</td>
                </tr>
                <% } %>
          </tbody>
        </table>
        <div>
          <div class="d-flex justify-content-between align-items-center container mt-2">
            <h3
              style="width: 300px; padding: 6px; text-align: center; border: 2px solid black; border-radius: 10px; background-color: #212529; color: white; font-size: 20px;">
              Total Amount: <strong>$<%=Math.ceil(totalAmount)%></strong></h3>
            <div class="d-flex justify-content-end container mt-2">
              <form action="ListItems" method="GET" style="margin-right: 20px;">
                <button class="btn btn-info" type="submit">Gor back to store</button>
              </form>
              <% if(cart !=null) { %>
                <form action="PlaceOrder" method="POST">
                  <button class="btn btn-success" type="submit">Place Order</button>
                </form>
                <% } else { %>
                  <button class="btn btn-success" type="button" disabled>Place Order</button>
                  <% } %>
            </div>
          </div>
        </div>
      </section>
      <% } else { response.sendRedirect("index.jsp"); } } catch (Exception e) { %>
        <div>Error Occurred: <%= e.getMessage() %>
        </div>
        <% } %>
          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</body>

</html>