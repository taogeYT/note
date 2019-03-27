---
title: xpath
date: 2017-10-26 23:09:47
tags: xpath
---
    通用输入帐号密码xpath表达式，如下示例通过awesome登录页演示
    $x('//input[not(@type="hidden")]')
    $x('(//input[not(@type="hidden")])[1]')
    $x('(//input[not(@type="hidden")])[2]')
    $x('(//input[not(@type="hidden")])[2]/following::*[@type="submit"]')


    //td[contains(text(),'行业')]  模糊查询
    /following::*[1] 选取当前元素的下一个同胞元素

    .//text() 选取已选节点下的所有text内容

    xpath返回都是列表，没有匹配到就返回空列表[]
  
    xml/lxml使用
    eletree对象代表整个文档结构，含有getroot方法获取根节点
    eletree.findall('//div')
    ele 代表某个节点对象
    ele.findall('.//div')
    ele.get('id')获取属性
    ele.tag
    ele.text