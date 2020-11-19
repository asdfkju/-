<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>Header 영역</title>

<script>

function selectBasket(id) {
	var popUrl = "selectBasket?id="+id;	
	var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;";
		window.open(popUrl,"",popOption);	
}


function goHome() {
	location.href="goHome";
}

function openModal2(modalname){
	  document.get
	  $("#modal").fadeIn(300);
	  $("."+modalname).fadeIn(300);
	}

function closeModal2() {
	$("#modal, .close").on('click',function(){
		$("#searchResult").empty();
		$("#searchResultPaging").empty();
		$("#modal").fadeOut(300);
	  $(".modal-con").fadeOut(300);
	});
}


function search() {
	var kind = $("#kind option:selected").val();
	console.log(kind);
    var contents = $("#searchContents").val();
    if (contents == "") {
    	alert("내용을 입력해주세요.");
    	return false;
    } else if(kind==""){
    	alert("분류를 선택해주세요.");
    	return false;
    } else {
    	$.ajax({
    		url:"search",
    		type:"post",
    		data:"kind="+kind+"&contents="+contents+"&page="+1,
    		datatype:"json",
            async:false,
            success:function(data) {
            	const a= "${session2}"; 
            	console.log(a);
            	var length = data.list.length;
            	var html = "";
    			if(length > 0) {
    				html+="<h3>검색 결과</h3>"
    				html+="<table class='type09'><thead><tr><th scope='cols'>글 번호</th><th scope='cols'>제목</th></thead>";
    				html+="<tbody>";
    				for(var i=0; i<length; i++) {
    					html+="<tr><th scope='row'>"+data.list[i].bnum+"</th><td><a onclick='goPost("+data.list[i].bnum+")'>"+data.list[i].title+"</a></td></tr>";
               			}
    		
     		        html+="</tbody></table>";
                 	}
    				
    			    else {
    				
    				html+="<h3>검색 결과가 없습니다.<h3>";
    				html+="<button onclick='back()'>돌아가기</button>"
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


                   
    			$("#searchResultPaging").html(page);
            	$("#searchResult").html(html)
            }, error:function(e) {
            	alert("에러 발생");
            }
    	});
}
}

function back() {
	$('#close').get(0).click();
}

function enterkey() {
    if (window.event.keyCode == 13) {
    	$('#search').get(0).click();
    }
}

function searchForm() {
	var popUrl = "searchForm";	
	var popOption = "width=450, height=650, resizable=no, scrollbars=no, status=no;";
		window.open(popUrl,"",popOption);
}


function goPost(bnum) {
	var id = "${id}";
	if(id == "") {
		alert("로그인 후 이용해주세요.")
		return false;
	} else {
		location.href="viewPost?bnum="+bnum;
	}
}

function openModal2(modalname){
	  document.get
	  $("#modal").fadeIn(300);
	  $("."+modalname).fadeIn(300);
	}

function closeModal2() {
	$("#modal, .close").on('click',function(){
	  $("#modal").fadeOut(300);
	  $(".modal-con").fadeOut(300);
	});
}
	

function signUp() {
	
	location.href="signUp";
}


function login(){
	var id=$("#hid").val();
	var password=$("#hpassword").val();
	var checkAutoLogin;
	if($("input:checkbox[id='checkAutoLogin']").is(":checked")){
		checkAutoLogin=true;
	}
	else{
		checkAutoLogin=false;
	}
	$.ajax({
		type : "POST",
		url : "login",
		data : "id=" + id + "&password="+password + "&checkAutoLogin="+ checkAutoLogin,
		dataType : "text",
		success : function(result) {
			console.log(result);
			if(result=="Success"){
				location.href="goHome";
		}
		else if(result=="Fail"){
			alert("아이디 또는 비밀번호가 맞지 않습니다.");
		}
		else if(result=="report"){
			alert("신고누적으로 10분동안 로그인이 불가능합니다.");
		}
		},
		error : function() {
			alert("로그인 중 에러 발생");
		}
	})
	
}

function enter(){
	//event.keyCode는 아스키코드를 기반함. 13번=enter
    if (window.event.keyCode == 13) {    	
    	document.getElementById("login").click();
   }
}
function autoLogin(){
	if($("input:checkbox[id='checkAutoLogin']").prop("checked")==true){
		$("input:checkbox[id='checkAutoLogin']").prop("checked", false);
	}
	else{
		$("input:checkbox[id='checkAutoLogin']").prop("checked", true);
	}
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




*{margin:0; padding:0;}
#modal{
  display:none;
  position:fixed; 
  width:100%; height:100%;
  top:0; left:0; 
  background:rgba(0,0,0,0.3);
}
.modal-con{
  display:none;
  position:fixed;
  top:50%; left:50%;
  transform: translate(-50%,-50%);
  max-width: 60%;
  min-height: 30%;
  background:#fff;
}
.modal-con .title{
  font-size:20px; 
  padding: 20px; 
  background : gold;
}
.modal-con .con{
  font-size:15px; line-height:1.3;
  padding: 30px;
}
.modal-con .close{
  display:block;
  position:absolute;
  width:30px; height:30px;
  border-radius:50%; 
  border: 3px solid #000;
  text-align:center; line-height: 30px;
  text-decoration:none;
  color:#000; font-size:20px; font-weight: bold;
  right:10px; top:10px;
}



<!---->

p,li {
    font-family: 'Jua', sans-serif;
}

.p1 {
    color: skyblue;
}

.p2 {
    font-size: 40px;
}
.mainNo {
    width: 100%;
    height: auto;
}




		body { font-family: Arial, Helvetica, sans-serif;}
		button{
			all: unset;
			background-color: pink;
			color: white;
			padding: 5px 10px;
			border-radius: 6px;
			cursor: pointer;
		}
		.modal{
			position: fixed;
			top: 0; left: 0;
			width: 100%; height: 100%;
			display: flex;
			justify-content: center;
			align-items : center;
		}
		.md_overlay {
			background-color: rgba(0, 0, 0, 0.6);
			width: 100%; height: 100%;
			position: absolute;
		}
		.md_content {
			width: 450px;
			height: 300px;
			position: relative;
			padding: 5px 5px;
			background-image:url('${pageContext.request.contextPath}/resources/img/노지선5.jpg');
			background-size: contain;
			border-radius: 6px;
			box-shadow: 0 10px 20px rgba(0,0,0,0.20), 0 6px 6px rgba(0, 0, 0, 0.20);
		}
		h1 {
			margin:0; 
			padding: 5px;
		}
		.hidden {
			display: none;
		}
		.modal_text { padding: 16px; }

</style>

</head>
<body>



<div class="mainPhoto">

<a onclick="goHome()"><img src="${pageContext.request.contextPath}/resources/img/노지선고화질3비율조정.jpg" class="mainNo"></a>
<div class="col-xs-12">
<div class="col-xs-5">
</div>
<div class="col-xs-2">
<a href="">
    <img style="width:200px; margin:auto; text-align:center; " src="${pageContext.request.contextPath}/resources/img/프로미스나인 팬카페.png">
</a>
</div>
<div class="col-xs-5">

<c:if test="${sessionScope.id ne null}">
      <li><i class="fas fa-dog"></i>${id}님 환영합니다!</li>
</c:if>

      <li><a href="javascript:openModal2('modal1');" class="button modal-open"><i class="fa fa-search"></i>검색하기</a></li>



  

<c:if test="${sessionScope.id ne null}">
      <li><a href="goMyPage"><span class="glyphicon glyphicon-user"></span>마이페이지</a></li>      
      <li><a href="logout"><span class="glyphicon glyphicon-log-in"></span>로그아웃</a></li>
            <li><a href="goShop"><span class="glyphicon glyphicon-log-in"></span>상점 가기</a></li>
            <li><a onclick="selectBasket('${id}')"><span class="glyphicon glyphicon-log-in"></span>장바구니 보기</a></li>
      <input type="hidden"id="open">
</c:if>


<c:if test="${sessionScope.id eq null}">
      <li><a id="open"><span class="glyphicon glyphicon-log-in"></span> 로그인</a></li>
      <li><a onclick="signUp()" id="signUpForm"><span class="glyphicon glyphicon-user"></span> 회원가입</a></li>
      <li><a onclick="searchForm()" id="searchForm"><span class="glyphicon glyphicon-user"></span> 아이디 or 비번 찾기</a></li>
      
</c:if>
      
</div>
</div>
</div>


<div id="modal"></div>
  <div class="modal-con modal1">
    <a href="javascript:closeModal2();" class="close" id="close">X</a>
    <p class="title">검색하기</p>
    <div class="con">
<select name="kind" id="kind">
    <option value="">분류</option>
    <option value="제목">제목</option>
    <option value="내용">내용</option>
    <option value="제목내용">제목+내용</option>
</select>
    <input type="text" id="searchContents" onkeyup="enterkey();"> <button onclick="search()" id="search">검색</button>    
    
    <div id="searchResult">
    
    </div>
    <div id="searchResultPaging">
    </div>
    </div>
  </div>
  
  

	<div class="modal hidden">
		<div class="md_overlay"></div>
		<div class="md_content">
		<br>
            <button>X</button>
			<h1 style="color:pink;">로그인</h1>			
			<br><br>
			<div class="input-group">
			<span class="input-group-addon" style="width:100px;"><i class="glyphicon glyphicon-user">아이디</i></span>
			<input type="text" id="hid" class="form-control" placeholder="아이디" style="width:200px;">
			</div>
<br>
  <div class="input-group">
<span class="input-group-addon" style="width:100px;"><i class="glyphicon glyphicon-lock">비밀번호</i></span>
<input type="password" id="hpassword" onkeyup="enter()" class="form-control" placeholder="비밀번호">
</div>
<br>




<label id="container"><a onclick="autoLogin()" style="color:black;" href="#"><b style="color:white">자동로그인</b></a>
  <input type="checkbox" id="checkAutoLogin">
  <span class="checkmark"></span>
  <button id="login" style="color:white; backgroundcolor:'pink';" onclick="login()">로그인</button>
  
</label>
			</div>
		</div>
	

	<script>
	//동작함수를 사용해서 먼저 웹사이트에서 모달창을안보이게 설정해놓고, 이벤트리스너로 클릭이벤트를 설정해준다.
		//필요한 엘리먼트들을 선택한다.
		const openButton = document.getElementById("open");
		const modal = document.querySelector(".modal");
//		const overlay = modal.querySelector(".md_overlay");
		const closeButton = modal.querySelector("button");
		//동작함수
		const openModal = () => {
			modal.classList.remove("hidden");
			// 해설:<a id="open">에 함수 적용 =>class="modal hidden"에서 hidden을 지움
			// 위에 css에서 modal hidden은 display:none; 해놓은 상태임. 
			// 그러면 1번에서 hidden이 지워지니까 모달창이 나오겠지?
		}
		const closeModal = () => {
			modal.classList.add("hidden");
		}
		//클릭 이벤트
		openButton.addEventListener("click", openModal);
		closeButton.addEventListener("click", closeModal);
	
	</script>
	
	
	<script>
window.onclick = function(e){
	const searchModal = document.getElementById("modal-con modal1");
	//모달 바깥창 누르면 닫히게 
	if(e.target == searchModal) {
		searchModal.style.visibility = "hidden";
		searchModal.style.opacity = 0;
	}
}
</script>
</body>
</html>
