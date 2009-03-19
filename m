From: Soren Hansen <soren@ubuntu.com>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 18:00:02 +0100
Message-ID: <20090319170002.GI20472@ralph.linux2go.dk>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr> <20090319142935.GE20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191530310.31487@fbirervta.pbzchgretzou.qr> <20090319154301.GF20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191701060.14674@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vs0rQTeTompTJjtd"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlas.linux2go.dk ([88.198.22.52]:39955 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZCSRAK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:00:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0903191701060.14674@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--vs0rQTeTompTJjtd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2009 at 05:02:57PM +0100, Jan Engelhardt wrote:
> >Index: iptables-1.4.1.1/iptables-save.c
>=20
> The one who has to merge it - not.
> Here is a reworked version that also adds the missing IPv6
> and manpage bits, pullable from the usual place at
>=20
>  git://dev.medozas.de/iptables master

Excellent. Thanks for cleaning up my mess :)

--=20
Soren Hansen                 |=20
Lead Virtualisation Engineer | Ubuntu Server Team
Canonical Ltd.               | http://www.ubuntu.com/

--vs0rQTeTompTJjtd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAknCehIACgkQo+Mz6+DAzGwXgAP/e4zBqM2Rw1+nfYE/bfJB3Ex1
IhcJWMzXr4sntimrDii45q+jETm2/shHG7Y5VHHtqJWdgUVpDGoJc6CdQpPBcZHT
CCgvZ+VfqyoBoOFsz+KWP47fPHYVrsF+O0KVC+4Tj9GleTHJTBKd9jaLNP8hUjsi
0cwzEJFldYV1+6AxqC8=
=1w3L
-----END PGP SIGNATURE-----

--vs0rQTeTompTJjtd--
