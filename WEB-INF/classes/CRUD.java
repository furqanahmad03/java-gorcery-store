
import java.io.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.sql.*;

public class CRUD extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        if (!session.getAttribute("userType").toString().equals("Admin")) {
            response.sendRedirect("home.jsp");
        }

        PrintWriter out = response.getWriter();
        String action = request.getParameter("actionType");

        try {
            DAO dao = new DAO();
            if (null == action) {
                out.println("<h1 style=\"color: white\">Invalid action.</h1>");
                response.setHeader("Refresh", "2;url=index.jsp");
            } else {
                switch (action) {
                    case "addProduct" ->  {
                        String name = request.getParameter("name");
                        String category = request.getParameter("category");
                        String priceString = request.getParameter("price");
                        String quantityString = request.getParameter("quantity");
                        try {
                            float price = Float.parseFloat(priceString);
                            int quantity = Integer.parseInt(quantityString);
                            boolean status = dao.addProduct(name, category, price, quantity);
                            if (status) {
                                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Product Added</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                            } else {
                                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Product couldn't be added</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                            }
                            response.setHeader("Refresh", "1;url=home.jsp");

                        } catch (Exception e) {
                            out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Invalid Datatype Error...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                            response.setHeader("Refresh", "1;url=home.jsp");
                        }
                    }
                    case "updateProduct" ->  {
                        String name = request.getParameter("name");
                        String priceString = request.getParameter("price");
                        String quantityString = request.getParameter("quantity");
                        try {
                            float price = priceString.isEmpty() ? 0.0f : Float.parseFloat(priceString);
                            int quantity = quantityString.isEmpty() ? 0 : Integer.parseInt(quantityString);
                            boolean status = dao.updateProduct(price, quantity, name);
                            if (status) {
                                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Data Updated...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                                response.setHeader("Refresh", "1;url=home.jsp");
                            } else {
                                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Not present in the database...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                                response.setHeader("Refresh", "1;url=home.jsp");
                            }
                        } catch (Exception e) {
                            out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Invalid Datatype Error...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                            response.setHeader("Refresh", "1;url=home.jsp");
                        }
                    }
                    case "deleteProduct" -> {
                        try {
                            String name = request.getParameter("name");
                            boolean status = dao.deleteProduct(name);
                            if (status) {
                                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Data Deleted...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                                response.setHeader("Refresh", "3;url=home.jsp");
                            } else {
                                out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Data not in the table...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                                response.setHeader("Refresh", "3;url=home.jsp");
                            }
                        } catch (Exception e) {
                            out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>" + e.getMessage() + "</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                            response.setHeader("Refresh", "3;url=home.jsp");
                        }
                    }
                    default -> {
                        out.println("<h1 style=\"color: white\">Invalid action.</h1>");
                        response.setHeader("Refresh", "2;url=index.jsp");
                    }
                }
            }

        } catch (Exception e) {
            out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Internal Server Error or Data Invalidation...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
            response.setHeader("Refresh", "3;url=home.jsp");
        } finally {
            out.close();
        }
    }
}
