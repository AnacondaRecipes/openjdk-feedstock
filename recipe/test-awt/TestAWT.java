import java.awt.GraphicsEnvironment;

public class TestAWT {
    public static void main(String[] args) {
        // To wywołanie ładuje libawt.dylib bez GUI
        GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        boolean isHeadless = ge.isHeadlessInstance();
        System.out.println("AWT loaded. Headless: " + isHeadless);
    }
}
