From: "VeNoMouS" <venom@gen-x.co.nz>
Subject: Flushing Conntrack Entrys
Date: Fri, 20 Aug 2004 14:07:29 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <009a01c4865a$72e55fb0$5746370a@nsp.co.nz>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0097_01C486BF.077B4090"
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

------=_NextPart_000_0097_01C486BF.077B4090
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

How hard would it be to flush conntrack entries matching to a certain =
ip?

The issue im having is that i have a fake dns server on port 54 if they =
are not in the DNS table i created then it goes via redirect to 54, now =
the issue is when i put them into the DNS table they start getting =
tracked in the conntrack but when i remove them out of the DNS table =
they are in the conntrack for x amount of seconds, which means if i =
removed them they could do ssh over dns creating a tunnel, keeping the =
conntrack entry alive.


now how badly would the conntrack go mental if i were to delete an entry =
from the conntrack with some code.
------=_NextPart_000_0097_01C486BF.077B4090
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2900.2180" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>How hard would it be to flush conntrack =
entries=20
matching to a certain ip?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>The issue im having is that i have a =
fake dns=20
server on port 54 if they are not in the DNS table i created then it =
goes via=20
redirect to 54, now the issue is when i put them into the DNS table they =
start=20
getting tracked in the conntrack but when i remove them out of the DNS =
table=20
they are in the conntrack for x amount of seconds, which means if i =
removed them=20
they could do ssh over dns creating a tunnel, keeping the conntrack =
entry=20
alive.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>now how badly would the conntrack go =
mental if i=20
were to delete an entry from the conntrack with some=20
code.</FONT></DIV></BODY></HTML>

------=_NextPart_000_0097_01C486BF.077B4090--
