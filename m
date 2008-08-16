From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and
 similar) to avoid file name clash
Date: Sat, 16 Aug 2008 21:14:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu>
References: <g84ufs$l66$1@ger.gmane.org> <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-237615989-1218914092=:20963"
Cc: =?ISO-8859-2?Q?Pteris_Kavi=B9?= <klavins@netspace.net.au>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:41840 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYHPTOy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:14:54 -0400
In-Reply-To: <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-237615989-1218914092=:20963
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 16 Aug 2008, Jan Engelhardt wrote:

> On Friday 2008-08-15 18:03, P=FF=FFteris K=FF=FFavi=FF=FF=B9 wrote:
>=20
> > This is a request for comments on the proposal that the following
> > filename changes (indicative at this point) be made in the
> > netfilter source code tree, together with correcting the
> > corresponding references to the files in both source code, the
> > build system, and wherever else necessary.
> >
> > The changes are proposed in order to avoid file name clashes on
> > filesystems that do not allow two files to have names that differ
> > only in the case of their letters:
> >
> > include/linux/netfilter/xt_CONNMARK.h =3D> xt_connmark_target.h
> [...]
>=20
> As I see it, this will already be addressed by merging complementary
> code into one source file (e.g. MARK, mark, CONNMARK, connmark
> all into a big new xt_mark.c), to reduce (a) amount of files
> and (b) build time.
[...]

That is half of the story: we encode the functionality (match/target) in=20
the case of the (file)name and there are targets which have got no match=20
counterpart and thus no natural lowercase filename to merge into it. So=20
the directory tree still will be broken on case-insensitive filesystems.=20

If as a side effect of some real internal changes netfilter becomes=20
compatible with case-insensitive filesystems, that's fine. However, I=20
object changes just for the sake to be compatible with such horrid=20
filesystems.
=20
Best regards,
Jozsef
the NACK guy of the week
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-237615989-1218914092=:20963--
