From: "Patrick" <patrick_@freenet.de>
Subject: string match patch
Date: Mon, 12 Jul 2004 17:27:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <005501c46824$c2c0e7b0$0200a8c0@milchreis>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0052_01C46835.85AC3F30"
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

------=_NextPart_000_0052_01C46835.85AC3F30
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

I am worried .. after I upgraded my kernel to 2.4.27-rc3 I also noticed =
that theres a new iptables version ( 1.2.11 ) .. I updated it, after =
this I noticed that I forgot to patch my kernel with the pom-ng =
extra/string patch .. after I patched it I noticed that I dont have any =
new menu point nor do I have CONFIG_IP_NF_MATCH_STRING in my kernel =
config .. the patch pretends to be applied correctly, which I can also =
verify, because the header files are present.

After booting my new kernel I recompiled iptables .. it also built the =
libipt_string.so as it is supposed to .. to verify that its included =
successfully I used 'iptables -m string -h' which returns:

STRING match v1.2.11 options:
--string [!] string          Match a string in a packet
--hex-string [!] string      Match a hex string in a packet

It looks as if everything's correct, but it is not. I cant use the =
string match at all. Everytime I get the reply "iptables: No =
chain/target/match by that name" .. the syntax is correct .. e.g. the =
syntax from the example of the POM page:

iptables -A INPUT -m string --string 'cmd.exe' -j QUEUE
iptables: No chain/target/match by that name

I am not sure wether it has something to do with the kernel or not .. =
but I tried all kernels between 2.4.20 and 2.4.27-rc3 and the entry =
'CONFIG_IP_NF_MATCH_STRING' did never appear ..=20

Any further help's appreciated


Sincerely yours
Patrick


------=_NextPart_000_0052_01C46835.85AC3F30
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1106" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hello,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I am worried .. after I upgraded my =
kernel to=20
2.4.27-rc3 I also noticed that theres a new iptables version ( 1.2.11 ) =
.. I=20
updated it, after this I noticed that I forgot to patch my kernel with =
the=20
pom-ng extra/string patch .. after I patched it I noticed that I dont =
have any=20
new menu point nor do I have CONFIG_IP_NF_MATCH_STRING in my kernel =
config ..=20
the patch pretends to be applied correctly, which I can also verify, =
because the=20
header files are present.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>After booting my new kernel I =
recompiled iptables=20
.. it also built the libipt_string.so as it is supposed to .. to verify =
that its=20
included successfully I used 'iptables -m string -h' which =
returns:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>STRING match v1.2.11 =
options:<BR>--string [!]=20
string&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Match a =
string in a=20
packet<BR>--hex-string [!] string&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Match a =
hex=20
string in a packet</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>It looks as if everything's correct, =
but it is not.=20
I cant use the string match at all. Everytime I get the reply "iptables: =
No=20
chain/target/match by that name" .. the syntax is correct .. e.g. the =
syntax=20
from the example of the POM page:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>iptables -A INPUT -m string --string =
'cmd.exe' -j=20
QUEUE<BR>iptables: No chain/target/match by that name</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I am not sure wether it has something =
to do with=20
the kernel or not .. but I tried all kernels between 2.4.20 and =
2.4.27-rc3 and=20
the entry 'CONFIG_IP_NF_MATCH_STRING' did never appear .. </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Any further help's </FONT><FONT =
face=3DArial=20
size=3D2>appreciated</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Sincerely yours</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Patrick</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_0052_01C46835.85AC3F30--
