From: Ozgur AKAN <akan@aiqa.com>
Subject: "args..." and "## args" ?
Date: Thu, 29 Apr 2004 18:33:11 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40912037.7080504@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------020402050800030806050501"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020402050800030806050501
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit

While I was looking for match info in iptables.c I found 
IPT_MATCH_ITERATE. In ip_tables.h IPT_MATCH_ITERATE is defined but there 
are two lines which I can  not understand!

#define IPT_MATCH_ITERATE(e, fn, args...)
....
....
    __ret = fn(__match , ## args);

Can you please tell me abour "args..." and "## args" notation?

thanks,

-- 
Ozgur Akan


--------------020402050800030806050501
Content-Type: text/html; charset=ISO-8859-9
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
<font face="microsoft-verdana-iso10646-1">While I was looking for match
info in iptables.c I found </font><font
 face="microsoft-verdana-iso10646-1">IPT_MATCH_ITERATE. In ip_tables.h </font><font
 face="microsoft-verdana-iso10646-1">IPT_MATCH_ITERATE is defined but
there are</font><font face="microsoft-verdana-iso10646-1"> two lines
which I can  not understand!<br>
<br>
#define IPT_MATCH_ITERATE(e, fn, args...)<br>
....<br>
....<br>
    __ret = fn(__match , ## args);<br>
<br>
Can you please tell me abour "args..." and "## args" notation?<br>
<br>
thanks,<br>
</font>
<pre class="moz-signature" cols="72">-- 
Ozgur Akan
</pre>
</body>
</html>

--------------020402050800030806050501--
