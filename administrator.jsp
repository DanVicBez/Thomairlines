<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Administrator Dashboard</title>
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
		<div id="banner">
			<img alt="Thomairlines" src="https://i.imgur.com/NfZWVqI.jpg" width=55px style="display: inline"/>
			<h1>Thomairlines</h1>
		</div>
		<h2>Administrator Dashboard</h2>
		<div>
			<p align = "left">
				<font color = "white" size = 4>
					<a href = 'success.jsp'>Back to Flight Search</a>
				</font>
			</p>
		</div>
		<section>
			<h3>Most Active Flights</h3>
				<form method="post" align="center">
				
				<%
					String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
					Class.forName("com.mysql.jdbc.Driver");
					Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
					
					ResultSet rs_list;
					
					String query = "SELECT flight_num, airline_id, count(*) count" +
									"FROM AssociatedWith GROUP BY flight_num, airline_id " +
									"ORDER BY count(*) DESC, flight_num LIMIT 10" ;
					
					PreparedStatement st = con.prepareStatement(query);
					//st.setString(1, airport.substring(0, 4));
					//st.setString(2, airport.substring(0, 4));
					rs_list = st.executeQuery(query);

					if(rs_list != null) {
						if (!rs_list.next()) {
				%>
					<div class="result">
						<p>No flights were found.</p>
					</div>
				<% 
						} else {
							int i = 0;
							do {
				%>
								<div class="result">
									<table>
										<tr>
											<td style="width: 40%; text-align: left;" >Flight Number: <%=rs_list.getInt("flight_num")%>  <%=rs_list.getString("airline_id")%><%=rs_list.getString("count")%></td>
										</tr>
									</table>
								</div>
								<%
								i++;
							} while(rs_list.next());
						}
					}
				%>
					
				</form>
						
							
		</section>
		<section>
		<h3>Check Flights</h3>
			<form method="post" action="list.jsp" align="center" >
					<table align="center">
						<tr>
							<td id="searchtd">
								<select name="Airport" id="airportSelect" required>
									<%
										//url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
										//Class.forName("com.mysql.jdbc.Driver");
										//con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
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
						</tr>
					</table>
					<button>Search</button>
				</form>
				<form method="post" align="center">
				<%
					rs = (ResultSet) session.getAttribute("results");
					if(rs != null) {
						%>
						<h1 class="section" style="margin-top: 120px">Results</h1>
						<%
						if (!rs.next()) {
							%>
							<div class="result">
								<p>No flights were found.</p>
							</div>
							<% 
						} else {
							int i = 0;
							do {
								%>
								<div class="result">
									<table>
										<tr>
											<td style="width: 40%; text-align: left;" ><%=rs.getString("airline_name")%> Flight <%=rs.getString("airline_id")%><%=rs.getInt("flight_num")%></td>
											<td style="width: 13%; text-align: right;"><%=rs.getString("d_airport_id")%></td>
											<td style="width: 13%"><%=rs.getString("a_airport_id")%></td>
											<td style="width: 10%">$<%=rs.getInt("price")%></td>
										</tr>
										<tr>
											<td>Number Of Stops: <%=rs.getString("stops")%></td>
											<td style="text-align: right"><%=rs.getString("departure_time").substring(0,5)%></td>
											<td></td>
											<td><%=rs.getString("arrival_time").substring(0,5)%></td>
											<td></td>
											
										</tr>
									</table>
								</div>
								<%
								i++;
							} while(rs.next());
						}
					}
				%>
				</form>
		</section>
		
	</body>
</html>