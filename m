From: Richard Weinberger <richard@nod.at>
Subject: Re: xt_target checkentry()/destroy() semantics
Date: Wed, 11 Jan 2012 11:38:02 +0100
Message-ID: <4F0D668A.5060200@nod.at>
References: <4F0CE6C0.6080900@nod.at> <alpine.LNX.2.01.1201110741110.27346@frira.zrqbmnf.qr> <4F0D5BE4.3040509@nod.at> <CAHo-Oow9fZg+O6jkmzN2cLooE6TwsFmOib+1gF5_VXtwXRt=Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig88F11F0DE99A5B697FCE314E"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2AKKiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:38:05 -0500
In-Reply-To: <CAHo-Oow9fZg+O6jkmzN2cLooE6TwsFmOib+1gF5_VXtwXRt=Wg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig88F11F0DE99A5B697FCE314E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 11.01.2012 11:27, schrieb Maciej =C5=BBenczykowski:
> every change, whether addition or deletion is done via table-replacemen=
t.
> the only modification operation supported is table replacement.
> so you're making 6 table replecaments with those 6 commands.

So the table is read-only and is being recreated on each change, right?

Thanks,
//richard


--------------enig88F11F0DE99A5B697FCE314E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPDWaLAAoJEN9758yqZn9ecDoH/2VJ+4LchfCQQvRmMkHSb04R
VJutULeS6ZzwgW9DFd90IRvmrXMInjiSCSP/udhHFZcTbtWd0j3ZMPG35GK1qqZ9
QFAbd09sGuAzL7K/PyBkoqGvsQPKUF2khcghuTz4H6GBREKo04soxJ7i4n6FRk3Q
Lu9vypQCT2QLrs3cbqjjVXmIdh8T/lPLOe4laF/l0wnp5C0dJ9+xX9LzuIYJ82uN
dIbFENvzGAqYJtFuG2MB3AAfKyKAHa5wlXZ7no9oUShrzhOqee36sDJ4UqmdEaPH
htiVA6hVCiAag1ta5kOzrgn+4Ho2yYAWIxlHXR25HkoIk3Zqhx1eGU746bY/GeM=
=Hhqc
-----END PGP SIGNATURE-----

--------------enig88F11F0DE99A5B697FCE314E--
