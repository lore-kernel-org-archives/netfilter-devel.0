From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 3/5] netfilter: convert logger modules to new API.
Date: Wed, 07 Jan 2009 08:17:01 +0100
Message-ID: <1231312622.4137.7.camel@ice-age>
References: <1230915875.28326.87.camel@ice-age>
	 <1230916055-15448-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xk9ALV7n+LVB63S6gXDZ"
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:36471 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZAGHRH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 02:17:07 -0500
In-Reply-To: <1230916055-15448-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-xk9ALV7n+LVB63S6gXDZ
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,
Le vendredi 02 janvier 2009 =E0 18:07 +0100, Eric Leblond a =E9crit :
> This patch converts the logging modules to the new API. For all modules
...
> and adds a call to nflog_register during init. Backward compatibility
> should be preserved by this patch.

I've discovered this is not the case, I will resend a reworked patchset
soon to provide a true backward compatibility.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-xk9ALV7n+LVB63S6gXDZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJZFbqnxA7CdMWjzIRAqcfAJsGlsseETRtj71ZJ3R0OkcvIa9p/gCeJiSo
zhyRVcF8xxShyQXtga7bpcA=
=f7hD
-----END PGP SIGNATURE-----

--=-xk9ALV7n+LVB63S6gXDZ--

