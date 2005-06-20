From: Harald Welte <laforge@netfilter.org>
Subject: Re: Status of 'pptp-conntrack-nat' ?!
Date: Mon, 20 Jun 2005 15:37:13 +0200
Message-ID: <20050620133713.GS9491@obroa-skai.de.gnumonks.org>
References: <42B6961C.7070604@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7WENQHN97/U9vH7R"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
Content-Disposition: inline
In-Reply-To: <42B6961C.7070604@anduras.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--7WENQHN97/U9vH7R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2005 at 12:10:36PM +0200, Sven Anders wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Hello!
>=20
> What is the status of the PPTP Connection-Tracking module?
>=20
> Sorry if I ask this question again, but I the last state I found on this
> mailing list was:
>=20
> | There is no pptp/gre conntrack and nat helper for 2.6.11+, since this
> | kernel version contains a redesigned infrastructure for such helpers.
> |
> | At this time, I see very limited chance that this new infrastructure is
> | sufficient enough to actually implement the same functionality.  A
> | straight 1:1 port ist definitely not possible.
>=20
> ...but in the latest patch-o-matic I found an special sub-directory
> for linux 2.6.11.

that's the incomplete code on which I'm working at the moment. =20

> What makes me confused is that the 'help' files says:
>=20
> ~ - does NOT work with kernels > 2.6.10

true.

> and the 'info' file:
>=20
> ~ Requires: linux < 2.6.11
> ~ Requires: linux-2.6 < 2.6.11

I'll update both (help and info) files when it works on >=3D 2.6.11

> Is this a special development version which is worth testing or do I have
> to wait? Does it work with 2.6.12 too?

I will announce it when it is finished.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7WENQHN97/U9vH7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCtsaJXaXGVTD0i/8RAnPoAJ9vMqATafRsGYqsCIKNWWSFl/DQwQCfYZzV
oHgFhF1IJ9cuToQoMm87JLk=
=h5O0
-----END PGP SIGNATURE-----

--7WENQHN97/U9vH7R--
