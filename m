From: "yeta" <yeta@orchid.ee.ntu.edu.tw>
Subject: about install iptables_1.2.9
Date: Thu, 12 Feb 2004 12:21:03 +0000 (UTC)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002e01c409bf$04029c60$831e708c@yeta>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_002B_01C40A02.121EB070"
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
Date: Sun, 14 Mar 2004 20:22:28 +0800
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_002B_01C40A02.121EB070
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable



hi.=20
I have try to install iptables_1.2.9. But it has some error messages, =
they seems similar problems.
The error message are below
-------------------------------------------------------------------------=
------------------------------------------------
In file included from extensions/libipt_conntrack.c:14:
/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ipt_conntrack.h:28: =
`IP_CT_DIR_MAX' undeclared here (not in a function)
/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ipt_conntrack.h:29: =
`IP_CT_DIR_MAX' undeclared here (not in a function)
/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ipt_conntrack.h:29: =
`IP_CT_DIR_MAX' undeclared here (not in a function)
extensions/libipt_conntrack.c: In function `parse_status':
extensions/libipt_conntrack.c:109: `IPS_EXPECTED' undeclared (first use =
in this function)
extensions/libipt_conntrack.c:109: (Each undeclared identifier is =
reported only once
extensions/libipt_conntrack.c:109: for each function it appears in.)
extensions/libipt_conntrack.c:111: `IPS_SEEN_REPLY' undeclared (first =
use in this function)
extensions/libipt_conntrack.c:113: `IPS_ASSURED' undeclared (first use =
in this function)
extensions/libipt_conntrack.c: In function `parse':
extensions/libipt_conntrack.c:212: `IP_CT_DIR_ORIGINAL' undeclared =
(first use in this function)
extensions/libipt_conntrack.c:269: `IP_CT_DIR_REPLY' undeclared (first =
use in this function)
extensions/libipt_conntrack.c: In function `print_status':
...............................
If somebody knows why and how to solve it, please help me.
thanks
yeta
------=_NextPart_000_002B_01C40A02.121EB070
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dbig5">
<META content=3D"MSHTML 6.00.2800.1170" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><BR>&nbsp;</DIV>
<DIV>hi. </DIV>
<DIV>I have try to install iptables_1.2.9. But it has some error =
messages, they=20
seems similar problems.</DIV>
<DIV>The error message are below</DIV>
<DIV>--------------------------------------------------------------------=
-----------------------------------------------------</DIV>
<DIV>In file included from=20
extensions/libipt_conntrack.c:14:<BR>/usr/src/linux-2.4.21/include/linux/=
netfilter_ipv4/ipt_conntrack.h:28:=20
`IP_CT_DIR_MAX' undeclared here (not in a=20
function)<BR>/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ipt_connt=
rack.h:29:=20
`IP_CT_DIR_MAX' undeclared here (not in a=20
function)<BR>/usr/src/linux-2.4.21/include/linux/netfilter_ipv4/ipt_connt=
rack.h:29:=20
`IP_CT_DIR_MAX' undeclared here (not in a=20
function)<BR>extensions/libipt_conntrack.c: In function=20
`parse_status':<BR>extensions/libipt_conntrack.c:109: `IPS_EXPECTED' =
undeclared=20
(first use in this function)<BR>extensions/libipt_conntrack.c:109: (Each =

undeclared identifier is reported only=20
once<BR>extensions/libipt_conntrack.c:109: for each function it appears=20
in.)<BR>extensions/libipt_conntrack.c:111: `IPS_SEEN_REPLY' undeclared =
(first=20
use in this function)<BR>extensions/libipt_conntrack.c:113: =
`IPS_ASSURED'=20
undeclared (first use in this =
function)<BR>extensions/libipt_conntrack.c: In=20
function `parse':<BR>extensions/libipt_conntrack.c:212: =
`IP_CT_DIR_ORIGINAL'=20
undeclared (first use in this =
function)<BR>extensions/libipt_conntrack.c:269:=20
`IP_CT_DIR_REPLY' undeclared (first use in this=20
function)<BR>extensions/libipt_conntrack.c: In function=20
`print_status':<BR>...............................</DIV>
<DIV>If somebody knows why and how to solve it, please help me.</DIV>
<DIV>thanks</DIV>
<DIV>yeta</DIV></BODY></HTML>

------=_NextPart_000_002B_01C40A02.121EB070--
