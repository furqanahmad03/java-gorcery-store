
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.HashMap;
import java.util.Vector;

import javax.net.ssl.SSLSession;

public class PlaceOrder extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        HttpSession session = request.getSession(false);
        if (!session.getAttribute("userType").toString().equals("Customer")) {
            response.sendRedirect("home.jsp");
        }

        PrintWriter out = response.getWriter();
        Vector<String> errors = new Vector<>();

        try {
            DAO dao = new DAO();
            @SuppressWarnings("unchecked")
            HashMap<Integer, HashMap<String, Object>> cart = (HashMap<Integer, HashMap<String, Object>>) session.getAttribute("cart");
            String email = session.getAttribute("email").toString();
            boolean status = dao.placeOrder(cart, errors, email);
            if (status) {
                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 1s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Order Placed</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                response.setHeader("Refresh", "1;url=cart.jsp");
            } else {
                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 1s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Error Occured in some products...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                response.setHeader("Refresh", "1;url=cart.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            session.removeAttribute("cart");
            out.close();
        }

    }
}
