From: Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCHv2] netfilter: ip6t_NPT: Fix translation for non-multiple
 of 32 prefix lengths
Date: Wed, 03 Apr 2013 11:42:00 +0200
Message-ID: <515BF968.6010505@universe-factory.net>
References: <bba4b68de747f6d3d580232a15592f6ba0fc6722.1364673589.git.mschiffer@universe-factory.net> <cf3234de124418a6954f079e473c3e01ea96952f.1364674922.git.mschiffer@universe-factory.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2DSHHELXJEQJPJVULEPUM"
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([5.9.180.86]:36257 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763300Ab3DCJmG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:42:06 -0400
In-Reply-To: <cf3234de124418a6954f079e473c3e01ea96952f.1364674922.git.mschiffer@universe-factory.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2DSHHELXJEQJPJVULEPUM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/30/2013 09:23 PM, Matthias Schiffer wrote:
> The bitmask used for the prefix mangling was being calculated incorrect=
ly,
> leading to the wrong part of the address being replaced when the prefix=
 length
> wasn't a multiple of 32.
>=20
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> ---
> Hi, this patch should to 3.9 and, if possible, 3.8-stable.
>=20
> v2: Remove a redundant pair of parentheses.
>=20
> Regards,
> Matthias Schiffer
>=20

*ping* Anybody read the patch? Any comments?


------enig2DSHHELXJEQJPJVULEPUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlFb+WgACgkQq3qIxbiQM9iqSACeK5e6ECCITGT1MnTdt4tCvEKm
mVQAoJ97lx87sdWh7Xr6Pu9PuwOq0r6l
=Zk6W
-----END PGP SIGNATURE-----

------enig2DSHHELXJEQJPJVULEPUM--
