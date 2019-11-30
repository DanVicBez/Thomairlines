<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Signup Form</title>
		<link rel="stylesheet" href="style.css"/>
	</head>
	<style>
		body {
 			background-image: url("https://i.imgur.com/A3Hbch8.jpg");
 			background-repeat: no-repeat;
 			background-attachment: fixed;
  			background-size: 100%;
		}
	</style>
	<body>
		<div id="banner">
			<img alt = "Thomairlines" src = "https://i.imgur.com/NfZWVqI.jpg" width = 55px style = "display: inline"/>
			<h1>Thomairlines</h1>
		</div>
		<%
			if(session.getAttribute("taken") != null) {
		%>
				<div id="error">ERROR: Username already taken. Please try again</div>
		<%
			} else if(session.getAttribute("match") != null) {
		%>
				<div id="error">ERROR: Passwords must match</div>
		<%
			} else if(session.getAttribute("toolong") != null) {
		%>
				<div id="error">ERROR: All fields must be less than 20 characters</div>
		<%
			} else if(session.getAttribute("blank") != null) {
		%>
				<div id="error">ERROR: The username and password cannot be blank</div>
		<%
			} else if(session.getAttribute("space") != null) {
		%>
				<div id="error">ERROR: The username and password cannot contain spaces</div>
		<%
			}
		%>
		<form action="createNewUser.jsp" method="POST">
			<input type="text" name="username" placeholder="username"/>
			<br/>
			<input type="text" name="first" placeholder="first name (optional)"/>
			<br/>
			<input type="text" name="last" placeholder="last name (optional)"/>
			<br/>
			<input type="password" name="password" placeholder="password"/>
			<br/>
			<input type="password" name="confirmpassword" placeholder="confirm password"/>
			<br/>
			<input type="submit" value="Sign up"/>
		</form>
		<form action="logout.jsp" method="POST">
			<input type="submit" value="Go Back"/>
		</form>
	</body>
</html>