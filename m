From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 3/3] netfilter: ipset: timeout fixing bug broke SET
 target special timeout value
Date: Wed, 17 Oct 2012 03:09:29 +0100
Message-ID: <1350439769.26833.83.camel@deadeye.wl.decadent.org.uk>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
	 <1349950658-12548-4-git-send-email-pablo@netfilter.org>
	 <20121015232225.GB2118@kroah.com> <20121015232750.GA32665@kroah.com>
	 <20121015234022.GB667@kroah.com> <20121016093653.GA18252@1984>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-m9/UZs/JJ3gMAcUg9wka"
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42279 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756093Ab2JQCLU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:11:20 -0400
In-Reply-To: <20121016093653.GA18252@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-m9/UZs/JJ3gMAcUg9wka
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-16 at 11:36 +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 15, 2012 at 04:40:22PM -0700, Greg KH wrote:
> > On Mon, Oct 15, 2012 at 04:27:50PM -0700, Greg KH wrote:
> > > On Mon, Oct 15, 2012 at 04:22:25PM -0700, Greg KH wrote:
> > > > On Thu, Oct 11, 2012 at 12:17:38PM +0200, pablo@netfilter.org wrote=
:
> > > > > From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > >=20
> > > > > The patch "127f559 netfilter: ipset: fix timeout value overflow b=
ug"
> > > > > broke the SET target when no timeout was specified.
> > > > >=20
> > > > > Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes=
.fr>
> > > > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > ---
> > > > >=20
> > > > > This patch requires:
> > > > >=20
> > > > > commit 127f559127f5175e4bec3dab725a34845d956591
> > > > > Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > > Date:   Mon May 7 02:35:44 2012 +0000
> > > > >=20
> > > > >     netfilter: ipset: fix timeout value overflow bug
> > > > >    =20
> > > > >     Large timeout parameters could result wrong timeout values du=
e to
> > > > >     an overflow at msec to jiffies conversion (reported by Andrea=
s Herz)
> > > >=20
> > > > This patch doesn't apply to the 3.0.y series, care to provide a
> > > > backport, and a backported version of the original patch above that
> > > > needs it?
> > >=20
> > > Oh wait, should I apply the 3.0.y specific patches first?  I'll go do
> > > that and see if these two then apply here...
> >=20
> > Nope, doesn't apply.  Care to backport both of these patches for 3.0.y
> > and send them to us?
>=20
> I can send you the backport for 3.2 but not for 3.0.
>
> That fix is for one feature that was added in 3.1, so no way to make it
> for 3.0 :-)
>=20
> Let me know.

I look after 3.2.  I don't think the original timeout overflow bug is
important enough for a stable update, so I don't intend to apply either
of these.

Ben.

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-m9/UZs/JJ3gMAcUg9wka
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUH4TWue/yOyVhhEJAQocshAAt022ndFveppPaPZ1Lwv3m03vxYYXSvii
klX3hx+o5IYO7V2iaSthgH47wBmHj0v16hBSWUSeSrAoOCPmqdvmTtcJQXQJeeWh
2iUfrbbsIdCiG1BCNTkTsEZzI/Sg3hhHbnCR98ZdI4DInnYkOhIQt49rV2pTInML
Ur11A3lIGmc9FIuE+gPyOpyFkUhuQMzPzdRRHU6TLqOSjRIy+s4ZcWhvVeExp7HE
Yjw6YG025+vv9+uYOS14rDShRVvSh1BrloX9P3lAr1tENOKMA5SxlFtEKFT7Y3Cs
K4tNS6DUvUclRkNk7hMzH/OozXZGXZVI2fE287Q0MyJSshH0+OZxZA9GMhqaGHfX
cbhFI0uJG+3QRUX5cs5SpefLH6Vfe0o9VjFRstIsKWjnLtsFhEdz+3FkR11nwNsi
pt8uPR4mH1VnXSDJ+qTAphk5xspnq3ksdu57JBMNoR85bPfPpFOPJWPhyjKfXXc7
hnffdGWJpVs7klQAHXLe0uvtUmWGaAtR4lVqe2GIBF4nCVmxFBMsRa688XC3Mldg
CU+muAJCOZb9OEK/UUecoEGCFfk9BhHOL5JBD+tNquYQkxnY6pMks3f4vV1hbdMM
6jMRuyRbjEm5K1M6R5UctBZlx1+2sYw0fauoPwN+KMJomUkJVdCVUjtWqhS9PLQ2
GWpeZ6b48CQ=
=DnmR
-----END PGP SIGNATURE-----

--=-m9/UZs/JJ3gMAcUg9wka--
