<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="style.css">
  <%@ page language="java" import="javax.servlet.*,javax.servlet.http.*,java.sql.*" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" session="false" %>
      <link rel="shortcut icon" type="image/x-icon" href="images/logo.svg" />
      <title>Orders List</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>

<style>
  .hidden {
    opacity: 0;
    display: none;
    transition: opacity 1s ease, visibility 1s ease;
  }

  .visible {
    opacity: 1;
    display: table-row-group;
    transition: opacity 1s ease, visibility 1s ease;
  }
</style>


<body style="display: block; padding: 0%;">

  <% try{ HttpSession session=request.getSession(false); if (session==null) { response.sendRedirect("index.jsp"); } else
    if (session.getAttribute("userType").toString().equals("Admin")) { %>

    <nav class="navbar border-bottom border-body"
      style="height: 8vh; background: linear-gradient(to bottom, rgba(0, 0, 0, 0.894), rgba(0, 0, 0, 0.718));"
      data-bs-theme="dark">
      <div class="container-fluid">
        <div class="d-flex justify-content-center align-items-center">
          <a href="home.jsp"><img style="height: 30px; width: 30px; margin-right: 7px;" src="images/home.png"
              alt="home"></a>
          <a class="navbar-brand" style="font-weight: 900;">
            <%=session.getAttribute("name").toString()%>
          </a>
        </div>
        <form action="SearchProductCategory" method="POST" class="d-flex flex-row" role="search">
          <input class="form-control me-2" style="width: 400px;" type="search" placeholder="Search product category"
            aria-label="Search" disabled>
          <button class="btn btn-outline-success" type="submit" disabled>Search</button>
        </form>

        <div class="d-flex align-items-center">
          <a style="margin-right: 15px;" href="orderList.jsp"><img style="height: 30px;" src="images/view-orders.png"
              alt="cart"></a>
          <form action="Logout" method="POST">
            <button class="btn btn-outline-danger" type="submit">Logout</button>
          </form>
        </div>
      </div>
    </nav>

    <section class="container my-5" style="max-height: 80vh; overflow: scroll;">
      <div class="d-flex justify-content-between">
        <form action="ListItems" method="GET" style="margin-bottom: 15px;">
          <button class="btn btn-success" style="max-width: max-content;" type="submit">Gor to store</button>
        </form>
        <div class="navigation">
          <button type="button" id="all" class="btn btn-info" onclick="showAll()">All</button>
          <button type="button" id="progress" class="btn btn-outline-info" onclick="showInProgressOrders()">In Progress Orders</button>
          <button type="button" id="dispatch" class="btn btn-outline-info" onclick="showDispatchedOrders()">Dispatched Orders</button>
          <button type="button" id="reject" class="btn btn-outline-info" onclick="showRejectedOrders()">Rejected Orders</button>
        </div>
        <div></div>
      </div>
      
    <table class="table table-dark table-striped" style="text-align: center; border: 1px solid black;">
      <thead style="font-size: large;">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Order #</th>
          <th scope="col">Info</th>
          <th scope="col">Name</th>
          <th scope="col">Category</th>
          <th scope="col">Price</th>
          <th scope="col">Quantity Ordered</th>
          <th scope="col">Total Amount</th>
          <th scope="col">Status</th>
        </tr>
      </thead>
      <%
      Connection connection = null;
      PreparedStatement ps = null;
      ResultSet result = null;

      try {
          Class.forName("com.mysql.jdbc.Driver");
          String url = "jdbc:mysql://127.0.0.1:3306/Project";
          connection = DriverManager.getConnection(url, "root", "root");
      %>
      <tbody class="visible" id="allTable">
      <%
          ps = connection.prepareStatement("SELECT C.address, C.fname, C.lname, SI.order_no, SI.email, SI.product_id, SI.price, SI.quantity, SI.price, SI.total_amount, SI.status, P.name, P.category FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email)");
          result = ps.executeQuery();
          if(result.next()) {
          int i = 1;
          do {
      %>
          <tr>
            <th scope="row" style="vertical-align: middle;">
              <%= i++ %>
            </th>
            <td style="vertical-align: middle;">
              <%= result.getString("order_no") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("email") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("name") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("category") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("price") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getInt("quantity") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("total_amount") %>
            </td>
            <td style="vertical-align: middle;">
              <% if("IN_PROGRESS".equals(result.getString("status"))) { %>
                <button class="btn btn-sm btn-primary" style="min-width: 130px;" data-bs-toggle="modal" data-bs-target="#exampleModal<%=i-1%>"><%= result.getString("status") %></button>

                <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="exampleModal<%=i-1%>" tabindex="-1" aria-labelledby="exampleModalLabel<%=i-1%>" aria-hidden="true">
                  <div class="modal-dialog">

                    <form action="ChangeStatus" method="POST">
                      <input type="hidden" name="order_no" value="<%=result.getInt("order_no")%>">
                      <input type="hidden" name="quantity" value="<%=result.getInt("quantity")%>">
                      <input type="hidden" name="productID" value="<%=result.getInt("product_id")%>">
                      <div class="modal-content" style="background: rgb(43, 38, 38);">
                        <div class="modal-header">
                          <h1 class="modal-title fs-5" id="exampleModalLabel<%=i-1%>">Change the staus of this product.</h1>
                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" style="text-align: start;">
                          <h4>User/Order Details</h4>
                          <p style="margin-bottom: 2px;"><strong>Name: </strong><%= result.getString("fname") %> <%= result.getString("lname") %></p>
                          <p style="margin-bottom: 2px;"><strong>Email: </strong><%= result.getString("email") %></p>
                          <p style="margin-bottom: 2px;"><strong>Address: </strong><%= result.getString("address") %></p>
                          <p style="margin-bottom: 2px;"><strong>Product: </strong><%= result.getString("name") %></p>
                          <p style="margin-bottom: 2px;"><strong>Category: </strong><%= result.getString("category") %></p>
                          <p style="margin-bottom: 2px;"><strong>Quantity: </strong><%= result.getString("quantity") %></p>
                          <p><strong>Total Amount: </strong><%= result.getString("total_amount") %></p>
                          You can either <mark>DISPATCH</mark> it or <mark>REJECT</mark> it.
                        </div>
                        <div style="margin-bottom: 10px;">
                          <label style="margin-right: 3px;">Remarks/Reason:</label>
                          <input style="background: #929292; width: 330px; outline: none; border: 1px transparent; padding: 2px 5px; border-radius: 5px;" type="text" name="reason" id="reason" required>
                        </div>
                        <div class="modal-footer">
                          <button class="btn btn-danger" type="submit" name="actionType" value="REJECTED">REJECT</button>
                          <button class="btn btn-success" type="submit" name="actionType" value="DISPATCHED">DISPATCH</button>
                        </div>
                      </div>
                    </form>

                  </div>
                </div>
              <% } else if("DISPATCHED".equals(result.getString("status"))) { %>
                <button type="button" class="btn btn-sm btn-outline-success" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% } else { %>
                <button type="button" class="btn btn-sm btn-outline-danger" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% }%>
            </td>
          </tr>
    <% } while(result.next());
    } else { %>
      <tr>
        <td colspan="8" style="vertical-align: middle;">No order history</td>
      </tr>
    <% } %>
    </tbody>

      <tbody class="hidden" id="inProgressTable">
      <%
          ps = connection.prepareStatement("SELECT C.address, C.fname, C.lname, SI.order_no, SI.email, SI.product_id, SI.price, SI.quantity, SI.price, SI.total_amount, SI.status, P.name, P.category FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email) WHERE SI.status = ?");
          ps.setString(1, "IN_PROGRESS");
          result = ps.executeQuery();
          if(result.next()) {
          int i = 1;
          do {
      %>
          <tr>
            <th scope="row" style="vertical-align: middle;">
              <%= i++ %>
            </th>
            <td style="vertical-align: middle;">
              <%= result.getString("order_no") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("email") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("name") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("category") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("price") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getInt("quantity") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("total_amount") %>
            </td>
            <td style="vertical-align: middle;">
              <% if("IN_PROGRESS".equals(result.getString("status"))) { %>
                <button class="btn btn-sm btn-primary" style="min-width: 130px;" data-bs-toggle="modal" data-bs-target="#exampleModal<%=i-1%>"><%= result.getString("status") %></button>

                <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="exampleModal<%=i-1%>" tabindex="-1" aria-labelledby="exampleModalLabel<%=i-1%>" aria-hidden="true">
                  <div class="modal-dialog">

                    <form action="ChangeStatus" method="POST">
                      <input type="hidden" name="order_no" value="<%=result.getInt("order_no")%>">
                      <input type="hidden" name="quantity" value="<%=result.getInt("quantity")%>">
                      <input type="hidden" name="productID" value="<%=result.getInt("product_id")%>">
                      <div class="modal-content" style="background: rgb(43, 38, 38);">
                        <div class="modal-header">
                          <h1 class="modal-title fs-5" id="exampleModalLabel<%=i-1%>">Change the staus of this product.</h1>
                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" style="text-align: start;">
                          <h4>User/Order Details</h4>
                          <p style="margin-bottom: 2px;"><strong>Name: </strong><%= result.getString("fname") %> <%= result.getString("lname") %></p>
                          <p style="margin-bottom: 2px;"><strong>Email: </strong><%= result.getString("email") %></p>
                          <p style="margin-bottom: 2px;"><strong>Address: </strong><%= result.getString("address") %></p>
                          <p style="margin-bottom: 2px;"><strong>Product: </strong><%= result.getString("name") %></p>
                          <p style="margin-bottom: 2px;"><strong>Category: </strong><%= result.getString("category") %></p>
                          <p style="margin-bottom: 2px;"><strong>Quantity: </strong><%= result.getString("quantity") %></p>
                          <p><strong>Total Amount: </strong><%= result.getString("total_amount") %></p>
                          You can either <mark>DISPATCH</mark> it or <mark>REJECT</mark> it.
                        </div>
                        <div style="margin-bottom: 10px;">
                          <label style="margin-right: 3px;">Remarks/Reason:</label>
                          <input style="background: #929292; width: 330px; outline: none; border: 1px transparent; padding: 2px 5px; border-radius: 5px;" type="text" name="reason" id="reason" required>
                        </div>
                        <div class="modal-footer">
                          <button class="btn btn-danger" type="submit" name="actionType" value="REJECTED">REJECT</button>
                          <button class="btn btn-success" type="submit" name="actionType" value="DISPATCHED">DISPATCH</button>
                        </div>
                      </div>
                    </form>

                  </div>
                </div>
              <% } else if("DISPATCHED".equals(result.getString("status"))) { %>
                <button type="button" class="btn btn-sm btn-outline-success" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% } else { %>
                <button type="button" class="btn btn-sm btn-outline-danger" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% }%>
            </td>
          </tr>
    <% } while(result.next());
    } else { %>
      <tr>
        <td colspan="8" style="vertical-align: middle;">No order history</td>
      </tr>
    <% } %>
    </tbody>

      <tbody class="hidden" id="dispatchedTable">
      <%
          ps = connection.prepareStatement("SELECT C.address, C.fname, C.lname, SI.order_no, SI.email, SI.product_id, SI.price, SI.quantity, SI.price, SI.total_amount, SI.status, P.name, P.category FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email) WHERE SI.status = ?");
          ps.setString(1, "DISPATCHED");
          result = ps.executeQuery();
          if(result.next()) {
          int i = 1;
          do {
      %>
          <tr>
            <th scope="row" style="vertical-align: middle;">
              <%= i++ %>
            </th>
            <td style="vertical-align: middle;">
              <%= result.getString("order_no") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("email") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("name") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("category") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("price") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getInt("quantity") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("total_amount") %>
            </td>
            <td style="vertical-align: middle;">
              <% if("IN_PROGRESS".equals(result.getString("status"))) { %>
                <button class="btn btn-sm btn-primary" style="min-width: 130px;" data-bs-toggle="modal" data-bs-target="#exampleModal<%=i-1%>"><%= result.getString("status") %></button>

                <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="exampleModal<%=i-1%>" tabindex="-1" aria-labelledby="exampleModalLabel<%=i-1%>" aria-hidden="true">
                  <div class="modal-dialog">

                    <form action="ChangeStatus" method="POST">
                      <input type="hidden" name="order_no" value="<%=result.getInt("order_no")%>">
                      <input type="hidden" name="quantity" value="<%=result.getInt("quantity")%>">
                      <input type="hidden" name="productID" value="<%=result.getInt("product_id")%>">
                      <div class="modal-content" style="background: rgb(43, 38, 38);">
                        <div class="modal-header">
                          <h1 class="modal-title fs-5" id="exampleModalLabel<%=i-1%>">Change the staus of this product.</h1>
                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" style="text-align: start;">
                          <h4>User/Order Details</h4>
                          <p style="margin-bottom: 2px;"><strong>Name: </strong><%= result.getString("fname") %> <%= result.getString("lname") %></p>
                          <p style="margin-bottom: 2px;"><strong>Email: </strong><%= result.getString("email") %></p>
                          <p style="margin-bottom: 2px;"><strong>Address: </strong><%= result.getString("address") %></p>
                          <p style="margin-bottom: 2px;"><strong>Product: </strong><%= result.getString("name") %></p>
                          <p style="margin-bottom: 2px;"><strong>Category: </strong><%= result.getString("category") %></p>
                          <p style="margin-bottom: 2px;"><strong>Quantity: </strong><%= result.getString("quantity") %></p>
                          <p><strong>Total Amount: </strong><%= result.getString("total_amount") %></p>
                          You can either <mark>DISPATCH</mark> it or <mark>REJECT</mark> it.
                        </div>
                        <div style="margin-bottom: 10px;">
                          <label style="margin-right: 3px;">Remarks/Reason:</label>
                          <input style="background: #929292; width: 330px; outline: none; border: 1px transparent; padding: 2px 5px; border-radius: 5px;" type="text" name="reason" id="reason" required>
                        </div>
                        <div class="modal-footer">
                          <button class="btn btn-danger" type="submit" name="actionType" value="REJECTED">REJECT</button>
                          <button class="btn btn-success" type="submit" name="actionType" value="DISPATCHED">DISPATCH</button>
                        </div>
                      </div>
                    </form>

                  </div>
                </div>
              <% } else if("DISPATCHED".equals(result.getString("status"))) { %>
                <button type="button" class="btn btn-sm btn-outline-success" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% } else { %>
                <button type="button" class="btn btn-sm btn-outline-danger" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% }%>
            </td>
          </tr>
    <% } while(result.next());
    } else { %>
      <tr>
        <td colspan="8" style="vertical-align: middle;">No order history</td>
      </tr>
    <% } %>
    </tbody>

      <tbody class="hidden" id="rejectedTable">
      <%
          ps = connection.prepareStatement("SELECT C.address, C.fname, C.lname, SI.order_no, SI.email, SI.product_id, SI.price, SI.quantity, SI.price, SI.total_amount, SI.status, P.name, P.category FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email) WHERE SI.status = ?");
          ps.setString(1, "REJECTED");
          result = ps.executeQuery();
          if(result.next()) {
          int i = 1;
          do {
      %>
          <tr>
            <th scope="row" style="vertical-align: middle;">
              <%= i++ %>
            </th>
            <td style="vertical-align: middle;">
              <%= result.getString("order_no") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("email") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("name") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getString("category") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("price") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getInt("quantity") %>
            </td>
            <td style="vertical-align: middle;">
              <%= result.getFloat("total_amount") %>
            </td>
            <td style="vertical-align: middle;">
              <% if("IN_PROGRESS".equals(result.getString("status"))) { %>
                <button class="btn btn-sm btn-primary" style="min-width: 130px;" data-bs-toggle="modal" data-bs-target="#exampleModal<%=i-1%>"><%= result.getString("status") %></button>

                <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="exampleModal<%=i-1%>" tabindex="-1" aria-labelledby="exampleModalLabel<%=i-1%>" aria-hidden="true">
                  <div class="modal-dialog">

                    <form action="ChangeStatus" method="POST">
                      <input type="hidden" name="order_no" value="<%=result.getInt("order_no")%>">
                      <input type="hidden" name="quantity" value="<%=result.getInt("quantity")%>">
                      <input type="hidden" name="productID" value="<%=result.getInt("product_id")%>">
                      <div class="modal-content" style="background: rgb(43, 38, 38);">
                        <div class="modal-header">
                          <h1 class="modal-title fs-5" id="exampleModalLabel<%=i-1%>">Change the staus of this product.</h1>
                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" style="text-align: start;">
                          <h4>User/Order Details</h4>
                          <p style="margin-bottom: 2px;"><strong>Name: </strong><%= result.getString("fname") %> <%= result.getString("lname") %></p>
                          <p style="margin-bottom: 2px;"><strong>Email: </strong><%= result.getString("email") %></p>
                          <p style="margin-bottom: 2px;"><strong>Address: </strong><%= result.getString("address") %></p>
                          <p style="margin-bottom: 2px;"><strong>Product: </strong><%= result.getString("name") %></p>
                          <p style="margin-bottom: 2px;"><strong>Category: </strong><%= result.getString("category") %></p>
                          <p style="margin-bottom: 2px;"><strong>Quantity: </strong><%= result.getString("quantity") %></p>
                          <p><strong>Total Amount: </strong><%= result.getString("total_amount") %></p>
                          You can either <mark>DISPATCH</mark> it or <mark>REJECT</mark> it.
                        </div>
                        <div style="margin-bottom: 10px;">
                          <label style="margin-right: 3px;">Remarks/Reason:</label>
                          <input style="background: #929292; width: 330px; outline: none; border: 1px transparent; padding: 2px 5px; border-radius: 5px;" type="text" name="reason" id="reason" required>
                        </div>
                        <div class="modal-footer">
                          <button class="btn btn-danger" type="submit" name="actionType" value="REJECTED">REJECT</button>
                          <button class="btn btn-success" type="submit" name="actionType" value="DISPATCHED">DISPATCH</button>
                        </div>
                      </div>
                    </form>

                  </div>
                </div>
              <% } else if("DISPATCHED".equals(result.getString("status"))) { %>
                <button type="button" class="btn btn-sm btn-outline-success" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% } else { %>
                <button type="button" class="btn btn-sm btn-outline-danger" style="min-width: 130px;"><%= result.getString("status") %></button>
              <% }%>
            </td>
          </tr>
    <% } while(result.next());
    } else { %>
      <tr>
        <td colspan="8" style="vertical-align: middle;">No order history</td>
      </tr>
    <% } %>
    </tbody>
    <%  } catch (Exception e) {
    e.printStackTrace();
} finally {
    try {
        if (result != null) {
            result.close();
        }
        if (ps != null) {
            ps.close();
        }
        if (connection != null) {
            connection.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    %>
    </table>
  </section>

    <% } else { 
        response.sendRedirect("home.jsp");
       } } catch (Exception e) { %>
        <div>Error Occured</div>
        <% response.sendRedirect("home.jsp"); %>
      <% } %>

      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>

            <script>
              function showForm(formIdToShow, buttonToActive) {
                const forms = ['allTable', 'inProgressTable', 'dispatchedTable', 'rejectedTable'];
                const buttons = ['all', 'progress', 'dispatch', 'reject'];
  
                forms.forEach(formId => {
                  const form = document.getElementById(formId);
  
                  if (formId === formIdToShow) {
                    form.classList.add('visible');
                    form.classList.remove('hidden');
                  } else {
                    form.classList.add('hidden');
                    form.classList.remove('visible');
                  }
                });
  
                buttons.forEach(buttonId => {
                  const button = document.getElementById(buttonId);
  
                  if (buttonId === buttonToActive) {
                    button.classList.add('btn-info');
                    button.classList.remove('btn-outline-info');
                  } else {
                    button.classList.add('btn-outline-info');
                    button.classList.remove('btn-info');
                  }
                })
              }
  
              function showAll() {
                showForm('allTable', 'all');
              }

              function showInProgressOrders() {
                showForm('inProgressTable', 'progress');
              }
  
              function showDispatchedOrders() {
                showForm('dispatchedTable', 'dispatch');
              }
  
              function showRejectedOrders() {
                showForm('rejectedTable', 'reject');
              }
            </script>
</body>

</html>