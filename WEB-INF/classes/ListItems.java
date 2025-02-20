
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class ListItems extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp");
        }

        try {
            DAO dao = new DAO();
            String searchedProduct = null;
            try {
                searchedProduct = request.getParameter("searchedProduct");
            } catch (Exception e) {
                searchedProduct = null;
            }

            ArrayList<ProductTransporter> products = dao.getAllProducts(searchedProduct);

            out.println("<!doctype html>");
            out.println("<html lang=\"en\">");
            out.println("<head>");
            out.println("<meta charset=\"utf-8\">");
            out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            out.println("<link rel=\"stylesheet\" href=\"style.css\">");
            out.println("<link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"images/logo.svg\" />");
            out.println("<title>Products List</title>");
            out.println("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH\" crossorigin=\"anonymous\">");
            out.println("</head>");
            out.println("<style>.hover-effect {transition: 0.2s;box-shadow: 5px 5px 5px #00000063;transform: scale(1.01);}</style>");
            out.println("<body style=\"display: block; padding: 0%;\">");

            out.println("<nav class=\"navbar border-bottom border-body\" style=\"height: 8vh; background: linear-gradient(to bottom, rgba(111, 110, 110, 0.75), rgba(0, 0, 0, 0.718));\" data-bs-theme=\"dark\">");
            out.println("<div class=\"container-fluid\">");
            out.println("<div class=\"d-flex justify-content-center align-items-center\">");
            out.println("<a href=\"home.jsp\"><img style=\"height: 30px; width: 30px; margin-right: 7px;\" src=\"images/home.png\" alt=\"home\"></a>");
            out.println("<a class=\"navbar-brand\" style=\"font-weight: 900;\">");
            out.println(session.getAttribute("name").toString());
            out.println("</a>");
            out.println("</div>");
            out.println("<form action=\"ListItems\" method=\"GET\" class=\"d-flex flex-row\" role=\"search\">");
            out.println("<input class=\"form-control me-2\" style=\"width: 400px;\" type=\"search\" name=\"searchedProduct\" placeholder=\"Search product name\" aria-label=\"Search\">");
            out.println("<button class=\"btn btn-outline-success\" type=\"submit\">Search</button>");
            out.println("</form>");
            out.println("<div class=\"d-flex align-items-center\">");
            if (session.getAttribute("userType").toString().equals("Admin")) {
                out.println("<a style=\"margin-right: 15px;\" href=\"orderList.jsp\"><img style=\"height: 30px;\" src=\"images/view-orders.png\" alt=\"cart\"></a>");
            } else {
                out.println("<a style=\"margin-right: 15px;\" href=\"cart.jsp\"><img style=\"height: 30px;\" src=\"images/cart.png\" alt=\"cart\"></a>");
            }
            out.println("<form action=\"Logout\" method=\"POST\">");
            out.println("<button class=\"btn btn-outline-danger\" type=\"submit\">Logout</button>");
            out.println("</form>");
            out.println("</div>");
            out.println("</div>");
            out.println("</nav>");

            out.println("<div class=\"container mt-4\" style=\"max-height: 85vh; overflow: scroll;\">");
            out.println("<div class=\"row\">");

            for (ProductTransporter product : products) {
                out.println("<div class=\"col-md-3 mb-4\">");
                out.println("<div class=\"card hover-effect\" style=\"background: rgba(92, 77, 77, 0.73); color: white;\">");

                out.println("<div style=\"position: relative;\">");
                out.println("<div style=\"height: 170px; width: 100%; overflow: hidden;\"><img src=\"images/" + product.getName() + ".jpg\" style=\"object-fit: contain; width: 100%; height: auto\" class=\"card-img-top\" alt=\"picture\">");

                out.println("<div style=\"position: absolute; top: 10px; left: 10px; background: white; color: black; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center;\">");

                if (session.getAttribute("cart") != null) {
                    @SuppressWarnings("unchecked")
                    HashMap<Integer, HashMap<String, Object>> cart = (HashMap<Integer, HashMap<String, Object>>) session.getAttribute("cart");
                    if (cart.containsKey(product.getId())) {
                        HashMap<String, Object> details = cart.get(product.getId());
                        int quantityOrdered = (Integer) details.get("count");
                        out.println(product.getQuantity() - quantityOrdered);
                    } else {
                        out.println(product.getQuantity());
                    }
                } else {
                    out.println(product.getQuantity());
                }
                out.println("</div>");
                out.println("</div>");

                if (session.getAttribute("userType").toString().equals("Admin") && product.getQuantity() <= 0) {
                    out.println("<div style=\"position: absolute; top: 10px; right: 10px; background: #9b0202; color: white; width: 110px; height: 30px; border-radius: 5px; display: flex; align-items: center; justify-content: center;\">Out of stock</div>");
                }

                out.println("</div>");

                out.println("<div class=\"card-body\">");
                out.println("<div class=\"d-flex justify-content-between\">");
                out.println("<h5 class=\"card-title\" style=\"font-weight: 700;\"><u>" + product.getName() + "</u></h5>");
                out.println("<p class=\"mb-0\">Price: $" + product.getPrice() + "</p>");
                out.println("</div>");
                out.println("<h6 class=\"card-text\"><strong>Category: </strong><small>" + product.getCategory() + "</small></h6>");

                if (session.getAttribute("userType").toString().equals("Customer")) {
                    if (product.getQuantity() > 0) {
                        out.println("<button type=\"button\" class=\"btn btn-success\" data-bs-toggle=\"modal\" data-bs-target=\"#modal" + product.getId() + "\">Buy it now</button>");
                    } else {
                        out.println("<button type=\"button\" class=\"btn btn-danger\" disabled>Out of stock</button>");
                    }
                }

                out.println("</div>");
                out.println("</div>");
                out.println("</div>");

                // MODAL
                out.println("<div class=\"modal fade\" style=\"background: rgba(43, 38, 38, 0.27);\" id=\"modal" + product.getId() + "\" tabindex=\"-1\" aria-labelledby=\"ModalLabel" + product.getId() + "\" aria-hidden=\"true\">");
                out.println("<div class=\"modal-dialog\">");
                out.println("<form action=\"AddToCart\" method=\"POST\">");
                out.println("<div class=\"modal-content\" style=\"background: rgb(43, 38, 38);\">");
                out.println("<div class=\"modal-header text-white\">");
                out.println("<h5 class=\"modal-title\" id=\"ModalLabel" + product.getId() + "\">Buy this item</h5>");
                out.println("<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>");
                out.println("</div>");
                out.println("<div class=\"modal-body text-white\">");
                out.println("<div class=\"d-flex\">");
                out.println("<img style=\"height: 200px; width: 200px; margin-right: 7px;\" src=\"images/home.png\" alt=\"image\">");
                out.println("<div>");
                out.println("<h2>" + product.getName() + "</h2>");

                out.println("<input type=\"hidden\" name=\"productID\" value=\"" + product.getId() + "\">");
                out.println("<input type=\"hidden\" name=\"name\" value=\"" + product.getName() + "\">");
                out.println("<input type=\"hidden\" name=\"category\" value=\"" + product.getCategory() + "\">");
                out.println("<input type=\"hidden\" name=\"price\" value=\"" + product.getPrice() + "\">");
                out.println("<p style=\"margin-bottom: 2px\"><strong>Category: </strong>" + product.getCategory() + "</p>");
                out.println("<p style=\"margin-bottom: 2px\"><strong>Quantity: </strong>" + product.getQuantity() + "</p>");
                out.println("<p style=\"margin-bottom: 2px\"><strong>Price: </strong>$" + product.getPrice() + "</p>");

                out.println("<div class=\"d-flex justify-content-start align-items-center\">");
                out.println("<button type=\"button\" class=\"btn btn-outline-danger d-flex align-items-center\" style=\"height: 25px; padding: 8px;\" "
                        + "onclick=\"document.getElementById('count" + product.getId() + "').value = parseInt(document.getElementById('count" + product.getId() + "').value) > 1 ? parseInt(document.getElementById('count" + product.getId() + "').value) - 1 : 1\">-</button>");
                out.println("<input class=\"m-2\" style=\"width: 50px; padding: 0px 3px; outline: none; border: 1px solid floralwhite; border-radius: 5px; background: rgb(43 38 38); color: white; font-weight: 400;\" " + "type=\"number\" name=\"count\" id=\"count" + product.getId() + "\" value=\"1\" min=\"1\" max=\"" + product.getQuantity() + "\">");
                out.println("<button type=\"button\" class=\"btn btn-outline-success d-flex align-items-center\" style=\"height: 25px; padding: 8px;\" "
                        + "onclick=\"document.getElementById('count" + product.getId() + "').value = parseInt(document.getElementById('count" + product.getId() + "').value) + 1\">+</button>");
                out.println("</div>");

                out.println("</div>");
                out.println("</div>");
                out.println("</div>");
                out.println("<div class=\"modal-footer\">");
                out.println("<button type=\"button\" class=\"btn btn-secondary\" data-bs-dismiss=\"modal\">Cancel</button>");
                out.println("<button type=\"submit\" value=\"submit\" class=\"btn btn-success\">Add to cart</button>");
                out.println("</div>");
                out.println("</div>");
                out.println("</form>");
                out.println("</div>");
                out.println("</div>");
            }

            out.println("</div>");
            out.println("</div>");

            out.println("<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js\" integrity=\"sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz\" crossorigin=\"anonymous\"></script>");
            out.println("</body>");
            out.println("</html>");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
