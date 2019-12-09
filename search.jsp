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
	String flightType = request.getParameter("flightType");
	String sortBy = request.getParameter("sortBy");
	String filterByPrice = request.getParameter("filterByPrice");
	String filterByStop = request.getParameter("filterByStops");
	String filterByAirline = request.getParameter("filterByAirline");
	boolean reverse = "on".equals(request.getParameter("reverse"));
	boolean flex = "on".equals(request.getParameter("flexibility"));
	
	String query = "SELECT * " +
				   "FROM Flight NATURAL JOIN Airline " +
				   "WHERE d_airport_id = ? AND a_airport_id = ?" + (flex ? "" : " AND days LIKE ?");
	if (!filterByPrice.equals("Price Filter")) {
		query += " AND price < " + filterByPrice.substring(9);
	}
	if (!filterByAirline.equals("Airline Filter")) {
		query += " AND airline_id = '" + filterByAirline.substring(0,2) + "'";
	}
	if (!filterByStop.equals("Stop Filter")) {
		query += " AND stops <= " + filterByStop.substring(8,9);
	}
	if(!"Not Sorted".equals(sortBy)) {
		if("Price Sort".equals(sortBy)) {
			query += " ORDER BY price";
		} else if("Take-Off Time Sort".equals(sortBy)) {
			query += " ORDER BY departure_time";
		} else if("Landing Time Sort".equals(sortBy)) {
			query += " ORDER BY arrival_time";
		}

		if(reverse) {
			query += " DESC";
		}
	}
	
	PreparedStatement st = con.prepareStatement(query);
	PreparedStatement st2;
	
	if (flightType.equals("Round-Trip")) {
		st2 = con.prepareStatement(query);
		st2.setString(1, toAirport.substring(0, 4));
		st2.setString(2, fromAirport.substring(0, 4));
		
		if(!flex) {
			st2.setString(3, "%" + new SimpleDateFormat("EE").format(new SimpleDateFormat("yyyy-MM-dd").parse(toDate)) + "%");
		}
		
		rs2 = st2.executeQuery();
	}
	
	if (!flex) {
		st.setString(3, "%" + new SimpleDateFormat("EE").format(new SimpleDateFormat("yyyy-MM-dd").parse(fromDate)) + "%");
	}
	
	st.setString(1, fromAirport.substring(0, 4));
	st.setString(2, toAirport.substring(0, 4));
	rs = st.executeQuery();

	session.setAttribute("results", rs);
	session.setAttribute("results2", rs2);
	session.setAttribute("fromDate", request.getParameter("fromDate"));
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
