From: "Sneppe Filip" <Filip.Sneppe@cronos.be>
Subject: RE: [PATCH] wanted: testers for ip_nat_cuseeme module
Date: Tue, 5 Nov 2002 10:09:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E131E9F1848D0148813EAF06A846608FD776C4@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C284AB.1A336588"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Kevin McConnell" <kevymac@yahoo.com>,
   <netfilter-devel@lists.netfilter.org>
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

------_=_NextPart_001_01C284AB.1A336588
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_002_01C284AB.1A336588"


------_=_NextPart_002_01C284AB.1A336588
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

>So did you add your module into the CVS repository or
>where can we get it from? Is this particular module in
>addition to the H323 patches or or is it in place of?

I guess it's best kept out of CVS until more users are successfully=20
using it, as I am not sure it will currently work for everyone. The=20
patch was attached to the announcement mail :-)

>I would be happy to test out both modules. Where is
>the first one available and when will the second be
>available?

Ah I've just remembered that yahoo.com users have problems
with some (text?) attachment. Here's a gzipped patch attached.

No due date on the msn helper - it'll be ready when it's ready,
in true open source tradition :-)

Regards,
Filip


------_=_NextPart_002_01C284AB.1A336588
Content-Type: text/html;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3DWindows-1252">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.0.6249.1">
<TITLE>RE: [PATCH] wanted: testers for ip_nat_cuseeme module</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Hi Kevin,<BR>
<BR>
&gt;So did you add your module into the CVS repository or<BR>
&gt;where can we get it from? Is this particular module in<BR>
&gt;addition to the H323 patches or or is it in place of?<BR>
<BR>
I guess it's best kept out of CVS until more users are successfully<BR>
using it, as I am not sure it will currently work for everyone. The<BR>
patch was attached to the announcement mail :-)<BR>
<BR>
&gt;I would be happy to test out both modules. Where is<BR>
&gt;the first one available and when will the second be<BR>
&gt;available?<BR>
<BR>
Ah I've just remembered that yahoo.com users have problems<BR>
with some (text?) attachment. Here's a gzipped patch attached.<BR>
<BR>
No due date on the msn helper - it'll be ready when it's ready,<BR>
in true open source tradition :-)<BR>
<BR>
Regards,<BR>
Filip<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_002_01C284AB.1A336588--

------_=_NextPart_001_01C284AB.1A336588
Content-Type: application/gzip;
	name="diff.netfilter.cuseeme.20021104-1.gz"
Content-Transfer-Encoding: base64
Content-Description: diff.netfilter.cuseeme.20021104-1.gz
Content-Disposition: attachment;
	filename="diff.netfilter.cuseeme.20021104-1.gz"

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
RAAA

------_=_NextPart_001_01C284AB.1A336588--
