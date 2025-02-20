
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.HashMap;
import javax.servlet.*;
import javax.servlet.http.*;

public class ChangeStatus extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        HttpSession session = request.getSession(false);
        if (!session.getAttribute("userType").toString().equals("Admin")) {
            response.sendRedirect("home.jsp");
        }
        PrintWriter out = response.getWriter();
        try {
            DAO dao = new DAO();
            String actionType = request.getParameter("actionType");
            String reason = request.getParameter("reason");
            int order_no = Integer.parseInt(request.getParameter("order_no"));

            if ("DISPATCHED".equals(actionType)) {
                boolean status = dao.dispatchProduct(reason, order_no);
                if (status) {
                    response.sendRedirect("orderList.jsp");
                } else {
                    out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Couldn't be updated...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                    response.setHeader("Refresh", "1;url=orderList.jsp");
                }
            } else if ("REJECTED".equals(actionType)) {
                int productID = Integer.parseInt(request.getParameter("productID"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                boolean status = dao.rejectProduct(reason, order_no, quantity, productID);

                if (status) {
                    response.sendRedirect("orderList.jsp");
                } else {
                    out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Error Occured...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                    response.setHeader("Refresh", "1;url=orderList.jsp");
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}
