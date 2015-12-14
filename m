From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Mon, 14 Dec 2015 21:47:31 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1512142140550.31836@blackhole.kfki.hu>
References: <n4g4s8$4pr$1@ger.gmane.org> <566BEF33.7090501@gmail.com> <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu> <566C09F5.6080606@gmail.com> <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu> <566C0E75.6080800@familie-kuntze.de>
 <566c4622.936d810a.ece67.ffffdfc9@mx.google.com> <20151212232044.GE12854@breakpoint.cc> <566cae67.86f60d0a.f3ad2.2638@mx.google.com> <alpine.LSU.2.20.1512130032300.32038@nerf40.vanv.qr> <566cb640.46dc0d0a.5c3cc.287a@mx.google.com>
 <alpine.LSU.2.20.1512130124180.832@nerf40.vanv.qr> <566cbcbe.01ed0d0a.36f37.2c88@mx.google.com> <alpine.LSU.2.20.1512130135350.32160@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-262429296-1450126051=:31836"
Cc: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Noel Kuntze <noel@familie-kuntze.de>,
	=?ISO-8859-15?Q?Remzi_AKY=DCZ?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:51799 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbbLNUre (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 15:47:34 -0500
In-Reply-To: <alpine.LSU.2.20.1512130135350.32160@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-262429296-1450126051=:31836
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 13 Dec 2015, Jan Engelhardt wrote:

> On Sunday 2015-12-13 01:32, D=C3=A2niel Fraga wrote:
>=20
> >On Sun, 13 Dec 2015 01:30:17 +0100 (CET)
> >Jan Engelhardt <jengelh@inai.de> wrote:
> >
> >> nf_conntrack_ipv4 is indeed autoloaded (provided modprobe can do it)
> >> when you cause instantiation of a xt_conntrack (or xt_state) rule
> >> object through ip(4)tables. And if modprobe cannot satisfy the
> >> request, that feeds back through the kernel and to iptables, which
> >> may then report it to stderr.
> >
> >=09No, I mean selected in the "make menuconfig" ;) If the user
> >chooses to compile state module, menuconfig won't select automatically
> >nf_conntrack_ipv4 (and it should, since it depends on it).
>=20
> There is nothing to add to Kconfig, because there is no build-time=20
> dependency here. In addition, some people might get grumpy if the=20
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK gained a dependency on something it=
=20
> does not depend on at runtime in 100% of cases.

But the reversed dependency is what seems to be missing, something like=20
this:

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index a355841..a1dfd23 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -12,6 +12,7 @@ config NF_DEFRAG_IPV4
 config NF_CONNTRACK_IPV4
        tristate "IPv4 connection tracking support (required for NAT)"
        depends on NF_CONNTRACK
+       default NETFILTER_XT_MATCH_CONNTRACK
        default m if NETFILTER_ADVANCED=3Dn
        select NF_DEFRAG_IPV4
        ---help---

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-262429296-1450126051=:31836--
