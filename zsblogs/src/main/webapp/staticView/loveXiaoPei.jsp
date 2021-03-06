<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <base href="<%=basePath%>">
    <title>《小佩走进我的生活》</title>
    <script type="text/javascript">
    var zs="zs",xp="xp";
    var isAni=true;//动画是否播放的标志
    var dd,now;
    var str="对方正在输入";
   	var timeID;
   	
    $(function(){
    	$('#myModal').window('close');
    	init();
    });
    
    function init(){
    	$.ajax({
    		url:"${path}/api/loveXiaoPei/init",
    		async:false,
    		success:function(data){
    			dd=data;
    			openMessage(data);
    		}
    	});
    }
    function selectById(start,id){
    	if (start.id==id) {
    		now=start;
			return;
		}else{
			if(start.child){
				$.each(start.child,function(i,item){
					selectById(item,id)
				});
			}else{
		    	return;
			}
		}
    }
    
    function next(id){
    	selectById(dd,id);
    	if(now){
	    	openMessage(now);
    	}
    }
    
    function openMessage(option){
    	isAni=true;
    	var isWorkXp=false;
    	if(option.author=="zs" && (option.child && option.child.length>0 && option.child[0].author=="xp") ){
	    	$("#message-mod").html(option.message);
	    	if(option.child){
	    		var str="<div style=\"text-align:left;\">";
	    		$.each(option.child,function(i,item){
	    			str=str+"<button class=\"button\" onclick='next("+item.id+")'>"+item.message+"</button><br>";
	    		});
	    		str=str+"</div>"
	    		$('#xuanxiang').html(str);
	    	}
	    	//延迟开启窗口
	    	setTimeout(function(){
	    		//先关闭动画
	    		isAni=false;
	    		//再做别的事
		    	$('#myModal').window('open');
		    	addContent(option);
	    	},option.delay);
    	}else{
    		if (option.child && option.child.length>0) {
    			isWorkXp=true;
			}
    		$("#message-mod").html("");
    		$('#xuanxiang').html("<button class=\"button\" iconCls=\"icon-cancel\" onclick=\"javascript:$('#myModal').dialog('close')\">关闭</button>");
    		$('#myModal').window('close');
    		
    		if(option.author!="xp"){
	    		//延迟开启窗口
		    	setTimeout(function(){
		    		//先关闭动画
		    		isAni=false;
		    		//再做别的事
			    	addContent(option);
		    		
			    	if (isWorkXp==true) {
			    		next(option.child[0].id);
					}
		    	},option.delay);
			}else{
				//先关闭动画
	    		isAni=false;
	    		//再做别的事
		    	addContent(option);
		    	if (isWorkXp==true) {
		    		next(option.child[0].id);
				}
			}
    	}
    	
    	//这里写动画效果
    	if(option.author!='xt'){
	   		animateStart(option);
    	}else{
    		//先关闭动画
    		isAni=false;
    	}
		
    	return option.message;
    }
    function addContent(option){
    	var img="";
    	if (option.author=="zs") {
    		img="<img alt=\"张顺\" src=\"${path }/framework/image/love/zs.jpg\" width=\"30\" height=\"30\" style=\"float:left\">"
	    	$("#daPingMu").append("<div class='zhangshun'>"+img+"<span class='bubble color_zs'>"+option.message+"</span></div><div style=\"clear:both;\"></div>");
		}else if(option.author=="xp"){
			img="<img alt=\"小佩\" src=\"${path }/framework/image/love/xiaopei.jpg\" width=\"30\" height=\"30\" style=\"float:right\">"
			$("#daPingMu").append("<div class='xiaopei'>"+img+"<span class='bubble color_xp'>"+option.message+"</span></div><div style=\"clear:both;\"></div>");
		}else if(option.author=="xt"){
			$("#daPingMu").append("<div class='xt'>"+option.message+"</div>");
		}
    	scrollToBottom();
    	//这里判断是否获得了结局
    	if(option.author=="xt" && option.message.indexOf("小佩，恭喜你达成了")>=0 && option.message.indexOf("结局")>=0){
    		saveResult();
    	}
    }
   	
    function animateStart(option){
    	if(timeID){
    		clearTimeout(timeID);
    	}
    	if (isAni==true) {
    		timeID=setTimeout(function(){
    			str=str+".";
    			if (str=="对方正在输入.......") {
    				str="对方正在输入";
				}
    			$("#title").html(str);
    			animateStart();
    		},300);
		}else{
			$("#title").html("");
			str="对方正在输入";//先初始化动画一下
		}
    }
    //滚动条滚动到底部
    function scrollToBottom(){
    	var div = document.getElementById('daPingMu');
    	div.scrollTop = div.scrollHeight;
    }
    //保存结果
    function saveResult(){
    	var a=$("#daPingMu").html();
    	console.log(a);
    	$.ajax({
    		url:"${path}/api/loveXiaoPei/result/save",
    		type:"POST",
    		async:false,
    		data:{jieju:a},
    		success:function(data){
    			console.log(data);
    		}
    	});
    }
    </script>
    <style type="text/css">
    #title_1{
    	padding: 7px;
    	background-color: rgb(211, 126, 0);
    	color: white;
    }
    #daPingMu{
    	padding: 4px;
    }
    .zhangshun{
    	text-align: left;
    }
    .xiaopei{
    	text-align: right;
    }
    .bubble{
    	margin-top:7px;
	    border: 1px solid black;
	    border-radius: 7px;
	    padding: 3px;
	}
	.color_zs{
		margin-left:3px;
		float:left;
		background-color: white;
	}
	.color_xp{
		margin-right:3px;
		float:right;
		background-color: #B0DD42;
	}
	
	.button {
	  display: inline-block;
	  padding: 3px 7px;
	  font-size: 12px;
	  cursor: pointer;
	  text-align: center;   
	  text-decoration: none;
	  outline: none;
	  color: #fff;
	  background-color: #4CAF50;
	  border: none;
	  border-radius: 4px;
	  box-shadow: 0 2px #999;
	  margin-top: 2px;
	  margin-bottom: 2px;
	}
	
	.button:hover {background-color: #3e8e41}
	
	.button:active {
	  background-color: #3e8e41;
	  box-shadow: 0 0px #666;
	  transform: translateY(2px);
	}
	
	.hint{
		margin-left: 20px;
	}
	.xt{
		text-align: center;
		padding: 10px;
	}
    </style>
  </head>
  
  <body style="margin: 0px;padding: 0px;">
  	<div style="background-color: #FDF2D4;height: 100%;">
  		<div id="title_1">
  			张顺<span id="title" class="hint"></span>
  		</div>
  		<!-- <button class="button" onclick="init()">开始</button> -->
  		<div id="daPingMu" style="width: 100%;height: 80%;overflow-y: scroll;">
  		
  		</div>
  		
  	</div>
  
	
	<div id="xuanxiang">
		<button class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#myModal').dialog('close')">关闭</button>
	</div>
	
	
	<div id="myModal" class="easyui-dialog" title="对话" style="width:80%;height:200px;max-width:800px;padding:10px"
		buttons="#xuanxiang" closable="false" modal="true"
		data-options="
			iconCls:'icon-zs-dialog',
			onResize:function(){
				$(this).dialog('center');
			}">
		<div id="message-mod"></div>
	</div>
  
  </body>
</html>
