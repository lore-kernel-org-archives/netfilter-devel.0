From: Ozgur AKAN <akan@aiqa.com>
Subject: mask for interface
Date: Thu, 25 Mar 2004 10:56:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40629EB1.4080005@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------020001030205090506000906"
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
--------------020001030205090506000906
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

in the code of "struct ipt_ip" there is a mask value for the interface. 
I can understand mask for an ip address but can not understand mask 
value for an interface. For example what can be the mask for eth0?

36         char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
37         unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];

Can anyone write me some about "iniface_mask[IFNAMSIZ]" ?

thanks,
Ozgur AKAN

--------------020001030205090506000906
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
in the code of "struct ipt_ip" there is a mask value for the interface.
I can understand mask for an ip address but can not understand mask
value for an interface. For example what can be the mask for eth0? <br>
<br>
36         char iniface[IFNAMSIZ], outiface[IFNAMSIZ];<br>
37         unsigned char </font><font
 face="microsoft-verdana-iso10646-1">iniface_mask[IFNAMSIZ]</font><font
 face="microsoft-verdana-iso10646-1">, outiface_mask[IFNAMSIZ];<br>
<br>
Can anyone write me some about </font><font
 face="microsoft-verdana-iso10646-1">"iniface_mask[IFNAMSIZ]" ?<br>
<br>
thanks,<br>
Ozgur AKAN<br>
</font>
</body>
</html>

--------------020001030205090506000906--
