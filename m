From: Ozgur AKAN <akan@aiqa.com>
Subject: target, match and checkentry functions
Date: Wed, 28 Apr 2004 12:04:08 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408F7388.5010704@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------070809030001040007030801"
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
--------------070809030001040007030801
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am reading ip_tables.h. There is a structure called  ipt_target. In it 
there is pointer to a function which is below.

unsigned int (*target <http://lxr.linux.no/ident?i=target>)(struct sk_buff <http://lxr.linux.no/ident?i=sk_buff> **pskb, .......)

I can not find the original function that this function pointer(*target) points. When I search for target, I see that it is defined in 6 files. Which one is used and when? How can I understand it? (this is same for match and checkentry functions)

6 files in which target is defined;

    * net/ipv4/netfilter/ipt_ECN.c, line 104
      <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_ECN.c#L104>
    * net/ipv4/netfilter/ipt_DSCP.c, line 25
      <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_DSCP.c#L25>
    * net/ipv4/netfilter/ipt_MARK.c, line 11
      <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_MARK.c#L11>
    * net/ipv4/netfilter/ipt_TOS.c, line 11
      <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_TOS.c#L11>
    * net/ipv6/netfilter/ip6t_MARK.c, line 11
      <http://lxr.linux.no/source/net/ipv6/netfilter/ip6t_MARK.c#L11>

thanks,

-- 
Ozgur Akan


--------------070809030001040007030801
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
<br>
I am reading ip_tables.h. There is a structure called  ipt_target. In
it there is pointer to a function which is below.</font><br>
<pre class="moz-signature" cols="72">unsigned int (*<a
 href="http://lxr.linux.no/ident?i=target">target</a>)(struct <a
 href="http://lxr.linux.no/ident?i=sk_buff">sk_buff</a> **pskb, .......)

I can not find the original function that this function pointer(*target) points. When I search for target, I see that it is defined in 6 files. Which one is used and when? How can I understand it? (this is same for match and checkentry functions)

6 files in which target is defined;
</pre>
<ul>
  <li><a
 href="http://lxr.linux.no/source/net/ipv4/netfilter/ipt_ECN.c#L104">net/ipv4/netfilter/ipt_ECN.c,
line 104</a>
  </li>
  <li><a
 href="http://lxr.linux.no/source/net/ipv4/netfilter/ipt_DSCP.c#L25">net/ipv4/netfilter/ipt_DSCP.c,
line 25</a>
  </li>
  <li><a
 href="http://lxr.linux.no/source/net/ipv4/netfilter/ipt_MARK.c#L11">net/ipv4/netfilter/ipt_MARK.c,
line 11</a>
  </li>
  <li><a
 href="http://lxr.linux.no/source/net/ipv4/netfilter/ipt_TOS.c#L11">net/ipv4/netfilter/ipt_TOS.c,
line 11</a>
  </li>
  <li><a
 href="http://lxr.linux.no/source/net/ipv6/netfilter/ip6t_MARK.c#L11">net/ipv6/netfilter/ip6t_MARK.c,
line 11</a>
  </li>
</ul>
<pre class="moz-signature" cols="72">
thanks,

-- 
Ozgur Akan
</pre>
</body>
</html>

--------------070809030001040007030801--
