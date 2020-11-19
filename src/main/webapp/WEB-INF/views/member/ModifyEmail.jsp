<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>ModifyEmail 영역</title>

<script>
function sendVerifyCode() {
	var emailid = document.getElementById("emailid").value;
	var emaildomain = document.getElementById("emaildomain").value;
	var email = emailid + "@" + emaildomain;
	if (emailid == "" || emaildomain == "") {
		alert("이메일 주소를 입력하세요");
		$("#emailid").focus();
	} else {
	$.ajax({
		url:"sendCodeToModify",
		type:"post",
		data:"email="+email,
		datatype:"json",
		success:function(data){
			var code = data.code;
			var html="";
			html+="발송된 코드번호를 입력해주세요.";
			html+="<input type='text' id='value'>";
			html+="<input type='hidden' id='code' value='"+code+"'>";
			html+="<input type='hidden' id='time' value='yes'>";
			html+="<button onclick='emailUpdate()'>입력</button>";			
			$("#input").html(html);
		}, error:function(e){
			alert("에러 발생");
		}
	});
	}
}
function domainselect() {
	var email = document.getElementById("domainvalue").value;
	document.getElementById("emaildomain").value = email;
}
function emailUpdate(){
	var emailid = $("#emailid").val();
	var emaildomain = $("#emaildomain").val();
	var certify = $("#certify").val();
	$("#email").val(emailid + "@" + emaildomain);
	var email = $("#email").val();
	var code = $("#code").val();
	var value = $("#value").val();
	var id = "${id}";
	if(code == value)
		$.ajax({
			type : 'POST',
			url : 'emailUpdate',
			data : "email="+email+"&id="+id,
			success : function(data) {
				if (data == "yes") {
					alert("이메일 수정이 완료되었습니다.");
					window.close();
					opener.location.reload();
				} else {
					alert("no 나와서 수정 실패");
				}
			},
			error : function() {
				alert("에러 발생");
			}
		});
	}

</script>
</head>
<body>

		<div class="col-xs-3">
		</div>
		<div class="col-xs-9">
				이메일 주소 변경<br>
		  <input type="text" id="emailid"> @ <input type="text" id="emaildomain"> 
		  <select onchange="domainselect()" id="domainvalue">
			<option value="">직접입력</option>
			<option value="naver.com">네이버</option>
			<option value="hanmail.net">한메일</option>
			<option value="gmail.com">구글</option>
		</select><br>
		<button class="btn btn-info" type="button" onclick="sendVerifyCode()">이메일 인증하기</button><br><br>
		<input type="hidden" value="인증안됨" id="certify"> 
		<input type="hidden" id="email" name="email"> 
		</div>
	
	<div id="input">	
	</div>


</body>
</html>