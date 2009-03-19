From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] netfilter: sysctl support of logger choice.
Date: Thu, 19 Mar 2009 22:46:05 +0100
Message-ID: <1237499165.3955.6.camel@ghlodit.inl.fr>
References: <1237331756.2708.41.camel@ice-age>
	 <1237332458-25202-1-git-send-email-eric@inl.fr>
	 <49C2143F.8070606@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kMLujLhk9ndTxXVvVChQ"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([91.121.73.151]:56169 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbZCSVqi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:46:38 -0400
In-Reply-To: <49C2143F.8070606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-kMLujLhk9ndTxXVvVChQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 19 mars 2009 =C3=A0 10:45 +0100, Patrick McHardy a =C3=A9crit :
> Eric Leblond wrote:
> > This patchs adds support of modification of the used logger via sysctl.
...
> > By echoing "NONE" to a /proc/sys/net/netfilter/nf_log/PROTO file, the
> > logger corresponding to this PROTO is set to NULL.
> >=20
...
> > +	if (write) {
> > +		if (!strnicmp(buffer, "NONE", *lenp - 1)) {
>=20
> What is the motivation here for not doing a full comparison?
> Suggested change: use strcmp

Hmmm that's correct. There is no motivation at all for insensitive
check. I should have done this.

The rest of the modifications are ok for me.

...
> > +		return r;
>=20
> I previously didn't realize an error will cause a panic. I'll add a
> comment explaning why unrolling is unnecessary.

OK, interesting point.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL SARL

--=-kMLujLhk9ndTxXVvVChQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJwr0anxA7CdMWjzIRAmiLAKCEIbr7boxiy2lZ2ca2JcoHc8EvqQCfXHH+
srsF9V1f+k7+lk00PARIbBg=
=sRXG
-----END PGP SIGNATURE-----

--=-kMLujLhk9ndTxXVvVChQ--

