From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: Re: using netfilter with mpls
Date: Mon, 14 Jun 2004 12:14:40 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <00c101c451f0$0622a070$248610ac@pc.ccse.kfupm.edu.sa>
References: <026301c44e59$b892c9a0$248610ac@pc.ccse.kfupm.edu.sa> <1087157097.11287.16.camel@ws>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_00BE_01C45209.2B2AB920"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
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

------=_NextPart_000_00BE_01C45209.2B2AB920
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Can you please help me on writing this MPLS match/target and if iptables =
is not a good solution than where should I focus.

regards
  ----- Original Message -----=20
  From: Patrick McHardy=20
  To: Muhammad R. Sami=20
  Cc: netfilter-devel@lists.netfilter.org=20
  Sent: Sunday, June 13, 2004 11:04 PM
  Subject: Re: using netfilter with mpls


  On Wed, 2004-06-09 at 21:41, Muhammad R. Sami wrote:
  > I am a newbee to netfilter. Can I use netfilter along with MPLS to
  > identify packets with special payload and then set EXP bits to =
certain
  > value in the MPLS header.

  There is no MPLS match/target yet, but it should be easy to write one.
  But iptables is not the best place because it would only see =
MPLS-tagged
  IP packets.

  Regards
  Patrick


  > regards
  > =20
  > ------------
  > =20
  > Muhammad R. Sami
  > Research Assistant,
  > Computer Engineering Department
  > P.O.Box 354
  > King Fahd University of Petroleum & Minerals
  > Dhahran 31261
  > Saudi Arabia.
  > Tel: +96638601423
  > Cell: +96657982951
  > www.ccse.kfupm.edu.sa/sami


------=_NextPart_000_00BE_01C45209.2B2AB920
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
<DIV><FONT face=3DVerdana size=3D1>Can you please help me on writing =
this MPLS=20
match/target and if iptables is not a good solution than where should I=20
focus.</FONT></DIV>
<DIV><FONT face=3DVerdana size=3D1></FONT>&nbsp;</DIV>
<DIV><FONT face=3DVerdana size=3D1>regards</FONT></DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3Dkaber@trash.net href=3D"mailto:kaber@trash.net">Patrick =
McHardy</A>=20
  </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Dsami@ccse.kfupm.edu.sa=20
  href=3D"mailto:sami@ccse.kfupm.edu.sa">Muhammad R. Sami</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Cc:</B> <A=20
  title=3Dnetfilter-devel@lists.netfilter.org=20
  =
href=3D"mailto:netfilter-devel@lists.netfilter.org">netfilter-devel@lists=
.netfilter.org</A>=20
  </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Sunday, June 13, 2004 =
11:04=20
PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: using netfilter =
with=20
  mpls</DIV>
  <DIV><BR></DIV>On Wed, 2004-06-09 at 21:41, Muhammad R. Sami =
wrote:<BR>&gt; I=20
  am a newbee to netfilter. Can I use netfilter along with MPLS =
to<BR>&gt;=20
  identify packets with special payload and then set EXP bits to =
certain<BR>&gt;=20
  value in the MPLS header.<BR><BR>There is no MPLS match/target yet, =
but it=20
  should be easy to write one.<BR>But iptables is not the best place =
because it=20
  would only see MPLS-tagged<BR>IP=20
  packets.<BR><BR>Regards<BR>Patrick<BR><BR><BR>&gt; =
regards<BR>&gt;&nbsp;=20
  <BR>&gt; ------------<BR>&gt;&nbsp; <BR>&gt; Muhammad R. Sami<BR>&gt; =
Research=20
  Assistant,<BR>&gt; Computer Engineering Department<BR>&gt; P.O.Box =
354<BR>&gt;=20
  King Fahd University of Petroleum &amp; Minerals<BR>&gt; Dhahran =
31261<BR>&gt;=20
  Saudi Arabia.<BR>&gt; Tel: +96638601423<BR>&gt; Cell: =
+96657982951<BR>&gt; <A=20
  =
href=3D"http://www.ccse.kfupm.edu.sa/sami">www.ccse.kfupm.edu.sa/sami</A>=
<BR><BR></BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_00BE_01C45209.2B2AB920--
