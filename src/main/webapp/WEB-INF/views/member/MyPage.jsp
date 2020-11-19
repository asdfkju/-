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
<title>MyPage 영역</title>


<script>

function managementProduct(page){
	var popUrl = "managementProduct?page="+page;	
	var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;"; 
	    window.open(popUrl,"",popOption);		
	
}

function registerProduct() {
	var popUrl = "registerProductForm";	
	var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;"; 
	    window.open(popUrl,"",popOption);		
}

function modifyEmail() {
	var id = "${id}";
	var popUrl = "modifyEmail?id="+id;	
	var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;"; 
	    window.open(popUrl,"",popOption);	
}

function goRerortPost(repnum) {
	var popUrl = "selectReportPost?repnum="+repnum;	
	var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;"; 
	    window.open(popUrl,"",popOption);
}

function modifyMI() {
	    location.href="miForm";
}

$(document).ready(function(){
	var kind = "${kind}";
	var id = "${id}";
	console.log(kind);
	if(kind =="회원"){
		boardWrittenByMe(id);
		commentsWrittenByMe(id);
	} else if(kind =="관리자") {
		selectReport(1);
		selectMember();
	}
});

function selectReport(page) {
	$.ajax({
		url:"selectReport",
		type:"post",
		data:"page="+page,
	    datatype:"json",
	    async:false,
	    success:function(data){
	    	var html = "";
	    	var length = data.list.length;
			html+="<h2>신고글 목록</h2>";
			html+="<table class='type09'><thead><tr><th scope='cols'>신고글 번호</th><th>제목</th></tr></thead>";
			html+="<tbody>";
	    	if(length > 0) {
				for(var i=0; i<length; i++){
					html+="<tr><th scope='cols'>"+data.list[i].repnum+"</th><td><a onclick='goRerortPost("+data.list[i].repnum+")'>"+data.list[i].title+"</a></td></tr>";	
			}
	    	} else {
	           	html += "<td colspan='8'>글이 없습니다.</td>"
	    	}
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
			html+="</tbody></table>";
	    	$("#rp").html(html);
	    	$("#rpp").html(page);
	    }, error:function(e){
	    	alert("신고게시물 불러오는 도중에 에러 발생");
	    }
	});
}

function boardWrittenByMe(id){
	$.ajax({
		url:"boardWrittenByMe",
		data:"id="+id+"&page="+1+"&kind="+"게시물",
		datatype:"json",
		type:"post",
		success:function(data){
			var length = data.list.length;
			var html = "";
			html+="<h2>내가 쓴 글</h2>";
			html+="<table class='type09'><thead><tr><th scope='cols'>글 번호</th><th>제목</th></tr></thead>";
			html+="<tbody>";
			if(length > 0) {
			for(var i=0; i<length; i++){
				html+="<tr><th scope='cols'>"+data.list[i].bnum+"</th><td><a onclick='goPost("+data.list[i].bnum+")'>"+data.list[i].title+"</a></td></tr>";	
		}
		}
       else{
       	html += "<td colspan='8'>글이 없습니다.</td>"
       }			
			
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
           
		
			
			html+="</tbody></table>";
			$("#bwp").html(page);
			$("#bw").html(html);
		}, error:function(e){
			alert("에러 발생");
		}
	});
	
}

function commentsWrittenByMe(id){
	$.ajax({
		url:"commentsWrittenByMe",
		data:"id="+id+"&page="+1+"&kind="+"댓글",
		datatype:"json",
		type:"post",
		success:function(data){
			var length = data.list.length;
			var html = "";
			html+="<h2>내가 쓴 댓글</h2>";
			html+="<table class='type09'><thead><tr><th scope='cols'>게시물제목</th><th>댓글내용</th></tr></thead>";
			html+="<tbody>";
			if(length > 0) {
			for(var i=0; i<length; i++){
				html+="<tr><th scope='cols'>"+data.list[i].title+"</th><td><a onclick='goPost("+data.list[i].bnum+")'>"+data.list[i].contents+"</a></td></tr>";	
		}
		}
       else{
       	html += "<td colspan='8'>글이 없습니다.</td>"
       }			
			
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
           
		
			
			html+="</tbody></table>";
			$("#cw").html(html);
			$("#cwp").html(page);
		}, error:function(e){
			alert("에러 발생");
		}
	});
	
}


function memberWithdrawal() {
	var pw ="${password}";
	var id ="${id}";
	var decision = prompt("탈퇴를 위해 비밀번호를 입력해 주세요.");
	if(decision) {
		$.ajax({
			url:"memberWithdrawal",
			type:"post",
			data:"id="+id,
			datatype:"text",
			success:function(result){
				if(result == true){
					alert("탈퇴가 완료되었습니다.");					
				    location.href="deleteMember";
				}
			}, error:function(e){
				alert("에러 발생");
			}
		});
	} else {
		return false;
	}
}

function deleteMember(id) {
	$.ajax({
		url:"memberWithdrawal",
		type:"post",
		data:"id="+id,
		datatype:"text",
		success:function(result){
			if(result == true){
				alert("탈퇴 완료");					
			    location.href="deleteMember";
			}
		}, error:function(e){
			alert("에러 발생");
		}
	});
}

function selectMember() {
	$.ajax({
		url:"selectMember",
		data:"page="+1,
		type:"get",
		datatype:"json",
		success:function(data){
			console.log(data);
			var html = "";
			var length = data.list.length;
			html+="<h2>회원 목록</h2>";
			html+="<table class='type09'><thead><tr><th scope='cols'>회원 아이디</th><th>탈퇴시키기</th></tr></thead>";
			html+="<tbody>";
			if(length > 0) {
			for(var i=0; i<length; i++){
				html+="<tr><th scope='cols'>"+data.list[i].id+"</th><td><a onclick='deleteMember("+data.list[i].id+")'>"+"O"+"</a></td></tr>";	
		}
		}
       else{
       	html += "<td colspan='8'>가입한 회원이 없습니다.</td>";
       }
			
			
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
			
			$("#sm").html(html);
			$("#smp").html(page);      		
		}, error:function(e){
			alert("에러 발생");
		}
	});
	
}

</script>
<style>
table.type09 {
    border-collapse: collapse;
    text-align: left;
    line-height: 1.5;

}
table.type09 thead th {
    padding: 10px;
    font-weight: bold;
    vertical-align: top;
    color: #369;
    border-bottom: 3px solid #036;
}
table.type09 tbody th {
    width: 150px;
    padding: 10px;
    font-weight: bold;
    vertical-align: top;
    border-bottom: 1px solid #ccc;
    background: #f3f6f7;
}
table.type09 td {
    width: 350px;
    padding: 10px;
    vertical-align: top;
    border-bottom: 1px solid #ccc;
}
</style>
</head>
<body>

<jsp:include page="../Header.jsp"></jsp:include>



<div id="bw">
</div>

<div id="bwp"> 
</div>

<div id="cw">
</div>

<div id="cwp">
</div>

<div id="rp">
</div>

<div id="rpp">
</div>

<div id="sm">
</div>

<div id="smp">
</div>



<div>

<c:if test="${kind == '관리자'}">
<button onclick="registerProduct()">상품 올리기</button>
<button onclick="managementProduct(1)">상품 관리</button>
</c:if>
<button onclick="modifyMI()">회원정보 수정</button>
<button onclick="modifyEmail()">이메일 수정</button>
<c:if test="${kind != '관리자'}">
<button onclick="memberWithdrawal()">회원탈퇴</button>
</c:if>
</div>

</body>

</html>