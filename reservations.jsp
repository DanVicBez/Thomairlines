<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
	<%	String url="jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection(url, "admin", "prinfo$9.99");
	%>
		<div>
			<font color = "white" size = 6>
				My Reservations
			</font>
		</div>
		<div>
			<p align = "left">
				<font color = "white" size = 4>
					<a href = 'success.jsp'>Back to Flight Search</a>
				</font>
			</p>
			<p align = "left">
				<font color = "white" size = 5>
					Past Reservations
				</font>
			</p>
			<%
				PreparedStatement temp = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date < (SELECT CURDATE() + 1) && username = ?;");
				temp.setString(1, (String)session.getAttribute("user"));
				ResultSet rtemp = temp.executeQuery();
				rtemp.next();
				if(rtemp.getInt("c") != 0){
			%>
			<table style="background-color:skyblue">
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
					PreparedStatement ps=con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date < (SELECT CURDATE() + 1) && username = ?;");
					ps.setString(1, (String)session.getAttribute("user"));
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
				}else{
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
		<div>
			<p align = "left">
				<font color = "white" size = 5>
					Upcoming Reservations
				</font>
			</p>
			<%
				PreparedStatement temp2 = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date > (SELECT CURDATE()) && username = ?;");
				temp2.setString(1, (String)session.getAttribute("user"));
				ResultSet rtemp2 = temp2.executeQuery();
				rtemp2.next();
				if(rtemp2.getInt("c") != 0){
			%>
			<form method="post" action="cancel.jsp">
				<input id="flightInfo" name="flightInfo" type="hidden" value=""/>
				<table id = table1 style="background-color:skyblue">
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
						<th></th>
					</tr>
					<%
						PreparedStatement ps2= con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith WHERE d_date > (SELECT CURDATE()) && username = ?;");
						ps2.setString(1, (String)session.getAttribute("user"));
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
						<td><%= tempS %></td>
						<td id = col10><%= rs2.getString("ticket_type")%></td>
						<td id = col11><%= rs2.getString("purchase_time")%></td>
						<td id = col12>$<%= rs2.getInt("total_fare")%></td>
						<%
						if(rs2.getString("ticket_type").equals("Economy")){
						%>
						<td id = col13><button value=<%=rs2.getInt("ticket_num") + "," + rs2.getInt("flight_num") + "," + rs2.getString("airline_id")%> name=button<%=count%> onClick="document.getElementById('flightInfo').value = this.value"> Pay $40 and Cancel </button></td>
						<%
							}else{
						%>
						<td id = col13><button value=<%=rs2.getInt("ticket_num") + "," + rs2.getInt("flight_num") + "," + rs2.getString("airline_id")%> name=button<%=count%> onClick="document.getElementById('flightInfo').value = this.value"> Cancel </button></td>
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
	</body>
</html>