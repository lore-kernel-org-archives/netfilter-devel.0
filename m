From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: State of the conntrack match
Date: Wed, 02 May 2007 11:18:46 +0200
Message-ID: <1178097526.15170.3.camel@henriknordstrom.net>
References: <a475e7310704300631m73f8a14yfad2afb10b041592@mail.gmail.com>
	<a475e7310705012314i6e51b921la7d2eded40a84709@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-erKG04jP8ajoB7CJASzA"
Cc: netfilter-devel@lists.netfilter.org
To: Christoph Lenggenhager <clenggenhager@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <a475e7310705012314i6e51b921la7d2eded40a84709@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-erKG04jP8ajoB7CJASzA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

ons 2007-05-02 klockan 08:14 +0200 skrev Christoph Lenggenhager:

> When going through the archives of netfilter-devel, I see that the
> conntrack match has originally been developed by Marc Boucher.
> Back in 2002, Henrik Nordstr=C3=B6m wrote a patch to it that would precis=
ely
> fit my needs.
> (cf. http://lists.netfilter.org/pipermail/netfilter-devel/2002-July/00838=
2.html)
> Unfortunately, this effort seems to have died with the advise from
> Harald Welte to contact Marc Boucher directly.

It mainly died due to the troubles in extending existing matches at the
time, which has since then been solved with the extension versioning.

So it should be pretty straight forward to extend the conntrack match
with the needed functionality today. See for example xt_multiport for an
example how to extend an existing match.

Regards
Henrik

--=-erKG04jP8ajoB7CJASzA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARjhXc0NPQ5Kbx8daAQIbwQQAs3VkcZT8Z8ZhENzPDenu3g2ONcgVyfpX
tAsculqAqhyKofR7TdKDwc0LWO8Ah/FCeFzKhFX2a2+TQLqUhN+TGnYxldvJpAtd
mmNJZ+KS+cXM/eAX3v4KwuP1CHDKOUKGOnPWInOlt8Yfy46Gc2FOH+B2zAB7BcRJ
ng+d8yc6DLA=
=9asD
-----END PGP SIGNATURE-----

--=-erKG04jP8ajoB7CJASzA--
