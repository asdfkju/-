<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
    <script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous">
    </script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <link href="https://fonts.googleapis.com/css?family=Jua&display=swap" rel="stylesheet">

<title>MIForm 영역</title>
<script>
function checkIMG() {
	var imgfile = document.getElementById("mfile").value;
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

function passwordCheck() {	
		var password = $("#mpassword").val();
		var confirmPassword = $("#confirmPassword").val();
		var pwreg = /^(?=.*[a-z])(?=.*\d)[a-zA-Z\d$@$!%*#?&]{8,16}$/;


		if (!password.match(pwreg)) {
			$('#pw_text').css("color", "red");
			$('#pw_text').html("비밀번호 사용불가");
		} else {
			$('#pw_text').css("color", "black");
			$('#pw_text').html("비밀번호 사용가능");
			if (password == confirmPassword) {
				$('#pwCheck_text').css("color", "black");
				$('#pwCheck_text').html("비밀번호 일치");
				$("#comparePasswordResult").val("yes");
			} else {
				$('#pwCheck_text').css("color", "red");
				$('#pwCheck_text').html("비밀번호 불일치");
			}
		}
	}


function modifyMI() {	

	var comparePW = $("#comparePasswordResult").val();
    console.log(comparePW);
    var memberPW = "${member.password}";
    var pw = $("#mpassword").val();
    var oriSrc = "${pageContext.request.contextPath}/resources/fileUpload/${member.imgoriname}";
	var src = jQuery('#picPreview').attr("src");
	var id="${id}";
    if(pw == memberPW) {
    	if(oriSrc == src){
    		alert("원래의 비밀번호로 변경할 수 없습니다.");
    		return false;
    	} else {  		
    		checkIMG();
    		if(true) {
    		    var formData = new FormData(document.getElementById("mmform"));
    		    formData.append("id", id);
    		    formData.append("nopic","nopic");
    		    $.ajax({
    				url:"modifyMI",
    				type:"post",
    				data:formData,
    				dataType:"text",
    				async:"false",
					processData : false,
					contentType : false,
    				success:function(result){
    					if(result=="yes"){
    						alert("수정 완료");
    						location.href="goHome";
    					} else {
    						alert("no 나와서 수정 불가");
    					}
    				}, error:function(e){
    					alert("에러 발생");
    				}
    			});
    		}
    	}
    } else if(comparePW == "yes") {
    	checkIMG();
    	if(true) {
		    var formData = new FormData(document.getElementById("mmform"));
		    formData.append("id", id);		    
		    formData.append("nopic", "yes");
			$.ajax({
				url:"modifyMI",
				type:"post",
				data:formData,
				dataType:"text",
				async:"false",
				processData : false, 
				contentType : false,
				success:function(result){
					if(result=="yes"){
						alert("수정 완료");
						location.href="goHome";
					} else {
						alert("no 나와서 수정 불가");
					}
				}, error:function(e){
					alert("에러 발생");
				}
			});
    	}
    }
	
}

</script>
<style>
		
		#picPreview {
	width: 100px;
	height: 100px;
}
</style>


</head>
<body>
<jsp:include page="../Header.jsp"></jsp:include>
<jsp:include page="../Nav.jsp"></jsp:include>


<div class="col-xs-12">

<div class="col-xs-2">
</div>

<div class="col-xs-8">

<div id="miForm">

<form class="modal-content" id="mmform" enctype="multipart/form-data">
    <div class="container02">
      <hr>

      <label for="id"><p>아이디</p></label>
      <input type="text" placeholder="${member.id}" readonly>
      
      <br>
      <label for="password"><p>비밀번호</p></label>
      <input type="password" placeholder="비밀번호" name="mpassword" id="mpassword" onchange="passwordCheck()" value="${member.password}">
      <span id="pw_text"></span>
      <br>
      <label for="confirmPassword"><p>비밀번호 확인</p></label>
      <input type="password" placeholder="비밀번호 확인" name="confirmPassword" id="confirmPassword" onchange="passwordCheck()">
      <span id="pwCheck_text"></span>
      <input type="hidden" id="comparePasswordResult" value="no">      
      <br>
      <label for="name"><p>이름</p></label>
      <input type="text" placeholder="${member.name}" readonly>
   
      <br/>
		</div>		
		<label for="picPreview">프로필 사진 설정</label>	
					<img id="picPreview" src="${pageContext.request.contextPath}/resources/fileUpload/${member.imgoriname}" alt="your image"
				onError="this.src='${pageContext.request.contextPath}/resources/img/default.webp'" />
			<br>
			<br>
			<input type="file" name="mfile" id="mfile" onchange="readURL(this);">
</form>
			<button onclick="modifyMI()"><p>수정하기</p></button>
			<button onclick="back()"><p>돌아가기</p></button>

		</div></div>

</div>
<div class="col-xs-2"></div>



<script>

function back() {
	history.back();
	}
</script>
</body>
</html>