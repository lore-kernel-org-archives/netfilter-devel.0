From: "Calvin" <calvinproject@ihug.com.au>
Subject: add/remove rules using libiptc
Date: Fri, 16 May 2003 21:32:38 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002e01c31b9e$db21bd30$d211fea9@toowoomba>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_002B_01C31BF2.ACAC8990"
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

------=_NextPart_000_002B_01C31BF2.ACAC8990
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

I am looking for a way to adding and deleting rules from iptables using =
module. I reaad the Rusty Hacking netfilter HOWTO and got a little bit =
idea.

However there are something i can't understand. I the guide, it mentions =
about the libiptc. Is it I can use the lib in the netfilter module for =
adding and deleting rules from the iptables at any time using the =
iptc_insert_entry(), iptc_append_entry(), iptc_delete_entry(), etc? =
However I can't find an example of  using these, i get really confused =
about the struct using in there. Could anyone pls give me a guide to =
start?

I can't find the libiptc.h in my linux Redhat 8, why? I have iptables =
complied as a module when I complie my kernel before.




------=_NextPart_000_002B_01C31BF2.ACAC8990
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1170" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#c0c0c0>
<DIV><FONT face=3DArial size=3D2>Hi all,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I am looking for a way to adding and =
deleting rules=20
from iptables using module. I reaad the Rusty Hacking netfilter HOWTO =
and got a=20
little bit idea.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>However there are something i can't =
understand. I=20
the guide, it mentions about the libiptc. Is it I can use the lib in the =

netfilter module for adding and deleting rules from the iptables at any =
time=20
using the iptc_insert_entry(), iptc_append_entry(), iptc_delete_entry(), =
etc?=20
However I can't find an example of&nbsp; using these, i get really =
confused=20
about the struct using in there. Could anyone pls give me a guide to=20
start?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I can't&nbsp;find the libiptc.h in my =
linux Redhat=20
8, why? I have iptables complied as a module when I complie my kernel=20
before.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_002B_01C31BF2.ACAC8990--
