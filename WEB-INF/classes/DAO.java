
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;

public class DAO extends HttpServlet {

    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet result = null;

    public DAO() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://127.0.0.1:3306/Project";
            connection = DriverManager.getConnection(url, "root", "root");
        } catch (Exception e) {
            throw new SQLException("Constructor throwing exception while making a connection: " + e.getMessage());
        }
    }

    public HashMap<String, Object> getLoginAuth(String userType, String email, String password) throws SQLException, ClassNotFoundException {

        try {
            if ("Admin".equals(userType)) {
                ps = connection.prepareStatement("SELECT * FROM Admin WHERE email = ?");
            } else {
                ps = connection.prepareStatement("SELECT * FROM Customer WHERE email = ?");
            }

            ps.setString(1, email);
            result = ps.executeQuery();
            HashMap<String, Object> response = new HashMap<>();

            if (!result.next()) { // No user found
                response.put("status", false);
                response.put("message", "User Not Found...");
                response.put("value", -1);
                return response;

            } else if (!result.getString("password").equals(password)) { // Wrong password
                response.put("status", false);
                response.put("message", "Wrong Passowrd");
                response.put("value", 0);
                return response;

            } else { // Successful login
                response.put("status", true);
                response.put("name", result.getString("fname") + " " + result.getString("lname"));
                response.put("value", 1);
                return response;
            }

        } finally {
            closeConnection();
        }
    }

    public int getRegistered(String userType, String email, String password, String fname, String lname, String address) throws Exception {

        try {
            ps = connection.prepareStatement("INSERT INTO Customer(fname, lname, address, email, password, type) VALUES (?, ?, ?, ?, ?, 'CUSTOMER')");
            ps.setString(1, fname);
            ps.setString(2, lname);
            ps.setString(3, address);
            ps.setString(4, email);
            ps.setString(5, password);
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    public boolean addProduct(String name, String category, float price, int quantity) throws Exception {
        try {
            ps = connection.prepareStatement("INSERT INTO Products(name, category, price, quantity) VALUES (?, ?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setFloat(3, price);
            ps.setInt(4, quantity);
            int status = ps.executeUpdate();
            return status > 0;

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    public boolean updateProduct(float price, int quantity, String name) throws Exception {
        try {
            ps = connection.prepareStatement("UPDATE Products SET price = price + ?, quantity = quantity + ? WHERE name = ?");
            ps.setFloat(1, price);
            ps.setInt(2, quantity);
            ps.setString(3, name);
            int status = ps.executeUpdate();
            return status > 0;

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    public boolean deleteProduct(String name) throws Exception {
        try {
            ps = connection.prepareStatement("DELETE FROM Products WHERE name = ?");
            ps.setString(1, name);
            int status = ps.executeUpdate();
            return status > 0;

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    public ArrayList<ProductTransporter> getAllProducts(String searchedProduct) throws SQLException {
        ArrayList<ProductTransporter> products = new ArrayList<>();
        try {
            if (searchedProduct == null || "all".equals(searchedProduct)) {
                ps = connection.prepareStatement("SELECT * FROM Products");
            } else {
                ps = connection.prepareStatement("SELECT * FROM Products WHERE LOWER(name) = LOWER(?)");
                ps.setString(1, searchedProduct);
            }
            result = ps.executeQuery();
            while (result.next()) {
                int id = result.getInt(1);
                String name = result.getString(2);
                String category = result.getString(3);
                float price = result.getFloat(4);
                int quantity = result.getInt(5);
                products.add(new ProductTransporter(id, name, category, price, quantity));
            }
            return products;

        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    public boolean dispatchProduct(String reason, int order_no) throws SQLException {
        try {
            ps = connection.prepareStatement("UPDATE Sold_Items SET status = ?, reason = ? WHERE order_no = ?");
            ps.setString(1, "DISPATCHED");
            ps.setString(2, reason);
            ps.setInt(3, order_no);
            int status = ps.executeUpdate();
            return status > 0;
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    public boolean rejectProduct(String reason, int order_no, int quantity, int productID) throws SQLException {
        try {
            ps = connection.prepareStatement("UPDATE Sold_Items SET status = ?, reason = ? WHERE order_no = ?");
            ps.setString(1, "REJECTED");
            ps.setString(2, reason);
            ps.setInt(3, order_no);
            int status = ps.executeUpdate();
            if (status > 0) {
                return updateProductAfterRejection(quantity, productID);
            } else {
                throw new SQLException("Rejection didn't take place");
            }
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    private boolean updateProductAfterRejection(int quantity, int productID) throws SQLException {
        try {
            ps = connection.prepareStatement("UPDATE Products SET quantity = quantity + ? WHERE product_id = ?");
            ps.setInt(1, quantity);
            ps.setInt(2, productID);
            int status = ps.executeUpdate();
            if (status > 0) {
                return true;
            } else {
                throw new SQLException("Rejection didn't take place");
            }
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        } finally {
            closeConnection();
        }
    }

    public boolean placeOrder(HashMap<Integer, HashMap<String, Object>> cart, Vector<String> errors, String email) throws SQLException {
        try {
            for (Integer productID : cart.keySet()) {
                HashMap<String, Object> details = cart.get(productID);
                int quantity = (Integer) details.get("count");
                ps = connection.prepareStatement("SELECT * FROM Products WHERE product_id = ?");
                ps.setInt(1, productID);
                try {
                    result = ps.executeQuery();
                    if (result.next()) {
                        int available_quantity = result.getInt("quantity");
                        if (quantity > available_quantity) {
                            errors.add("Product number " + productID + " is unavailable");
                        } else {
                            ps = connection.prepareStatement("UPDATE Products SET quantity = quantity - ? WHERE product_id = ?");
                            ps.setInt(1, quantity);
                            ps.setInt(2, productID);
                            int updation = ps.executeUpdate();
                            if (updation > 0) {
                                ps = connection.prepareStatement("INSERT INTO Sold_Items (email, product_id, price, quantity, total_amount) VALUES (?, ?, ?, ?, ?)");
                                ps.setString(1, email);
                                ps.setInt(2, productID);
                                ps.setFloat(3, result.getFloat("price"));
                                ps.setInt(4, quantity);
                                ps.setFloat(5, (quantity * result.getFloat("price")));
                                int nextUpdation = ps.executeUpdate();
                                if (nextUpdation <= 0) {
                                    errors.add("Cart Updation Faild for product id " + productID);
                                }
                            } else {
                                errors.add("Product number " + productID + " caused failure in updation");
                            }
                        }
                    }
                } catch (Exception e) {
                    errors.add("Exception caught: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        return errors.isEmpty();
    }

    // public HashMap<String, HashMap<String, Object>> getUserOrderList(String email, String searchedProduct) throws SQLException {
    //     HashMap<String, HashMap<String, Object>> orderHistory = new HashMap();
    //     try {
    //         if (searchedProduct == null || "all".equals(searchedProduct)) {
    //             ps = connection.prepareStatement("SELECT P.name, P.category, SI.quantity, P.price, SI.total_amount, SI.status, SI.reason, SI.order_no FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email) WHERE C.email = ? ORDER BY SI.order_no DESC;");
    //         } else {
    //             ps = connection.prepareStatement("SELECT P.name, P.category, SI.quantity, P.price, SI.total_amount, SI.status, SI.reason, SI.order_no FROM Sold_Items SI JOIN Products P USING (product_id) JOIN Customer C USING (email) WHERE C.email = ? AND LOWER(P.name) = LOWER(?) ORDER BY SI.order_no DESC;");
    //             ps.setString(2, searchedProduct);
    //         }
    //         ps.setString(1, email);
    //         result = ps.executeQuery();
    //         while (result.next()) {
    //             String name = result.getString("name");
    //             String category = result.getString("category");
    //             int quantity = result.getInt("quantity");
    //             float price = result.getFloat("price");
    //             float total_amount = result.getFloat("total_amount");
    //             String status = result.getString("status");
    //             String reason = result.getString("reason");

    //             HashMap<String, Object> productDetails = new HashMap<>();
    //             productDetails.put("name", name);
    //             productDetails.put("category", category);
    //             productDetails.put("quantity", quantity);
    //             productDetails.put("price", price);
    //             productDetails.put("totalAmount", total_amount);
    //             productDetails.put("status", status);
    //             productDetails.put("reason", reason);

    //             orderHistory.put(name, productDetails);

    //         }

    //     } catch (SQLException e) {
    //         throw new SQLException(e.getMessage());
    //     } finally {
    //         closeConnection();
    //     }
    //     return orderHistory;
    // }

    public void closeConnection() throws SQLException {
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
            throw new SQLException(e.getMessage());
        }
    }

}
