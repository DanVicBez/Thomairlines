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
		<div>
			<p align = "left">
				<font color = "white" size = 4>
					<a href = 'success.jsp'>Back to Flight Search</a>
				</font>
			</p>
		</div>
		<h2>Administrator Dashboard</h2>
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
		<section>
			<h3>User Manager</h3>
			<%
			String responseMsg = (String) session.getAttribute("user-response");
			if(responseMsg != null && !"null".equals(responseMsg)) {
				if (responseMsg.startsWith("Error")) {%>
					<div style="margin-bottom: 20px; font-weight: bold; color: red"><%=responseMsg%></div>
				<%} else {%>
				<div style="margin-bottom: 20px; font-weight: bold; color: green"><%=responseMsg%></div>
			<%}
			}
			
			session.setAttribute("user-response", "null");
			%>
			<form method="post" action="editUser.jsp">
				<label for="username">Username:</label>
				<input id="username" name="username" placeholder="Username" disabled required />
				<br><br>
				<label for="choice">What would you like to do?</label>
				<select id="choice" name="choice" onchange="userEdit()">
					<option value="create">Create new user</option>
					<option value="delete">Delete this user</option>
					<option value="edit">Edit this user</option>
				</select>
				<br><hr><br>
				<div id="user-edit">
					If editing an existing user, leave a field blank to leave it unchanged.
					<br><br>
					<label for="new-username">New Username:</label>
					<input id="new-username" name="new-username" placeholder="New Username" maxlength="20" />
					<br>
					<label for="new-password">New Password:</label>
					<input type="password" id="new-password" name="new-password" placeholder="New Password" maxlength="20"/>
					<br>
					<label for="new-first">New First Name:</label>
					<input id="new-first" name="new-first" placeholder="New First Name" maxlength="20"/>
					<br>
					<label for="new-last">New Last Name:</label>
					<input id="new-last" name="new-last" placeholder="New Last Name" maxlength="20"/>
					<br>
					<label for="new-type">New Account Type:</label>
					<select id="new-type" name="new-type">
						<option value="customer">Customer</option>
						<option value="rep">Customer Representative</option>
					</select>
				</div>
				<br><br>
				<button>Submit</button>
			</form>
		</section>
		<section>
			<h3>Sales Reports</h3>
			<%
			String month = request.getParameter("month");
			String year = request.getParameter("year");
			if(month != null && year != null) {
				PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS num, SUM(total_fare) AS revenue, SUM(booking_fee) AS profit FROM Ticket WHERE MONTH(purchase_time) = ? AND YEAR(purchase_time) = ?");
				ps.setString(1, month);
				ps.setString(2, year);
				ResultSet rs = ps.executeQuery();
				
				if(rs.next()) {
			%>
					<div style="margin-bottom: 20px; font-weight: bold">
						Sales for <%=new DateFormatSymbols().getMonths()[Integer.parseInt(month) - 1]%> <%=year%>:
						<br>
						Tickets sold: <%=rs.getString("num")%>
						<br>
						Profit: $<%=rs.getInt("profit")%>
						<br>
						Revenue: $<%=rs.getInt("revenue")%>
					</div>
					<br><br>
			<%
				}
			}
			%>
			<form method = "post" action ="administrator.jsp">
				<label for="month">Month:</label>
				<select id= "month" name="month" style="margin-bottom:10px">
					<option value="1">January</option>
					<option value="2">February</option>
					<option value="3">March</option>
					<option value="4">April</option>
					<option value="5">May</option>
					<option value="6">June</option>
					<option value="7">July</option>
					<option value="8">August</option>
					<option value="9">September</option>
					<option value="10">October</option>
					<option value="11">November</option>
					<option value="12">December</option>
				</select>
				<br>
				<label for="year">Year:</label>
				<input id="year" name="year" type="number" value="2019" min="2019" required />
				<br>
				<button>Go!</button>
			</form>
		</section>
		<section>
			<h3>Revenue</h3>
			<%
			String choice = request.getParameter("revenueby");
			if(choice != null) {
				String query = "SELECT COUNT(*) AS num, SUM(total_fare) as revenue, SUM(booking_fee) AS profit " +
							   "FROM Flight NATURAL JOIN Ticket NATURAL JOIN AssociatedWith " +
							   "WHERE %s";
				
				if(choice.equals("user")) {
					query = String.format(query, "username = ?");
				} else if(choice.equals("flight")) {
					query = String.format(query, "flight_num = ? AND airline_id = ?");
				} else {
					query = String.format(query, "airline_id = ?");
				}
				
				PreparedStatement ps = con.prepareStatement(query);
				
				if(choice.equals("user")) {
					String username = request.getParameter("revenueuser");
					ps.setString(1, username);
				} else if(choice.equals("flight")) {
					String flight = request.getParameter("flightnum");
					String airline = request.getParameter("airline");
					ps.setString(1, flight);
					ps.setString(2, airline);
				} else {
					String airline = request.getParameter("airline2");
					ps.setString(1, airline);
				}
				
				ResultSet rs = ps.executeQuery();
				
				while(rs.next()) {
			%>
					Tickets sold: <%=rs.getString("num")%>
					<br>
					Profit: $<%=rs.getInt("profit")%>
					<br>
					Revenue: $<%=rs.getInt("revenue")%>
					<br>
			<%
				}
			}
			%>
			<form method="post" action ="administrator.jsp">
				<input id="revenuebyuser" name="revenueby" onchange="enableRevenue('user')" value="user" type="radio" checked />
				<label for="revenuebyuser">For User</label>
				<input id="revenueuserinput" name="revenueuser" required />
				<br>
				<input id="revenuebyflight" name="revenueby" onchange="enableRevenue('flight')" value="flight" type="radio"/>
				<label for="revenuebyflight">For Flight Number</label>
				<input id="revenueflightinput" name="flightnum" type="number" required disabled />
				<label for="revenueairlineinput">Airline:</label>
				<select id="revenueairlineinput" name="airline" required disabled>
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
				<input id="revenuebyairline" name="revenueby" onchange="enableRevenue('airline')" value="airline" type="radio"/>
				<label for="revenuebyairline">For Airline</label>
				<select id="revenueairlineinput2" name="airline2" required disabled>
					<%
					ps = con.prepareStatement("SELECT * FROM Airline");
					rs = ps.executeQuery();
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
		<section>
			<h3>Most Active Flights</h3>
		</section>
		<section>
			<h3>Flights by Airport</h3>
		</section>
		<script>
			function userEdit() {
				var choice = document.getElementById('choice').value; 
				
				if(choice === 'edit' || choice === 'create') {
					document.getElementById('user-edit').style.display = 'block';
				} else {
					document.getElementById('user-edit').style.display = 'none';
				}
				
				document.getElementById('username').disabled = (choice === 'create');
			}
			
			function enableRevenue(which) {
				var flightnum = document.getElementById('revenueflightinput');
				var airline = document.getElementById('revenueairlineinput');
				var airline2 = document.getElementById('revenueairlineinput2');
				var user = document.getElementById('revenueuserinput');
				
				if(which === 'user') {
					flightnum.disabled = true;
					flightnum.value = '';
					airline.disabled = true;
					airline.value = '';
					airline2.disabled = true;
					airline2.value = '';

					user.disabled = false;
				} else if(which === 'flight') {
					user.disabled = true;
					user.value = '';
					airline2.disabled = true;
					airline2.value = '';

					flightnum.disabled = false;
					airline.disabled = false;
				} else {
					user.disabled = true;
					user.value = '';
					flightnum.disabled = true;
					flightnum.value = '';
					airline.disabled = true;
					airline.value = '';
					
					airline2.disabled = false;
				}
			}
		</script>
	</body>
</html>