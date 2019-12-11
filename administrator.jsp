<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
			<h3>User Manager</h3>
			<%
			String responseMsg = (String) session.getAttribute("user-response");
			if(responseMsg != null && !"null".equals(responseMsg)) {
				if (responseMsg.startsWith("Error")) {%>
					<div style="margin-bottom: 20px; font-weight: bold; color: red"><%=responseMsg%></div> <%
				} else {%>
				<div style="margin-bottom: 20px; font-weight: bold; color: green"><%=responseMsg%></div>
			<%}
			}
			
			session.setAttribute("user-response", "null");
			%>
			<form method="post" action="editUser.jsp">
				<label for="username">Username:</label>
				<input id="username" name="username" placeholder="Username" required />
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
					<input id="new-password" name="new-password" placeholder="New Password" maxlength="20"/>
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
			}
		</script>
	</body>
</html>