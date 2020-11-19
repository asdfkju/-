<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/0625b87657.js"
	crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.4.1.js"
	integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
	crossorigin="anonymous">
    </script>
<link href="https://fonts.googleapis.com/css?familyf=Jua&display=swap"
	rel="stylesheet">
<title>ViewPost 영역</title>


<script>

function commentsLike(cnum,id){	
	$.ajax({
		data:"cnum="+cnum+"&id="+id,
		type:"post",
		url:"commentsLike",
		datatype:"text",
		success:function(result){
			if(result>0){
				location.reload();
			} else {
				alert("코딩 잘못함");
			}
		}, error:function(e){
			alert("에러 발생");
		}
	});
}

function writeCommentReply(cnum,contents,bnum) {
	var td = document.querySelector(".re");
	//이렇게 사용 가능
	$(td).remove();
	if(contents.match("삭제된 댓글입니다.")) {
		alert("삭제된 댓글에는 덧글 달 수 없습니다.");
		return false;
	} else {
		var html ="";
		var html2 ="";
		                    //쿼리셀렉터를 위해 re뒤에 띄워쓰기함.
		    html+="<td class='re "+cnum+"'>";
	    	html += "<form id='rform' method='post' enctype='multipart/form-data'>";
			html += "<input type='text' id='rcontents' name='contents' style='width:900px;'>";		
	    	html += "<input type='file' name='rfile' id='rfile'>";
	    	html += "<input type='hidden' value='"+cnum+"' name='cnum'>";
	    	html += "<input type='hidden' value='"+bnum+"' name='bnum'>";
	    	html += "</form><button id='writeCommentReply' onclick='writeCommentReply2()'>등록</button></td>";
	    	// > 기호가 자식 태그임.
	    	$('#reply > tbody.mandu'+cnum+':last').append(html); 
	    	$('#btn' + cnum).append(html2);		
	}
}

function modifyCommentsForm(crnum) {
	var td = document.querySelector(".woo");
	$(td).remove();
	var html ="";
	var html2 ="";
	    html+="<td class='woo "+crnum+"'></td>"
    	html += "<form id='mform' method='post' enctype='multipart/form-data'>";
		html += "<input type='text' id='contents' name='contents' style='width:900px;'>";		
    	html += "<input type='file' name='cfile' id='cfile'>";
    	html += "<input type='hidden' value='"+crnum+"' name='cnum'>";
    	html += "</form><button id='modifyComments' onclick='modifyComments()'>등록</button>";
    	html2 += "<button id='cbtn' onclick='cancelModify()'>취소하기</button></tr></table>";
    	$('.jin'+ crnum).empty();
        $('#btn'+crnum).empty();
    	$('#btn'+crnum).append(html2);
        $('.jin'+ crnum).append(html);
}

function writeCommentReply2() {
	var id="${id}";
	var contents=$("#rcontents").val();
    var formData = new FormData(document.getElementById("rform"));
    formData.append("id", id); 	
	var decision = confirm("등록하시겠습니까?");
	if(contents == "") {
		alert("내용을 입력해주세요.");
		//contents.focus(); rg?
		$("#rcontents").focus();
	} else if(decision) {
		$.ajax({
			url:"writeCommentsReply",
			type:"post",
			data:formData,
			datatype:"text",
			processData : false, // 필수 
			contentType : false, // 필수
			success:function(result){
				if(result){
					alert("등록 성공하였습니다.");
					location.reload();
				} else {
					alert("등록 실패");
				}
			}, error:function(e){
				alert("에러 발생");
			}			
		});		
	}
}

$(document).ready(function(){
	var bnum='${post.bnum}';
	console.log(bnum);
		$.ajax({
			url:"selectBoardLike",
			type:"post",
			data:"bnum="+bnum,
			datatype:"json",
			success:function(data){
				if(data == "") {
					$("#like").html(0);
					$("#dislike").html(0);										
				} else {
					var like = data.likes;
					var dislike = data.dislikes;
						$("#like").html(like);
						$("#dislike").html(dislike);					
				}
			}, error:function(e){
				alert("에러 발생");
			}
		});
});

