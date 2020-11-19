<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
  <!-- iamport.payment.js -->
  <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<title>장바구니 셀렉트</title>

<script>

function deleteBasket(id){
	$.ajax({
		url:"deleteBasket",
		type:"post",
		data:"id="+id,
		datatype:"text",
		success:function(text){
		}, error:function(e){
			alert("에러 발생");
		}
	});	
}

function payment(){

	var id="${id}";
	var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
	var string_length = 15;
	var randomstring = '';
	for (var i=0; i<string_length; i++) {
	var rnum = Math.floor(Math.random() * chars.length);
	randomstring += chars.substring(rnum,rnum+1);
	}
	var td = document.querySelector(".woo");
	var dd = $(td).text();
	console.log(dd);
	if(dd == ""){
		alert("결제할 물품이 없습니다.");
	} else {
	$.ajax({
		url:"payment",
		type:"post",
		data:"id="+id,
		datatype:"json",
		success:function(data){
			var IMP = window.IMP;
			IMP.init('imp93140329');
			IMP.request_pay({
			pg: 'payco',
			pay_method: 'phone',
			merchant_uid: randomstring,
			name: data.info.id+"님의 결제",
			amount: data.info.resultSum,
			buyer_name: data.info.id
			}, function (rsp) {
			console.log(rsp);
			if (rsp.success) {
			var msg = '결제가 완료되었습니다.';
		    opener.location.reload();
			self.close();
			deleteBasket(id);
			} else {
			var msg = '결제에 실패하였습니다.';
			msg += '에러내용 : ' + rsp.error_msg;
			}
			alert(msg);
			});	
		}, error:function(e){
			alert("에러 발생");
		}
	});
	}
}

$(document).ready(function(){
	var id = "${id}";
	selectBasketSum(id);
});

function buyAllProduct(id){
}

function removeThatProduct(pnum,id){
	var decision = confirm("삭제하시겠습니까?");
	if(decision){
		$.ajax({
			url:"removeThatProduct",
			type:"post",
			data:"id="+id+"&pnum="+pnum,
			datatype:"text",
			aysnc:false,
			success:function(data){
				if(data)
					location.reload();
				else
					alert("삭제 중 에러 발생");
			}, error:function(e){
				alert("에러 발생");
			}
		});
	}
	else 
		return false;
}

function selectBasketSum(id){
	$.ajax({
		url:"selectBasketSum",
		type:"post",
		data:"id="+id,
		datatype:"json",
		aysnc:false,
		success:function(data){
			var html = "";
			html+="<h4>총 가격 : "+data+"</h4>";
			$("#sum").html(html);
			
		}, error:function(e){
			alert("에러 발생");
		}
	});
}

function changeAmount(pnum,id,amount,sum) {
	var changeAmount = $(".jin"+ pnum).val();
	if(changeAmount < 1) {
		alert("수량은 1 미만으로 설정할 수 없습니다.");
		return false;
	} else {
	$.ajax({
		url:"changeAmount",
		type:"post",
		data:"pnum="+pnum+"&id="+id+"&amount="+amount+"&sum="+sum+"&changeAmount="+changeAmount,
		datatype:"json",
		aysnc:false,
		success:function(data){
			selectBasketSum(id);
			var length = data.length;
			if(data == "")
				alert("변경 과정에서 에러 발생");
			else {
				for(var i=0; i<length; i++){
				$('.woo '+data[i].pnum).empty();
				var html="";
				html+="<h4>이름 : "+data[i].name+"</h4>";
				html+="<h4>수량 : <input type='number' class='jin"+data[i].pnum+"' value="+data[i].amount+" min='1' onchange='changeAmount("+data[i].pnum+",\""+data[i].id+"\","+data[i].amount+","+data[i].sum+")'></h4>";
				html+="<h4>총 가격 : "+data[i].sum+"</h4>";
				html+="<button onclick='removeThatProduct("+data[i].pnum+",\""+data[i].id+"\")'>삭제</button>";

				$(".woo"+data[i].pnum).html(html);
				}
			}
			var resultSum = "<h4>총 가격 :"+sum+"</h4>";
			$("#sum").empty();
			$("#sum").html(resultSum);
		}, error:function(e){
			alert("에러 발생");
		}
	});
	}
}
</script>
<style>


</style>
</head>
<body>

   <h2>${id}님의 장바구니</h2>
   <c:forEach items="${list}" var="li">
<div class="woo ${li.pnum}">
	<h4>이름 : ${li.name}</h4>
	<h4>수량 : <input type="number" class="jin${li.pnum}" value="${li.amount}" min="1" onchange="changeAmount(${li.pnum},'${li.id}',${li.amount},${li.sum})"></h4>
	<h4>총 가격 : ${li.sum}</h4>
	<button onclick="removeThatProduct(${li.pnum},'${li.id}')">삭제</button>	
</div>			
</c:forEach>   

<c:if test="${empty list}">
<h2>담긴 물품이 없습니다.</h2>
</c:if>



<div id="sum">
</div>
<div id="paymentResult">
</div>


  <button id="payment" onclick="payment()">결제하기</button>

</body>
</html>