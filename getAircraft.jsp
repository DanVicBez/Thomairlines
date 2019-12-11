<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>    
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	String designation = request.getParameter("designation");
	String airlineId = request.getParameter("airlineid");
	String choice = request.getParameter("choice");
	
	PreparedStatement ps;
	ResultSet rs;
	
	if(choice.equals("create")) {
		ps = con.prepareStatement("SELECT * FROM Aircraft WHERE designation = ? AND airline_id = ?");
		ps.setString(1, designation);
		ps.setString(2, airlineId);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			session.setAttribute("aircraft-response", "Error creating aircraft: already exists");
		} else {
			ps = con.prepareStatement("INSERT INTO Aircraft VALUES (?, ?)");
			ps.setString(1, designation);
			ps.setString(2, airlineId);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			session.setAttribute("aircraft-response", "Aircraft successfully created");
		}
	} else if(choice.equals("delete")) {
		ps = con.prepareStatement("SELECT * FROM Aircraft WHERE designation = ? AND airline_id = ?");
		ps.setString(1, designation);
		ps.setString(2, airlineId);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			ps = con.prepareStatement("DELETE FROM Aircraft WHERE designation = ? AND airline_id = ?");
			ps.setString(1, designation);
			ps.setString(2, airlineId);
			System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
			session.setAttribute("aircraft-response", "Aircraft successfully deleted");
		} else {
			session.setAttribute("aircraft-response", "Error deleting aircraft: doesn't exist");
		}
	} else if(choice.equals("edit")) {
		ps = con.prepareStatement("SELECT * FROM Aircraft WHERE designation = ? AND airline_id = ?");
		ps.setString(1, designation);
		ps.setString(2, airlineId);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			String newDesignation = request.getParameter("new-designation");
			String newAirlineId = request.getParameter("new-airlineid");
			
			ps = con.prepareStatement("SELECT * FROM Aircraft WHERE designation = ? AND airline_id = ?");
			ps.setString(1, newDesignation);
			ps.setString(2, newAirlineId);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				session.setAttribute("aircraft-response", "Error editing aircraft: new aircraft already exists");
			} else {
				ps = con.prepareStatement("UPDATE Aircraft SET designation = ?, airline_id = ? WHERE designation = ? and airline_id = ?");
				ps.setString(1, newDesignation);
				ps.setString(2, newAirlineId);
				ps.setString(3, designation);
				ps.setString(4, airlineId);
				System.out.printf("Updated %d rows\n", ps.executeUpdate());
				
				session.setAttribute("aircraft-response", "Aircraft successfully edited");	
			}
		} else {
			session.setAttribute("aircraft-response", "Error editing aircraft: doesn't exist");
		}
	}
	
	response.sendRedirect("representative.jsp");
%>