From: <Atanu.Mondal@infineon.com>
Subject: RE: NAT question on holding back a port
Date: Wed, 18 Aug 2004 15:38:09 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <04EE7AD0450F7B498BA216312943A1A11555CE@blrse201.ap.infineon.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C4850B.437FF060"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
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

------_=_NextPart_001_01C4850B.437FF060
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi All,
I have a unique requirement.. I am writing a SIP ALG and am facing with
the following situation.
=20
The local Lan SIP phone sends a registration message and along with it ,
its own contact port number. This gets SRC natted and the SIP ALG
changes
the Lan contact address and contact port to a Firewall global address
and contact port... A DNAT rule also get added dynamically on this
global address
and contact port so that any WAN phone calling on this global address
and contact port will get DNAT ed to the lan SIP phone.
=20
Now any phone on the WAN can connect the lan phone by calling on this
contact address and contact port.
=20
My problem arises from the part that if the conntrack created by the
Registration message goes off, and any other application is given that
global port(NAT checks
only for unique tuple match to assign port).. then everything comes
crashing when some packets come from the WAN side. Due to the DNAT rule
set, the packet gets
directed to the SIP application on the LAN port or a SIP call from
outside will get directed to the Application on the LAN....=20
=20
Is there any way in which I can prevent the assignment of the port to
someother application.
=20
Regards
Atanu Mondal

=09


------_=_NextPart_001_01C4850B.437FF060
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Message</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 5.50.4937.800" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>Hi=20
All,</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>I have=20
a unique requirement.. I am writing a SIP ALG and am facing with the =
following=20
situation.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN=20
class=3D393375509-18082004></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>The=20
local Lan SIP phone sends a registration message and along with it , its =
own=20
contact port number. This gets&nbsp;SRC natted and the SIP ALG=20
changes</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>the=20
Lan contact address and contact port to a Firewall global address and =
contact=20
port... A DNAT rule also get added dynamically on this global=20
address</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>and=20
contact port so that any WAN phone calling on this global address and =
contact=20
port will get DNAT ed to the lan SIP phone.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN=20
class=3D393375509-18082004></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>Now=20
any phone on the WAN can connect the lan phone by calling on this =
contact=20
address and contact port.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN=20
class=3D393375509-18082004></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>My=20
problem arises from the part that if the conntrack created by the =
Registration=20
message goes off, and any other application is given that global =
port(NAT=20
checks</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>only=20
for unique tuple match to assign port).. then everything comes crashing =
when=20
some packets come from the WAN side. Due to the DNAT rule set, the =
packet=20
gets</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN=20
class=3D393375509-18082004>directed to the SIP application on the LAN =
port or a=20
SIP call from outside will get directed to the Application on the =
LAN....=20
</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN=20
class=3D393375509-18082004></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>Is=20
there any way in which I can prevent the assignment of the port to =
someother=20
application.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN=20
class=3D393375509-18082004></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN=20
class=3D393375509-18082004>Regards</SPAN></FONT></DIV>
<DIV><FONT face=3DArial color=3D#0000ff size=3D2><SPAN =
class=3D393375509-18082004>Atanu=20
Mondal</SPAN></FONT></DIV>
<BLOCKQUOTE style=3D"MARGIN-RIGHT: 0px">
  <DIV><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT></DIV></BLOCKQUOTE></BODY></HTML>
=00
------_=_NextPart_001_01C4850B.437FF060--
