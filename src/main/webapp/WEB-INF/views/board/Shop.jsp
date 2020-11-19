<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous">
    </script>
<title>샵 페이지</title>
<script type="text/javascript">

$(document).ready(function(){
selectProduct(1);
});

function basket(pnum,amount,name,price) {
	if(amount==0){
		alert("매진 되어 구매할 수 없습니다.")
		return false;
	}
	if(num ==0){
		alert("asdad");
	}
	var num = $(".amount"+ pnum).val();
	var id = "${id}";
	if(amount<num)
		alert("남은 수량보다 많이 선택할 수 없습니다.");
	else {
	$.ajax({
		url:"containBasket",
		type:"post",
		data:"pnum="+pnum+"&amount="+num+"&id="+id+"&name="+name+"&price="+price,
		datatype:"text",
		success:function(result){
			if(result == "yes")
			alert("성공적으로 담겼습니다.");
			else  
			alert("담는 과정에서 에러 발생");
		}, error:function(e){
			alert("에러 발생");
		}
	});
}
}

function selectProduct(page){
	$.ajax({
		url:"selectProduct",
		type:"post",
		data:"page="+page,
	    datatype:"json",
	    async:false,
	    success:function(data){
            var html = "";
            html+="<div class='row'>";
            var length=data.list.length;
            if(length > 0){
            	for(var i=0; i<length; i++) {
            	html+="<div class='column'>";
            	html+="<img src='${pageContext.request.contextPath}/resources/fileUpload/"
						+data.list[i].filename+"' style='height:200px; weigh:200px;'>";
				html+="<h4>이름 :"+data.list[i].name+"</h2>";
				html+="<h4>가격 :"+data.list[i].price+"</h4>";
				html+="<h4>설명 :"+data.list[i].contents+"</h4>";
					html+="<h4>남은 수량 :"+data.list[i].amount+"</h4>";
					html+="수량 : <input type='number' class='amount"+data.list[i].pnum+"' value='1' min='1'><br>";
					html+="<button onclick='buyProduct("+data.list[i].pnum+","+data.list[i].amount+")'>구매하기</button><br>";
					html+="<button onclick='basket("+data.list[i].pnum+","+data.list[i].amount+",\""+data.list[i].name+"\","+data.list[i].price+")'>장바구니 담기</button>";
					html+="</div><br>";
            	}
            } else {
            	html+="상품이 없습니다.";
            }
            html+="</div>";
    
            
	       	var page="<div class='text-center'>";
     		 page+="<ul class='pagination pagination-sm'>";
     		var prevPage=data.paging.beginPage-1;
     		var nextPage=data.paging.endPage+1;
     		if(data.paging.page!=1){
     			page += "<li><a href='javascript:selectBoard("+1+")'>처음</a></li>";
     		}
     		else{
     			page += "<li class='disable'><a>처음</a></li>";
     		}
     		if(data.paging.beginPage!=1){
     			page +="<li><a href='javascript:selectBoard("+prevPage+")'>이전</a></li>";
     		}
     		else{
     			page +="<li class='disable'><a>이전</a></li>";
     			
     		}
     		
     		for(var j=data.paging.beginPage; j<=data.paging.endPage; j++){
     			if(j==data.paging.page){
     				page+="<li><a style='color:red'><span>"+j+"</span></a></li>";
     			}
     			else{
     				page+="<li><a href='javascript:selectBoard("+j+")'>"+j+"</a></li>";
     				
     			}
     		}
     		
     		if(data.paging.endPage!=data.paging.totalPage){
     			page += "<li><a href='javascript:selectBoard("+nextPage+")'>다음</a></li>";
     		}
     		else{
     			page += "<li class='disable'><a>다음</a></li>";
     		}
     		if(data.paging.page<data.paging.totalPage){
     			page +="<li><a href='javascript:selectBoard("+data.paging.totalPage+")'>끝</a></li>";
     		}
     		else{
     			page +="<li class='disable'><a>끝</a></li>";
     		}
      		page+="</ul>";
      		page+="</div>";       					
	    	$("#sp").html(html);
	    	$("#spp").html(page);
	    }, error:function(e){
	    	alert("에러 발생");
	    }
	});
}


</script>
<style>
</style>
</head>
<body>
<jsp:include page="../Header.jsp"></jsp:include>
<jsp:include page="../Nav.jsp"></jsp:include>
<div id="sp">
</div>
<div id="spp">
</div>

</body>
</html>