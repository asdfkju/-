<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.4.1.js"
    integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
    crossorigin="anonymous">
    </script>
<title>Insert title here</title>

<script>
function certify(bnum){
	var rstr = "${temp}";
    var code=document.getElementById("code").value;
       if(rstr == code){
    	   $.ajax({
    		  url:"deletePost",
    		  type:"POST",
    		  data:"bnum="+bnum,
    		  dataType:"text",
              async:false,
    		  success:function(result){
    			  if(result == true){
    					alert("성공");
    					location.href="goHome";
    					window.close();
    			  } else {
    				  alert("에러 발생");
    			  }    			  
    		  }, error:function(e){
    			  alert("에러 발생");
    		  }
    	   });
       } else {
    	   alert("입력한 값이 맞지 않습니다.");
       }
}
</script>
</head>
<body>
보이는 문자를 입력해주세요.
${temp}
<input type="text" name="code" id="code">
<button onclick="certify('+${bnum}+')">입력</button>


</body>
</html>