From: "Sneppe Filip" <Filip.Sneppe@cronos.be>
Subject: RE: xdmcp
Date: Sat, 9 Nov 2002 14:35:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E131E9F1848D0148813EAF06A846608FD776F0@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C287F4.E67984EE"
Cc: <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Min Li" <li9@expert.ics.purdue.edu>, <laforge@gnumonks.org>,
   <linux96@netsarang.com>
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

------_=_NextPart_001_01C287F4.E67984EE
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Min Li [mailto:li9@expert.ics.purdue.edu] wrote:
>Dear all,
>I am trying to make xdmcp work on red-hat 7.3. What I did was turn on =
the
>flag in /etc/kde/kdm/kdmrc, make "enable =3D true", since I'm using =
kde.
>However, my exceed on the windows still cannot see the broadcast from =
the
>linux machine. Please advise. Thanks a lot. I also checked the firewall
>rules in /etc/sysconfig/iptables, and make sure port 177 is not =
blocked.

Hi Min,

I think the problem is that the xdmcp protocol requires a special
helper module to add the necessary connection expectations, since
it appears to open random connections, like ftp for instance.

This raises an interesting question: Here:
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter-extensions/helpers/xdmc=
p/
is some work on a conntrack helper/nat module by Hojae Lee, apparently.

I've never heard any noise about this, the code is not available in
standard patch-o-matic, and I am also wondering what the whole
/netfilter-extensions CVS directory is all about ?
Perhaps Harald knows more about this...

Regards,
Filip





------_=_NextPart_001_01C287F4.E67984EE
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
<TITLE>RE: xdmcp</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Min Li [<A =
HREF=3D"mailto:li9@expert.ics.purdue.edu">mailto:li9@expert.ics.purdue.ed=
u</A>] wrote:<BR>
&gt;Dear all,<BR>
&gt;I am trying to make xdmcp work on red-hat 7.3. What I did was turn =
on the<BR>
&gt;flag in /etc/kde/kdm/kdmrc, make &quot;enable =3D true&quot;, since =
I'm using kde.<BR>
&gt;However, my exceed on the windows still cannot see the broadcast =
from the<BR>
&gt;linux machine. Please advise. Thanks a lot. I also checked the =
firewall<BR>
&gt;rules in /etc/sysconfig/iptables, and make sure port 177 is not =
blocked.<BR>
<BR>
Hi Min,<BR>
<BR>
I think the problem is that the xdmcp protocol requires a special<BR>
helper module to add the necessary connection expectations, since<BR>
it appears to open random connections, like ftp for instance.<BR>
<BR>
This raises an interesting question: Here:<BR>
<A =
HREF=3D"http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter-extensions/help=
ers/xdmcp/">http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter-extensions/=
helpers/xdmcp/</A><BR>
is some work on a conntrack helper/nat module by Hojae Lee, =
apparently.<BR>
<BR>
I've never heard any noise about this, the code is not available in<BR>
standard patch-o-matic, and I am also wondering what the whole<BR>
/netfilter-extensions CVS directory is all about ?<BR>
Perhaps Harald knows more about this...<BR>
<BR>
Regards,<BR>
Filip<BR>
<BR>
<BR>
<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C287F4.E67984EE--