function like(bnum,id){
	$.ajax({
		url:"like",
		type:"post",
		data:"bnum="+bnum+"&id="+id,
		datatype:"json",
		success:function(result){
			if(result) {
				location.reload();				
			} else {
				alert("에러 발생");
			}
		}, error:function(e){
			alert("에러 발생");
		}
	});
}
function dislike(bnum,id){
	$.ajax({
		url:"dislike",
		type:"post",
		data:"bnum="+bnum+"&id="+id,
		datatype:"json",
		success:function(result){
			if(result) {
				location.reload();				
			} else {
				alert("에러 발생");
			}
		}, error:function(e){
			alert("에러 발생");
		}
	});
}


function reportPost(bnum,postId) {
	console.log(postId);
	var popUrl = "reportForm?bnum="+bnum+"&postId="+postId;	
	var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;"; 
	    window.open(popUrl,"",popOption);
}

function writeComments() {
	var ccontents = $("#ccontents").val();
	var bnum = document.getElementById("bnum").value;    
	var cf = confirm("등록하시겠습니까?");
	var id = "${id}";
	console.log(id);
	if(cf) {		
		if(ccontents=="") {
			alert("내용을 입력해주세요");
			$("#ccontents").focus();
		} else if(checkIMG()) {
		    var formData = new FormData(document.getElementById("form"));
		    formData.append("id", id);
			$.ajax({
				url:"writeComments",
				type:"POST",
				data:formData,
				dataType : "text",
				processData : false, // 필수 
				contentType : false, // 필수
				success:function(result) {
					if(result > 0) {
						location.reload();
					} else {
						alert("0 나와서 댓글 작성 실패");
					}
				},error:function(){
					alert("에러 발생");
				}				
			});
		}
	}
}

function checkIMG() {
	var imgfile = document.getElementById("cfile").value;
	if (imgfile != "") {
		var ext = imgfile.slice(imgfile.lastIndexOf(".") + 1).toLowerCase();
		if (!(ext == "gif" || ext == "jpg" || ext == "png" || ext == "bmp")) {
			alert("이미지파일 (.jpg, .png, .gif,.bmp ) 만 업로드 가능합니다.");
			return false;
		} else {
			return true;
		}
	} else {
		return true;
	}
}

function fileDownload(fileName) {
	location.href="fileDownload?filename="+fileName;
}

function showModifyWindow(cnum,id,writer) {
	var me = "${id}";
	var html ="";
	var html2 ="";
	if(me == id || writer) {
    	html += "<form id='mform' method='post' enctype='multipart/form-data'>";
		html += "<input type='text' id='contents' name='contents' style='width:900px;'>";		
    	html += "<input type='file' name='cfile' id='cfile'>";
    	html += "<input type='hidden' value='"+cnum+"' name='cnum'>";
    	html += "</form><button id='modifyComments' onclick='modifyComments()'>등록</button>";
    	html2 += "<button id='cbtn' onclick='cancelModify()'>취소하기</button></tr></table>";
    	$('#bid' + cnum).empty();
        $('#btn' + cnum).empty();
    	$('#bid' + cnum).append(html);
        $('#btn' + cnum).append(html2);
    	
	} else {
		return false;
	}	
}

function cancelModify() {
location.reload();
}
    
    
    
function modifyComments() {
	var contents = $("#contents").val();
	if(contents=="") {
		alert("내용을 입력해주세요.");
	} else if(checkIMG()) {
	    var formData = new FormData(document.getElementById("mform"));
		$.ajax({
			url:"modifyComments",
			type:"POST",
			data:formData,
			dataType : "text",
			processData : false, // 필수 
			contentType : false, // 필수
			success:function(result) {
				if(result>0){
					alert("수정 완료");
					location.reload();					
				} else {
					alert("0 나와서 에러 발생");
				}
			}, error:function(){
				alert("수정 중 에러 발생");
			}	
		});
	}
}

function deleteComments(cnum) {
	var decision = confirm("삭제하시겠습니까?");
	if(decision) {
		$.ajax({
			url:"deleteComments",
			data:"cnum="+cnum,
			dataType:"text",
			type:"post",
			success:function(result){
				alert("삭제 완료");
				location.reload();
			}, error:function(){
				alert("삭제 중 에러 발생");
			}
		});
	} else {
		return false;
	}	
}



$(document).ready(function(){
	var bnum="${post.bnum}";
	selectComments(1,${post.bnum});
	var postPic = "${postPic}";
	if(postPic == "[]") {
		$("#wrapper").remove();
	}
});


