From: "Huadong Liu" <hliu@cs.utk.edu>
Subject: link layer hooks
Date: Thu, 8 Jul 2004 11:10:20 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003901c464fd$af8ec790$f73824a0@laptop80>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0036_01C464DC.286336F0"
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

------=_NextPart_000_0036_01C464DC.286336F0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

Hi All,

>From the netfilter documentation I know that hooks are inserted in the =
Ipv4, IPv6 and DecNET stack. Is there any link layer hook supported by =
netfilter? I need to process the link layer frames before they go up the =
stack, e.g. ip_rcv(). Is netfilter_bridge for this purpose?=20

Thanks,

Huadong
------=_NextPart_000_0036_01C464DC.286336F0
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dgb2312">
<META content=3D"MSHTML 6.00.2800.1400" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hi All,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>From the netfilter documentation I know =

that&nbsp;hooks are inserted&nbsp;in the Ipv4, IPv6 and&nbsp;DecNET=20
stack.&nbsp;Is there any link layer hook supported by netfilter?&nbsp;I =
need to=20
process the&nbsp;link layer frames&nbsp;before they go&nbsp;up the =
stack, e.g.=20
ip_rcv(). Is netfilter_bridge for this purpose? </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Thanks,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Huadong</FONT></DIV></BODY></HTML>

------=_NextPart_000_0036_01C464DC.286336F0--
