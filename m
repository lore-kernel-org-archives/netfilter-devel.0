From: "Craig Mahonchak" <cmahonchak@mystrotv.com>
Subject: Multicast not showing up in PRE_ROUTING hook?
Date: Fri, 25 Apr 2003 09:45:35 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000701c30b41$b68d5000$790e8f0a@mystro.mystrotv.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0008_01C30B0F.6BF2E000"
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

------=_NextPart_000_0008_01C30B0F.6BF2E000
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I have a weird thing I am seeing.. I have a PRE_ROUTING hook setup in a
netfilter module looking for packets bound for a specific destination
address.. mostly multicast.  I can see all the packets bound for 239.0.0.1
with no problem however anything bound for 239.0.0.2, 239.0.0.3, 239.0.0.4,
etc.. do not show up.  But, when I run tcpdump on that interface and the
interface goes in to promiscuous mode they magically appear in my
PRE_ROUTING hook.

Any ideas?

Thanks for the help.

------=_NextPart_000_0008_01C30B0F.6BF2E000
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.0.4630.0">
<TITLE>Multicast not showing up in PRE_ROUTING hook?</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">I have a weird thing I am seeing.. I =
have a PRE_ROUTING hook setup in a netfilter module looking for packets =
bound for a specific destination address.. mostly multicast.&nbsp; I can =
see all the packets bound for 239.0.0.1 with no problem however anything =
bound for 239.0.0.2, 239.0.0.3, 239.0.0.4, etc.. do not show up.&nbsp; =
But, when I run tcpdump on that interface and the interface goes in to =
promiscuous mode they magically appear in my PRE_ROUTING =
hook.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Any ideas?</FONT>
<BR>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Thanks for the help.</FONT>
</P>

</BODY>
</HTML>
------=_NextPart_000_0008_01C30B0F.6BF2E000--
