From: "Chris Poon" <Chris.Poon@TELUS.COM>
Subject: sparc64 kernel, netfilter-20021115, iptables-1.2.7a - conntrack
 i ssue with expecting related connections, FTP
Date: Fri, 31 Jan 2003 11:14:00 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <771F217D7A4AF84494632457889470A412D77C@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="----_=_NextPart_001_01C2C954.873BFC72"
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

------_=_NextPart_001_01C2C954.873BFC72
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

After some further digging and debug output in the expect_cmp, I have found
that the pptp_nat patch will break in a 64 bit big-endian platform. Basically,
the whole masked comparison will be wrong since this patch changed a whole
bunch of fields in various structures in ip_conntrack_tuple.h from 16 bits to
either 32 bits or 64 bits.

Passive FTP section:
Jan 31 09:37:53 sparky kernel: ip_conntrack_expect_related fffff80016c909e0
Jan 31 09:37:53 sparky kernel: tuple: tuple 0000000000417690: 6 client:0x00000000 -> server:0x00005a3f
Jan 31 09:37:53 sparky kernel: mask:  tuple 00000000004176b0: 65535 255.255.255.255:0x00000000 -> 255.255.255.255:0x0000ffff
Jan 31 09:37:53 sparky kernel: expect_cmp
Jan 31 09:37:53 sparky kernel: tuple: tuple fffff80016bab760: 6 client:0x04080000 -> server:0x00000000
Jan 31 09:37:53 sparky kernel: test : tuple fffff80015871960: 6 client:0x00000000 -> server:0x00005a3f
Jan 31 09:37:53 sparky kernel: mask : tuple fffff80015871980: 65535 255.255.255.255:0x00000000 -> 255.255.255.255:0x0000ffff
Jan 31 09:37:53 sparky kernel: rcode: 0

Looks like I will need to pad out the structure in the right way if I want the
PPTP_NAT patch but since this is an RPM build, I will see if I can come
up with another patch to fix the structure for big-endian 64 bit machine with
the PPTP_NAT patch, instead of just ripping it out of the picture.

Thanks....

------_=_NextPart_001_01C2C954.873BFC72
Content-Type: text/html;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
5.5.2653.12">
<TITLE>sparc64 kernel, netfilter-20021115, iptables-1.2.7a - conntrack =
issue with expecting related connections, FTP</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=3D2>After some further digging and debug output in the =
expect_cmp, I have found</FONT>
<BR><FONT SIZE=3D2>that the pptp_nat patch will break in a 64 bit =
big-endian platform. Basically,</FONT>
<BR><FONT SIZE=3D2>the whole masked comparison will be wrong since this =
patch changed a whole</FONT>
<BR><FONT SIZE=3D2>bunch of fields in various structures in =
ip_conntrack_tuple.h from 16 bits to</FONT>
<BR><FONT SIZE=3D2>either 32 bits or 64 bits.</FONT>
</P>

<P><FONT SIZE=3D2>Passive FTP section:</FONT>
<BR><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: =
ip_conntrack_expect_related fffff80016c909e0</FONT>
<BR><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: tuple: tuple =
0000000000417690: 6 client:0x00000000 -&gt; server:0x00005a3f</FONT>
<BR><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: mask:&nbsp; tuple =
00000000004176b0: 65535 255.255.255.255:0x00000000 -&gt; =
255.255.255.255:0x0000ffff</FONT></P>

<P><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: expect_cmp</FONT>
<BR><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: tuple: tuple =
fffff80016bab760: 6 client:0x04080000 -&gt; server:0x00000000</FONT>
<BR><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: test : tuple =
fffff80015871960: 6 client:0x00000000 -&gt; server:0x00005a3f</FONT>
<BR><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: mask : tuple =
fffff80015871980: 65535 255.255.255.255:0x00000000 -&gt; =
255.255.255.255:0x0000ffff</FONT></P>

<P><FONT SIZE=3D2>Jan 31 09:37:53 sparky kernel: rcode: 0</FONT>
</P>

<P><FONT SIZE=3D2>Looks like I will need to pad out the structure in =
the right way if I want the</FONT>
<BR><FONT SIZE=3D2>PPTP_NAT patch but since this is an RPM build, I =
will see if I can come</FONT>
<BR><FONT SIZE=3D2>up with another patch to fix the structure for =
big-endian 64 bit machine with</FONT>
<BR><FONT SIZE=3D2>the PPTP_NAT patch, instead of just ripping it out =
of the picture.</FONT>
</P>

<P><FONT SIZE=3D2>Thanks....</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C2C954.873BFC72--
