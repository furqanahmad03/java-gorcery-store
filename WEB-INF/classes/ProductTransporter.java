
public class ProductTransporter {

    private int id;
    private String name;
    private String category;
    private float price;
    private int quantity;

    public ProductTransporter(int id, String name, String category, float price, int quantity) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.quantity = quantity;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getCategory() {
        return category;
    }

    public float getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

}
