<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>SignUp 영역</title>

<script>


    function idOverlapCheck() {
	    var id = document.getElementById("id").value;
	    $.ajax({
		    type:"get",
		    url:"checkId",
		    data:"id="+id,
		    dataType:"text",
		    async:"false",
		    success:function(result) {
		    	console.log(result);
			if(result.match(true)) {
				$("#checkId").html("사용가능한 아이디 입니다.")
				$("#checkIdResult").val("사용가능한 아이디 입니다.");
			} else {
				$("#checkId").html("중복되는 아이디가 있습니다.");
				$("#checkIdResult").val("중복되는 아이디가 있습니다.");
			}
		},
		error:function() {
			alert("에러 발생");
		}
	 });
	}
    
	function passwordCheck() {
		var password = $("#password").val();
		console.log(password);
		var confirmPassword = $("#confirmPassword").val();
		var passwordReg = /^[0-9a-z]+$/;
		if (!password.match(passwordReg)) {
			$('#comparePassword').css("color", "red");
			$('#comparePassword').html("비밀번호 사용불가");
		} else {
			$('#comparePassword').css("color", "black");
			$('#comparePassword').html("비밀번호 사용가능");
			if (password == confirmPassword) {
				$('#comparePassword').css("color", "black");
				$('#comparePassword').html("비밀번호 일치");
				$('#comparePasswordResult').val("허가");
			} else {
				$('#comparePassword').css("color", "red");
				$('#comparePassword').html("비밀번호 불일치");
				$('#comparePasswordResult').val("불허가");
			}
		}
	}
	
	function sendVerifyCode() {
		var check = $("#checkEmailResult").val();
		console.log(check);
		if(check == "중복된 이메일") {
			alert("중복된 이메일입니다.");
		} else {
			var emailid = document.getElementById("emailid").value;
			var emaildomain = document.getElementById("emaildomain").value;
			var email = emailid + "@" + emaildomain;
			var url = "sendCode?email=" + email;
			window.open(url, 'pop01',
					'width=500, height=500, status=no, menubar=no, toolbar=no');
		}
	}
	
    function selectedEmailDomain() {
	    var domain = $("#domainvalue").val();
	    console.log(domain);
	    $("#emaildomain").val(domain);
    }

	function checkIMG() {
		var imgfile = document.getElementById("pic").value;
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
    
	function readURL(input) {
		if (input.files && input.files[0]) {
			var reader = new FileReader();
			reader.onload = function(e) {
				$('#picPreview').attr('src', e.target.result);
			}
			reader.readAsDataURL(input.files[0]);
		}
	}
	
	function signUp2() {
		var id = $("#id").val();
		var password = $("#password").val();
		var confirmPassword = $("#confirmPassword").val();
		var name = $("#name").val();
		var checkIdResult = $("#checkIdResult").val();
		var emailid = $("#emailid").val();
		var emaildomain = $("#emaildomain").val();
		var idreg = /^(?=.*[a-z])[A-Za-z\d]{5,20}$/;
		var pwreg = /^(?=.*[a-z])(?=.*\d)[a-zA-Z\d$@$!%*#?&]{8,16}$/;
		var certify = $("#certify").val();
		$("#email").val(emailid + "@" + emaildomain);
		var email = $("#email").val();
		
		if (id == "") {
			alert("아이디를 입력하세요");
			$("#id").focus();
		}
		else if(password == "") {
				alert("비밀번호를 입력하세요");
				$("#password").focus();
			}
			else if (confirmPassword == "") {
				alert("비밀 번호 확인을 해야합니다.");
				$("#confirmPassword").focus();
			} else if (password != confirmPassword) {
				alert("입력하신 비밀번호가 서로 같지 않습니다.");
				$("#confirmPassword").val("");
				$("#confirmPassword").focus();
			}
			else if (id.match(idreg) && !password.match(pwreg)) {
				alert("유효하지 않은 비밀번호입니다.");
				$("#password").val("");
				$("#confirmPassword").val("");
				$("#comparePasswordResult").html("");
				$("#password").focus();
			}
		 else if (name == "") {
			alert("이름을 입력하세요");
			$("#name").focus();
		} else if (emailid == "" || emaildomain == "") {
			alert("이메일 주소를 입력하세요");
			$("#emailid").focus();
		} else if (checkIdResult == "중복된 아이디") {
			alert("중복된 아이디입니다.");
		} else if (!id.match(idreg) && password.match(pwreg)) {
			alert("유효하지 않은 아이디입니다.");
			$("#id").val("");
			$("#checkId").html("");
			$("#checkIdResult").val("");
			$("#id").focus();
		} else if (certify == "인증안됨") {
			alert("이메일 인증이 완료되지 않았습니다.");
		} else if (checkEmailResult == "중복된 이메일") {
			alert("입력하신 이메일 주소는 이미 사용중입니다.");
			$("#emailid").val("");
			$("#emaildomain").val("");
			$("#emailid").focus();
		} else if (checkIMG()) {
				if (id.match(idreg) && password.match(pwreg)) {
					var formData = new FormData(document.getElementById("form")); // 
					$.ajax({
						type : 'POST',
						url : 'createMember',
						processData : false, // 필수 
						contentType : false, // 필수 
						data : formData,
						datatype:"text",
						success : function(data) {
							if (data == "Success") {
								alert("회원가입 완료");
								location.href = "goHome";
							} else {
								alert("회원가입 실패");
							}
						},
						error : function() {
							alert("실패");
						}
					});
				}
		}
	}
	
function checkEmail(){
	var emailid = $("#emailid").val();	
	var emaildomain = $("#emaildomain").val();
	$("#email").val(emailid + "@" + emaildomain);
	var email = $("#email").val();
	$.ajax({
		type : "POST",
		url : "checkEmail",
		data : "email=" + email,
		dataType : "text",
		success : function(result) {
			console.log(result);
			if (result.match(true)) {
				$("#checkEmailResult").val("중복된 이메일");
			} else {
				$("#checkEmailResult").val("중복되지 않은 이메일");
			}
		},
		error : function() {
			alert("에러 발생");
		}

	});
}	
	

</script>

<style>


#picPreview {
	width: 100px;
	height: 100px;
}

p,li {
    font-family: 'Jua', sans-serif;
}

.p1 {
    color: skyblue;
}

.p2 {
    font-size: 40px;
}

.modal {
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  padding-top: 50px;
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 5% auto 15% auto; /* 5% from the top, 15% from the bottom and centered */
  border: 1px solid #888;
  width: 40%; /* Could be more or less, depending on screen size */
}
.container02 {
  padding: 16px;
}


body {font-family: Arial, Helvetica, sans-serif;}

/* Full-width input fields */
input[type=text], input[type=password],
input[type=date] {
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  display: inline-block;
  border: none;
  background: #f1f1f1;
}
/*텍스트,비번창,데이트창 눌렀을때 밑에 효과를 줘라*/
input[type=text]:focus, input[type=password]:focus,
input[type=date]:focus {
  background-color: #ddd;
  outline: none;
}

/* Set a style for all buttons */
button {
  background-color: skyblue;
  color: white;
  padding: 14px 14px 14px 14px;
  border :cornflowerblue;
  cursor: pointer;
  width: auto;
  opacity: 0.9;
}

button:hover {
  opacity:1;
}

</style>

</head>
<body>



<jsp:include page="Header.jsp"></jsp:include>
<jsp:include page="Nav.jsp"></jsp:include>


<form class="modal-content" id="form" enctype="multipart/form-data">
    <div class="container02">
      <p class="p2">회원가입</p>  
      <p>아래 사항을 기재해주세요.</p>

      <hr>

      <label for="id"><p>아이디</p></label>
      <input type="text" onkeyup="idOverlapCheck()" placeholder="아이디" name="id" id="id">
      <span id="checkId"></span><br>       
      <input type="hidden" name="checkIdResult">

      <label for="password"><p>비밀번호</p></label>
      <input type="password" placeholder="비밀번호" name="password" id="password" onchange="passwordCheck()">

      <label for="confirmPassword"><p>비밀번호 확인</p></label>
      <input type="password" placeholder="비밀번호 확인" name="confirmPassword" id="confirmPassword" onchange="passwordCheck()">
      <span id="comparePassword"></span>
      <input type="hidden" id="comparePasswordResult">
      
      <br>
      <label for="name"><p>이름</p></label>
      <input type="text" placeholder="이름" name="name">
   
      <br/>


      <label for="email"><p>이메일</p></label>
      			<input class="form-control" type="text" id="emailid">@
      			<input class="form-control" type="text" id="emaildomain" onkeyup="checkEmail()">
		<select onchange="selectedEmailDomain()" id="domainvalue">
			<option value="">직접입력</option>
			<option value="naver.com">네이버</option>
			<option value="hanmail.net">한메일</option>
			<option value="gmail.com">구글</option>
		</select>
		
		
		<input type="hidden" value="인증안됨" id="certify"> 
		<input type="hidden" id="email" name="email"> 
		<input type="hidden" id="checkEmailResult"> 
		<br><br>
		<button type="button" class="btn btn-success" onclick="sendVerifyCode()">이메일 인증하기</button><br><br>
		
		
		<label for="picPreview">프로필 사진 설정</label>
			
			<img id="picPreview" src="#" alt="your image"
				onError="this.src='${pageContext.request.contextPath}/resources/img/default.webp'" />
			<br>
			<br>
			<input type="file" name="pic" id="pic" onchange="readURL(this);">
			
		<input type="hidden" id="kind" name="kind" value="회원">
</div></form>		
	
  		<button onclick="signUp2()"><p>가입하기</p></button>
  
		

</body>
</html>