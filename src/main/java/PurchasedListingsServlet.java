package main.java;



import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class NewListingServlet
 */
@WebServlet(name="PurchasedListingsServlet", urlPatterns=("/PurchasedListingsServlet"))
public class PurchasedListingsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PurchasedListingsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void doPost(HttpServletRequest req, HttpServletResponse response) throws ServletException, IOException {
    	doGet(req, response);
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
				
				HttpSession session = req.getSession();
				User user = (User) session.getAttribute("user");
				int userID = user.getId(); 
				
		
				Properties props = new Properties();
				props.load(getClass().getClassLoader().getResourceAsStream("database.properties"));
				
				final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
				final String DB_URL = props.getProperty("dburl");
				
				//  Database credentials
				final String USER = props.getProperty("user");
				final String PASS = props.getProperty("password");
				Connection conn = null;
				PreparedStatement preparedStatement = null;
				User thisUser = new User(null, null, null,null, null);
				ArrayList<Listing> resultList = new ArrayList<Listing>();
				
				resp.getWriter().println("<html>");
				resp.getWriter().println("<head>");
				resp.getWriter().println("<title>This is the response</title>");
				resp.getWriter().println("</head>");
				resp.getWriter().println("<body>");
						
				try	{
					Class.forName(JDBC_DRIVER);
					System.out.println("Connecting to database....");
					conn = DriverManager.getConnection(DB_URL, USER, PASS);
					
					String sql = "SELECT * FROM PARKINGLISTING WHERE tenantID = " + userID;
					Statement statement = conn.createStatement();
					ResultSet rs = statement.executeQuery(sql);
					
					while(rs.next())	{
						int listingID = rs.getInt("listingID");
						String listingName = rs.getString("listingName");
						String address = rs.getString("address");
						double price = rs.getDouble("price");
						String parkingType = rs.getString("parkingType");
						String timeAvailable = rs.getString("timeAvailable");
						String availableTill = rs.getString("availableTill");
						int renterID = rs.getInt("renterID");
						
						String sql2 = "SELECT uPhoneNumber, uFname, uLname FROM USER WHERE uID in (SELECT renterID FROM PARKINGLISTING WHERE renterID = " + renterID + ")";
						Statement statement2 = conn.createStatement();
						ResultSet rs2 = statement2.executeQuery(sql2);
						
						while(rs2.next()) {
							String phoneNumber = rs2.getString("uPhoneNumber");
							String firstName = rs2.getString("uFname");
							String lastName = rs2.getString("uLname");
							
							Listing result = new Listing(listingID, listingName, address, price, parkingType, timeAvailable, availableTill, renterID);
							result.setRenterPhoneNumber(phoneNumber);
							result.setRenterName(firstName + " " + lastName);
							resultList.add(result);	
						}	
					}
				}
				catch(SQLException se){se.printStackTrace();}
				catch(Exception e)	{
					e.printStackTrace();
				}
				finally	{
					try{ if(preparedStatement!=null) preparedStatement.close(); }
					catch(SQLException se2){ }// nothing we can do

					try{ if(conn!=null) conn.close(); }
					catch(SQLException se){ se.printStackTrace(); }
				}			
				
				req.setAttribute("results", resultList);
				req.getRequestDispatcher("PurchasedListings.jsp").forward(req, resp);
				
//				resp.getWriter().println("</body>");
//				resp.getWriter().println("</html>");
			}
		//response.getWriter().append("Served at: ").append(request.getContextPath());
}