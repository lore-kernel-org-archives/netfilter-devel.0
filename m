From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH] Fix IPv6 packet parsing.
Date: Mon, 2 Jun 2008 14:32:53 +0200
Message-ID: <20080602123253.GD30308@khasse.inl.fr>
References: <1211574847-14768-1-git-send-email-eric@inl.fr> <484338FE.8070507@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2hMgfIw2X+zgXrFs"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44969 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYFBMc5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:32:57 -0400
Content-Disposition: inline
In-Reply-To: <484338FE.8070507@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Monday, 2008 June  2 at  2:04:14 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Source and destination addresses were put in ptr field of the target st=
ructure
> > instead of being put in the new type ui128. The result was an improper =
value
> > of the IPv6 source add destination addresses.
>=20
> Applied. Thanks.
>=20
> I'll test this a bit along this week, any help appreciated. We can
> prepare the first release of 2.0.0-rc series soon. If my mind serves
> well, configuration file reload is still pending.

Yes, reload is still missing.

By the way, a new libnetfilter_conntrack release will be needed before
ulogd2 rc. Latest libnetfilter_conntrack git is needed to have ulogd2
compile.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--2hMgfIw2X+zgXrFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIQ+h1nxA7CdMWjzIRAgWrAJ0fJcJQzsIOiTbI4We+efeCX33VagCeNQ2x
bVXWWZd2c5Yhk0hLN3jT3V0=
=0ujG
-----END PGP SIGNATURE-----

--2hMgfIw2X+zgXrFs--
