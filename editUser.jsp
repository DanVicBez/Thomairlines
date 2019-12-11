<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>    
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	String username = request.getParameter("username");
	String choice = request.getParameter("username");
	
	PreparedStatement ps;
	ResultSet rs;
	
	if(choice.equals("create")) {
		ps = con.prepareStatement("SELECT * FROM Users WHERE username = ?");
		ps.setString(1, username);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			session.setAttribute("user-response", "Error creating user: already exists");
		} else {
			String newUsername = request.getParameter("new-username");
			String newPassword = request.getParameter("new-password");
			String newFirst = request.getParameter("new-first");
			String newLast = request.getParameter("new-last");
			String newType = request.getParameter("new-type");
			
			ps = con.prepareStatement("INSERT INTO Users VALUES (?, ?, ?, ?) WHERE username = ?");
			ps.setString(1, newUsername);
			ps.setString(2, newPassword);
			ps.setString(3, newFirst);
			ps.setString(4, newLast);
			ps.setString(5, username);
			
			System.out.printf("%d rows updated\n", ps.executeUpdate());
			session.setAttribute("user-response", "User created successfully");
			
			if(newType.equals("customer")) {
				ps = con.prepareStatement("INSERT INTO Customer VALUES (?)");
			} else {
				ps = con.prepareStatement("INSERT INTO CustomerRep VALUES (?)");
			}
			
			ps.setString(1, newUsername);
			
			System.out.printf("%d rows updated\n", ps.executeUpdate());
		}
	} else if(choice.equals("delete")) {
		ps = con.prepareStatement("SELECT * FROM Users WHERE username = ?");
		ps.setString(1, username);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			ps = con.prepareStatement("DELETE FROM Users WHERE username = ?");
			ps.setString(1, username);
			System.out.printf("%d rows updated\n", ps.executeUpdate());
			session.setAttribute("user-response", "User deleted successfully");
		} else {
			session.setAttribute("user-response", "Error deleting user: doesn't exist");
		}
	} else if(choice.equals("edit")) {
		ps = con.prepareStatement("SELECT * FROM Users WHERE username = ?");
		ps.setString(1, username);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			String newUsername = request.getParameter("new-username");
			String newPassword = request.getParameter("new-password");
			String newFirst = request.getParameter("new-first");
			String newLast = request.getParameter("new-last");
			String newType = request.getParameter("new-type");
			
			ps = con.prepareStatement("UPDATE Users SET username = ?, acc_password = ?, first_name = ?, last_name = ? WHERE username = ?");
			ps.setString(1, newUsername);
			ps.setString(2, newPassword);
			ps.setString(3, newFirst);
			ps.setString(4, newLast);
			ps.setString(5, username);
			
			System.out.printf("%d rows updated\n", ps.executeUpdate());
			session.setAttribute("user-response", "User edited successfully");
		} else {
			session.setAttribute("user-response", "Error editing user: doesn't exist");
		}
	}
%>