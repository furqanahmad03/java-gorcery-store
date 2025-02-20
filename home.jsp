<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="style.css">
  <%@ page language="java" import="javax.servlet.*,javax.servlet.http.*,java.sql.*" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" session="false" %>
      <link rel="shortcut icon" type="image/x-icon" href="images/logo.svg" />
      <title>Dashboard</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>

<style>
  .side-bar {
    height: 92vh;
    width: 250px;
    background: linear-gradient(to bottom, rgba(0, 0, 0, 0.871), rgba(0, 0, 0, 0.52));
    padding-top: 5px;
  }

  .admin-button {
    height: 60px;
    font-size: large;
    width: 100%;
    font-weight: 800;
    display: block;
    padding: 0 15px;
    outline: none;
    border: none;
    border-radius: 0%;
    text-align: left;
    transition: 0.2s ease;

    &:hover {
      background-color: white;
      color: black;
      transition: 0.2s ease;
    }
  }

  .checked {
    color: black;
    background-color: #fff;
  }

  .hidden {
    opacity: 0;
    display: none;
    transition: opacity 1s ease, visibility 1s ease;
  }

  .visible {
    opacity: 1;
    display: flex;
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
    <section>
      <div class="row" style="max-width: 100%;">
        <div class="col-4 side-bar">
          <button class="btn btn-outline-secondary admin-button checked" id="add" onclick="addProduct()">Add
            Product</button>
          <button class="btn btn-outline-secondary admin-button" id="update" onclick="updateProduct()">Update
            Product</button>
          <button class="btn btn-outline-secondary admin-button" id="delete" onclick="deleteProduct()">Delete
            Product</button>
          <form action="ListItems" method="GET"><button type="submit" class="btn btn-outline-info"
              style="width: 100%; margin: 58vh 0px 0px 5px;">See All Products</button></form>
        </div>


        <div class="col-8 container my-auto justify-content-start visible" id="addProductForm">
          <h1 style="font-size: 54px; color: white; font-weight: 800; max-width: 300px;">Add a Product</h1>
          <form action="CRUD" method="POST"
            style="background: rgba(221, 221, 221, 0.288); padding: 50px; border-radius: 20px;">
            <div class="row" style="margin-bottom: 20px;">
              <div class="col">
                <div class="input-field"
                  style="background-color: rgba(0, 0, 0, 0.5); width: 300px; border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                  <input type="text" name="name" required>
                  <label style="translate: 6%;">Enter product name</label>
                </div>
              </div>
              <div class="col">
                <div class="col">
                  <div class="input-field"
                    style="background-color: rgba(0, 0, 0, 0.5); width: 200px; border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                    <input type="text" name="category" required>
                    <label style="translate: 10%;">Enter category</label>
                  </div>
                </div>
              </div>
            </div>
            <div class="row" style="margin-bottom: 20px;">
              <div class="col">
                <div class="col">
                  <div class="input-field"
                    style="background-color: rgba(0, 0, 0, 0.5); border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                    <input type="number" name="price" step="0.01" required>
                    <label style="translate: 12%;">Enter Price</label>
                  </div>
                </div>
              </div>
              <div class="col">
                <div class="col">
                  <div class="input-field"
                    style="background-color: rgba(0, 0, 0, 0.5); border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                    <input type="number" name="quantity" required>
                    <label style="translate: 12%;">Enter quantity</label>
                  </div>
                </div>
              </div>
            </div>
            <button class="btn btn-success" type="submit" name="actionType" value="addProduct">Add Product</button>
          </form>
        </div>


        <div class="col-8 container my-auto justify-content-start hidden" id="updateProductForm">
          <h1 style="font-size: 54px; color: white; font-weight: 800; max-width: 300px;">Update a Product</h1>
          <form action="CRUD" method="POST"
            style="background: rgba(221, 221, 221, 0.288); padding: 50px; border-radius: 20px;">
            <div class="row" style="margin-bottom: 20px;">
              <div class="col">
                <div class="input-field"
                  style="background-color: rgba(0, 0, 0, 0.5); width: 300px; border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                  <input type="text" name="name" required>
                  <label style="translate: 6%;">Enter product name</label>
                </div>
              </div>
            </div>
            <div class="row" style="margin-bottom: 20px;">
              <div class="col">
                <div class="col">
                  <div class="input-field"
                    style="background-color: rgba(0, 0, 0, 0.5); width: 250px; border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                    <input type="number" name="price" step="0.01" required>
                    <label style="translate: 8%; font-size: 15px;">Price Increment/Decrement</label>
                  </div>
                </div>
              </div>
              <div class="col">
                <div class="col">
                  <div class="input-field"
                    style="background-color: rgba(0, 0, 0, 0.5); width: 250px; border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                    <input type="number" name="quantity" required>
                    <label style="translate: 8%; font-size: 15px;">Enter quantity arrived/Lost</label>
                  </div>
                </div>
              </div>
            </div>
            <button class="btn btn-success" type="submit" name="actionType" value="updateProduct">Update
              Product</button>
          </form>
        </div>


        <div class="col-8 container my-auto justify-content-between hidden" id="deleteProductForm">
          <h1 style="font-size: 54px; color: white; font-weight: 800; max-width: 300px;">Delete a Product</h1>
          <form action="CRUD" method="POST"
            style="background: rgba(221, 221, 221, 0.288); padding: 50px; border-radius: 20px;">
            <div class="row" style="margin-bottom: 20px;">
              <div class="col">
                <div class="input-field"
                  style="background-color: rgba(0, 0, 0, 0.5); width: 300px; border: 1px solid black; border-radius: 20px; padding: 0px 10px;">
                  <input type="text" name="name" required>
                  <label style="translate: 6%;">Enter product name</label>
                </div>
              </div>
            </div>
            <button class="btn btn-success" type="submit" name="actionType" value="deleteProduct">Delete
              Product</button>
          </form>
        </div>


      </div>
    </section>

    <% } else { %>

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
          <form action="home.jsp" method="POST" class="d-flex flex-row" role="search">
            <input class="form-control me-2" name="searchedProduct" style="width: 400px;" type="search" placeholder="Search product category"
              aria-label="Search">
            <button class="btn btn-outline-success" type="submit">Search</button>
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
          <form action="ListItems" method="GET" style="margin-bottom: 15px;">
            <button class="btn btn-success" style="max-width: max-content;" type="submit">Gor to store</button>
          </form>
          
        <table class="table table-dark table-striped" style="text-align: center; border: 1px solid black;">
          <thead style="font-size: large;">
            <tr>
              <th scope="col">#</th>
              <th scope="col">Name</th>
              <th scope="col">Category</th>
              <th scope="col">Quantity Ordered</th>
              <th scope="col">Price</th>
              <th scope="col">Total Amount</th>
              <th scope="col">Status</th>
            </tr>
          </thead>
          <tbody>
          <%
          Connection connection = null;
          PreparedStatement ps = null;
          ResultSet result = null;
  
          try {
              Class.forName("com.mysql.jdbc.Driver");
              String url = "jdbc:mysql://127.0.0.1:3306/Project";
              connection = DriverManager.getConnection(url, "root", "root");
              String email = session.getAttribute("email").toString();
              String searchedProduct = request.getParameter("searchedProduct");
              if(searchedProduct == null || "all".equals(searchedProduct)) {
                ps = connection.prepareStatement("SELECT P.name, P.category, SI.quantity, P.price, SI.total_amount, SI.status, SI.reason, SI.order_no FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email) WHERE C.email = ? ORDER BY SI.order_no DESC;");
              } else {
                ps = connection.prepareStatement("SELECT P.name, P.category, SI.quantity, P.price, SI.total_amount, SI.status, SI.reason, SI.order_no FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email) WHERE C.email = ? AND LOWER(P.name) = LOWER(?) ORDER BY SI.order_no DESC;");
                ps.setString(2, searchedProduct);
              }
              ps.setString(1, email);
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
                  <%= result.getString("name") %>
                </td>
                <td style="vertical-align: middle;">
                  <%= result.getString("category") %>
                </td>
                <td style="vertical-align: middle;">
                  <%= result.getString("quantity") %>
                </td>
                <td style="vertical-align: middle;">
                  $<%= result.getFloat("price") %>
                </td>
                <td style="vertical-align: middle;">
                  $<%= result.getFloat("total_amount") %>
                </td>
                <td style="vertical-align: middle;">
                  <% if("IN_PROGRESS".equals(result.getString("status"))) { %>
                    <button class="btn btn-sm btn-outline-primary" style="min-width: 130px;" data-bs-toggle="modal" data-bs-target="#exampleModal<%=i-1%>"><%= result.getString("status") %></button>

                    <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="exampleModal<%=i-1%>" tabindex="-1" aria-labelledby="exampleModalLabel<%=i-1%>" aria-hidden="true">
                      <div class="modal-dialog">
                        <div class="modal-content" style="background: rgb(43, 38, 38);">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel<%=i-1%>">Reason of <%=result.getString("status")%></h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <%=result.getString("reason")%>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">OK</button>
                          </div>
                        </div>
                      </div>
                    </div>

                  <% } else if("DISPATCHED".equals(result.getString("status"))) { %>
                    <button class="btn btn-sm btn-outline-success" style="min-width: 130px;" data-bs-toggle="modal" data-bs-target="#exampleModal<%=i-1%>"><%= result.getString("status") %></button>

                    <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="exampleModal<%=i-1%>" tabindex="-1" aria-labelledby="exampleModalLabel<%=i-1%>" aria-hidden="true">
                      <div class="modal-dialog">
                        <div class="modal-content" style="background: rgb(43, 38, 38);">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel<%=i-1%>">Reason of <%=result.getString("status")%></h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <%=result.getString("reason")%>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">OK</button>
                          </div>
                        </div>
                      </div>
                    </div>

                  <% } else { %>
                    <button class="btn btn-sm btn-outline-danger" style="min-width: 130px;" data-bs-toggle="modal" data-bs-target="#exampleModal<%=i-1%>"><%= result.getString("status") %></button>

                    <div class="modal fade" style="background: rgba(43, 38, 38, 0.27);" id="exampleModal<%=i-1%>" tabindex="-1" aria-labelledby="exampleModalLabel<%=i-1%>" aria-hidden="true">
                      <div class="modal-dialog">
                        <div class="modal-content" style="background: rgb(43, 38, 38);">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel<%=i-1%>">Reason of <%=result.getString("status")%></h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <%=result.getString("reason")%>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">OK</button>
                          </div>
                        </div>
                      </div>
                    </div>

                  <% }%>
                </td>
              </tr>
        <% } while(result.next());
        } else { %>
          <tr>
            <td colspan="8" style="vertical-align: middle;">No order history</td>
          </tr>
        <% }
          } catch (Exception e) {
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
      </tbody>
    </table>
      </section>


      <% } } catch (Exception e) { %>
        <div>Error Occured</div>
        <% } %>

          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
            
          <script>
            function showForm(formIdToShow, buttonToActive) {
              const forms = ['addProductForm', 'updateProductForm', 'deleteProductForm'];
              const buttons = ['add', 'update', 'delete'];

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
                  button.classList.add('checked');
                } else {
                  button.classList.remove('checked');
                }
              })
            }

            function addProduct() {
              showForm('addProductForm', 'add');
            }

            function updateProduct() {
              showForm('updateProductForm', 'update');
            }

            function deleteProduct() {
              showForm('deleteProductForm', 'delete');
            }
          </script>
</body>

</html>