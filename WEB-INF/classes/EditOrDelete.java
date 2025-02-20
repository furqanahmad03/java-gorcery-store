
import java.io.*;
import java.util.HashMap;
import javax.servlet.*;
import javax.servlet.http.*;

public class EditOrDelete extends HttpServlet {

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
            String actionType = request.getParameter("actionType");
            if ("update".equals(actionType)) {
                int productID = Integer.parseInt(request.getParameter("productID"));
                int count = Integer.parseInt(request.getParameter("count"));

                if (cart != null && cart.containsKey(productID)) {
                    HashMap<String, Object> productDetails = cart.get(productID);
                    productDetails.put("count", count);
                    session.setAttribute("cart", cart);
                    out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 1s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Item updated</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                    response.setHeader("Refresh", "1;url=cart.jsp");
                } else {
                    out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 1s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Item not in the cart</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                    response.setHeader("Refresh", "1;url=cart.jsp");
                }
            } else if ("delete".equals(actionType)) {
              int productID = Integer.parseInt(request.getParameter("productID"));
              cart.remove(productID);
              if (cart == null || cart.isEmpty()) {
                session.removeAttribute("cart");
              }
              out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 1s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Product Removed</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                response.setHeader("Refresh", "1;url=cart.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
