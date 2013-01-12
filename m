From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: iptables: build fixes
Date: Sat, 12 Jan 2013 06:49:15 +0400
Message-ID: <20130112024915.GA22315@altlinux.org>
References: <1357830919-10367-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:47163 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab3ALCtQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2013 21:49:16 -0500
Content-Disposition: inline
In-Reply-To: <1357830919-10367-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 04:15:17PM +0100, Jan Engelhardt wrote:
[...]
> Jan Engelhardt (2):
>       build: also use libtool for install stage
>       build: do not dereference symlinks on installation
>=20
>  extensions/GNUmakefile.in |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)

Acked-by: Dmitry V. Levin <ldv@altlinux.org>


--=20
ldv

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlDwzyoACgkQfKvmrJ41Nh65HwCeJD5kcbGYaiCFFvF1erYuNP0C
Wc0AoMKEOF2M5KhxUE2zQnGZWiaDNBWD
=cZWA
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
