From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] iptables: Spelling fixes
Date: Sun, 6 Sep 2015 20:21:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1509062017380.12868@blackhole.kfki.hu>
References: <20150905210746.GA13600@salvia> <1441520550-526-1-git-send-email-ville.skytta@iki.fi> <alpine.LSU.2.20.1509060915240.28331@nerf40.vanv.qr> <CABr9L5BtsG-mzA4LrN0TANPFG-9L8bOeLL6O=M9D4P9d52putw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-1875017634-1441563682=:12868"
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Ville_Skytt=E4?= <ville.skytta@iki.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:58896 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbIFSUa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Sep 2015 14:20:30 -0400
In-Reply-To: <CABr9L5BtsG-mzA4LrN0TANPFG-9L8bOeLL6O=M9D4P9d52putw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-1875017634-1441563682=:12868
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 6 Sep 2015, Ville Skytt=C3=A4 wrote:

> On Sun, Sep 6, 2015 at 10:15 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> >
> > On Sunday 2015-09-06 08:22, Ville Skytt=C3=A4 wrote:
> >>
> >>-/* print a given ip including mask if neccessary */
> >>+/* Print a given ip including mask if necessary.
> >>+ */
> >> static void print_ip(const char *prefix, const struct in6_addr *ip,
> >>                    const struct in6_addr *mask, int invert)
> >> {
> >
> > Hm that really looks worse than it did before.
>=20
> Well, I believe it matches the instructions for block formatting I was
> given by Pablo.=20

No, it does not.

> If it doesn't, I suggest applying my original patch which didn't do=20
> anything but the spelling fixes -- I'm not going to spend any more time=
=20
> on this.

Your original patch does not follow either the comment styles for files=20
under net/, therefore was you asked to fix it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-1875017634-1441563682=:12868--
