<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><html>
<head>
	<title>Nav 영역</title>	
    <meta charset="UTF-8">
    <script src="https://kit.fontawesome.com/0625b87657.js" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous">
    </script>
    <link href="https://fonts.googleapis.com/css?family=Jua&display=swap" rel="stylesheet">
	
<script>

</script>

<style>
.icon-bar {
  width: 100%; /* Full-width */
  background-color: #555; /* Dark-grey background */
  overflow: auto; /* Overflow due to float */
}

.icon-bar a {
  float:left; /* Float links side by side */
  text-align: center; /* Center-align text */
  width: 50%; /* Equal width (5 icons with 20% width each = 100%) */
  padding: 12px 0; /* Some top and bottom padding */
  transition: all 0.3s ease; /* Add transition for hover effects */
  color: white; /* White text color */
  font-size: 36px; /* Increased font size */
}

.icon-bar a:hover {
  background-color: #000; /* Add a hover color */
}

.active {
  background-color:skyblue; /* Add an active/current color */
}

</style>
</head>
<body>



<div class="icon-bar">
    <a href="goHome" class="active"><i class="far fa-clipboard"></i></a>
    <a href="goSelectBoardPhoto"><i class="far fa-image"></i></a>
</div>



</body>
</html>
