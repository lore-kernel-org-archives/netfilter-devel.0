From: Ozgur AKAN <akan@aiqa.com>
Subject: prohibiting iptables to insert a rule twice
Date: Thu, 06 May 2004 11:47:05 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4099FB89.3000604@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------060601060603040003040009"
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
--------------060601060603040003040009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I am working on a patch for iptables.c to prohibit inserting the same 
rule twice. Inserting same rule twice does not cause any problems but 
also is not meaningful.

After the patch iptables will has an option to force the system to 
insert the rule twice but by default it will check whether the rule is 
already inserted or not and will give warning.

I think that checking the rule in the system may take too much time for 
systems with thousands of rules, so an option argument will be a good 
choice.

I wonder why this has not been done before. Please write your 
suggestions and thoughts.

thanks,

-- 
Ozgur Akan


--------------060601060603040003040009
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
<font face="microsoft-verdana-iso10646-1">Hi,<br>
I am working on a patch for iptables.c to prohibit inserting the same
rule twice. Inserting same rule twice does not cause any problems but
also is not meaningful.<br>
<br>
After the patch iptables will has an option to force the system to
insert the rule twice but by default it will check whether the rule is
already inserted or not and will give warning.<br>
<br>
I think that checking the rule in the system may take too much time for
systems with thousands of rules, so an option argument will be a good
choice.<br>
<br>
I wonder why this has not been done before. Please write your
suggestions and thoughts.<br>
<br>
thanks,<br>
</font>
<pre class="moz-signature" cols="72">-- 
Ozgur Akan
</pre>
</body>
</html>

--------------060601060603040003040009--
