From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2 PATCH 2/3] Make NFLOG and NFCT build conditionnal
Date: Fri, 12 Sep 2008 00:15:04 +0200
Message-ID: <20080911221504.GC20985@ice-age>
References: <1221166085-23435-3-git-send-email-eric@inl.fr> <48C99429.2020406@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks301150.kimsufi.com ([91.121.73.151]:45446 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYIKWvf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:51:35 -0400
Content-Disposition: inline
In-Reply-To: <48C99429.2020406@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 September 11 at 23:56:57 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > This patch modifies the build system behaviour to be able to compile
> > ulogd on system without recent release of libnetfilter library. If
> > a library is absent or too old, it will simply not compile the concerned
> > input module.
>=20
> I don't see any gain from this patch. We had this sort of conditional
> compilation in iptables - that we finally removed - and it was source of
> user-side problems.

Hmm, even if you think autodetection is a mistake, it is useful to
be able to compile ulogd on system where NFLOG or NFCT is not installed
or not usable (too old kernel).

What do you think about a --without flag to be able to manually disable
the compilation ?

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIyZhonxA7CdMWjzIRAoXLAJ9PRQ7QpHEGHTOv/O8u9PoZCtpLDgCfbGYx
aoI3AnzPhwfUK0XE5KfG/vs=
=eTXC
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
