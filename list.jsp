<%@page import = "java.text.SimpleDateFormat"%>
<%@page import = "java.util.Calendar"%>
<%@ page import = "java.sql.*" %>
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	ResultSet rs = (ResultSet) session.getAttribute("results");
	ResultSet rs2 = (ResultSet) session.getAttribute("results2");
	
	String airport = request.getParameter("Airport");
	
	String query = "SELECT * " +
				   "FROM Flight NATURAL JOIN Airline " +
				   "WHERE d_airport_id = '" + airport.substring(0,4) + "' OR a_airport_id = '" + airport.substring(0,4) + "'" ;
	
	PreparedStatement st = con.prepareStatement(query);
	//st.setString(1, airport.substring(0, 4));
	//st.setString(2, airport.substring(0, 4));
	rs = st.executeQuery(query);
	
	session.setAttribute("results", rs);
	response.sendRedirect("administrator.jsp");
%>
				 