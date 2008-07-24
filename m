From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2 PATCH 2/4] Add parsing module for raw.mac.
Date: Thu, 24 Jul 2008 19:16:01 +0200
Message-ID: <20080724171600.GA23670@khasse.inl.fr>
References: <1216848048-13516-2-git-send-email-eric@inl.fr> <48882B03.2030806@netfilter.org> <20080724073733.GD2250@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:35350 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbYGXRQH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:16:07 -0400
Content-Disposition: inline
In-Reply-To: <20080724073733.GD2250@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 July 24 at  9:37:34 +0200, Eric Leblond wrote:
> Hello,
>=20
> On Thursday, 2008 July 24 at  9:10:59 +0200, Pablo Neira Ayuso wrote:
> > Eric Leblond wrote:
> > > This patch adds a module named RAWMAC which is in charge of parsing t=
he
> > > hardware header to extract source and destination hardware address.
> >=20
> > I think that this should be merged with MAC2STR, can you see any other
> > potential user of this information apart from the string converter?
>=20
> No, this was also my conclusion before falling asleep yesterday ;)
>=20
> > Also, it would be nice to rename it to HW2STR instead.

Hmm, in fact it will also be capable of outputting :
 * raw.type
 * oob.protocol
This is not really STR related.

Maybe should we call it HWHDR.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiIuNAACgkQnxA7CdMWjzI9lQCcDznwteNRzNjXsRS5/jd/WEKi
o8kAoJCd4XDSVE/ByfK5Zg3iTrwx+wB+
=BhR7
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
