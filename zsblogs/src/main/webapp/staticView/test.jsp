<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>本地接口测试工具</title>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
<script type="text/javascript">
	function addBody(opt){
		var k="",v="";
		if(opt){
			k=opt.k?opt.k:k;
			v=opt.v?opt.v:v;
		}
		var par=$('#http_body');
		var first=$('#div1');
		var len=par.children().length;
		first.after("<div id='div"+(len+1)+"'>Key:<input type=\"text\" value=\""+k+"\"/>Value:<input type=\"text\" value=\""+v+"\"/><input type=\"button\" value=\"删除参数\" onclick=\"removeChildren('div"+(len+1)+"')\"/></div>");  
	}
	function removeChildren(id){
		$("#"+id).remove();
	}
	function sendHttpPost(){
		var arr = new Object(); 						
		$('#http_body').children().each(function(i,n){
			var obj = $(n);
			var key=obj.children().eq(0).val();
			var value=obj.children().eq(1).val();
			arr[key+""]=value+"";
	    });
        console.log(JSON.stringify(arr));
        var urltmp=$('#urltmp').val();//后面的url
        var t=$("#method").val();
        var token=$("#token").val();
		$.ajax({
			url:"<%=path %>/"+urltmp,
			type:t,
			beforeSend: function(request) {
				request.setRequestHeader("token", token);
			},
			data:arr,
			success:function(data){
				console.log(data);
				$("#result").append("<P>"+JSON.stringify(data)+"</p>");
			}
		});
	}
	function clearResult(){
		$("#result").html("");
	}
</script>

本地测试接口<br/>
URL：只用写controller的url（开头不带/）<input id="urltmp" type="text"/>(写后面的部分,开头不要带/)
请求方式:
<select id="method">
	<option value="GET">GET</option>
	<option value="POST" selected="selected">POST</option>
	<option value="PUT">PUT</option>
	<option value="DELETE">DELETE</option>
</select>
token:<input type="text" id="token"/>
<input type="button" value="添加参数" onclick="addBody()" style="background-color: rgba(230, 255, 0, 0.33);"/>
<br>
<div id="http_body" style="border:1px solid rgba(4, 253, 4, 0.43);padding: 10px;">
	<div id="div1">Key:<input type="text"/>Value:<input type="text"/></div>
</div>
<script type="text/javascript">
function quartszStart(){
	$("#urltmp").val("api/quartsz/start");
	$("#method").val("GET");
}
function quartszPause(){
	$("#urltmp").val("api/quartsz/pause");
	$("#method").val("GET");
	addBody({k:"name",v:"hw_job"});
	addBody({k:"group",v:"hw_group"});
}
function resumeJob(){
	$("#urltmp").val("api/quartsz/resume");
	$("#method").val("GET");
	addBody({k:"name",v:"hw_job"});
	addBody({k:"group",v:"hw_group"});
}
function quartszShutdown(){
	$("#urltmp").val("api/quartsz/shutdown");
	$("#method").val("GET");
}
function show(){
	$("#urltmp").val("api/quartsz/show");
	$("#method").val("GET");
}
function transaction(){
	$("#urltmp").val("api/test/transaction");
	$("#method").val("POST");
}
</script>
<button onclick="quartszStart()">quartsz开启</button>
<button onclick="quartszPause()">quartsz暂停</button>
<button onclick="resumeJob()">quartsz暂停恢复</button>
<button onclick="quartszShutdown()">quartsz关闭</button>
<button onclick="show()">quartsz显示所有任务</button>
<button onclick="transaction()">aop测试(事务配置测试前置)</button>
<hr>
<input type="button" value="发送请求" onclick="sendHttpPost()"/>请在开发者模式的console中查看结果

<hr>
<input type="button" value="清除结果" onclick="clearResult()"/>
<div id="result">

</div>


</body>
</html>
