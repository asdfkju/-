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
<title>상품 등록 페이지</title>
<script>
function readURL(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function(e) {
			$('#picPreview').attr('src', e.target.result);
		}
		reader.readAsDataURL(input.files[0]);
	}
}

function registerProduct(){
	var name = $("#name").val();
	var price = $("#price").val();
	var contents = $("#contents").val();
	var amount = $("#amount").val();
	if(name == "") {
		alert("상품 이름을 설정하세요.");
		$("#name").focus();
	} else if(price == ""){
		alert("가격을 설정하세요.");
		$("#price").focus();
	} else if(contents == "") {
		alert("설명을 설정하세요.");
		$("#contents").focus();
	} else if(amount == ""){
	    alert("수령을 설정하세요.");
	    $("#amount").focus();
	} else {
		var formData = new FormData(document.getElementById("pform")); // 
		$.ajax({
			url:"registerProduct",
			type:"post",
			data:formData,
			dataType:"text",
			contentType: false,
			processData: false,
			success:function(text){
				console.log(text);
				if(text == "yes"){
					alert("물건 등록 성공");
        			self.close();		                		
				} else {
					alert("물건 등록 중 에러 발생");
				}
			}, error:function(e){
				alert("에러 발생");
			}
		});
	}
}
</script>

<style>


#picPreview{
height:200px;
weigh:200px;
}
</style>
</head>
<body>

<form class="modal-content" id="pform" enctype="multipart/form-data">
    <div class="container02">
      <hr>
      <label for="name"><p>물건 이름</p></label>
      <input type="text" name="name" id="name">

      <label for="price"><p>가격</p></label>
      <input type="text" name="price" id="price">

      <label for="contents"><p>설명</p></label>
      <input type="text" name="contents" id="contents">

      <label for="contents"><p>수량</p></label>
      <input type="number" name="amount" id="amount">

   
      <br>   
      <br/>		
		<label for="picPreview">물건 사진 설정</label>			
			<img id="picPreview" src="#" alt="your image"
				onError="this.src='${pageContext.request.contextPath}/resources/img/default.webp'" />
			<br>
			<br>
			<input type="file" name="pic" id="pic" onchange="readURL(this);">
			
</div>

</form>		
	
  		<button onclick="registerProduct()"><p>등록하기</p></button>
 


</body>
</html>