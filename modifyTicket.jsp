<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>    
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");

	int ticket = Integer.parseInt(request.getParameter("ticketnum"));
	String meal = request.getParameter("meal").toLowerCase();
	String ticketType = request.getParameter("class");
	
	PreparedStatement ps;
	ResultSet rs;
	
	if(!meal.isEmpty()) {
		ps = con.prepareStatement("UPDATE AssociatedWith SET meal = ? WHERE ticket_num = ?");
		ps.setString(1, meal);
		ps.setInt(2, ticket);
		System.out.printf("Updated %d rows\n", ps.executeUpdate());
	}
	
	session.setAttribute("error", "");
	
	if(!ticketType.isEmpty()) {
		ps = con.prepareStatement("SELECT flight_num, airline_id FROM AssociatedWith WHERE ticket_num = ?");
		ps.setInt(1, ticket);
		rs = ps.executeQuery();
		rs.next();
		int flightNum = rs.getInt("flight_num");
		String airlineId = rs.getString("airline_id");
		
		ps = con.prepareStatement(String.format("SELECT %s_class_total - %s_class FROM Seat WHERE flight_num = ? AND airline_id = ?", ticketType, ticketType));
		ps.setInt(1, flightNum);
		ps.setString(2, airlineId);
		rs = ps.executeQuery();
		rs.next();
		
		if(rs.getInt(1) > 0) {
			ps = con.prepareStatement("SELECT ticket_type FROM Ticket WHERE ticket_num = ?");
			ps.setInt(1, ticket);
			rs = ps.executeQuery();
			rs.next();
			String oldTicketType = rs.getString("ticket_type");
			
			ps = con.prepareStatement(String.format("UPDATE Seat SET %s_class = %s_class - 1 WHERE flight_num = ? AND airline_id = ?", oldTicketType, oldTicketType));
			ps.setInt(1, flightNum);
			ps.setString(2, airlineId);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			ps = con.prepareStatement("UPDATE Ticket SET ticket_type = ? WHERE ticket_num = ?");
			ps.setString(1, ticketType);
			ps.setInt(2, ticket);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			ps = con.prepareStatement(String.format("UPDATE Seat SET %s_class = %s_class + 1 WHERE flight_num = ? AND airline_id = ?", ticketType, ticketType));
			ps.setInt(1, flightNum);
			ps.setString(2, airlineId);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			String[] classes = {"economy", "business", "first"};
			int[] prices = {0, 150, 300};
			int priceChange = 0;
			
			for(int newType = 0; newType < classes.length; newType++) {
				if(classes[newType].equals(ticketType)) {
					for(int oldType = 0; oldType < classes.length; oldType++) {
						if(classes[oldType].equals(oldTicketType)) {
							priceChange = prices[newType] - prices[oldType];
						}
					}		
				}
			}
			
			ps = con.prepareStatement("UPDATE Ticket SET total_fare = total_fare + ? WHERE ticket_num = ?");
			ps.setInt(1, priceChange);
			ps.setInt(2, ticket);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
		} else {
			session.setAttribute("error", String.format("Failed to update ticket: %s class is already full", ticketType));
		}
	}
	
	response.sendRedirect("reservations.jsp");
%>