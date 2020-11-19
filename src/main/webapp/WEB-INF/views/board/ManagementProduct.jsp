<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous">
    </script>
    <link href="https://fonts.googleapis.com/css?family=Jua&display=swap" rel="stylesheet">
    <script type="text/JavaScript" src="http://code.jquery.com/jquery-1.7.min.js"></script>
<title>상품 관리 하는 페이지</title>

<script>
function modifyProduct(pnum){
	
}

function deleteProduct(pnum){
	alert("삭제 완료");
	location.href="deleteProduct?pnum="+pnum;
}
</script>

<style>
p,li {
    font-family: 'Jua', sans-serif;
}
</style>
</head>
<body>
<h2>상품 관리</h2>


   <c:forEach items="${map.list}" var="li">
<div class="woo${li.pnum}">
	<h4>이름 : ${li.name}</h4>
	<h4>수량 : ${li.amount}</h4>
	<h4>가격 : ${li.price}</h4>
	<button onclick="modifyProduct(${li.pnum})">수정</button>
	<button onclick="deleteProduct(${li.pnum})">삭제</button>	
</div>			
</c:forEach>   

<c:if test="${empty map.list}">
<h2>등록한 물품이 없습니다.</h2>
</c:if>


        	<div class='text-center'>
     		<ul class='pagination pagination-sm'>
     		<c:choose>
     		<c:when test="${map.paging.page ne 1}">
     		<li><a href="selectProduct(1)">처음</a></li>
     		</c:when>
     		<c:otherwise>
     		<li class='disable'><a>처음</a></li>
     		</c:otherwise>
     		</c:choose>
     		
     		<c:choose>
     		<c:when test="${map.paging.beginPage ne 1}">
     	    <li><a href="selectProduct(${map.paging.begenPage-1})">이전</a></li>
     		</c:when>
     		<c:otherwise>
         	<li class='disable'><a>이전</a></li>
     		</c:otherwise>
     		</c:choose>

     		     		
    		   <c:forEach var="i" begin="${map.paging.beginPage}" end="${map.paging.endPage}">
     		<c:choose>
     		<c:when test="${i eq map.paging.page}">
            <li><a style='color:red'><span>${i}</span></a></li>     
            </c:when>
     		<c:otherwise>
     		<li><a href='selectProduct(${i})'>${i}</a></li>
     		</c:otherwise>
     		</c:choose>	   
              </c:forEach>   

     		<c:choose>
     		<c:when test="${map.paging.endPage ne map.paging.totalPage}">
            <li><a href='selectProduct(${map.paging.endPage+1})'>다음</a></li>
     		</c:when>
     		<c:otherwise>
            <li class='disable'><a>다음</a></li>
     		</c:otherwise>
     		</c:choose>
     		
     		<c:choose>
     		<c:when test="${map.paging.page lt map.paging.totalPage}">
            <li><a href='selectProduct(${map.paging.totalPage})'>끝</a></li>     	
            </c:when>
     		<c:otherwise>
            <li class='disable'><a>끝</a></li>
     		</c:otherwise>
     		</c:choose>
      		</ul>
      		</div>    
 		

</body>
</html>