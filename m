From: "Chris Poon" <Chris.Poon@TELUS.COM>
Subject: [PATCH] big endian patch against netfilter after PPTP NAT patch
Date: Fri, 31 Jan 2003 16:53:44 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <771F217D7A4AF84494632457889470A487DCDC@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----_=_NextPart_000_01C2C983.FD564AA9"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2C983.FD564AA9
Content-Type: multipart/alternative;
 boundary="----_=_NextPart_001_01C2C983.FD564AA9"
Content-Transfer-Encoding: 7bit


------_=_NextPart_001_01C2C983.FD564AA9
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

This is related to the problems I found with expecting related connections
on Sparc64 platform. This is really a patch against the PPTP NAT patch,
which changed the unions in ip_conntrack_manip_proto and
ip_conntrack_tuple from strictly a 16 bit union to a mixed 16/32 bit and
16/32/64 bit union (the later case in ip_conntrack_tuple.dst.u). The patch
will only apply to ip_conntrack_tuple.h after the PPTP patch is installed,
and I did the diff right on the file.

Issue stem from the assumption of little endian platform when the PPTP
patch changed the unions, and compiler padding basically screw up the
actual location of various fields. I have added the #ifdef around the
dummy fields so it should be usable by every platform, and my tests show
that expectations for related connections will now be found so I am one
happy man.... other than the long kernel compile on my Ultra 10 (using
an RedHat like kernel RPM build - PLD for those who are interested), it
wasn't too hard to track down the problem, and now I wonder how many
people are using big-endian machines to run iptables, let alone a sparc64.

Enjoy


------_=_NextPart_001_01C2C983.FD564AA9
Content-Type: text/html;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii">
<META NAME="Generator" CONTENT="MS Exchange Server version 5.5.2653.12">
<TITLE>[PATCH] big endian patch against netfilter after PPTP NAT patch</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=2>This is related to the problems I found with expecting related connections</FONT>
<BR><FONT SIZE=2>on Sparc64 platform. This is really a patch against the PPTP NAT patch,</FONT>
<BR><FONT SIZE=2>which changed the unions in ip_conntrack_manip_proto and</FONT>
<BR><FONT SIZE=2>ip_conntrack_tuple from strictly a 16 bit union to a mixed 16/32 bit and</FONT>
<BR><FONT SIZE=2>16/32/64 bit union (the later case in ip_conntrack_tuple.dst.u). The patch</FONT>
<BR><FONT SIZE=2>will only apply to ip_conntrack_tuple.h after the PPTP patch is installed,</FONT>
<BR><FONT SIZE=2>and I did the diff right on the file.</FONT>
</P>

<P><FONT SIZE=2>Issue stem from the assumption of little endian platform when the PPTP</FONT>
<BR><FONT SIZE=2>patch changed the unions, and compiler padding basically screw up the</FONT>
<BR><FONT SIZE=2>actual location of various fields. I have added the #ifdef around the</FONT>
<BR><FONT SIZE=2>dummy fields so it should be usable by every platform, and my tests show</FONT>
<BR><FONT SIZE=2>that expectations for related connections will now be found so I am one</FONT>
<BR><FONT SIZE=2>happy man.... other than the long kernel compile on my Ultra 10 (using</FONT>
<BR><FONT SIZE=2>an RedHat like kernel RPM build - PLD for those who are interested), it</FONT>
<BR><FONT SIZE=2>wasn't too hard to track down the problem, and now I wonder how many</FONT>
<BR><FONT SIZE=2>people are using big-endian machines to run iptables, let alone a sparc64.</FONT>
</P>

<P><FONT SIZE=2>Enjoy</FONT>
</P>

<P><FONT FACE="MingLiu" SIZE=2 COLOR="#000000"></FONT>&nbsp;

</BODY>
</HTML>
------_=_NextPart_001_01C2C983.FD564AA9--

------_=_NextPart_000_01C2C983.FD564AA9
Content-Type: application/octet-stream;
 name=netfilter.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=netfilter.patch

--- linux-2.4.20.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	=
Thu Jan 30 09:33:31 2003=0A=
+++ linux-2.4.20.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	=
Fri Jan 31 10:28:10 2003=0A=
@@ -17,12 +17,21 @@=0A=
 	u_int32_t all;=0A=
 =0A=
 	struct {=0A=
+#if defined(__BIG_ENDIAN)=0A=
+		u_int16_t dummy;=0A=
+#endif=0A=
 		u_int16_t port;=0A=
 	} tcp;=0A=
 	struct {=0A=
+#if defined(__BIG_ENDIAN)=0A=
+		u_int16_t dummy;=0A=
+#endif=0A=
 		u_int16_t port;=0A=
 	} udp;=0A=
 	struct {=0A=
+#if defined(__BIG_ENDIAN)=0A=
+		u_int16_t dummy;=0A=
+#endif=0A=
 		u_int16_t id;=0A=
 	} icmp;=0A=
 	struct {=0A=
@@ -50,12 +59,24 @@=0A=
 			u_int64_t all;=0A=
 =0A=
 			struct {=0A=
+#if defined(__BIG_ENDIAN)=0A=
+				u_int32_t dummy32;=0A=
+				u_int16_t dummy16;=0A=
+#endif=0A=
 				u_int16_t port;=0A=
 			} tcp;=0A=
 			struct {=0A=
+#if defined(__BIG_ENDIAN)=0A=
+				u_int32_t dummy32;=0A=
+				u_int16_t dummy16;=0A=
+#endif=0A=
 				u_int16_t port;=0A=
 			} udp;=0A=
 			struct {=0A=
+#if defined(__BIG_ENDIAN)=0A=
+				u_int32_t dummy32;=0A=
+				u_int16_t dummy16;=0A=
+#endif=0A=
 				u_int8_t type, code;=0A=
 			} icmp;=0A=
 			struct {=0A=

------_=_NextPart_000_01C2C983.FD564AA9--
