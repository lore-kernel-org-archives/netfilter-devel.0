From: "Pavan Gokarn" <pavang@techknowledge.ws>
Subject: DNAT Query
Date: Thu, 27 Feb 2003 13:29:34 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <007001c2de36$2af03220$e11310ac@techknowledge.ws>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_006D_01C2DE64.44949800"
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

------=_NextPart_000_006D_01C2DE64.44949800
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,
    I am a system administrator new to IPTables, well pretty new. I have =
an issue with DNAT. my DNAT does not work internally. let me give you =
the configuration. I have a Firewall with 2 plumbed interface on the =
same card. eth0=3D172.16.19.231 and eth0:a=3D10.1.1.25. i have enabled =
ip_forward. now when i try to access a 10.0.0.0/8 ip address from =
172.16.19.0/24 (http) using DNAT on the firewall NATBox it does not =
work. can you please give me a solution. the commands i issued are.
# iptables -t nat -A PREROUTING -d 172.16.19.152 -p tcp --dport 8080 -j =
DNAT --to 10.1.1.33:8080

#iptables -t nat -A POSTROUTING -d 10.1.1.33 -p tcp --dport 80 -j SNAT =
10.1.1.25

(DNAT in the same network is working though)

can some one please help me with this. also i am writing a gui solution =
using 'C' as a frontend to iptables tool. Making it much easier for =
users to configure their firewall quickly. can someone give me the full =
description of NETFILTER/IPTables extentions and options (manpages is =
not enough)

Thanx a ton
Regards
Pavan

------=_NextPart_000_006D_01C2DE64.44949800
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Diso-8859-1" =
http-equiv=3DContent-Type>
<META content=3D"MSHTML 5.00.2314.1000" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff><FONT face=3DArial size=3D2>
<DIV><FONT face=3DArial size=3D2>
<DIV>Hello,</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;&nbsp;&nbsp; I am a system =
administrator new=20
to IPTables, well pretty new. I have an issue with DNAT. my DNAT does =
not work=20
internally. let me give you the configuration. I have a Firewall with 2 =
plumbed=20
interface on the same card. eth0=3D172.16.19.231 and eth0:a=3D10.1.1.25. =
i have=20
enabled ip_forward. now when i try to access a 10.0.0.0/8 ip address =
from=20
172.16.19.0/24 (http) using DNAT on the firewall NATBox it does not =
work. can=20
you please give me a solution. the commands i issued are.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2># iptables -t nat -A PREROUTING -d =
172.16.19.152 -p=20
tcp --dport 8080 -j DNAT --to 10.1.1.33:8080</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV>#iptables -t nat -A POSTROUTING -d 10.1.1.33 -p tcp --dport 80 -j =
SNAT=20
10.1.1.25</DIV>
<DIV>&nbsp;</DIV>
<DIV>(DNAT in the same network is working though)</DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>can some one please help me with this. =
also i am=20
writing a gui solution using 'C' as a frontend to iptables tool. Making =
it much=20
easier for users to configure their firewall quickly. can someone give =
me the=20
full description of NETFILTER/IPTables extentions and options (manpages =
is not=20
enough)</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Thanx a ton</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Regards</FONT></DIV>
<DIV><FONT face=3DArial=20
size=3D2>Pavan</FONT></DIV></FONT></DIV></FONT></BODY></HTML>

------=_NextPart_000_006D_01C2DE64.44949800--
