
import java.io.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.sql.*;
import java.util.HashMap;

public class AuthenticationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String action = request.getParameter("actionType");

        try {
            DAO dao = new DAO();
            if ("login".equals(action)) {
                String userType = request.getParameter("userType");
                HashMap<String, Object> result = dao.getLoginAuth(userType, email, password);

                if (!((boolean) result.get("status"))) { // No user found
                    out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>" + result.get("message") + "</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                    response.setHeader("Refresh", "1;url=index.jsp");

                } else { // Successful login
                    HttpSession session = request.getSession();
                    session.setMaxInactiveInterval(30 * 60);
                    session.setAttribute("email", email);
                    session.setAttribute("userType", userType);
                    session.setAttribute("name", result.get("name"));
                    response.sendRedirect("home.jsp");
                }

            } else if ("register".equals(action)) {
                String fname = request.getParameter("fname");
                String lname = request.getParameter("lname");
                String address = request.getParameter("address");
                try {
                    if (dao.getRegistered(address, email, password, fname, lname, address) > 0) {
                        HttpSession session = request.getSession(true);
                        session.setMaxInactiveInterval(30 * 60);
                        session.setAttribute("email", email);
                        session.setAttribute("userType", "Customer");
                        session.setAttribute("name", fname + " " + lname);
                        response.sendRedirect("home.jsp");
                    } else {
                        out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Internal Server Error or Email is already registered...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                        response.setHeader("Refresh", "1;url=index.jsp");
                    }
                } catch (Exception e) {
                    out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Email already exists...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
                    response.setHeader("Refresh", "1;url=index.jsp");
                }
            } else {
                out.println("<h1 style=\"color: white\">Invalid action.</h1>");
                response.setHeader("Refresh", "2;url=index.jsp");
            }

        } catch (SQLException | ClassNotFoundException e) {
            out.println("<body style='background: linear-gradient(to bottom, black, #000000); width: 100%; height: 100%; display: flex; justify-content: center; align-items: center;'><div style='animation: fadeInOut 3s ease-in-out; background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;'><h3 style='color: white; margin: 0;'>Internal Server Error or Email is already registered...</h3></div><style>@keyframes fadeInOut {0% {opacity: 0; transform: translateY(-20px);} 20%,80% {opacity: 1; transform: translateY(0);} 100% {opacity: 0; transform: translateY(20px);}}</style></body>");
            response.setHeader("Refresh", "1;url=index.jsp");
        } finally {
            out.close();
        }
    }
}
