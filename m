From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and
 similar) to avoid file name clash
Date: Sat, 16 Aug 2008 21:52:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808162127200.21025@blackhole.kfki.hu>
References: <g84ufs$l66$1@ger.gmane.org> <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu>
 <alpine.LNX.1.10.0808161520430.27260@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1489864065-1218916322=:21025"
Cc: =?UTF-8?Q?Pteris_Kavi=C5=A1?= <klavins@netspace.net.au>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:50761 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYHPTwG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:52:06 -0400
In-Reply-To: <alpine.LNX.1.10.0808161520430.27260@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1489864065-1218916322=:21025
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 16 Aug 2008, Jan Engelhardt wrote:

> On Saturday 2008-08-16 15:14, Jozsef Kadlecsik wrote:
> >On Sat, 16 Aug 2008, Jan Engelhardt wrote:
> >> On Friday 2008-08-15 18:03, P=FF=FFteris K=FF=FFavi=FF=FF=B9 wrote:
> >>=20
> >> > The changes are proposed in order to avoid file name clashes on
> >> > filesystems that do not allow two files to have names that differ
> >> > only in the case of their letters:
> >> >
> >> > include/linux/netfilter/xt_CONNMARK.h =3D> xt_connmark_target.h
> >> [...]
> >>=20
> >> As I see it, this will already be addressed by merging complementary
> >> code into one source file (e.g. MARK, mark, CONNMARK, connmark
> >> all into a big new xt_mark.c), to reduce (a) amount of files
> >> and (b) build time.
> >[...]
> >
> >That is half of the story: we encode the functionality (match/target) in=
=20
> >the case of the (file)name and there are targets which have got no match=
=20
> >counterpart and thus no natural lowercase filename to merge into it. So=
=20
> >the directory tree still will be broken on case-insensitive filesystems.=
=20
>=20
> We have not decided on filenames yet, just that matches/targets that
> are commonly used together should go into a single file for the two
> above-mentioned reasons, and lower-casing does not appear in (a) or (b).

You wrote: "by merging into ... a big new xt_mark.c". Pteris also=20
suggested fully lowercased names, e.g. xt_connmark_target.h. Or are you=20
just pulling my leg by pointing to the possibility to >capitalize< all=20
the filenames in netfilter, to achieve case-insensitive filenames?

But of course I'm writing about (c):=20

libipt_SNAT|DNAT|MASQUERADE|REDIRECT|SAME|NETMAP.c
libipt_LOG.c, libxt_NFLOG.c,
=2E..

And you are fully aware that the same case-sensitivity applies to the=20
source of iptables as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1489864065-1218916322=:21025--
