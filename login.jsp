<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Login Form</title>
		<link rel="stylesheet" href="style.css"/>
	</head>
	<body>
		<div id="banner">
			<h1>Thomairlines</h1>
		</div>
		<%
			if(session.getAttribute("invalid") != null) {
		%>
				<div id="error">ERROR: Invalid username or password. Please try again</div>
		<%
			}
		%>
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
	</body>
</html>