<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>
<%	String url="jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection(url, "admin", "prinfo$9.99");
%>
<%
	String flightInfo = request.getParameter("flightInfo");
	String[] info = flightInfo.split(",");
	PreparedStatement pss = con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN AssociatedWith NATURAL JOIN Ticket WHERE username = ? && ticket_num = ? && flight_num = ? && airline_id = ?;");
	pss.setString(1, (String)session.getAttribute("user"));
	pss.setInt(2, Integer.valueOf(info[0]));
	pss.setInt(3, Integer.valueOf(info[1]));
	pss.setString(4, info[2]);
	ResultSet rss = pss.executeQuery();
	rss.next();
	String ticketType = rss.getString("ticket_type");
	String dDate = rss.getString("d_date");
	if(ticketType.equals("business")){
		pss = con.prepareStatement("UPDATE Seat SET business_class = business_class - 1 WHERE flight_num = ? && airline_id = ?;");
		pss.setInt(1, Integer.valueOf(info[1]));
		pss.setString(2, info[2]);
		pss.executeUpdate();
	}else if(ticketType.equals("first-class")){
		pss = con.prepareStatement("UPDATE Seat SET first_class = first_class - 1 WHERE flight_num = ? && airline_id = ?;");
		pss.setInt(1, Integer.valueOf(info[1]));
		pss.setString(2, info[2]);
		pss.executeUpdate();
	}else{
		pss = con.prepareStatement("UPDATE Seat SET economy_class = economy_class - 1 WHERE flight_num = ? && airline_id = ?;");
		pss.setInt(1, Integer.valueOf(info[1]));
		pss.setString(2, info[2]);
		pss.executeUpdate();
	}
	pss = con.prepareStatement("SELECT COUNT(*) AS c FROM Ticket NATURAL JOIN AssociatedWith NATURAL JOIN Reserves WHERE username = ? && d_date = ? && flight_num = ? && airline_id = ?;");
	pss.setString(1, (String)session.getAttribute("user"));
	pss.setString(2, dDate);
	pss.setInt(3, Integer.valueOf(info[1]));
	pss.setString(4, info[2]);
	rss = pss.executeQuery();
	rss.next();
	if(rss.getInt("c") > 1){
		pss = con.prepareStatement("DELETE FROM AssociatedWith WHERE ticket_num = ? && flight_num = ?;");
		pss.setInt(1, Integer.valueOf(info[0]));
		pss.setInt(2, Integer.valueOf(info[1]));
		rss = pss.executeQuery();
		pss = con.prepareStatement("DELETE FROM Ticket WHERE ticket_num = ? && username = ?;");
		pss.setInt(1, Integer.valueOf(info[0]));
		pss.setString(2, (String)session.getAttribute("user"));
		pss.executeUpdate();
		
	}else{
		pss = con.prepareStatement("DELETE FROM Reserves WHERE username = ? && flight_num = ?;");
		pss.setString(1, (String)session.getAttribute("user"));
		pss.setInt(2, Integer.valueOf(info[1]));
		pss.executeUpdate();
		pss = con.prepareStatement("DELETE FROM AssociatedWith WHERE ticket_num = ? && flight_num = ?;");
		pss.setInt(1, Integer.valueOf(info[0]));
		pss.setInt(2, Integer.valueOf(info[1]));
		pss.executeUpdate();
		pss = con.prepareStatement("DELETE FROM Ticket WHERE ticket_num = ? && username = ?;");
		pss.setInt(1, Integer.valueOf(info[0]));
		pss.setString(2, (String)session.getAttribute("user"));
		pss.executeUpdate();
	}
	response.sendRedirect("reservations.jsp");
%>