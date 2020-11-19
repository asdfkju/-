<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <script src="https://kit.fontawesome.com/0625b87657.js" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous">
    </script>
<title>SelectBoardPhoto 영역</title>

<script>

$(document).ready(function(){
	selectBoardPhoto(1);
});

function boardWrite() {
	var id = '${id}';
	var idLength = id.length;
	if (idLength > 0) {
		location.href="goBoardWrite";
	} else {
		alert("로그인 해주세요.");
	}
}

function selectBoardPhoto(page){
    $.ajax({
        type:'post',
        url : "selectBoardPhoto",
        data : "page=" + page,
        dataType : "json",
        async : false,
        success : function(data){
        	console.log(data);
            var html = "";
            html+="<div class='row'>";
            var length=data.list.length;
        	var page="<div class='text-center'>";
      		    page+="<ul class='pagination pagination-sm'>";
            if(length > 0){
            	for(var i=0; i<length; i++) {
            	html+="<div class='column'>";
            	html+="<img onclick='goPost("+data.list[i].bnum+")' src='${pageContext.request.contextPath}/resources/fileUpload/"
						+data.list[i].filename+"'>";
				html+="<h3>글 제목 :"+data.list[i].title+"</h2>";
				html+="<h4>조회수 :"+data.list[i].hits+"</h4>";
				html+="</div>";
            	}
            html+="</div>";
                      	
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
            $("#selectBoardPhoto").html(html);
            $("#selectBoardPhotoPaging").html(page);            
        },
        error:function(request,status,error){
            alert("리스트를 불러오는 중 에러 발생");
       } 
    });
}


</script>

<style>

.row {
  display: flex;
  flex-wrap: wrap;
  padding: 0 4px;
}

/* Create four equal columns that sits next to each other */
.column {
  flex: 25%;
  max-width: 25%;
  padding: 0 4px;
}

.column img {
  margin-top: 8px;
  vertical-align: middle;
  width: 100%;
}

/* Responsive layout - makes a two column-layout instead of four columns */
@media screen and (max-width: 800px) {
  .column {
    flex: 50%;
    max-width: 50%;
  }
}

/* Responsive layout - makes the two columns stack on top of each other instead of next to each other */
@media screen and (max-width: 600px) {
  .column {
    flex: 100%;
    max-width: 100%;
  }
}
</style>
</head>
<body>

<jsp:include page="../Header.jsp"></jsp:include>
<jsp:include page="../Nav.jsp"></jsp:include>

<div id="selectBoardPhoto"></div>
<div id="selectBoardPhotoPaging"></div>
</body>
</html>