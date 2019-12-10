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
			<h3>Aircraft Manager</h3>
			<%
			String responseMsg = (String) session.getAttribute("response");
			if(responseMsg != null && !"null".equals(responseMsg)) {%>
				<div style="margin-bottom: 20px; font-weight: bold"><%=responseMsg%></div>
			<%
			}
			
			session.setAttribute("response", "null");
			%>
			<form method="post" action="getAircraft.jsp">
				<label for="designation">Model:</label>
				<input id="designation" name="designation" placeholder="Model" maxlength="4" required />
				<br>
				<label for="airlineid">Airline:</label>
				<select id="airlineid" name="airlineid" required>
					<%
					ps = con.prepareStatement("SELECT * FROM Airline");
					rs = ps.executeQuery();
					while(rs.next()) {
						String id = rs.getString("airline_id");
					%>
						<option value="<%=id%>"><%=id%> (<%=rs.getString("airline_name")%>)</option>
					<%}%>
				</select>
				<br><br>
				<label for="choice">What would you like to do?</label>
				<select id="choice" name="choice" onchange="aircraftEdit()">
					<option value="create">Create this aircraft</option>
					<option value="delete">Delete this aircraft</option>
					<option value="edit">Edit this aircraft</option>
				</select>
				<br><br>
				<div id="edit" style="display:none">
					<label for="new-designation">New Model:</label>
					<input id="new-designation" name="new-designation" placeholder="New Model" minlength="1" maxlength="4" />
					<br>
					<label for="new-airlineid">New Airline:</label>
					<select id="new-airlineid" name="new-airlineid">
						<%
						ps = con.prepareStatement("SELECT * FROM Airline");
						rs = ps.executeQuery();
						while(rs.next()) {
							String id = rs.getString("airline_id");
						%>
							<option value="<%=id%>"><%=id%> (<%=rs.getString("airline_name")%>)</option>
						<%}%>
					</select>
				</div>
				<br><br>
				<button>Submit</button>
			</form>
		</section>
		<section>
			<h3>Airport Manager</h3>
			
		</section>
		<script>
			function aircraftEdit() {
				if(document.getElementById('choice').value === 'edit') {
					document.getElementById('edit').style.display = 'block';
					document.getElementById('new-designation').required = true;
				} else {
					document.getElementById('edit').style.display = 'none';
					document.getElementById('new-designation').required = false;
				}
			}
		</script>
	</body>
</html>