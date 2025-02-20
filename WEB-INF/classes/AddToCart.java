
import java.io.*;
import java.util.HashMap;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddToCart extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        try {
            HttpSession session = request.getSession(false);
            if (!session.getAttribute("userType").toString().equals("Customer")) {
                response.sendRedirect("home.jsp");
            }

            @SuppressWarnings("unchecked")
            HashMap<Integer, HashMap<String, Object>> cart = (HashMap<Integer, HashMap<String, Object>>) session.getAttribute("cart");
            if (cart == null) {
                cart = new HashMap<>();
            }

            int productID = Integer.parseInt(request.getParameter("productID"));
            int count = Integer.parseInt(request.getParameter("count"));
            float price = Float.parseFloat(request.getParameter("price"));
            String name = request.getParameter("name");
            String category = request.getParameter("category");

            HashMap<String, Object> productDetails = new HashMap<>();
            productDetails.put("name", name);
            productDetails.put("category", category);
            productDetails.put("count", count);
            productDetails.put("price", price);
            cart.put(productID, productDetails);
            
            session.setAttribute("cart", cart);
            response.setHeader("Refresh", "0;url=ListItems");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
