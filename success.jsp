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
	</body>
</html>