<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><html>
<head>
	<title>Nav 영역</title>	
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script src="https://kit.fontawesome.com/0625b87657.js" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous">
    </script>
    <link href="https://fonts.googleapis.com/css?family=Jua&display=swap" rel="stylesheet">
	
<script>

function weather() {
	$.ajax({
		type:"get",
		url:"weather",
		datatype:"json",
		success:function(check){
		}, error:function(){
	        alert("에러 발생");
	    } 
	});
}


function boardWrite() {
	var id = '${id}';
	var idLength = id.length;
	if (idLength > 0) {
		location.href="goBoardWrite";
	} else {
		alert("로그인 해주세요.");
	}
}



function checkReport(bnum) {
	var id = '${id}';
	if (id.length != 0) {
		$.ajax({
			type:'GET',
			url:'reportCheck',
			data:"bnum="+bnum+"&page="+1,
			datatype:"json",
			success:function(check){
				console.log(check);
				if(check == true){
					location.href="viewPost?bnum="+bnum;
				} else {
					alert("신고 당한 글이므로 지금은 볼 수 없습니다.");
				}
			}, error:function(request,status,error){
		        alert("에러 발생");
		    } 
		});
	} else {
		alert("로그인 후 이용 가능합니다.");
	}
}

function popularPost(){
	$.ajax({
		url:"popularPost",
		type:"get",
		datatype:"json",
		success:function(data){
			var html ="";
			var length = data.length;
			if(data.length > 0) {
				html+="<h2>좋아요 많은 게시글</h2>"
				html+="<table class='type09'><thead><tr><th scope='cols'>글 번호</th><th scope='cols'>제목</th></thead>";
				html+="<tbody>";
				for(var i=0; i<length; i++) {
					html+="<tr><th scope='row'>"+data[i].bnum+"</th><td><a href='javascript:goPost("+data[i].bnum+")'>"+data[i].title+"</a></td></tr>";					
				}
			        html+="</tbody></table>";
			} else {
				html+="<h2>좋아요 많은 게시글</h2>"	
				html+="아직 글이 없습니다.";
			}					
			$("#popularPost").html(html);
		}, error:function(e){
			alert("에러 발생");
		}
	});
}

function bestPost() {
	$.ajax({
		url:"bestPost",
		type:"get",
		datatype:"json",
		success:function(data){
			if(data.length > 0) {
				var html ="";
				var length = data.length;
				html+="<h2>조회수 많은 게시글</h2>"
				html+="<table class='type09'><thead><tr><th scope='cols'>글 번호</th><th scope='cols'>제목</th></thead>";
				html+="<tbody>";
				for(var i=0; i<length; i++) {
					html+="<tr><th scope='row'>"+data[i].bnum+"</th><td><a href='javascript:goBestPost("+data[i].bnum+")'>"+data[i].title+"</a></td></tr>";					
				}
			        html+="</tbody></table>";
			}
			
			$("#bestPost").html(html);
		}, error:function(e){
			alert("에러 발생");
		}
	});
}

function goPost(bnum) {
	var id ="${id}";
	if (id== "") {
		alert("로그인 후 이용 가능합니다.");
		return false;
	}
	location.href="viewPost?bnum=" +bnum;
}

$(document).ready(function(){
	weather();
	selectBoard(1);
	bestPost();
	popularPost();
});



function selectBoard(page) {
    $.ajax({
        type:'GET',
        url : "selectBoard",
        data : "page=" + page,
        dataType : "json",
        async : false,
        success : function(data){
        	
        	console.log(data);
            var html = "<h2>글 리스트</h2>";
            var length=data.list.length;
        	var page="<div class='text-center'>";
            if(length > 0){
                	html += "<table class='table table-striped table-bordered table-hover'><thead><tr><th>글 번호</th><th>제목</th><th>조회수</th></tr></thead>";
                	for(var i=0; i<length; i++) {
						html+="<tr><td>"+data.list[i].bnum+"</td><td><a href='#' onclick='checkReport("+data.list[i].bnum+")'>"+data.list[i].title+"</a></td><td>"+data.list[i].hits+"</td></tr>";
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
                	html +="</table>";
            		page+="</ul>";        	
                }
            else{
            	html += "<table class='table table-striped table-bordered table-hover'><thead><tr><th>글번호</th><th>제목</th><th>조회수</th></tr></thead>";
            	html += "<td colspan='8'>글이 없습니다.</td>"
            	html +="</table>";
            }
    		page+="</div>";            
    		page+="<button onclick='boardWrite()' id='boardWrite'>글쓰기</button>";

            $("#selectBoard").html(html);
            $("#selectBoardPaging").html(page);
            
        },
        error:function(request,status,error){
            alert("리스트를 불러오는 중 에러 발생");
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
${elem}

<div id="bestPost">
</div>
<div id="popularPost">
</div>

<div id="selectBoard">

</div>

<div id="selectBoardPaging">

</div>


</body>
</html>