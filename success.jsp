<html>
	<head>
		<title>Login Form</title>
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
				Welcome <%=session.getAttribute("user")%>
				<a href='logout.jsp'>Log out</a>
		<%
		    }
		%>
		
		<img alt = "Balouek's Eyewear" src = "https://i.imgur.com/UbjLxeh.jpg" width = 200px style="float:right; margin-right: 5%"/>
	</body>
</html>