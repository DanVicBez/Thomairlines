<%@page import="com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException"%>
<%@page import="com.mysql.jdbc.MysqlDataTruncation"%>
<%@ page import ="java.sql.*" %>
<%
	String username = request.getParameter("username");   
	String password = request.getParameter("password");
	String first = request.getParameter("first");   
	String last = request.getParameter("last");
	String confirmpassword = request.getParameter("confirmpassword");
	
	session.setAttribute("taken", null);
	session.setAttribute("match", null);
	session.setAttribute("toolong", null);
	session.setAttribute("blank", null);
	session.setAttribute("space", null);
	
	if(!username.isEmpty() && !password.isEmpty()) {
		if(username.indexOf(' ') == -1 && password.indexOf(' ') == -1) {
			if(password.equals(confirmpassword)) {
				String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
				
				try {
					first = first.isEmpty() ? null : first;
					last = last.isEmpty() ? null : last;
					
					PreparedStatement st = con.prepareStatement("INSERT INTO Account " +
								    							"VALUES (?, ?, ?, ?)");
					
					st.setString(1, username);
					st.setString(2, password);
					st.setString(3, first);
					st.setString(4, last);
					st.executeUpdate();
					
					st = con.prepareStatement("INSERT INTO Customer " +
							"VALUES (?)");
					st.setString(1, username);
					st.executeUpdate();
					
					session.setAttribute("user", username);
			        response.sendRedirect("success.jsp");
				} catch(MysqlDataTruncation e) {
					session.setAttribute("toolong", true);
					response.sendRedirect("signup.jsp");
					e.printStackTrace();
				} catch(MySQLIntegrityConstraintViolationException e) {
					session.setAttribute("taken", true);
					response.sendRedirect("signup.jsp");
					e.printStackTrace();
				} catch(Exception e) {
					out.println("unknown exception");
					e.printStackTrace();
				}
			} else {
				session.setAttribute("match", true);
				response.sendRedirect("signup.jsp");
			}	
		} else {
			session.setAttribute("space", true);
			response.sendRedirect("signup.jsp");
		}
	} else {
		session.setAttribute("blank", true);
		response.sendRedirect("signup.jsp");
	}
%>