From: Bart <b-m@pandora.be>
Subject: Re: mac_len uninitialized in ipt_ULOG.c
Date: Mon, 28 Oct 2002 16:49:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DBD5C90.70704@pandora.be>
References: <3DBC5F7D.3FC31A48@cohaesio.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------080302050507080304040300"
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


--------------080302050507080304040300
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Great !

I have been noticing this strange mac-output by ulog.
Gonna try your solution...

greetz


"Anders K. Pedersen"@harrier.cohaesio.com wrote:

>Hello,
>
>I recently startet using the ulogd daemon to log traffic from a PPPoE
>interface (have used it on regular ethernet interfaces for long). In the
>resulting logs, the MAC address was filled with (what seemed to be)
>garbage like the following entry:
>
>Oct 13 21:15:09 gw INPUT: IN=ppp0 OUT=
>MAC=6b:21:c0:00:00:00:00:11:00:00:00:00:00:00:00:00:00:00:00:01:00:00:00:00:00:00:00:63:26:00:00:00:00:00:00:02:26:00:00:7d:26:00:00:00:00:00:00:00:80:8e:c6:00:80:8e:c6:00:00:00:00:00:00:00:00:00:00:00:00:a8:60:76:c1:a8:60:76:c1:00:00:00:00:0c:45:00:00:4e:75:63:00:00:72:11:5e:4f:c1:f9:05:05:50:3f:5d:af:04:01:00:89:00:3a:46:ba:01:00:00:10:00:01:00:00:00:00:00:00:20:43:4b:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:00:00:21:00:01:00:2c:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00 
>SRC=vvv.xxx.yyy.zzz 249.5.5 DST=aaa.bbb.ccc.ddd LEN=78 TOS=00 PREC=0x00
>TTL=114 ID=30051 PROTO=UDP SPT=1025 DPT=137 LEN=58
>
>When using the regular LOG target, the MAC field was empty. I traced
>this back to the ipt_ulog_target function in
>net/ipv4/netfilter/ipt_ULOG.c in the kernel, where pm->mac_len in the
>ulog_packet_msg_t struct is left uninitialized, when there is no MAC
>address.
>
>The attached patch fixes this. It is made against 2.4.19, and I have
>verified, that it applies to 2.4.20-pre11 as well as the latest
>patch-o-matic patches from CVS.
>
>Regards,
>Anders K. Pedersen
>
>------------------------------------------------------------------------
>
>--- linux-2.4.19/net/ipv4/netfilter/ipt_ULOG.c.orig	Sun Oct 13 22:01:55 2002
>+++ linux-2.4.19/net/ipv4/netfilter/ipt_ULOG.c	Sun Oct 13 22:01:55 2002
>@@ -223,7 +223,8 @@
> 	    && in->hard_header_len <= ULOG_MAC_LEN) {
> 		memcpy(pm->mac, (*pskb)->mac.raw, in->hard_header_len);
> 		pm->mac_len = in->hard_header_len;
>-	}
>+	} else
>+		pm->mac_len = 0;
> 
> 	if (in)
> 		strncpy(pm->indev_name, in->name, sizeof(pm->indev_name));
>  
>


--------------080302050507080304040300
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title></title>
</head>
<body>
<br>
Great ! <br>
<br>
I have been noticing this strange mac-output by ulog.<br>
Gonna try your solution...<br>
<br>
greetz<br>
<br>
<br>
"Anders K. Pedersen"@harrier.cohaesio.com wrote:<br>
<blockquote type="cite" cite="mid3DBC5F7D.3FC31A48@cohaesio.com">
  <pre wrap="">Hello,

I recently startet using the ulogd daemon to log traffic from a PPPoE
interface (have used it on regular ethernet interfaces for long). In the
resulting logs, the MAC address was filled with (what seemed to be)
garbage like the following entry:

Oct 13 21:15:09 gw INPUT: IN=ppp0 OUT=
MAC=6b:21:c0:00:00:00:00:11:00:00:00:00:00:00:00:00:00:00:00:01:00:00:00:00:00:00:00:63:26:00:00:00:00:00:00:02:26:00:00:7d:26:00:00:00:00:00:00:00:80:8e:c6:00:80:8e:c6:00:00:00:00:00:00:00:00:00:00:00:00:a8:60:76:c1:a8:60:76:c1:00:00:00:00:0c:45:00:00:4e:75:63:00:00:72:11:5e:4f:c1:f9:05:05:50:3f:5d:af:04:01:00:89:00:3a:46:ba:01:00:00:10:00:01:00:00:00:00:00:00:20:43:4b:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:41:00:00:21:00:01:00:2c:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00 
SRC=vvv.xxx.yyy.zzz 249.5.5 DST=aaa.bbb.ccc.ddd LEN=78 TOS=00 PREC=0x00
TTL=114 ID=30051 PROTO=UDP SPT=1025 DPT=137 LEN=58

When using the regular LOG target, the MAC field was empty. I traced
this back to the ipt_ulog_target function in
net/ipv4/netfilter/ipt_ULOG.c in the kernel, where pm-&gt;mac_len in the
ulog_packet_msg_t struct is left uninitialized, when there is no MAC
address.

The attached patch fixes this. It is made against 2.4.19, and I have
verified, that it applies to 2.4.20-pre11 as well as the latest
patch-o-matic patches from CVS.

Regards,
Anders K. Pedersen</pre>
  <pre wrap="">
<hr width="90%" size="4">
--- linux-2.4.19/net/ipv4/netfilter/ipt_ULOG.c.orig	Sun Oct 13 22:01:55 2002
+++ linux-2.4.19/net/ipv4/netfilter/ipt_ULOG.c	Sun Oct 13 22:01:55 2002
@@ -223,7 +223,8 @@
 	    &amp;&amp; in-&gt;hard_header_len &lt;= ULOG_MAC_LEN) {
 		memcpy(pm-&gt;mac, (*pskb)-&gt;mac.raw, in-&gt;hard_header_len);
 		pm-&gt;mac_len = in-&gt;hard_header_len;
-	}
+	} else
+		pm-&gt;mac_len = 0;
 
 	if (in)
 		strncpy(pm-&gt;indev_name, in-&gt;name, sizeof(pm-&gt;indev_name));
  </pre>
</blockquote>
<br>
</body>
</html>

--------------080302050507080304040300--
