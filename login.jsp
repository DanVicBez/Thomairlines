<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Login Form</title>
		<link rel="stylesheet" href="style.css"/>
	</head>
	<style>
		body {
 			background-image: url("https://images.pexels.com/photos/314726/pexels-photo-314726.jpeg");
 			background-repeat: no-repeat;
 			background-attachment: fixed;
  			background-size: cover;
  			}
	</style>
	<body>
		<div id="banner">
			<img alt = "Thomairlines" src = "https://i.imgur.com/NfZWVqI.jpg" width = 55px style = "display: inline"/>
			<h1>Thomairlines</h1>
		</div>
		<%
			if(session.getAttribute("invalid") != null) {
		%>
				<div id="error">ERROR: Invalid username or password. Please try again</div>
		<%
			} else {
		%>
				<div id="space"></div>
		<%
			}
		%>
		<img alt = "Thomairlines" src = "https://i.imgur.com/HJnuMXp.png" width = 30% style="float:left; margin-left: 6%; border: 5px solid black"/>
		<img alt = "Thomairlines" src = "https://i.imgur.com/35XJ6lz.jpg" width = 30% style="float:right; margin-right: 6%; border: 5px solid black"/>
		<div id="form">
			<form action="checkLoginDetails.jsp" method="POST">
				<input type="text" name="username" placeholder="username"/>
				<br/>
				<input type="password" name="password" placeholder="password"/>
				<br/>
				<input type="submit" value="Log in"/>
			</form>
			<input onclick="window.location.href='signup.jsp'" type="submit" value="Sign up"/>
		</div>
	
	<!--<img alt = "Thomairlines" src = "https://media.giphy.com/media/3NhLokVyVOv0C1WVaT/giphy.gif" width = 15% style = "display: block; margin-left: auto; margin-right: auto"/>-->
	</body>
</html>