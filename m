From: "Joseph Tung" <jst1@pacbell.net>
Subject: Masquerading and loading balancing among several outbound Internet connections
Date: Tue, 1 Jun 2004 07:52:38 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <063e01c447e8$16d81060$650011ac@knxshunsfjwpvc>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_063B_01C447AD.68D377A0"
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

------=_NextPart_000_063B_01C447AD.68D377A0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

I have several internal networks that are to be ipmasqueraded or snat'd =
among several outbound Internet connections (all going to this one =
router/bridge).
1) Is it possible to ipmasquerade to more than 1 outbound Internet =
connection? (I have Fedora Core 1).
2) If so, are there any samples of how this is done?  For now, I'd be =
happy just assigning each private network one outgoing ip address; but I =
want to do this with one box.  Then I'll bridge the two (or more) by =
modifying the routing table?
3) I'd like to provide webservices via several low bandwidth =
connections, so I'd like to dynamically route the traffic based on the =
load.  My sense is that this is impossible with the current release.
_________________________

Joseph Tung
eXnium Inc.

5255 Stevens Creek Blvd Ste 336
Santa Clara, CA 95051
   main:     408.253.9970
   mobile:  408.393.1123
   fax::       408.253.9971
   email:     joe.tung@eXnium.com

   url:         http://www.eXnium.com
_________________________


------=_NextPart_000_063B_01C447AD.68D377A0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1400" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hello,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I have several internal networks that =
are to be=20
ipmasqueraded or snat'd among several outbound Internet connections (all =
going=20
to this one router/bridge).</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>1) Is it possible to ipmasquerade to =
more than 1=20
outbound Internet connection? (I have Fedora Core 1).</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>2) If so, are there any samples of how =
this is=20
done?&nbsp; For now, I'd be happy just assigning each private network =
one=20
outgoing ip address; but I want to do this with one box.&nbsp; Then I'll =
bridge=20
the two (or more) by modifying the routing table?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>3) I'd like to provide webservices via =
several low=20
bandwidth connections, so I'd like to dynamically route the traffic =
based on the=20
load.&nbsp; My sense is that this is impossible with the current=20
release.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>_________________________</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Joseph Tung<BR>eXnium Inc.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>5255 Stevens Creek Blvd Ste =
336<BR>Santa Clara, CA=20
95051<BR>&nbsp;&nbsp; main:&nbsp;&nbsp;&nbsp;&nbsp; =
408.253.9970<BR>&nbsp;&nbsp;=20
mobile:&nbsp; 408.393.1123<BR>&nbsp;&nbsp;=20
fax::&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 408.253.9971<BR>&nbsp;&nbsp;=20
email:&nbsp;&nbsp;&nbsp;&nbsp; <A=20
href=3D"mailto:joe.tung@eXnium.com">joe.tung@eXnium.com</A></FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;&nbsp;=20
url:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <A=20
href=3D"http://www.eXnium.com">http://www.eXnium.com</A><BR>_____________=
____________</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_063B_01C447AD.68D377A0--
