From: "pevee" <clkuan@greenpacket.com>
Subject: Enable pinging of public IP without doing NAT
Date: Tue, 12 Nov 2002 11:29:30 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <039e01c289fb$b7c2d1b0$60faa8c0@gpcalvin>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_039B_01C28A3E.C427E6F0"
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

------=_NextPart_000_039B_01C28A3E.C427E6F0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

I think I do not understand your implementation quite well, mayb I amm =
still
new in networking. Do you mind to
explain it with more details?

Let me restate my situation (network diagram) again :)

(1) 192.168.250.96  --------------  192.168.18.18 (2) 92.168.250.199  =
------   192.168.250.254  (3)

How can I configure my network so that 192.168.250.96 can ping to
192.168.250.199?
(1) is a Windows XP machine
(2) and (3) is a Linux box
(2) is more like a router
(3) is our gateway to Internet

I merely know what you are advising me, I am not sure on which maching
should I do the configuration you mentioned :)

Please advise. hope to hear from you soon :)

Warm regards,
Calvin Kaiwen



------=_NextPart_000_039B_01C28A3E.C427E6F0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2719.2200" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>Hi,<BR><BR>I think I do not understand your =
implementation=20
quite well, mayb I amm still<BR>new in networking. Do you mind =
to<BR>explain it=20
with more details?<BR><BR>Let me restate my situation (network diagram) =
again=20
:)<BR><BR>(1) 192.168.250.96&nbsp; --------------&nbsp; 192.168.18.18 =
(2)=20
92.168.250.199&nbsp; ------&nbsp;&nbsp; 192.168.250.254&nbsp; =
(3)<BR><BR>How can=20
I configure my network so that 192.168.250.96 can ping=20
to<BR>192.168.250.199?<BR>(1) is a Windows XP machine<BR>(2) and (3) is =
a Linux=20
box<BR>(2) is more like a router<BR>(3) is our gateway to =
Internet<BR><BR>I=20
merely know what you are advising me, I am not sure on which =
maching<BR>should I=20
do the configuration you mentioned :)<BR><BR>Please advise. hope to hear =
from=20
you soon :)<BR><BR>Warm regards,<BR>Calvin Kaiwen<BR>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_039B_01C28A3E.C427E6F0--
