From: Ozgur AKAN <akan@aiqa.com>
Subject: size of a rule
Date: Mon, 26 Apr 2004 16:54:10 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408D1482.5030009@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------020404040703050004020101"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------020404040703050004020101
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I am trying to find the size of a rule in memory.

const struct ipt_entry *e;

sizeof (*e) is equal to 112 always. But the size of rule should be 
different because we can give different parameters to each rule. (I 
guess that this is the size of the header-like place)

So I looked at the source of libiptc and found this in linux_list.h 
while searching for the size value.

#define list_entry(ptr, type, member) \
        ((type *) ( (char *)(ptr)-(unsigned long)(&((type *)0)->member) ) )

What is the meaning of ((type *)0)->member ? I can not understand the 
part with 0.  

thanks,
-- 
Ozgur Akan


--------------020404040703050004020101
Content-Type: text/html; charset=ISO-8859-9
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
<font face="microsoft-verdana-iso10646-1">Hi,<br>
I am trying to find the size of a rule in memory.<br>
<br>
const struct ipt_entry *e;<br>
<br>
sizeof (*e) is equal to 112 always. But the size of rule should be
different because we can give different parameters to each rule. (I
guess that this is the size of the header-like place)<br>
<br>
So I looked at the source of libiptc and found this in linux_list.h
while searching for the size value.<br>
<br>
#define list_entry(ptr, type, member) \<br>
        ((type *) ( (char *)(ptr)-(unsigned long)(&amp;((type
*)0)-&gt;member) ) )<br>
</font><br>
What is the meaning of <font face="microsoft-verdana-iso10646-1">((type
*)0)-&gt;member ? I can not understand the part with 0.   </font><br>
<pre class="moz-signature" cols="72">
thanks,
-- 
Ozgur Akan
</pre>
</body>
</html>

--------------020404040703050004020101--
