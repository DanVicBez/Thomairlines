<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page import ="java.sql.*" %>
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	ResultSet rs = (ResultSet) session.getAttribute("results");
	ResultSet rs2 = (ResultSet) session.getAttribute("results2");
	
	String fromAirport = request.getParameter("fromAirport");
	String toAirport = request.getParameter("toAirport");
	String fromDate = request.getParameter("fromDate");
	String toDate = request.getParameter("toDate");
	
	boolean flex = ("on".equals(request.getParameter("flexibility")));

	String flightType = request.getParameter("flightType");
	PreparedStatement st;
	PreparedStatement st2;
	if (flex) {
		st = con.prepareStatement("SELECT * " +
									"FROM Flight NATURAL JOIN Airline " +
									"WHERE d_airport_id = ? AND a_airport_id = ?");
		if (flightType.equals("Round-Trip")) {
			st2 = con.prepareStatement("SELECT * " +
					"FROM Flight NATURAL JOIN Airline " +
					"WHERE a_airport_id = ? AND d_airport_id = ?");
			st2.setString(1, fromAirport.substring(0, 4));
			st2.setString(2, toAirport.substring(0, 4));
			rs2 = st2.executeQuery();
		}
	} else {
		st = con.prepareStatement("SELECT * " +
									"FROM Flight NATURAL JOIN Airline " +
									"WHERE d_airport_id = ? AND a_airport_id = ? AND days LIKE ?");
		st.setString(3, "%" + new SimpleDateFormat("EE").format(new SimpleDateFormat("yyyy-MM-dd").parse(fromDate)) + "%");
		if (flightType.equals("Round-Trip")) {
			st2 = con.prepareStatement("SELECT * " +
					"FROM Flight NATURAL JOIN Airline " +
					"WHERE a_airport_id = ? AND d_airport_id = ? AND days LIKE ?");
			st2.setString(1, fromAirport.substring(0, 4));
			st2.setString(2, toAirport.substring(0, 4));
			st2.setString(3, "%" + new SimpleDateFormat("EE").format(new SimpleDateFormat("yyyy-MM-dd").parse(toDate)) + "%");
			rs2 = st2.executeQuery();
		}
	}
	
	st.setString(1, fromAirport.substring(0, 4));
	st.setString(2, toAirport.substring(0, 4));
	rs = st.executeQuery();

	session.setAttribute("results", rs);
	session.setAttribute("results2", rs2);
	response.sendRedirect("success.jsp");
%>
<br>
<%= request.getParameter("fromAirport").substring(0, 4)%>
<br>
<%= request.getParameter("toAirport").substring(0, 4)%>
<br>
From: <%=request.getParameter("fromDate")%>
<br>
To: <%=request.getParameter("toDate")%>
<br>
