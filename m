From: "Drake Henderson" <dhenderson@n2bb.com>
Subject: using libipq to change ip destination
Date: Tue, 24 Jun 2003 13:04:46 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <382BC0C28F397F4785E7414B8279F527040F769C@n2-atl-exch.it.n2bb.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C33A72.B6C03850"
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

------_=_NextPart_001_01C33A72.B6C03850
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Is it possible to use libipq to modify the destination ip address of the
packet?
=20
The following rule succeeds in rerouting the packet...
=20
iptables -t nat -A OUTPUT -p icmp -d 10.252.3.15 -j DNAT
--to-destination 10.252.3.223
=20
However, when using the rule
=20
iptables -t nat -A OUTPUT -p icmp -d 10.252.3.15 -j QUEUE
=20
and attempting to change the destination in the user space app, the
destination is not changed.
=20
=20
I can send the user space app code if needed; however, I want to verify
this approach is doable.  (The end goal is to change the destination
based on the packet's payload.)
=20
Thanks for your help.
=20
=20
Drake
=20
=20

------_=_NextPart_001_01C33A72.B6C03850
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Message</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 5.50.4807.2300" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial size=3D2>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial size=3D2>Is it =
possible to=20
use libipq to modify the destination ip address of the=20
packet?</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial size=3D2>The =
following rule=20
succeeds in rerouting the packet...</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial =
size=3D2>iptables -t nat -A=20
OUTPUT -p icmp -d 10.252.3.15 -j DNAT --to-destination=20
10.252.3.223</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial =
size=3D2>However, when using=20
the rule</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial =
size=3D2>iptables -t nat -A=20
OUTPUT -p icmp -d 10.252.3.15 -j QUEUE</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial size=3D2>and =
attempting to=20
change the destination in the user space app, the destination is not=20
changed.</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial size=3D2>I can =
send the user=20
space app code if needed; however, I want to verify this approach is=20
doable.&nbsp; (The end goal is to change the destination based on the =
packet's=20
payload.)</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial size=3D2>Thanks =
for your=20
help.</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D295515416-24062003><FONT face=3DArial=20
size=3D2>Drake</FONT></SPAN></DIV>
<DIV><SPAN class=3D295515416-24062003></SPAN>&nbsp;</DIV></FONT></DIV>
<DIV>&nbsp;</DIV></BODY></HTML>
=00
------_=_NextPart_001_01C33A72.B6C03850--
