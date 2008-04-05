From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 06/14] MAC address handling in MySQL output
	plugin.
Date: Sat, 5 Apr 2008 21:03:58 +0200
Message-ID: <20080405190358.GI5333@bayen.regit.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895234125-git-send-email-eric@inl.fr> <47F79203.2040301@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Cc: netfilter-devel@vger.kernel.org, pchifflier@inl.fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52592 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYDETED (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:04:03 -0400
Content-Disposition: inline
In-Reply-To: <47F79203.2040301@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Saturday, 2008 April  5 at 16:51:47 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > This patch adds MAC address handling to the MySQL output plugin.
>=20
> Applied. Thanks. Please, next time also include in the description that
> you have deleted the mac_saddr field (I assume that it makes sense since
> it does not provide any useful information for the logging purposes)
>=20
> BTW, we have to freeze changes in the databases before the final
> release, otherwise we'll have to include upgrade scripts to convert the
> database from version X to Y as it happens to other apps (like
> bugzilla). I know that this would happen sooner or later if we have to
> add features but still introducing such kind of scripts would be really
> a pain. I don't think that we should go that way.

Pierre Chifflier and I will soon start working on improving the SQL schemas.
Some things remind to be done on them before freezing.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH980enxA7CdMWjzIRAgevAKCFzKR0sHS4KYHAdUyachnqlb91VQCfXnEz
1jeRIv79t0PkhTm4QsRO1AA=
=dJw/
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
