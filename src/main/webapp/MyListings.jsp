<%@ page import="main.java.User" %>
<%@ page import="main.java.Listing" %>
<%@ page import="java.util.ArrayList" %>

<% User user = (User) session.getAttribute("user"); %>
<% ArrayList<Listing> results = (ArrayList<Listing>) request.getAttribute("results"); %>

<!doctype html>
<html ng-app>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular.min.js"></script>
<title>Pull Up</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
<link rel="stylesheet" href="styles.css" type="text/css">

</head>

<body>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="WelcomePage.jsp"><i
					class="fa fa-car" aria-hidden="true"></i> Pull Up</a>
			</div>
			<div class="collapse navbar-collapse">
				<ul class="nav navbar-nav">
					<li><a href="NewListing.jsp"><i
							class="fa fa-plus-square-o" aria-hidden="true"> Create
								Listing</i></a></li>
					<li><a href="FindParking.jsp"><i
							class="fa fa-search-plus" aria-hidden="true"> Find Parking</i></a></li>

				</ul>

				<ul class="nav navbar-nav navbar-right">
					<li><a href="./LogOutServlet">Log-out <i class="fa fa-sign-out"
							aria-hidden="true"></i></a></li>
				</ul>
			</div>
		</div>
	</nav>
	
	<div class="socialmargin" style="text-align: right">
	<a href="#"><i class="fa fa-facebook-official fa-2x" aria-hidden="true"></i></a>
	<a href="#"><i class="fa fa-instagram fa-2x" aria-hidden="true"></i></a>
	<a href="#"><i class="fa fa-twitter fa-2x" aria-hidden="true"></i></a>
	</div>
	
	<% if (results == null || results.isEmpty()) { %>
		<h1 style="text-align: center">Sorry, you didn't have listings...</h1>
		<h2 style="text-align: center"> Please click <a href="NewListing.jsp">HERE</a> to make one!</h2>
	<% } else { %>
	<h1 style="text-align: center">Here's Your Rentals</h1>
	<div class="container results-box">
		<div class="jumbotron">
			<% for (int i = 0; i < results.size(); i++) { %>
				<div class="panel panel-default">
		 			 <div class="panel-heading">
		   				 <h2><%= results.get(i).getListingName() %></h2>
		   				 <% if (results.get(i).getTenantName() != null) { %>
		   				 <div style="float: right">
		   				 	<h3 style="font-weight: bold; color: red">BOOKED</h3>
		   				 	<h3><span style="font-weight: lighter">Tenant: </span><span style="font-weight: bold"><%= results.get(i).getTenantName() %></span></h3>
		   				 	<h4><span style="font-weight: lighter">Phone Number: </span><span style="font-weight: bold"><%= results.get(i).getTenantPhoneNumber() %></span></h4>
		   				 </div>
		   				 <% } else { %>
		   				 <div style="float: right">
		   				 	<h3 style="font-weight: bold; color: green">AVAILABLE</h3>
		   				 </div>	
		   				 <% } %>
		  			</div>
		  			<div class="panel-body">
		   	 			<h3><%= results.get(i).getAddress() %></h3>
		   	 			<% String beginTime = results.get(i).getTimeAvailable(); %>
		   	 			<% beginTime = beginTime.replaceFirst("T", " "); %>
		   	 			<% String endTime = results.get(i).getAvailableTill(); %>
		   	 			<% endTime = endTime.replaceFirst("T", " "); %>
		   	 			<h5><span style="font-weight: lighter">Available From: </span><%= beginTime %></h5>
		   	 			<h5><span style="font-weight: lighter">Available Until: </span><%= endTime %></h5>
		   	 			<h5><span style="font-weight: lighter">Type: </span><%= results.get(i).getParkingType() %></h5>
		   	 			<h3 style="color: green">$<%= String.format("%.2f", results.get(i).getPrice()) %>/hour</h3>
		   	 			<form name="deleteForm" method="GET" action="./DeleteListingServlet">
		   	 				<input type="hidden" name="listingID" value="<%= results.get(i).getListingID() %>">
		   	 				<button style="float: right" type="submit" class="btn btn-danger">
									<span class="fa fa-trash-o" aria-hidden="true"></span> Delete
							</a></button>
		   	 			</form>
		  			</div>
				</div>
				
			<% } %>
		</div>
	</div>
	<% } %>
	
</body>
</html>