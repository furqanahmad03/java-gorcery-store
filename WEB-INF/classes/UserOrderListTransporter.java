
public class UserOrderListTransporter {

    private String name;
    private String category;
    private int quantity;
    private float price;
    private float total_amount;
    private String status;
    private String reason;

    public UserOrderListTransporter(String name, String category, int quantity, float price, float total_amount, String status, String reason) {
        this.name = name;
        this.category = category;
        this.quantity = quantity;
        this.price = price;
        this.total_amount = total_amount;
        this.status = status;
        this.reason = reason;
    }

    public String getName() {
        return name;
    }

    public String getCategory() {
        return category;
    }

    public int getQuantity() {
        return quantity;
    }

    public float getPrice() {
        return price;
    }

    public float getTotal_amount() {
        return total_amount;
    }

    public String getStatus() {
        return status;
    }

    public String getReason() {
        return reason;
    }

}
