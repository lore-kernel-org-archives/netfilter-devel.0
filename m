From: "James Williams" <jameswilliams-1@comcast.net>
Subject: nf_register_hook problem
Date: Tue, 15 Jul 2003 16:44:03 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <005c01c34b33$5af35e60$6401a8c0@williams>
Reply-To: "James Williams" <jameswilliams-1@comcast.net>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0059_01C34AF0.4C5F0D10"
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

------=_NextPart_000_0059_01C34AF0.4C5F0D10
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

All-

I am building a LKM. I'd like this module to be a netfilter. I can build =
the module no problem. Upon trying /sbin/insmod <module> I get the error =
"unresolved symbol nf_register_hook." Any thoughts? I've tried building =
the netfilter options in as modules and as part of the kernel. So far no =
luck. Some direction in this matter is greatly appreciated. Also if a =
sample .config file can be provided with netfilter propely configured, =
that would be great.

Thanks,
James
------=_NextPart_000_0059_01C34AF0.4C5F0D10
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1141" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>All-</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I am building a LKM. I'd like this =
module to be a=20
netfilter. I can build the module no problem. Upon trying /sbin/insmod=20
&lt;module&gt; I get the error "unresolved symbol nf_register_hook." Any =

thoughts? I've tried building the netfilter options in as modules and as =
part of=20
the kernel. So far no luck. Some direction in this matter is greatly=20
appreciated. Also if a sample .config file can be provided with =
netfilter=20
propely configured, that would be great.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Thanks,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>James</FONT></DIV></BODY></HTML>

------=_NextPart_000_0059_01C34AF0.4C5F0D10--
