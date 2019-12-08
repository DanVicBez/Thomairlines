<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*"%>
<!DOCTYPE html>
<html>
	<head>
@@ -17,6 +18,10 @@
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
@@ -48,6 +53,27 @@
					<th>Purchase Time</th>
					<th>Price</th>
				</tr>
				<%
					ResultSet rs=con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket WHERE d_date < (SELECT CURDATE() + 1);").executeQuery();
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
		</div>
		<div>
@@ -70,8 +96,30 @@
					<th>Class</th>
					<th>Purchase Time</th>
					<th>Price</th>
					<th>Cancel?</th>
					<th></th>
				</tr>
				<%
					ResultSet rs2=con.prepareStatement("SELECT * FROM Reserves NATURAL JOIN Flight NATURAL JOIN Ticket WHERE d_date > (SELECT CURDATE());").executeQuery();
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
					<td><button> Cancel </button></td>
				</tr>
				<%
				}
				%>
			</table>
		</div>
	</body>
