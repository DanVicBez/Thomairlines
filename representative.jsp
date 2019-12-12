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
			if(session.getAttribute("usernames") != null && !"null".equals(session.getAttribute("usernames"))){
				String[] usernames = (String[]) session.getAttribute("usernames");
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
			session.setAttribute("usernames", "null");
			%>
		</section>
		<section>
			<h3>Flight Manager</h3>
			<%
			String responseMsg = (String) session.getAttribute("flight-response");
			if(responseMsg != null && !"null".equals(responseMsg)) {
				if (responseMsg.startsWith("Error")) {%>
					<div style="margin-bottom: 20px; font-weight: bold; color: red"><%=responseMsg%></div> <%
				} else {%>
				<div style="margin-bottom: 20px; font-weight: bold; color: green"><%=responseMsg%></div>
			<%}
			}
			session.setAttribute("flight-response", "null");
			%>
			<form method = "post" action = "getFlight.jsp">
				<div id= "flight-create" style = "display:none">
				<label for="flightNum">Flight #:</label>
				<input id="flightNum" name="flightNum" placeholder="Flight #"/>
				<br>
				<label for="airlineid2">Airline:</label>
				<select id="airlineid2" name="airlineid2">
					<option value = "" selected disabled>Please choose an airline</option>
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
				</div>
				<label for="flight-choice">What would you like to do?</label>
				<select id="flight-choice" name="choice" onchange="flightEdit()">
					<option value="create">Create this flight</option>
					<option value="delete">Delete this flight</option>
					<option value="edit">Edit this flight</option>
				</select>
				<br><br>
				<div id="flight-edit">
					Leave a field blank to leave it unchanged.
					<br><br>
					<label for="new-flightnum">New Flight #:</label>
					<input required id="new-flightnum" name="new-flightnum" placeholder="New Flight #" type= "number" min = "2" max = "9999" />
					<br>
					<label for="new-airlineid2">New Airline:</label>
					<select id="new-airlineid2" name="new-airlineid2" required>
					<option value = "" selected disabled>Please choose an airline</option>
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
					<label for="new-days">New Operating Days:</label>
					<br><br>
					<input type="checkbox" name="new-mon"> Monday
					<br>
					<input type="checkbox" name="new-tue"> Tuesday
					<br>
					<input type="checkbox" name="new-wed"> Wednesday
					<br>
					<input type="checkbox" name="new-thu"> Thursday
					<br>
					<input type="checkbox" name="new-fri"> Friday
					<br>
					<input type="checkbox" name="new-sat"> Saturday
					<br>
					<input type="checkbox" name="new-sun"> Sunday
					<br>
					<label for="new-dtime">New Departure Time:</label>
					<input type = "time" id="new-dtime" name="new-dtime" required/>
					<br>
					<label for="new-atime">New Arrival Time:</label>
					<input type = "time" id="new-atime" name="new-atime" required/>
					<br>
					<label for="new-dairportid">New Departing Airport:</label>
					<select id="new-dairportid" name="new-dairportid" required>
					<option value="" disabled selected>Please choose an airport</option>
						<%
						ps = con.prepareStatement("SELECT * FROM Airport");
						rs = ps.executeQuery();
						while(rs.next()) {
							String id = rs.getString("airport_id");
						%>
							<option value="<%=id%>"><%=id%> (<%=rs.getString("airport_name")%>)</option>
						<%}%>
					</select>
					<br><br>
					<label for="new-aairportid">New Arriving Airport:</label>
					<select id="new-aairportid" name="new-aairportid" required>
						<option value="" disabled selected>Please choose an airport</option>
						<%
						ps = con.prepareStatement("SELECT * FROM Airport");
						rs = ps.executeQuery();
						while(rs.next()) {
							String id = rs.getString("airport_id");
						%>
							<option value="<%=id%>"><%=id%> (<%=rs.getString("airport_name")%>)</option>
							<%}%>
					</select>
					<br><br>
					<label for="new-designation2">New Model:</label>
					<select id="new-designation2" name="new-designation2" required>
						<option value="" disabled selected>Please choose an aircraft model</option>
						<%
						ps = con.prepareStatement("SELECT DISTINCT designation FROM Aircraft;");
						rs = ps.executeQuery();
						while(rs.next()) {
							String id = rs.getString("designation");
						%>
							<option value="<%=id%>"><%=id%></option>
							<%}%>
					</select>
					<br><br>
					<label for="new-price">New Price:</label>
					<input id="new-price" name="new-price" placeholder="New Price" required/>
					<br>
					<label for="new-stops">New # of Stops:</label>
					<select id="new-stops" name="new-stops" required>
						<option value="" disabled selected>Please choose an amount of stops</option>
						<option value="0">0</option>
						<option value="1">1</option>
						<option value="2">2</option>
					</select>
				</div>
				<br><br>
				<button>Submit</button>
			</form>
		</section>
		<section>
			<h3>Aircraft Manager</h3>
			<%
			responseMsg = (String) session.getAttribute("aircraft-response");
			if(responseMsg != null && !"null".equals(responseMsg)) {
				if (responseMsg.startsWith("Error")) {%>
					<div style="margin-bottom: 20px; font-weight: bold; color: red"><%=responseMsg%></div> <%
				} else {%>
				<div style="margin-bottom: 20px; font-weight: bold; color: green"><%=responseMsg%></div>
			<%}
			}
			
			session.setAttribute("aircraft-response", "null");
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
				<label for="aircraft-choice">What would you like to do?</label>
				<select id="aircraft-choice" name="choice" onchange="aircraftEdit()">
					<option value="create">Create this aircraft</option>
					<option value="delete">Delete this aircraft</option>
					<option value="edit">Edit this aircraft</option>
				</select>
				<br><br>
				<div id="aircraft-edit" style="display:none">
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
			<%
			responseMsg = (String) session.getAttribute("airport-response");
			if(responseMsg != null && !"null".equals(responseMsg)) {
				if (responseMsg.startsWith("Error")) {
					%><div style="margin-bottom: 20px; font-weight: bold; color: red"><%=responseMsg%></div> <%
				} else {%>
				<div style="margin-bottom: 20px; font-weight: bold; color: green"><%=responseMsg%></div>
			<%}
			}
			
			session.setAttribute("airport-response", "null");
			%>
			<form method="post" action="getAirport.jsp">
				<label for="name">Name:</label>
				<input id="name" name="name" placeholder="Name" maxlength="40" required />
				<br>
				<label for="airportid">ID:</label>
				<input id="airportid" name="airportid" placeholder="ID" maxlength="3" required>
				<br>
				<label for="country">Country:</label>
				<input id="country" name="country" placeholder="Country" maxlength="40" required>
				<br><br>
				<label for="airport-choice">What would you like to do?</label>
				<select id="airport-choice" name="choice" onchange="airportEdit()">
					<option value="create">Create this airport</option>
					<option value="delete">Delete this airport</option>
					<option value="edit">Edit this airport</option>
				</select>
				<br><br>
				<div id="airport-edit" style="display:none">
					Leave a field blank to leave it unchanged.
					<br><br>
					<label for="new-name">New Name:</label>
					<input id="new-name" name="new-name" placeholder="New Name" maxlength="40" />
					<br>
					<label for="new-airportid">New ID:</label>
					<input id="new-airportid" name="new-airportid" placeholder="New ID" maxlength="3">
					<br>
					<label for="new-country">New Country:</label>
					<input id="new-country" name="new-country" placeholder="Country" maxlength="40">
				</div>
				<br><br>
				<button>Submit</button>
			</form>
		</section>
		<script>
			function aircraftEdit() {
				if(document.getElementById('aircraft-choice').value === 'edit') {
					document.getElementById('aircraft-edit').style.display = 'block';
					document.getElementById('new-designation').required = true;
				} else {
					document.getElementById('aircraft-edit').style.display = 'none';
					document.getElementById('new-designation').required = false;
				}
			}
			
			function airportEdit() {
				if(document.getElementById('airport-choice').value === 'edit') {
					document.getElementById('airport-edit').style.display = 'block';
				} else {
					document.getElementById('airport-edit').style.display = 'none';
				}
			}
			
			function flightEdit() {
				var choice = document.getElementById('flight-choice').value;
				if(choice == 'edit'){
					document.getElementById('flight-edit').style.display = 'block';
					document.getElementById('flight-create').style.display = 'block';
					document.getElementById('flightNum').required = true;
					document.getElementById('airlineid2').required = true;
					document.getElementById('new-flightnum').required = false;
					document.getElementById('new-airlineid2').required = false;
					document.getElementById('new-dtime').required = false;
					document.getElementById('new-atime').required = false;
					document.getElementById('new-dairportid').required = false;
					document.getElementById('new-aairportid').required = false;
					document.getElementById('new-designation2').required = false;
					document.getElementById('new-price').required = false;
					document.getElementById('new-stops').required = false;

				}else if(choice == 'delete'){
					document.getElementById('flight-edit').style.display = 'none';
					document.getElementById('flight-create').style.display = 'block';
					document.getElementById('flightNum').required = true;
					document.getElementById('airlineid2').required = true;
					document.getElementById('new-flightnum').required = false;
					document.getElementById('new-airlineid2').required = false;
					document.getElementById('new-dtime').required = false;
					document.getElementById('new-atime').required = false;
					document.getElementById('new-dairportid').required = false;
					document.getElementById('new-aairportid').required = false;
					document.getElementById('new-designation2').required = false;
					document.getElementById('new-price').required = false;
					document.getElementById('new-stops').required = false;

				}else{
					document.getElementById('flightNum').required = false;
					document.getElementById('airlineid2').required = false;
					document.getElementById('flight-create').style.display = 'none';
					document.getElementById('flight-edit').style.display = 'block';
					document.getElementById('new-flightnum').required = true;
					document.getElementById('new-airlineid2').required = true;
					document.getElementById('new-dtime').required = true;
					document.getElementById('new-atime').required = true;
					document.getElementById('new-dairportid').required = true;
					document.getElementById('new-aairportid').required = true;
					document.getElementById('new-designation2').required = true;
					document.getElementById('new-price').required = true;
					document.getElementById('new-stops').required = true;
				}
			}
		</script>
	</body>
</html>