<%@ page import ="java.sql.*"%>
<%@ page import ="java.time.LocalDateTime"%>
<%@ page import ="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<html>
	<head>
		<title>Login Form</title>
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
		<div id="banner">
			<img alt="Thomairlines" src="https://i.imgur.com/NfZWVqI.jpg" width=55px style="display: inline"/>
			<h1>Thomairlines</h1>
		</div>
		<%
		    if ((session.getAttribute("user") == null)) {
		%>
				You are not logged in<br/>
				<a href="login.jsp">Please Login</a>
		<%
			} else {
		%>
				<div id="pageText">
					Welcome, <%=session.getAttribute("user")%>!
					<br>
					<br>
					<a href="reservations.jsp">My Reservations</a>
					<br>
					<br>
					<a href="logout.jsp">Log out</a>
				</div>
				<form method="post" action="search.jsp" align="center" >
					<table align="center">
						<tr>
							<th>From?</th>
							<th>To?</th>
							<th>Departure Date</th>
							<th>Return Date</th>
						</tr>
						<tr>
							<td id="searchtd">
								<select name="fromAirport" id="airportSelect" required>
									<%
										String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
										Class.forName("com.mysql.jdbc.Driver");
										Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
										ResultSet rs = con.prepareStatement("SELECT * FROM Airport").executeQuery();
									%>
									<option value="" selected disabled>Departure Airport</option>
									<%
										while(rs.next()) {
											%>
												<option><%=rs.getString(2)%> (<%=rs.getString(1)%>)</option>
											<%
										}
									%>
								</select>
							</td>
							<td id="searchtd">
								<select name="toAirport" id="airportSelect" required>
									<%
										// TODO: prevent people from selecting same airport as departure
										rs=con.prepareStatement("SELECT * FROM Airport").executeQuery();
									%>
									<option value="" selected disabled>Arrival Airport</option>
									<%
										while(rs.next()) {
											%>
												<option><%=rs.getString(2)%> (<%=rs.getString(1)%>)</option>
											<%
										}
									%>
								</select>
							</td>
							<%
								LocalDateTime now=LocalDateTime.now();
								DateTimeFormatter dtf=DateTimeFormatter.ofPattern("yyyy-MM-dd");
								// TODO: ban people from selecting later departure than arrival dates
							%>
							<td id="searchtd">
								<input type="date" name="fromDate" id="ddateinput" value=<%=dtf.format(now)%> min=<%=dtf.format(now)%>></input>
							</td>
							<td id="searchtd">
								<input type="date" name="toDate" id="adateinput" value=<%=dtf.format(now)%> min=<%=dtf.format(now)%>></input>
							</td>
							
							<!--<img alt="Thomairlines" src="https://i.imgur.com/NfZWVqI.jpg" width=200px style="float:right; margin-right: 5%"/>-->
							<img alt="Balouek"s Eyewear" src="https://i.imgur.com/UbjLxeh.jpg" width=200px style="float:right; margin-right: 5%"/>
						</tr>
					</table>
					<select id = 'flightType' onchange = "oneway()" required name = "flightType">
						<option>Round-Trip</option>
						<option>One-Way</option>
					</select>
					<select id = 'sortBy' required name = "sortBy">
						<option selected>Not Sorted</option>
						<option>Sort By Price</option>
						<option>Sort By Take-Off Time</option>
						<option>Sort By Landing Time</option>
					</select>
					<select id = 'filterBy' required name = "filterBy">
						<option selected>Not Filtered</option>
						<option>Filter By Price</option>
						<option>Filter By Number of Stops</option>
						<option>Filter By Airline</option>
					</select>
					<input type="checkbox" name = "flexibility"/>Flexible Dates
					<button>Search</button>
				</form>
				<%
					rs = (ResultSet) session.getAttribute("results");
					if(rs != null) {
						%>
						<h1 class="section" style="margin-top: 120px">Departing Flights</h1>
						<%
						if (!rs.next()) {
							%>
							<div class="result">
								<p>No flights were found.</p>
							</div>
							<% 
						} else {
							do {
								%>
								<div class="result">
									<table>
										<tr>
											<td style="width: 40%"><%=rs.getString("airline_name")%> Flight <%=rs.getString("airline_id")%><%=rs.getInt("flight_num")%></td>
											<td style="width: 13%; text-align: right;"><%=rs.getString("d_airport_id")%></td>
											<td style="width: 5%">&rarr;</td>
											<td style="width: 13%"><%=rs.getString("a_airport_id")%></td>
											<td style="width: 10%">$<%=rs.getInt("price")%></td>
											<td style="width: 19%">Reserve Flight</td>
										</tr>
										<tr>
											<td></td>
											<td style="text-align: right"><%=rs.getString("departure_time").substring(0,5)%></td>
											<td></td>
											<td><%=rs.getString("arrival_time").substring(0,5)%></td>
										</tr>
									</table>
								</div>
								<%
							} while(rs.next());
						}
						
						ResultSet rs2 = (ResultSet) session.getAttribute("results2");
						if(rs2 != null) {
							%>
							<h1 class="section">Returning Flights</h1>
							<%
							if (!rs2.next()) {
								%>
								<div class="result">
									<p>No results could be found</p>
								</div>
								<%
							} else {
								do {
									%>
									<div class="result">
										<table>
											<tr>
												<td style="width: 40%"><%=rs2.getString("airline_name")%> Flight <%=rs2.getString("airline_id")%><%=rs2.getInt("flight_num")%></td>
												<td style="width: 13%; text-align: right;"><%=rs2.getString("d_airport_id")%></td>
												<td style="width: 5%">&rarr;</td>
												<td style="width: 13%"><%=rs2.getString("a_airport_id")%></td>
												<td style="width: 10%">$<%=rs2.getInt("price")%></td>
												<td style="width: 19%">Reserve Flight</td>
											</tr>
											<tr>
												<td></td>
												<td style="text-align: right"><%=rs2.getString("departure_time").substring(0,5)%></td>
												<td></td>
												<td><%=rs2.getString("arrival_time").substring(0,5)%></td>
											</tr>
										</table>
									</div>
									<%
								} while(rs2.next());
							}
						}
					}
			}
		%>
		<script>
		function oneway() {
			if (document.getElementById('flightType').value === 'One-Way') {
				document.getElementById('adateinput').setAttribute('disabled','disabled');
			} else {
				document.getElementById('adateinput').removeAttribute('disabled');
			}
		}
		</script>
	</body>
</html>