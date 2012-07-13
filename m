From: Eric Leblond <eric@regit.org>
Subject: Re: pgsql-ulogd2
Date: Fri, 13 Jul 2012 17:55:35 +0200
Message-ID: <1342194935.11019.12.camel@tiger.regit.org>
References: <50002CEF.508@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-CutuMqxGHuYyjoUIkjsr"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57585 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab2GMQPB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 12:15:01 -0400
In-Reply-To: <50002CEF.508@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-CutuMqxGHuYyjoUIkjsr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le vendredi 13 juillet 2012 =C3=A0 15:13 +0100, Mr Dash Four a =C3=A9crit :
> I just came across the pgsql script for the ulogd2 daemon supplied with t=
he latest sources and since I intend to deploy it (upgrading my system from=
 syslog-ng) I thought to ask about a couple of ideas I have.
>=20
> As I see it, the script does not have any security/permission policies cr=
eated or implemented. Is such feature planned?=20

No work is planned on that but it is a good idea.

>=20
> If not, I think I have enough PostgreSQL experience and could alter that =
script to include such implementation, though I might need help with the NF=
LOG/ULOGD2 part as I am fairly new to this.

I'm here to help ;)

> The idea I have is that the ulogd2 daemon should only be allowed INSERT p=
ermissions (nothing else) to the log tables, so that even if someone is abl=
e to hijack the ulogd2 connection to PostgreSQL somehow, they won't be able=
 to see what has been logged, let alone alter it or delete it.

That's a sane setup.

>=20
> For certain views, I am sure there is a need for SELECT permission and fo=
r others there would even be a need for USAGE or REFERENCES privileges.
>=20
> I tried to email the author of that script (Pierre - chifflier@inl.fr), b=
ut my emails are not getting through for some reason. Thanks!

INL company is dead but I'm sure that Pierre is still reading this ML
from another mail ;)

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-CutuMqxGHuYyjoUIkjsr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAARPcACgkQnxA7CdMWjzLyegCcCVFSAwFIh8J2w6xQfQYD+Qtz
j4AAnjkqzl71KAThclP/pZCYrxI49p+l
=JA6u
-----END PGP SIGNATURE-----

--=-CutuMqxGHuYyjoUIkjsr--

