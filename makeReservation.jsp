<%@ page import ="java.sql.*" %>
<%

	String username = (String)session.getAttribute("user");
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	PreparedStatement st = con.prepareStatement("INSERT INTO Reserves " +
					   							"VALUES (?,?,?);");
	st.setString(1,username);
	if (request.getParameter("group1") != null && request.getParameter("group1").length() > 2) {
		String dReserveAirline = request.getParameter("group1").substring(0,2);
		String dReserveFlightNumber = request.getParameter("group1").substring(2);
		st.setString(2,dReserveFlightNumber);
		st.setString(3,dReserveAirline);
		st.executeUpdate();
	}
	if (request.getParameter("group2") != null && request.getParameter("group2").length() > 2) {
		String rReserveAirline = request.getParameter("group2").substring(0,2);
		String rReserveFlightNumber = request.getParameter("group2").substring(2);
		st.setString(2,rReserveFlightNumber);
		st.setString(3,rReserveAirline);
		st.executeUpdate();
	}
	
	response.sendRedirect("reservations.jsp");
%>