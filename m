From: Ozgur AKAN <akan@aiqa.com>
Subject: plus sign as interface value bug
Date: Mon, 05 Apr 2004 16:44:04 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407162A4.3050901@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040000090906090408080409"
Cc: Harald Welte <laforge@netfilter.org>
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
--------------040000090906090408080409
Content-Type: multipart/alternative;
 boundary="------------050504000209020202060306"


--------------050504000209020202060306
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I found a minor bug in iptables.c. Assuming that;

iptables -A INPUT -i + -j ACCEPT == iptables -A INPUT -j ACCEPT

giving "+" as interface value is same as giving no interface value. But 
the output of "iptables -nvL" is "+" as interface value for "-i +". If 
no interface value is given "iptables -nvL" prints "*". (Also 
iptables-save ignores single "+" as interface value, as normally it should)

This can be fixed by changing "if (vialen == 0)" in iptables.c

"if ( (vialen == 0) || (vialen == 1 && vianame[0] == '+') )"

I attached the patches for iptables.c and ip6tables.c.

regards,
Ozgur AKAN

--------------050504000209020202060306
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
<br>
I found a minor bug in iptables.c. Assuming that;<br>
<br>
iptables -A INPUT -i + -j ACCEPT == iptables -A INPUT -j ACCEPT<br>
<br>
giving "+" as interface value is same as giving no interface value. But
the output of "iptables -nvL" is "+" as interface value for "-i +". If
no interface value is given "iptables -nvL" prints "*". (Also
iptables-save ignores single "+" as interface value, as normally it
should)<br>
<br>
This can be fixed by changing </font>
"if (vialen == 0)" in iptables.c <br>
<br>
"if ( (vialen == 0) || (vialen == 1 &amp;&amp; vianame[0] == '+') )"<br>
<br>
I attached the patches for iptables.c and ip6tables.c.<br>
<br>
regards,<br>
Ozgur AKAN
</body>
</html>

--------------050504000209020202060306--

--------------040000090906090408080409
Content-Type: text/plain;
 name="plus_sign_ip6tables.PATCH"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="plus_sign_ip6tables.PATCH"

--- cvs/iptables/ip6tables.c	2004-02-02 22:02:10.000000000 +0200
+++ cvs/iptables_dev/ip6tables.c	2004-04-05 16:29:50.549995824 +0300
@@ -840,7 +840,7 @@ parse_interface(const char *arg, char *v
 			   " (%i)", arg, IFNAMSIZ-1);
 
 	strcpy(vianame, arg);
-	if (vialen == 0)
+	if ( (vialen == 0) || (vialen == 1 && vianame[0] == '+') )
 		memset(mask, 0, IFNAMSIZ);
 	else if (vianame[vialen - 1] == '+') {
 		memset(mask, 0xFF, vialen - 1);

--------------040000090906090408080409
Content-Type: text/plain;
 name="plus_sign_iptables.PATCH"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="plus_sign_iptables.PATCH"

--- cvs/iptables/iptables.c	2004-02-21 11:20:34.000000000 +0200
+++ cvs/iptables_dev/iptables.c	2004-04-05 16:29:33.256624816 +0300
@@ -780,7 +780,7 @@ parse_interface(const char *arg, char *v
 			   " (%i)", arg, IFNAMSIZ-1);
 
 	strcpy(vianame, arg);
-	if (vialen == 0)
+	if ( (vialen == 0) || (vialen == 1 && vianame[0] == '+') )
 		memset(mask, 0, IFNAMSIZ);
 	else if (vianame[vialen - 1] == '+') {
 		memset(mask, 0xFF, vialen - 1);

--------------040000090906090408080409--