function selectComments(page,bnum) {
	$.ajax({
        type:'GET',
        url : "selectComments",
       data : "page=" + page+"&bnum=" + bnum,
        dataType : "json",
        async : false,
        success : function(data){
        	console.log(data);
        	var writer = '${post.id}';
        	var id = '${id}';
        	var kind ='${kind}';
        	var html = "<h2>댓글 리스트</h2>";
        	console.log(id);
            var length=data.commentsList.length;
            var length2=data.commentsReplyList.length;
        	html += "<table class='table table-striped table-bordered table-hover' id='reply'><thead><tr><th>댓글 번호</th><th>아이디</th><th>내용</th><th>작성일자</th><th>관리</th></tr></thead>";
            if(length > 0){
                	for(var i=0; i<length; i++){ 
                		if(data.commentsList[i].filename != null) {
						html+="<tr><td>"+data.commentsList[i].cnum+"</td><td>"+data.commentsList[i].id+"<a onclick='commentsLike("+data.commentsLike[i].cnum+",\""+id+"\")'><i class='fas fa-thumbs-up fa-2x' id='up'></i></a>"+data.commentsList[i].likes+"</td>";
						html+="<td id='bid"+data.commentsList[i].cnum+"'><img onclick='fileDownload(\""+data.commentsList[i].filename+"\")' src='${pageContext.request.contextPath}/resources/fileUpload/"
						+data.commentsList[i].filename+"' style='width:100px; height:50px;'>"						
								+data.commentsList[i].contents+"</td>"+
								"<td>"+data.commentsList[i].wd+"</td>";
						html+="<td id='btn"+data.commentsList[i].cnum+"'>";
						if(id == data.commentsList[i].id || kind =="관리자"){
						html+="<button onclick='showModifyWindow("+data.commentsList[i].cnum+",\""+data.commentsList[i].id+"\",\""+writer+"\")'>수정</button>";
						html+="<button onclick='deleteComments("+data.commentsList[i].cnum+",\""+data.commentsList[i].id+"\")'>삭제</button>";
					    html+="<button onclick='writeCommentReply("+data.commentsList[i].cnum+",\""+data.commentsList[i].contents+"\","+data.commentsList[i].bnum+")'>덧글달기</button></td><tbody class='mandu"+data.commentsList[i].cnum+"'></tbody>";								
						} else {
							html +="<button onclick='writeCommentReply("+data.commentsList[i].cnum+",\""+data.commentsList[i].contents+"\","+data.commentsList[i].bnum+")'>덧글달기</button></td><tbody class='mandu"+data.commentsList[i].cnum+"'></tbody>";								
						}
		            	} else {
							html+="<tr><td>"+data.commentsList[i].cnum+"</td><td>"+data.commentsList[i].id+
							"<a onclick='commentsLike("+data.commentsList[i].cnum+",\""+id+"\")'><i class='fas fa-thumbs-up fa-1x' id='up'></i></a>"+data.commentsList[i].likes+"</td><td id='bid"+data.commentsList[i].cnum+"'>"						
									+data.commentsList[i].contents+"</td>"+
									"<td>"+data.commentsList[i].wd+"</td>";
									html+="<td id='btn"+data.commentsList[i].cnum+"'>";
									if(id == data.commentsList[i].id || kind =="관리자"){
							html+="<button onclick='showModifyWindow("+data.commentsList[i].cnum+",\""+data.commentsList[i].id+"\")'>수정</button>";
							html+="<button onclick='deleteComments("+data.commentsList[i].cnum+")'>삭제</button>";	
						    html+="<button onclick='writeCommentReply("+data.commentsList[i].cnum+",\""+data.commentsList[i].contents+"\","+data.commentsList[i].bnum+")'>덧글달기</button></td><tbody class='mandu"+data.commentsList[i].cnum+"'></tbody>";								
						} else {
							html +="<button onclick='writeCommentReply("+data.commentsList[i].cnum+",\""+data.commentsList[i].contents+"\","+data.commentsList[i].bnum+")'>덧글달기</button></td><tbody class='mandu"+data.commentsList[i].cnum+"'></tbody>";
						}
		            	} 
                		
                		for(var j=0; j<length2; j++) {
                			if(data.commentsList[i].cnum == data.commentsReplyList[j].cnum) {
                   				html+="<td>"+data.commentsReplyList[j].id+"</td>";
                				if(data.commentsReplyList[j].filename != null) {                        			
            						html+="<td class='jin"+data.commentsReplyList[j].crnum+"'><img onclick='fileDownload(\""+data.commentsReplyList[j].filename+"\")' src='${pageContext.request.contextPath}/resources/fileUpload/"
            						+data.commentsReplyList[j].filename+"' style='width:100px; height:50px;'>"						
            								+data.commentsReplyList[j].contents+"</td>"+
            								"<td>"+data.commentsReplyList[j].wd+"</td>";
                        		} else {
                    				html+="<td class='jin"+data.commentsReplyList[j].crnum+"'>"+data.commentsReplyList[j].contents+"</td>";                        			
    								html+="<td>"+data.commentsReplyList[j].wd+"</td>";
                        		}
                				html+="<td id='btn"+data.commentsReplyList[j].crnum+"'>";
                				if(data.commentsReplyList[j].id == id){
        							html+="<button onclick='orm("+data.commentsReplyList[j].crnum+")'>수정</button>";
        							html+="<button onclick='deleteCommentsReply("+data.commentsReplyList[j].crnum+")'>삭제</button></td>";	

                				} else {
                				html+="</td>";
                				}
                			} 
                		                			
                			else {
                				
                			}
                			html+="</tr>";
                		}

                	}
                	
                	
                	html +="</table>";
            		page+="</ul>";
            		page+="</div>";
            		
                	
                }
            else{
            	html +="</td></table></div>";
            }

            
        	var page="<div class='text-center'>";
   		 page+="<ul class='pagination pagination-sm'>";
   		var prevPage=data.commentsPaging.beginPage-1;
   		var nextPage=data.commentsPaging.endPage+1;
   		if(data.commentsPaging.page!=1){
   			page += "<li><a href='javascript:selectComment("+1+")'>처음</a></li>";
   		}
   		else{
   			page += "<li class='disable'><a>처음</a></li>";
   		}
   		if(data.commentsPaging.beginPage!=1){
   			page +="<li><a href='javascript:selectComments("+prevPage+")'>이전</a></li>";
   		}
   		else{
   			page +="<li class='disable'><a>이전</a></li>";
   			
   		}
   		for(var j=data.commentsPaging.beginPage; j<=data.commentsPaging.endPage; j++){
   			if(j==data.commentsPaging.page){
   				page+="<li><a style='color:red'><span>"+j+"</span></a></li>";
   			}
   			else{
   				page+="<li><a href='javascript:selectComments("+j+","+${post.bnum}+")'>"+j+"</a></li>";
   				
   			}
   		}
   		
   		if(data.commentsPaging.endPage!=data.commentsPaging.totalPage){
   			page += "<li><a href='javascript:selectComments("+nextPage+")'>다음</a></li>";
   		}
   		else{
   			page += "<li class='disable'><a>다음</a></li>";
   		}
   		if(data.commentsPaging.page<data.commentsPaging.totalPage){
   			page +="<li><a href='javascript:selectComments("+data.commentsPaging.totalPage+")'>끝</a></li>";
   		}
   		else{
   			page +="<li class='disable'><a>끝</a></li>";
   		}
            
            
            
            
            
            
            
        	html += "<div class='col-xs-12'>";
        	html += "<div class='col-xs-2'></div>";
        	html += "<div class='col-xs-8'>";
        	html += "<form id='form' method='post' enctype='multipart/form-data'>";
        	html += "<input type='text' id='contents' name='contents' style='width:900px;'>";
        	html += "<input type='file' name='cfile' id='cfile'>";
        	html += "<input type='hidden' value='${post.bnum}' id='bnum' name='bnum'>";
        	html += "</form></div>";
        	html += "<button id='writeComments'onclick='writeComments()'>등록</button>";
        	html += "<div class='col-xs-2'></div>";
            $("#selectComments").html(html);
            $("#selectCommentsPaging").html(page);
            
        },
        error:function(request,status,error){
            alert("리스트를 불러오는 중 에러 발생");
       } 
    });
}

