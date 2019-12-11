<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>    
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	String username = request.getParameter("username");
	String choice = request.getParameter("choice");
	
	PreparedStatement ps;
	ResultSet rs;
	
	if(choice.equals("create")) {
		String newUsername = request.getParameter("new-username");
		
		ps = con.prepareStatement("SELECT * FROM Account WHERE username = ?");
		ps.setString(1, newUsername);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			session.setAttribute("user-response", "Error creating user: already exists");
		} else {
			String newPassword = request.getParameter("new-password");
			String newFirst = request.getParameter("new-first");
			String newLast = request.getParameter("new-last");
			String newType = request.getParameter("new-type");
			
			ps = con.prepareStatement("INSERT INTO Account VALUES (?, ?, ?, ?)");
			ps.setString(1, newUsername);
			ps.setString(2, newPassword);
			ps.setString(3, newFirst);
			ps.setString(4, newLast);
			
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
		ps = con.prepareStatement("SELECT * FROM Account WHERE username = ?");
		ps.setString(1, username);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			ps = con.prepareStatement("DELETE FROM Account WHERE username = ?");
			ps.setString(1, username);
			System.out.printf("%d rows updated\n", ps.executeUpdate());
			session.setAttribute("user-response", "User deleted successfully");
		} else {
			session.setAttribute("user-response", "Error deleting user: doesn't exist");
		}
	} else if(choice.equals("edit")) {
		ps = con.prepareStatement("SELECT * FROM Account WHERE username = ?");
		ps.setString(1, username);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			String password = rs.getString("acc_password");
			String first = rs.getString("first_name");
			String last = rs.getString("last_name");
			String newUsername = request.getParameter("new-username");
			String newPassword = request.getParameter("new-password");
			String newFirst = request.getParameter("new-first");
			String newLast = request.getParameter("new-last");
			String newType = request.getParameter("new-type");
			
			ps = con.prepareStatement("SELECT * FROM Account WHERE username = ?");
			ps.setString(1, newUsername);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				session.setAttribute("user-response", "Error editing user: new username already taken");
			} else {
				ps = con.prepareStatement("UPDATE Account SET username = ?, acc_password = ?, first_name = ?, last_name = ? WHERE username = ?");
				ps.setString(1, newUsername.isEmpty() ? username : newUsername);
				ps.setString(2, newPassword.isEmpty() ? password : newPassword);
				ps.setString(3, newFirst.isEmpty() ? first : newFirst);
				ps.setString(4, newLast.isEmpty() ? last : newLast);
				ps.setString(5, username);
				
				System.out.printf("%d rows updated\n", ps.executeUpdate());
				session.setAttribute("user-response", "User edited successfully");
				
				newUsername = newUsername.isEmpty() ? username : newUsername;
				
				ps = con.prepareStatement("SELECT * FROM Customer WHERE username = ?");
				ps.setString(1, newUsername);
				rs = ps.executeQuery();
				
				if(rs.next() && newType.equals("rep")) {
					ps = con.prepareStatement("DELETE FROM Customer WHERE username = ?");
					ps.setString(1, newUsername);
					System.out.printf("%d rows updated\n", ps.executeUpdate());
					
					ps = con.prepareStatement("INSERT INTO CustomerRep VALUES (?)");
					ps.setString(1, newUsername);
					System.out.printf("%d rows updated\n", ps.executeUpdate());
				}
				
				ps = con.prepareStatement("SELECT * FROM CustomerRep WHERE username = ?");
				ps.setString(1, newUsername);
				rs = ps.executeQuery();
				
				if(rs.next() && newType.equals("customer")) {
					ps = con.prepareStatement("DELETE FROM CustomerRep WHERE username = ?");
					ps.setString(1, newUsername);
					System.out.printf("%d rows updated\n", ps.executeUpdate());
					
					ps = con.prepareStatement("INSERT INTO Customer VALUES (?)");
					ps.setString(1, newUsername);
					System.out.printf("%d rows updated\n", ps.executeUpdate());
				}
			}
		} else {
			session.setAttribute("user-response", "Error editing user: doesn't exist");
		}
	}
	
	response.sendRedirect("administrator.jsp");
%>