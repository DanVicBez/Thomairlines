<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page import ="java.sql.*" %>
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	ResultSet rs = (ResultSet) session.getAttribute("results");
	
	boolean flex = ("on".equals(request.getParameter("flexibility")));
	
	PreparedStatement st;
	if (flex) {
		st = con.prepareStatement("SELECT * " +
								  "FROM Flight " +
								  "WHERE d_airport_id = ? AND a_airport_id = ?");
	} else {
		st = con.prepareStatement("SELECT * " +
								  "FROM Flight " +
								  "WHERE d_airport_id = ? AND a_airport_id = ? AND days LIKE ?");
		st.setString(3, "%" + new SimpleDateFormat("EE").format(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("fromDate"))) + "%");
	}
	
	st.setString(1, request.getParameter("fromAirport").substring(0, 4));
	st.setString(2, request.getParameter("toAirport").substring(0, 4));
	rs = st.executeQuery();
	
	session.setAttribute("results", rs);
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
