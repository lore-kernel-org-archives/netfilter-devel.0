From: "Nguyen Binh Phuong" <phuongnb@sunyard.net.tw>
Subject: port parameter of ftp conntrack module
Date: Mon, 13 Oct 2003 14:55:47 +0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001a01c3915f$6be869a0$fe0210ac@phuongnb>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0017_01C3919A.16062B40"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_0017_01C3919A.16062B40
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,=20
When I issue this command:
    iptables -A INPUT -m helper --helper ftp -j ACCEPT
I don't know:
1/ How can ftp conntrack module is called inside kernel?
2/ How can ftp conntrack module get ports parameter inside kernel? Who =
does transmit value of port parameter to init() function of =
ip_conntrack_ftp.c?
Pls help me!
Thanks in advance,
Nguyen Binh Phuong
R&D Dept, Sunyard Embedded Tech Company.

------=_NextPart_000_0017_01C3919A.16062B40
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2600.0" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>
<DIV><FONT face=3DArial size=3D2><FONT face=3DArial =
size=3D2>Hello,</FONT>=20
<DIV>When&nbsp;I issue this command:</DIV>
<DIV>&nbsp;&nbsp;&nbsp; iptables -A&nbsp;INPUT -m helper --helper ftp=20
-j&nbsp;ACCEPT</DIV>
<DIV>I don't know:</DIV>
<DIV>1/ How can ftp conntrack module is called inside kernel?</DIV>
<DIV>2/ How can ftp conntrack module get ports parameter inside kernel? =
Who does=20
transmit <STRONG>value of port parameter</STRONG> to <STRONG>init() =
function of=20
ip_conntrack_ftp.c?</STRONG></DIV>
<DIV><FONT face=3DArial size=3D2>Pls help me!</FONT></DIV>
<DIV>Thanks in advance,</DIV></FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Nguyen Binh Phuong<BR>R&amp;D Dept, =
Sunyard=20
Embedded Tech Company.</FONT></FONT></DIV></DIV></BODY></HTML>

------=_NextPart_000_0017_01C3919A.16062B40--
