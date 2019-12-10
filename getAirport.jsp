<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>    
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	String name = request.getParameter("name");
	String airportId = request.getParameter("airportid");
	String country = request.getParameter("country");
	String choice = request.getParameter("choice");
	
	PreparedStatement ps;
	ResultSet rs;
	
	if(choice.equals("create")) {
		ps = con.prepareStatement("SELECT * FROM Airport WHERE airport_id = ?");
		ps.setString(1, airportId);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			session.setAttribute("airport-response", "Error creating airport: already exists");
		} else {
			ps = con.prepareStatement("INSERT INTO Airport VALUES (?, ?, ?)");
			ps.setString(1, name);
			ps.setString(2, airportId);
			ps.setString(3, country);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			session.setAttribute("airport-response", "Airport successfully created");
		}
	} else if(choice.equals("delete")) {
		ps = con.prepareStatement("SELECT * FROM Airport WHERE airport_id = ?");
		ps.setString(1, airportId);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			ps = con.prepareStatement("DELETE FROM Airport WHERE airport_id = ?");
			ps.setString(1, airportId);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			session.setAttribute("airport-response", "Airport successfully deleted");
		} else {
			session.setAttribute("airport-response", "Error deleting airport: doesn't exist");
		}
	} else if(choice.equals("edit")) {
		ps = con.prepareStatement("SELECT * FROM Airport WHERE airport_id = ?");
		ps.setString(1, airportId);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			String newName = request.getParameter("new-name");
			String newAirportId = request.getParameter("new-airportid");
			String newCountry = request.getParameter("new-country");
			
			ps = con.prepareStatement("UPDATE Airport SET airport_name = ?, airport_id = ?, country = ? WHERE airport_id = ?");
			ps.setString(1, newName.isEmpty() ? name : newName);
			ps.setString(2, newAirportId.isEmpty() ? airportId : newAirportId);
			ps.setString(3, newCountry.isEmpty() ? country : newCountry);
			ps.setString(4, airportId);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			session.setAttribute("airport-response", "Airport successfully edited");
		} else {
			session.setAttribute("airport-response", "Error editing airport: doesn't exist");
		}
	}
	
	response.sendRedirect("representative.jsp");
%>