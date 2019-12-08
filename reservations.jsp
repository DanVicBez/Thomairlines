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
					<a href = 'success.jsp'>Back to Flight Search --></a>
				</font>
			</p>
			<p align = "left">
				<font color = "white" size = 5>
					Past Reservations
				</font>
			</p>
			<%
				PreparedStatement temp = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket WHERE d_date < (SELECT CURDATE() + 1) && username = ?;");
				temp.setString(1, (String)session.getAttribute("username"));
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
					PreparedStatement ps=con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket WHERE d_date < (SELECT CURDATE() + 1) && username = ?;");
					ps.setString(1, (String)session.getAttribute("username"));
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
					<td><%= rs.getString("ticket_type")%></td>
					<td><%= rs.getString("purchase_time")%></td>
					<td><%= rs.getInt("total_fare")%></td>
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
				PreparedStatement temp2 = con.prepareStatement("SELECT COUNT(*) AS c FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket WHERE d_date > (SELECT CURDATE()) && username = ?;");
				temp2.setString(1, (String)session.getAttribute("username"));
				ResultSet rtemp2 = temp2.executeQuery();
				rtemp2.next();
				if(rtemp2.getInt("c") != 0){
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
					<th>Cancel?</th>
					<th></th>
				</tr>
				<%
					PreparedStatement ps2= con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket WHERE d_date > (SELECT CURDATE()) && username = ?;");
					ps2.setString(1, (String)session.getAttribute("username"));
					ResultSet rs2 = ps2.executeQuery();
					while(rs2.next()){
				%>
				<tr>
					<td><%= rs2.getInt("flight_num")%></td>
					<td><%= rs2.getInt("ticket_num")%></td>
					<td><%= rs2.getString("airline_id")%></td>
					<td><%= rs2.getString("d_airport_id")%></td>
					<td><%= rs2.getString("a_airport_id")%></td>
					<td><%= rs2.getString("d_date")%></td>
					<td><%= rs2.getString("departure_time")%></td>
					<td><%= rs2.getString("arrival_time")%></td>
					<td><%= rs2.getInt("seat_num")%></td>
					<td><%= rs2.getString("ticket_type")%></td>
					<td><%= rs2.getString("purchase_time")%></td>
					<td><%= rs2.getInt("total_fare")%></td>
					<td><a href = "cancel.jsp"><button> Cancel </button></a></td>
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
					No Upcoming Reservations
				</font>
			</p>
			<%
				}
			%>
		</div>
	</body>
</html>