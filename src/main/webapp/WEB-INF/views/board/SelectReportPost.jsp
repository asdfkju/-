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
<title>SelectReportPost 영역</title>
 
 
<script>

function acceptReport() {
	var accept = '${report.acceptreport}';
	console.log(accept);
	var repnum = $("#repnum").val();
	if(accept == "y") {
		alert("이미 신고 접수 된 글입니다.");
		window.close();
	} else {
		$.ajax({
			url:"acceptReport",
			type:"post",
			data:"repnum="+repnum,
			datatype:"json",
			async:"false",
			success:function(result){
					alert("정상적으로 처리되었습니다.");
					window.close();
					opener.location.reload();
			}, error:function(e){
				alert("에러 발생");
			}
		});
	}
}

</script>   
    
<style>
p, h1, button{border:0; margin:0; padding:0;}
.spacer{clear:both; height:1px;}
.myform{
	margin:10px;
	width:400px;
	height:600px;
	padding:10px;
}

#stylized{
	border:solid 2px #b7ddf2;
	background:#ebf4fb;
}
#stylized h1 {
	font-size:16px;
	font-weight:bold;
	margin-bottom:8px;
	font-family:nanumgothic,dotum;

}
#stylized p{
	font-size:11px;
	color:#666666;
	margin-bottom:20px;
	border-bottom:solid 1px #b7ddf2;
	padding-bottom:10px;
	font-family:dotum;
}
#stylized label{
	display:block;
	font-weight:bold;
	text-align:right;
	width:20px;
	float:left;
	font-family:tahoma;
}
#stylized .small{
	color:#666666;
	display:block;
	font-size:18px;
	font-weight:normal;
	text-align:right;
	width:100px;
	font-family:dotum;
	letter-spacing:-1px;
}
#stylized input{
float:left;
font-size:12px;
padding:4px 2px;
border:solid 1px #aacfe4;
width:200px;
margin:2px 0 20px 10px;
}
#stylized button{
clear:both;
margin-left:150px;
width:125px;
height:31px;
text-align:center;
line-height:31px;
background-color:#000;
color:#FFFFFF;
font-size:11px;
font-weight:bold;
font-family:tahoma;
}
</style>
</head>
<body>

<div id="stylized" class="myform">
<br>
<h3>신고글</h3>
<br>
<label class="small" for="title">제목 :</label> <input type="text" name="title" id="title" value="${report.title}"readonly/>
<label class="small" for="title">신고자 아이디 :</label> <input type="text" name="id" id="id" value="${report.id}"readonly/>
<p><textarea cols="50" rows="20" name="contents" id="contents">${report.contents}</textarea></p>
<div class="spacer"></div>
        <input type="hidden" value="${report.repnum}" name="repnum" id="repnum">
                    <span id="span"></span>         
                    <button onclick="acceptReport()">신고글 접수</button> 
</div>

</body>
</html>