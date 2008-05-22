From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] simplify list handing in ifname2index infrastructure
Date: Thu, 22 May 2008 14:54:44 +0200
Message-ID: <20080522125443.GL7436@bayen.regit.org>
References: <483564C0.2000100@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+WOirvrtTKur1pg"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, Anton <anton.vazir@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:42130 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951AbYEVMxV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 08:53:21 -0400
Content-Disposition: inline
In-Reply-To: <483564C0.2000100@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--x+WOirvrtTKur1pg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 22 at 14:19:12 +0200, Pablo Neira Ayuso wrote:
> Hi!
>=20
> The patch attached simplifies the ifname2index list handling by using
> linux list and it introduces minor cleanups such as remove iftb_log()
> calls. This patch also fixes the leak in the nlif_close path (we forgot
> to release the ifindex nodes from the hashes) that Anton has reported.
>=20
> Slightly tested here. If you are OK with it I'll apply it asap.

Maybe, this patch is a little too much for a code which should disappear for
libnl ?

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--x+WOirvrtTKur1pg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINW0TnxA7CdMWjzIRAigbAJ468dp6rQNDUWwHGpL/Tyf1DnTDpQCeLxhX
3BToJjv8BRmMJGgJCNgfbZ8=
=5MVa
-----END PGP SIGNATURE-----

--x+WOirvrtTKur1pg--
