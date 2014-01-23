From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] add markmask for hash:ip,mark data type
Date: Thu, 23 Jan 2014 20:28:02 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1401232027070.9499@blackhole.kfki.hu>
References: <1387288904-26456-1-git-send-email-vytas.dauksa@smoothwall.net> <1387288904-26456-2-git-send-email-vytas.dauksa@smoothwall.net> <alpine.DEB.2.10.1401082213110.27937@blackhole.kfki.hu> <CACUMwTnn3HyOT5S431viY0s=qoLasFsuv=i7HMQPPC9is745Kw@mail.gmail.com>
 <alpine.DEB.2.10.1401092159240.30009@blackhole.kfki.hu> <CACUMwT=Z8bSO=DK5Xkvrvd=LxqWgCsF+0o=T0wb1Nw_gOYOVWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-1102932827-1390505282=:9499"
Cc: netfilter-devel@vger.kernel.org
To: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:55797 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaAWT2H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:28:07 -0500
In-Reply-To: <CACUMwT=Z8bSO=DK5Xkvrvd=LxqWgCsF+0o=T0wb1Nw_gOYOVWQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-1102932827-1390505282=:9499
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 17 Jan 2014, Vytas Dauksa wrote:

> as promised attaching third patch, which prints mark and markmask in
> hexadecimal.

Patch is applied with a small modification: the prefix "0x" was missing at=
=20
printing/saving mark/mask values.

Best regards,
Jozsef

> On 9 January 2014 21:02, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrot=
e:
> > On Thu, 9 Jan 2014, Vytas Dauksa wrote:
> >
> >> > Why it's important that the kernel should mask the mark value, when =
the
> >> > user could add the intended value directly? The only case where it's
> >> > required when entries added/deleted by the SET target. It's more nat=
ural
> >> > for me if the markmask value has a meaning and effect for kernel sid=
e
> >> > add/del operations only, and ignored for user add/del/test and kerne=
l
> >> > tests. What's your opinion?
> >>
> >> The kernel must apply the mask at test time - that's the whole reason
> >> for it. In our use case the desired mask is 0xff000000, because those
> >> bits identify the protocol, and the other bits are for an unrelated pu=
rpose.
> >> Because the other bits could be set to anything, without a mask there
> >> might have to be 2^24 entries for the other possible values.
> >>
> >> If the kernel applies a mask on test, but values added by the user are=
n't
> >> masked, those entries would never match. It seems clearer to mask them
> >> at add time, so that the user gets sensible errors; for instance, addi=
ng two
> >> different values which mask to the same thing will give the same error=
 as
> >> adding the same value twice.
> >>
> >> Another option we discounted was that each entry could have its own
> >> mask. This didn't make sense because they're not strictly ordered like
> >> netmasks, so multiple entries could be equally applicable, and no hash=
ing
> >> is possible. If 12000000/ff000000 and 00340000/00ff0000 are in the set=
,
> >> but one is nomatch, and a packet has mark 12345678, which entry should
> >> take effect?
> >
> > I see - good arguments, keep the original operations then.
> >
> >> > A small thing, but I'd prefer if the mark value were printed/saved i=
n hex
> >> > instead of decimal, similarly to iptables. Better introduce a new pr=
int
> >> > function for it.
> >>
> >> Sure, will implement this on Friday
> >
> > Best regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics, Hungarian Academy of Scie=
nces
> >           H-1525 Budapest 114, POB. 49, Hungary
>=20
>=20
>=20
> --=20
> Vytas Dauksa
> Junior Developer
> vytas.dauksa@smoothwall.net
>=20
> Smoothwall Ltd
> Phone: +44 (0=AD) 8701 999500
> www.smoothwall.net
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-1102932827-1390505282=:9499--
