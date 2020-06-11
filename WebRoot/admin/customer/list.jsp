<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<HTML>
<HEAD>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${pageContext.request.contextPath}/admin/css/Style.css"
	rel="stylesheet" type="text/css" />
<script language="javascript"
	src="${pageContext.request.contextPath}/admin/js/public.js"></script>
<script src="http://libs.baidu.com/jquery/1.9.0/jquery.js"></script>
<script type="text/javascript">
    var reg = /^[1-9]\d*$/;
    /*删除选中行*/
    function deleteCustomer() {
        var r=confirm("确认删除！");
        if (r==true)
        var check = $("input[type='checkbox']:checked");//在table中找input下类型为checkbox属性为选中状态的数据
		var check_val = [];
        check.each(function () {//遍历
            var id = $(this).closest('tr').find('td').eq(1).text()
			if(reg.test(id)) {
                check_val.push(id)
            }
        })
		//使用ajax方式跳转到servlet，但是无法从servlet跳转到jsp
        $.ajax({
            type : "POST",
            contentType : "application/json",
            url : "${pageContext.request.contextPath}/deleteCustomer?id=" + check_val,
            dataType : 'json',
            success : function(result) {
                alert(result);
            }
        });
        myrefresh();
    }
	function addCustomer() {
		window.location.href = "${pageContext.request.contextPath}/admin/customer/add.jsp";
	}

    function editCustomer() {
        var check = $("input[type='checkbox']:checked");
        if(check.length==0){
            alert("请选择一条数据！")
		}
		else if(check.length>1){
            alert("一次仅可以修改一条记录！")
		}
		else {
            var editId ;
            check.each(function () {//遍历
                var id = $(this).closest('tr').find('td').eq(1).text()
                if(reg.test(id)) {
                    editId = id;
                }
            })
            location.href = "${pageContext.request.contextPath}/findCustomer?id=" + editId;
		}
    }
    window.onload=function(){//网页加载完成后调用函数
        var oA=document.getElementsByTagName("a")[0];//获取第一个a元素，即链接"反选"
        var oInput=document.getElementsByTagName("input");//获取所有的输入选择框
        var oLabel=document.getElementsByTagName("label")[0];//获取第一个lable标签，lable标签为input标签定义标记，即"全选"选项。
        var isCheckAll=function( ){//声明一个全选函数
            for(var i=1,n=0;i<oInput.length;i++){//从i=1循环，排除第一个选项"全选“，从选项1开始循环。
                oInput[i].checked && n++//没选择一个选项，则n增加1，n=已选的项目数
            }
            oInput[0].checked=n==oInput.length-1;//选择第一个选项=选择第一个项目之外的全部选项，所以点击全选的同时，其他所有选项一并选中。
            oLabel.innerHTML = oInput[0].checked ? "全不选" : "全选"//innerHtml改变第一个标签"全选'的元素内容，后面为判断语句：选择"全选"时，全选变为全不选，
        };
        oInput[0].onclick=function(){//给第一个选项"全选"绑定点击函数事件,点击全选时，执行函数
            for(var i=1;i<oInput.length;i++){
                oInput[i].checked=this.checked//当点击第一个"全选"选项时，执行循环函数:遍历选择每个选项，即点击全选时，所有选项都选择，实现全选，同理实现全不选，
            }
            isCheckAll()
        };
        oA.onclick=function(){//给"反选"绑定点击事件，当点击反选时，执行相应函数事件
            for (var i = 1; i < oInput.length; i++){
                oInput[i].checked=!oInput[i].checked//点击反选，已选变未选，未选变已选，!为否定
            };
        }
        for (var i = 1; i < oInput.length; i++) {//点击改变元素
            oInput[i].onclick=function(){
                isCheckAll()//oLabel.innerHTML = oInput[0].checked ? "全不选" : "全选"，根据选中个数更新全选框状态，当全选后，全选切换为全不选。
            };
        }

    }
    function myrefresh()
    {
        window.location.reload();
    }
</script>
</HEAD>
<body>
	<br>
	<form id="Form1" name="Form1" action="" method="post">
		<table cellSpacing="1" cellPadding="0" width="100%" align="center" bgColor="#f5fafe" border="0">
			<tbody>
				<tr>
					<td class="ta_01" align="center" bgColor="#afd1f3"><strong>客 户 列 表</strong>
					</td>
				</tr>
				<tr>
					<td class="ta_01" align="right">
						<button type="button" id="add" name="add"
							class="button_add" onclick="addCustomer()">新增
						</button>
						<button type="button" id="delete" name="delete"
								class="button_delete" onclick="deleteCustomer()">删除
						</button>
						<button type="button" id="edit" name="edit"
								class="button_edit" onclick="editCustomer()">编辑
						</button>
					</td>
				</tr>
				<tr>
					<td class="ta_01" align="center" bgColor="#f5fafe">
						<table cellspacing="0" cellpadding="1" rules="all"
							bordercolor="gray" border="1" id="DataGrid1"
							style="BORDER-RIGHT: gray 1px solid; BORDER-TOP: gray 1px solid; BORDER-LEFT: gray 1px solid; WIDTH: 100%; WORD-BREAK: break-all; BORDER-BOTTOM: gray 1px solid; BORDER-COLLAPSE: collapse; BACKGROUND-COLOR: #f5fafe; WORD-WRAP: break-word">
							<tr
								style="FONT-WEIGHT: bold; FONT-SIZE: 12pt; HEIGHT: 25px; BACKGROUND-COLOR: #afd1f3">
								<td width="1%" align="left"><input type="checkbox" name="chkTittle" id="checkAll">
								</td>
								<td align="center" width="12%" hidden="true">ID</td>
								<td align="center" width="12%">客户编号</td>
								<td align="center" width="12%">客户名称</td>
								<td align="center" width="24%">客户地址</td>
							</tr>
							<c:forEach items="${customers}" var="n">
								<tr onmouseover="this.style.backgroundColor = 'white'"
									onmouseout="this.style.backgroundColor = '#F5FAFE';">
									<td width="1%" align="left"><input type="checkbox" name="chkValue"></td>
									<td hidden="true" align="center"
										width="12%">${n.id}</td>
									<td style="CURSOR: hand; HEIGHT: 22px" align="center"
										width="12%">${n.customerNo }</td>
									<td style="CURSOR: hand; HEIGHT: 22px" align="center"
										width="12%">${n.customerName }</td>
									<td style="CURSOR: hand; HEIGHT: 22px" align="center"
										width="24%">${n.address }</td>
								</tr>
							</c:forEach>
						</table>
					</td>
				</tr>
			</TBODY>
		</table>
	</form>
</body>
</HTML>

