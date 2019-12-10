<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");

	int flight = Integer.parseInt(request.getParameter("flightnum"));
	String airlineId = request.getParameter("airlineid");
	
	// get number of usernames
	PreparedStatement ps = con.prepareStatement("SELECT count(*) FROM OnWaitingList WHERE flight_number = ? AND airline_id = ?");
	ps.setInt(1, flight);
	ps.setString(2, airlineId);
	ResultSet rs = ps.executeQuery();
	rs.next();
	
	String[] usernames = new String[rs.getInt(1)];
	
	// get usernames
	ps = con.prepareStatement("SELECT username FROM OnWaitingList WHERE flight_number = ? AND airline_id = ?");
	ps.setInt(1, flight);
	ps.setString(2, airlineId);
	rs = ps.executeQuery();
	
	int i = 0;
	while(rs.next()) {
		usernames[i++] = rs.getString(1);
	}
	
	session.setAttribute("flightnum", flight);
	session.setAttribute("airlineid", airlineId);
	session.setAttribute("usernames", usernames);
	
	response.sendRedirect("representative.jsp");
%>