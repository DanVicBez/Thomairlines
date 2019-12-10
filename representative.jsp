<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Representative Dashboard</title>
		<link rel="stylesheet" href="style.css"/>
		<style>
			body {
	 			background-image: url("https://images.pexels.com/photos/440731/pexels-photo-440731.jpeg");
	 			background-repeat: no-repeat;
	 			background-attachment: fixed;
	  			background-size: 100%;
			}
		</style>
	</head>
	<body>
		<%
		String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
		%>
		<div id="banner">
			<img alt="Thomairlines" src="https://i.imgur.com/NfZWVqI.jpg" width=55px style="display: inline"/>
			<h1>Thomairlines</h1>
		</div>
		<div>
			<p align = "left">
				<font color = "white" size = 4>
					<a href = 'success.jsp'>Back to Flight Search</a>
				</font>
			</p>
		</div>
		<h2>Customer Representative Dashboard</h2>
		<section>
			<h3>Check waiting list</h3>
			<form method="post" action="getWaitingList.jsp">
				<label for="airlineid">Airline:</label>
				<select id="airlineid" name="airlineid" required>
					<%
					PreparedStatement ps = con.prepareStatement("SELECT * FROM Airline");
					ResultSet rs = ps.executeQuery();
					while(rs.next()) {
						String id = rs.getString("airline_id");
					%>
						<option value="<%=id%>"><%=id%> (<%=rs.getString("airline_name")%>)</option>
					<%}%>
				</select>
				<label for="flightnum">Flight number:</label>
				<input type="number" min="10" max="9999" id="flightnum" name="flightnum" required />
				<br>
				<button>Get waiting list</button>
			</form>
			<br>
			<%
			String[] usernames = (String[]) session.getAttribute("usernames");
			if(usernames != null) {
				if(usernames.length > 0) {
			%>
				Waiting list for flight <%=(String) session.getAttribute("airlineid") + (Integer) session.getAttribute("flightnum")%>:
				<ol>
			<%
					for(String username : usernames) {
			%>
						<li><%=username%></li>
			<%
					}
			%>
				</ol>
			<%
				} else {
			%>
					The waiting list for flight <%=(String) session.getAttribute("airlineid") + (Integer) session.getAttribute("flightnum")%> is empty.
			<%
				}
			}
			%>
		</section>
		<section>
			<h3>Flight Manager</h3>
		</section>
		<section>
			<h3>Airplane Manager</h3>
		</section>
		<section>
			<h3>Airport Manager</h3>
		</section>
	</body>
</html>