function modifyPost(bnum) {
	location.href="callPostForm?bnum="+bnum;
}

function deletePost(bnum) {
	var decision = confirm("정말로 삭제하시겠습니까?") 
		if(decision) {
				var popUrl = "RandomStr?bnum="+bnum;	
				var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;";
					window.open(popUrl,"",popOption);
		} else {
			
		}		
}

</script>

<style>


.row{
height:400px;
}


* {
	margin: 0;
	padding: 0;
	list-style: none;
}

a {
	text-decoration: none;
	color: #666;
}

a:hover {
	color: #1bc1a3;
}

body, hmtl {
	background: #ecf0f1;
	font-family: 'Anton', sans-serif;
}

#wrapper {
	width: 600px;
	margin: 50px auto;
	height: 400px;
	position: relative;
	color: #fff;
	text-shadow: rgba(0, 0, 0, 0.1) 2px 2px 0px;
}

#slider-wrap {
	width: 600px;
	height: 400px;
	position: relative;
	overflow: hidden;
}

#slider-wrap ul#slider {
	width: 100%;
	height: 100%;
	position: absolute;
	top: 0;
	left: 0;
}

#slider-wrap ul#slider li {
	float: left;
	position: relative;
	width: 600px;
	height: 400px;
}

#slider-wrap ul#slider li>div {
	position: absolute;
	top: 20px;
	left: 35px;
}

