From: "Sandeep Singh Kohli" <sskohli@vsnl.com>
Subject: patch-o-matic problem
Date: Mon, 16 Feb 2004 23:50:28 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000801c3f4b9$8eb883d0$4900a8c0@racoon>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0005_01C3F4E7.A7CBCD40"
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

------=_NextPart_000_0005_01C3F4E7.A7CBCD40
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

hi
i dunno whether i have to mail here
i downloaded the latest path-o-matic version from the CVS
I dunno whether there should be a sequence in which one midule compiles =
over other..cos there were MANY problems while compiling the kernel
first the LOG and ULOG had duplicate function calls
then ipt_conntrack_core.c had some functions sumthing_find_get and =
sumthing_get but=20
ipt_connlimit.c called these functions but it cudn't find it anywhere
also there were MAJOR problem of variables used but not defined...
and there was this dstlimit option which had many variables used but not =
defined]
one variable was some num_cpus variable or sumthing
am i doing anything wrong...if i am then can someone guide me that way i =
can help write some documentation which might help others like me=20
i mean whas the point in building a firewall when u had to comment out =
majority of the code
Hope to find some information on this
thanks
sskohli


------=_NextPart_000_0005_01C3F4E7.A7CBCD40
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2600.0" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>hi</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>i dunno whether i have to mail =
here</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>i downloaded the latest path-o-matic =
version from=20
the CVS</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>I dunno whether there should be a =
sequence in which=20
one midule compiles over other..cos there were MANY problems while =
compiling the=20
kernel</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>first the LOG and ULOG had duplicate =
function=20
calls</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>then ipt_conntrack_core.c had some =
functions=20
sumthing_find_get and sumthing_get but </FONT></DIV>
<DIV><FONT face=3DArial size=3D2>ipt_connlimit.c called these functions =
but it=20
cudn't find it anywhere</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>also there were MAJOR problem of =
variables used but=20
not defined...</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>and there was this dstlimit option =
which had many=20
variables used but not defined]</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>one variable was some num_cpus variable =
or=20
sumthing</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>am i doing anything wrong...if i am =
then can=20
someone guide me that way i can help write some documentation which =
might help=20
others like me </FONT></DIV>
<DIV><FONT face=3DArial size=3D2>i mean whas the point in building a =
firewall when u=20
had to comment out majority of the code</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Hope to find some information on =
this</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>thanks</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>sskohli</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_0005_01C3F4E7.A7CBCD40--
