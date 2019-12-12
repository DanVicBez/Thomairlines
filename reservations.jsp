<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="ISO-8859-1">
	<title>My Reservations</title>
	<link rel="stylesheet" href="style.css"/>
		<meta charset="utf-8"/>
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
		String url="jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(url, "admin", "prinfo$9.99");
		%>
		<div>
			<font color = "white" size = 6>
				<%
				String username = (String) session.getAttribute("user");
				String lookingAtUser = (String) session.getAttribute("lookingAtUser");
				String flightNum = (String) session.getAttribute("lookingAtFlightNum");
				String flightAirline = (String) session.getAttribute("lookingAtFlightAirline");
				boolean rep = (Boolean) session.getAttribute("rep");
				boolean admin = (Boolean) session.getAttribute("admin");
				
				if((rep || admin) && lookingAtUser != null && !lookingAtUser.equals("null") && !lookingAtUser.equals(username)) {
					username = (String) session.getAttribute("lookingAtUser");
				%>
					<%=username%>'s Reservations
				<%} else if(admin && flightNum != null && flightAirline != null && !flightNum.equals("null") && !flightAirline.equals("null")) {%>
					Reservations for Flight <%=flightAirline + flightNum%> 
				<%} else {%>
					My Reservations
				<%}%>
			</font>
		</div>
		<div>
			<p align = "left">
				<font color = "white" size = 4>
					<a href = 'success.jsp'>Back to Flight Search</a>
				</font>
			</p>
		</div>
		<%if((Boolean) session.getAttribute("admin")) {%>
		<section>
			<h3>Search</h3>
			<form method="post" action ="switchUser.jsp">
				<input id="searchbyuser" name="searchby" onchange="enable('user')" value="user" type="radio"/>
				<label for="searchbyuser">Search by User</label>
				<input id="userinput" name="user" required />
				<br>
				<input id="searchbyflight" name="searchby" onchange="enable('flight')" value="flight" type="radio"/>
				<label for="searchbyflight">Search by Flight Number</label>
				<input id="flightinput" name="flightnum" type="number" required disabled />
				<label for="airlineinput">Airline:</label>
				<select id="airlineinput" name="airline" required disabled>
					<%
					PreparedStatement ps = con.prepareStatement("SELECT * FROM Airline");
					ResultSet rs = ps.executeQuery();
					while(rs.next()) {
						String id = rs.getString("airline_id");
					%>
						<option value="<%=id%>"><%=id%> (<%=rs.getString("airline_name")%>)</option>
					<%}%>
				</select>
				<br>
				<button>Go!</button>
			</form>
		</section>
		<%} else if((Boolean) session.getAttribute("rep")) {%>
			<form action="switchUser.jsp" method="post" class="rep">
				<label style="font-size: 24px" for="user">Switch user</label>
				<input id="user" name="user" placeholder="Username" required/>
				<button>Switch</button>
			</form>
		<%}%>
		<div>
			<p align = "left">
				<font color = "white" size = 5>
					Upcoming Reservations
				</font>
			</p>
			<%
				PreparedStatement temp2;
				if(flightNum != null && !flightNum.equals("null")) {
					temp2 = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date > (SELECT CURDATE()) && flight_num = ? && airline_id = ?;");
					temp2.setString(1, flightNum);
					temp2.setString(2, flightAirline);
				} else {
					temp2 = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date > (SELECT CURDATE()) && username = ?;");
					temp2.setString(1, username);
				}
				
				ResultSet rtemp2 = temp2.executeQuery();
				rtemp2.next();
				if(rtemp2.getInt("c") != 0) {
			%>
			<form method="post" action="cancel.jsp">
				<input id="flightInfo" name="flightInfo" type="hidden" value=""/>
				<table id = table1 style ="margin: 0 auto;background-color:skyblue">
					<tr id = header>
						<th>Flight Number</th>
						<th>Ticket Number</th>
						<th>Airline</th>
						<th>Departing Airport</th>
						<th>Arriving Airport</th>
						<th>Departure Date</th>
						<th>Departure Time</th>
						<th>Arrival Time</th>
						<th>Seat Number</th>
						<th>Class</th>
						<th>Purchase Time</th>
						<th>Price</th>
						<th>Cancel?</th>
					</tr>
					<%
						PreparedStatement ps2= con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date > (SELECT CURDATE()) && username = ?;");
						ps2.setString(1, username);
						ResultSet rs2 = ps2.executeQuery();
						while(rs2.next()){
							int count = 0;
							count++;
					%>
					<tr id = row<%=count%>>
						<td id = col1><%= rs2.getInt("flight_num")%></td>
						<td id = col2><%= rs2.getInt("ticket_num")%></td>
						<td id = col3><%= rs2.getString("airline_id")%></td>
						<td id = col4><%= rs2.getString("d_airport_id")%></td>
						<td id = col5><%= rs2.getString("a_airport_id")%></td>
						<td id = col6><%= rs2.getString("d_date")%></td>
						<td id = col7><%= rs2.getString("departure_time")%></td>
						<td id = col8><%= rs2.getString("arrival_time")%></td>
						<td id = col9><%= rs2.getInt("seat_num")%></td>
						<% 
						String tempS = rs2.getString("ticket_type");
						tempS = tempS.substring(0,1).toUpperCase() + tempS.substring(1);
						%>
						<td id = col10><%= tempS %></td>
						<td id = col11><%= rs2.getString("purchase_time")%></td>
						<td id = col12>$<%= rs2.getInt("total_fare")%></td>
						<%
						if(rs2.getString("ticket_type").equals("economy")){
						%>
						<td id = col13><button value=<%=rs2.getInt("ticket_num") + "," + rs2.getInt("flight_num") + "," + rs2.getString("airline_id")%> name=button<%=count%> onClick="document.getElementById('flightInfo').value = this.value">Pay $40 and Cancel</button></td>
						<%
							}else{
						%>
						<td id = col13><button value=<%=rs2.getInt("ticket_num") + "," + rs2.getInt("flight_num") + "," + rs2.getString("airline_id")%> name=button<%=count%> onClick="document.getElementById('flightInfo').value = this.value">Cancel</button></td>
						<%
							}
						%>
					</tr>
					<%
					}
					%>
				</table>
			</form>
			<%
				}else{
			%>
				<p align = "center">
					<font color = "white" size = 5>
						No Upcoming Reservations
					</font>
				</p>
				<%
				}
				%>
		</div>
		<%
		String error = (String) session.getAttribute("error");
		if(error != null && !"null".equals(error)) {
		%>
			<div id="error"><%=error%></div>
		<%}
		if((Boolean) session.getAttribute("rep")) {%>
			<form action="modifyTicket.jsp" method="post" class="rep">
				<label for="ticketnum">Modify ticket</label>
				<select id="ticketnum" name="ticketnum" required>
					<%
					PreparedStatement ps;
					if(flightNum != null && !flightNum.equals("null")) {
						ps = con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN AssociatedWith NATURAL JOIN Ticket WHERE d_date > (SELECT CURDATE()) AND flight_num = ? AND airline_id = ?;");
						ps.setString(1, flightNum);
						ps.setString(2, flightAirline);
					} else {
						ps = con.prepareStatement("SELECT * AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date > (SELECT CURDATE()) AND username = ?;");
						ps.setString(1, username);
					}

					ResultSet rs = ps.executeQuery();

					while(rs.next()){
						int count = 0;
					%>
						<option value="<%=rs.getInt("ticket_num")%>"><%=rs.getInt("ticket_num")%></option>
					<%}%>
				</select>
				<br>
				<select style="height: 25px" id ="meal" name="meal">
					<option value="" selected>Don't change meal</option>
					<option>Steak</option>
					<option>Chicken</option>
					<option>Curry</option>
					<option>Lobster</option>
					<option>Salad(Contains Eggs)</option>
					<option>Kosher</option>
					<option>Veggie</option>
					<option>Halal</option>
				</select>
				<select style="height: 25px" id="class" name="class">
					<option value="" selected>Don't change class</option>
					<option value="economy">Economy</option>
					<option value="business">Business (+$150)</option>
					<option value="first">First (+$300)</option>
				</select>
				<button>Modify</button>
			</form>
		<%}%>
		<div>
				<p align = "left">
					<font color = "white" size = 5>
						Waiting List
					</font>
				</p>
		</div>
				<%
				PreparedStatement temp3;
				if(flightNum != null && !flightNum.equals("null")) {
					temp3 = con.prepareStatement("SELECT COUNT(*) AS c FROM OnWaitingList NATURAL JOIN Flight WHERE flight_num = ? AND airline_id = ?;");
					temp3.setString(1, flightNum);
					temp3.setString(2, flightAirline);
				} else {
					temp3 = con.prepareStatement("SELECT COUNT(*) AS c FROM OnWaitingList NATURAL JOIN Flight WHERE username = ?;");
					temp3.setString(1, username);
				}

				ResultSet rtemp3 = temp3.executeQuery();
				rtemp3.next();

				if(rtemp3.getInt("c") != 0){
				%>
				<table style ="margin: 0 auto;" style="background-color:skyblue">
				<tr>
					<th>Flight Number</th>
					<th>Airline</th>
					<th>Departing Airport</th>
					<th>Arriving Airport</th>
					<th>Departure Time</th>
					<th>Arrival Time</th>
					<th>Price</th>
					
				</tr>
				<%
				if(flightNum != null && !flightNum.equals("null")) {
					temp3 = con.prepareStatement("SELECT * FROM OnWaitingList NATURAL JOIN Flight WHERE flight_num = ? AND airline_id = ? AND flight_num = flight_number");
					temp3.setString(1, flightNum);
					temp3.setString(2, flightAirline);
				} else {
					temp3 = con.prepareStatement("SELECT * FROM OnWaitingList NATURAL JOIN Flight WHERE username = ? && flight_num = flight_number;");
					temp3.setString(1, username);
				}

				rtemp3 = temp3.executeQuery();

				while(rtemp3.next()) {
				%>
				<tr>
					<td><%= rtemp3.getInt("flight_num")%></td>
					<td><%= rtemp3.getString("airline_id")%></td>
					<td><%= rtemp3.getString("d_airport_id")%></td>
					<td><%= rtemp3.getString("a_airport_id")%></td>
					<td><%= rtemp3.getString("departure_time")%></td>
					<td><%= rtemp3.getString("arrival_time")%></td>
					<%
					String price = rtemp3.getString("price");
					int index = price.indexOf('.');
					price = price.substring(0, index);
					%>
					<td>$<%= price%></td>
				</tr>
				<%
				}
				%>
			</table>
			<%
				}else{
			%>	
				<p align = "center">
					<font size = 5 color = "white">
						Not Currently on a Waiting List
					</font>
				</p>
				<% 
				}
			%>
		<div>
			<p align = "left">
				<font color = "white" size = 5>
					Past Reservations
				</font>
			</p>
			<%
				PreparedStatement temp;
				if(flightNum != null && !flightNum.equals("null")) {
					temp = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date < (SELECT CURDATE() + 1) AND flight_num = ? AND airline_id = ?;");	
					temp.setString(1, flightNum);
					temp.setString(2, flightAirline);
				} else {
					temp = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date < (SELECT CURDATE() + 1) && username = ?;");	
					temp.setString(1, username);
				}

				ResultSet rtemp = temp.executeQuery();
				rtemp.next();
				if(rtemp.getInt("c") != 0){
			%>
			<table style ="margin: 0 auto;" style="background-color:skyblue">
				<tr>
					<th>Flight Number</th>
					<th>Ticket Number</th>
					<th>Airline</th>
					<th>Departing Airport</th>
					<th>Arriving Airport</th>
					<th>Departure Date</th>
					<th>Departure Time</th>
					<th>Arrival Time</th>
					<th>Seat Number</th>
					<th>Class</th>
					<th>Purchase Time</th>
					<th>Price</th>
				</tr>
				<%
				PreparedStatement ps;
				if(flightNum != null && !flightNum.equals("null")) {
					ps = con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date < (SELECT CURDATE() + 1) AND flight_num = ? AND airline_id = ?;");	
					ps.setString(1, flightNum);
					ps.setString(2, flightAirline);
				} else {
					ps = con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date < (SELECT CURDATE() + 1) && username = ?;");	
					ps.setString(1, username);
				}
				
				ResultSet rs = ps.executeQuery();
				while(rs.next()){
				%>
				<tr>
					<td><%= rs.getInt("flight_num")%></td>
					<td><%= rs.getInt("ticket_num")%></td>
					<td><%= rs.getString("airline_id")%></td>
					<td><%= rs.getString("d_airport_id")%></td>
					<td><%= rs.getString("a_airport_id")%></td>
					<td><%= rs.getString("d_date")%></td>
					<td><%= rs.getString("departure_time")%></td>
					<td><%= rs.getString("arrival_time")%></td>
					<td><%= rs.getInt("seat_num")%></td>
					<% 
					String tempS = rs.getString("ticket_type");
					tempS = tempS.substring(0,1).toUpperCase() + tempS.substring(1);
					%>
					<td><%= tempS %></td>
					<td><%= rs.getString("purchase_time")%></td>
					<td>$<%= rs.getInt("total_fare")%></td>
				</tr>
				<%
				}
				%>
			</table>
			<%
			} else {
			%>
			<p align = "center">
				<font color = "white" size = 5>
					No Past Reservations
				</font>
			</p>
			<%
			}
			%>
		</div>
		<script>
			function enable(which) {
				var flightnum = document.getElementById('flightinput');
				var airline = document.getElementById('airlineinput');
				var user = document.getElementById('userinput');
				
				if(which === 'user') {
					flightnum.disabled = true;
					flightnum.value = '';
					airline.disabled = true;
					airline.value = '';

					user.disabled = false;
				} else {
					user.disabled = true;
					user.value = '';

					flightnum.disabled = false;
					airline.disabled = false;
				}
			}
		</script>
	</body>
</html>