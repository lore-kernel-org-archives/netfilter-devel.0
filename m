From: Ozgur AKAN <akan@aiqa.com>
Subject: iptables-save and iptables difference
Date: Tue, 30 Mar 2004 11:50:45 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <406934E5.8080006@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------030104080205050309080404"
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
--------------030104080205050309080404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I found that iptables-save and iptables process interface mask value 
(iniface_mask) differently.

if you add a rule to iptables with this command,

"iptables -A test -i + -j ACCEPT" (by the way, this is same with giving 
no interface value)

iptables-save discards the + sign (...because this is same with giving 
no interface value)
however iptables -nvL command shows "+" as the input interface. (which 
shall be null as iptables-save does)

I know this is not a bug but I think it should be fixed. If it is worth 
to do I would like to prepare a patch for it.

I would like to be pleased to hear your comments,
Ozgur AKAN

--------------030104080205050309080404
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
I found that iptables-save and iptables process interface mask value
(iniface_mask) differently.<br>
<br>
if you add a rule to iptables with this command,<br>
<br>
"iptables -A test -i + -j ACCEPT" (by the way, this is same with giving
no interface value)<br>
<br>
iptables-save discards the + sign (...because </font><font
 face="microsoft-verdana-iso10646-1">this is same with giving no
interface value)<br>
however iptables -nvL command shows "+" as the input interface. (which
shall be null as iptables-save does)<br>
</font><font face="microsoft-verdana-iso10646-1"><br>
I know this is not a bug but I think it should be fixed. If it is worth
to do I would like to prepare a patch for it.<br>
<br>
I would like to be pleased to hear your comments,<br>
Ozgur AKAN<br>
</font>
</body>
</html>

--------------030104080205050309080404--
