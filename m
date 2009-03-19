From: Soren Hansen <soren@ubuntu.com>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 13:55:32 +0100
Message-ID: <20090319125532.GC20472@ralph.linux2go.dk>
References: <20090316171014.GG31952@ralph.linux2go.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlas.linux2go.dk ([88.198.22.52]:50182 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZCSMzr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 08:55:47 -0400
Received: from localhost (0107ds1-abv.0.fullrate.dk [90.185.52.147])
	by atlas.linux2go.dk (Postfix) with ESMTP id E5BC440A92F
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2009 13:55:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20090316171014.GG31952@ralph.linux2go.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2009 at 06:10:14PM +0100, Soren Hansen wrote:
> Resubmitting as per
> http://marc.info/?l=3Dnetfilter-devel&m=3D123722008913373&w=3D2
>=20
> If the iptables modules are not loaded when iptables-save is run,
> iptables-save will fail, because it can't open the relevant files in
> /proc.  This patch makes iptables-save attempt to load the modules, and
> then retries.

Is this the correct list for this?

--=20
Soren Hansen                 |=20
Lead Virtualisation Engineer | Ubuntu Server Team
Canonical Ltd.               | http://www.ubuntu.com/

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAknCQMMACgkQo+Mz6+DAzGwu9gQAo91ZpJDPe8Wtj+LUliCI9P87
3HLHLjnJl7fp1PA3J49lOMp0FSFr+i7tCJI6iZ/ZNg8KSkRAn03N2sw5rwVPNdzn
hB7vz48a7tt8+n5ihRpC7jiN16qgoZS/FWpzHU6piQ+XpVCeXrilkmetWfuL+6BH
uJzAIzDPJCVcS00Dx5M=
=fvEV
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