#slider-wrap ul#slider li>div h3 {
	font-size: 36px;
	text-transform: uppercase;
}

#slider-wrap ul#slider li>div span {
	font-family: Neucha, Arial, sans serif;
	font-size: 21px;
}

#slider-wrap ul#slider li img {
	display: block;
	width: 100%;
	height: 100%;
}

/*btns*/
.btns {
	position: absolute;
	width: 50px;
	height: 60px;
	top: 50%;
	margin-top: -25px;
	line-height: 57px;
	text-align: center;
	cursor: pointer;
	background: rgba(0, 0, 0, 0.1);
	z-index: 100;
	-webkit-user-select: none;
	-moz-user-select: none;
	-khtml-user-select: none;
	-ms-user-select: none;
	-webkit-transition: all 0.1s ease;
	-moz-transition: all 0.1s ease;
	-o-transition: all 0.1s ease;
	-ms-transition: all 0.1s ease;
	transition: all 0.1s ease;
}

.btns:hover {
	background: rgba(0, 0, 0, 0.3);
}

#next {
	right: -50px;
	border-radius: 7px 0px 0px 7px;
}

#previous {
	left: -50px;
	border-radius: 0px 7px 7px 7px;
}

#counter {
	top: 30px;
	right: 35px;
	width: auto;
	position: absolute;
}

#slider-wrap.active #next {
	right: 0px;
}

#slider-wrap.active #previous {
	left: 0px;
}

/*bar*/
#pagination-wrap {
	min-width: 20px;
	margin-top: 350px;
	margin-left: auto;
	margin-right: auto;
	height: 15px;
	position: relative;
	text-align: center;
}

#pagination-wrap ul {
	width: 100%;
}

#pagination-wrap ul li {
	margin: 0 4px;
	display: inline-block;
	width: 5px;
	height: 5px;
	border-radius: 50%;
	background: #fff;
	opacity: 0.5;
	position: relative;
	top: 0;
}

#pagination-wrap ul li.active {
	width: 12px;
	height: 12px;
	top: 3px;
	opacity: 1;
	box-shadow: rgba(0, 0, 0, 0.1) 1px 1px 0px;
}

/*Header*/
h1, h2 {
	text-shadow: none;
	text-align: center;
	font-family: Neucha, Arial, sans serif;
}

h1 {
	color: #666;
	text-transform: uppercase;
	font-size: 36px;
}

h2 {
	color: #7f8c8d;
	font-size: 18px;
	margin-bottom: 30px;
}

/*ANIMATION*/
#slider-wrap ul, #pagination-wrap ul li {
	-webkit-transition: all 0.3s cubic-bezier(1, .01, .32, 1);
	-moz-transition: all 0.3s cubic-bezier(1, .01, .32, 1);
	-o-transition: all 0.3s cubic-bezier(1, .01, .32, 1);
	-ms-transition: all 0.3s cubic-bezier(1, .01, .32, 1);
	transition: all 0.3s cubic-bezier(1, .01, .32, 1);
}

