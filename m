From: "Sneppe Filip" <Filip.Sneppe@cronos.be>
Subject: RE: ip_nat_amanda unresolved symbol
Date: Thu, 17 Oct 2002 01:37:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E131E9F1848D0148813EAF06A846608F615F97@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C2756C.ED85D426"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Jan Srzednicki" <winfried@expro.pl>,
	<netfilter-devel@lists.netfilter.org>,
	<netfilter@interlinx.bc.ca>
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

------_=_NextPart_001_01C2756C.ED85D426
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi,

Jan Srzednicki [mailto:winfried@expro.pl] wrote:
>
>Hello there,
>
>I've just cvsupped new version of netfilter stuff (16/10/2002). I =
wanted
>to try some of the new modules in patch-o-matic, one of which is the
>Amanda connection tracking helper. However, this module contains an
>unresolved symbol:
>
>find kernel -path '*/pcmcia/*' -name '*.o' | xargs -i -r ln -sf ../{} =
pcmcia
>if [ -r System.map ]; then /sbin/depmod -ae -F System.map 2.4.19; fi
>depmod: *** Unresolved symbols in
>/lib/modules/2.4.19/kernel/net/ipv4/netfilter/ip_nat_amanda.o
>depmod:         ip_nat_mangle_udp_packet
>
>I grepped all kernel sources and netfilter patches -
>ip_nat_mangle_udp_packet is not defined anywhere! I looked on the code =
of
>similar function - ip_nat_mangle_tcp_packet(); it is defined and =
exported
>correctly. Yet, ip_nat_mangle_udp_packet() clearly is missing. I use =
the
>"new" nat headers and schemes, if that matters in any way.
>

It seems like the amanda conntracker/nat module depends on some
earlier code written by the same author to mangle udp packets.
However, that earlier code did not get accepted; see the following
mails on netfilter-devel:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/009012.h=
tml
http://lists.netfilter.org/pipermail/netfilter-devel/2002-September/00937=
1.html
http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/008916.h=
tml

So what you can do is:
- if you need to get this to work quickly, you can apply the patch
  that adds ip_nat_mangle_udp_packet() and recompile. This is more of=20
  a quickfix solution, though.
- get in touch with the author of the amanda conntracker/nat module,
  because obviously the patch in p-o-m is of little use to anyone in its
  current state. (I've put him email address in the mail loop)

Regards,
Filip Sneppe


------_=_NextPart_001_01C2756C.ED85D426
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
<TITLE>RE: ip_nat_amanda unresolved symbol</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Hi,<BR>
<BR>
Jan Srzednicki [<A =
HREF=3D"mailto:winfried@expro.pl">mailto:winfried@expro.pl</A>] =
wrote:<BR>
&gt;<BR>
&gt;Hello there,<BR>
&gt;<BR>
&gt;I've just cvsupped new version of netfilter stuff (16/10/2002). I =
wanted<BR>
&gt;to try some of the new modules in patch-o-matic, one of which is =
the<BR>
&gt;Amanda connection tracking helper. However, this module contains =
an<BR>
&gt;unresolved symbol:<BR>
&gt;<BR>
&gt;find kernel -path '*/pcmcia/*' -name '*.o' | xargs -i -r ln -sf =
../{} pcmcia<BR>
&gt;if [ -r System.map ]; then /sbin/depmod -ae -F System.map 2.4.19; =
fi<BR>
&gt;depmod: *** Unresolved symbols in<BR>
&gt;/lib/modules/2.4.19/kernel/net/ipv4/netfilter/ip_nat_amanda.o<BR>
&gt;depmod:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
ip_nat_mangle_udp_packet<BR>
&gt;<BR>
&gt;I grepped all kernel sources and netfilter patches -<BR>
&gt;ip_nat_mangle_udp_packet is not defined anywhere! I looked on the =
code of<BR>
&gt;similar function - ip_nat_mangle_tcp_packet(); it is defined and =
exported<BR>
&gt;correctly. Yet, ip_nat_mangle_udp_packet() clearly is missing. I use =
the<BR>
&gt;&quot;new&quot; nat headers and schemes, if that matters in any =
way.<BR>
&gt;<BR>
<BR>
It seems like the amanda conntracker/nat module depends on some<BR>
earlier code written by the same author to mangle udp packets.<BR>
However, that earlier code did not get accepted; see the following<BR>
mails on netfilter-devel:<BR>
<BR>
<A =
HREF=3D"http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/=
009012.html">http://lists.netfilter.org/pipermail/netfilter-devel/2002-Au=
gust/009012.html</A><BR>
<A =
HREF=3D"http://lists.netfilter.org/pipermail/netfilter-devel/2002-Septemb=
er/009371.html">http://lists.netfilter.org/pipermail/netfilter-devel/2002=
-September/009371.html</A><BR>
<A =
HREF=3D"http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/=
008916.html">http://lists.netfilter.org/pipermail/netfilter-devel/2002-Au=
gust/008916.html</A><BR>
<BR>
So what you can do is:<BR>
- if you need to get this to work quickly, you can apply the patch<BR>
&nbsp; that adds ip_nat_mangle_udp_packet() and recompile. This is more =
of<BR>
&nbsp; a quickfix solution, though.<BR>
- get in touch with the author of the amanda conntracker/nat module,<BR>
&nbsp; because obviously the patch in p-o-m is of little use to anyone =
in its<BR>
&nbsp; current state. (I've put him email address in the mail loop)<BR>
<BR>
Regards,<BR>
Filip Sneppe<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C2756C.ED85D426--
