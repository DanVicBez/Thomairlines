<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
			<table>
				<tr>
					<th>Flight Number</th>
					<th>Ticket Number</th>
					<th>Airline</th>
					<th>Departing Airport</th>
					<th>Arriving Airport</th>
					<th>Departure Date</th>
					<th>Departure Time</th>
					<th>Arrival time</th>
					<th>Seat Number</th>
					<th>Class</th>
					<th>Purchase Time</th>
					<th>Price</th>
				</tr>
			</table>
		</div>
		<div>
			<p align = "left">
				<font color = "white" size = 5>
					Upcoming Reservations
				</font>
			</p>
			<table border = 1>
				<tr>
					<th>Flight Number</th>
					<th>Ticket Number</th>
					<th>Airline</th>
					<th>Departing Airport</th>
					<th>Arriving Airport</th>
					<th>Departure Date</th>
					<th>Departure Time</th>
					<th>Arrival time</th>
					<th>Seat Number</th>
					<th>Class</th>
					<th>Purchase Time</th>
					<th>Price</th>
				</tr>
			</table>
		</div>
	</body>
</html>