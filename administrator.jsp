<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DateFormatSymbols" %>
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
		<%
		String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
		%>
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
				PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS num, SUM(total_fare) AS total FROM Ticket WHERE MONTH(purchase_time) = ? AND YEAR(purchase_time) = ?");
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
						Total revenue: $<%=rs.getInt("total")%>
					</div>
					<br>
			<%
				}
			}
			%>
			<form method = "post" action = 'administrator.jsp'>
				<label for="month">Month:</label>
				<select id= "month" name = "month" style = "margin-bottom: 10px">
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
			<h3>Search for Reservations</h3>
		</section>
		<section>
			<h3>Revenue</h3>
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
		</script>
	</body>
</html>