#map {
	height: 400px;
	width: 500px;
}
/* Optional: Makes the sample page fill the window. */
#infowindow-content .title {
	font-weight: bold;
}

#infowindow-content {
	display: none;
}

#map #infowindow-content {
	display: inline;
}

.domain {
vertical-align: middle;
text-align:center;

  float:left;

}

.domain2 {
vertical-align: middle;
}

</style>
</head>
<body>

	<jsp:include page="../Header.jsp"></jsp:include>
	<jsp:include page="../Nav.jsp"></jsp:include>


	<div class="row">


		<div class="col-xs-12">

			<div class="col-xs-2"></div>
			<div class="col-xs-8">
				<li>조회수 : ${post.hits}
				<li>작성일자 : ${post.wd}</li>
				<li>글내용</li> ${post.contents}
				
				
				
			
			</div>

			<div class="col-xs-2">
			<c:if test="${id eq post.id}">
			<button onclick="modifyPost('${post.bnum}')">수정</button>
			<button onclick="deletePost('${post.bnum}')">삭제</button>
			</c:if>
			<button onclick="reportPost('${post.bnum}','${post.id}')">신고하기</button>
			</div>
		</div>
	</div>


	<div class="row">
		<div class="col-xs-12">
		
			<div id="wrapper">
				<div id="slider-wrap">
					<ul id="slider">
						<c:forEach var="picList" items="${postPic}">
							<li><img
								src="${pageContext.request.contextPath}/resources/fileUpload/${picList.filename}"
								style="width: 600px"></li>
						</c:forEach>
					</ul>
					<!--controls-->
					<div class="btns" id="next">
						<i class="fa fa-arrow-right"></i>
					</div>
					<div class="btns" id="previous">
						<i class="fa fa-arrow-left"></i>
					</div>
					<div id="counter"></div>
					<div id="pagination-wrap">
						<ul>
						</ul>
					</div>
					<!--controls-->
				</div>
			</div>
			
			<div class="domain2">
			
			<div class="domain">
					<a onclick="like(${post.bnum},'${id}')"><i class="fas fa-thumbs-up fa-2x" id="up"></i></a>
			</div>		
				<div class="domain">	
					<div id="like">0</div>
					</div>
					
					<div class="domain">			
		<a onclick="dislike(${post.bnum},'${id}')"><i class="fas fa-thumbs-down fa-2x" id="down"></i></a>			
	</div>
	
					<div class="domain">	
					<div id="dislike">0</div>
					<input type="hidden" value="${blnum}" id="blnum">
					</div>
	
	
	</div>

		</div>
	</div>
	




	<div id="selectComments"></div>

	<div id="selectCommentsPaging"></div>




</body>

<script>

var pos = 0;
var totalSlides = $('#slider-wrap ul li').length;
var sliderWidth = $('#slider-wrap').width();
$(document).ready(function(){
    $('#slider-wrap ul#slider').width(sliderWidth*totalSlides);
    $('#next').click(function(){
        slideRight();
    });
    $('#previous').click(function(){
        slideLeft();
    });
    var autoSlider = setInterval(slideRight, 3000);
    $.each($('#slider-wrap ul li'), function() { 
       var li = document.createElement('li');
       $('#pagination-wrap ul').append(li);    
    });
    countSlides();
    pagination();
    $('#slider-wrap').hover(
      function(){ $(this).addClass('active'); clearInterval(autoSlider); }, 
      function(){ $(this).removeClass('active'); autoSlider = setInterval(slideRight, 3000); }
    );
});
function slideLeft(){
    pos--;
    if(pos==-1){
    	pos = totalSlides-1; 
    }
    $('#slider-wrap ul#slider').css('left', -(sliderWidth*pos));    
    countSlides();
    pagination();
}
function slideRight(){
    pos++;
    if(pos==totalSlides){
    	pos = 0; 
    	}
    $('#slider-wrap ul#slider').css('left', -(sliderWidth*pos));   
    countSlides();
    pagination();
}
function countSlides(){
    $('#counter').html(pos+1 + ' / ' + totalSlides);
}
function pagination(){
    $('#pagination-wrap ul li').removeClass('active');
    $('#pagination-wrap ul li:eq('+pos+')').addClass('active');
}
</script>
</html>