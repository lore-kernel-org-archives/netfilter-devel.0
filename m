From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ip_nat_cuseeme NAT helper
Date: Wed, 26 Feb 2003 18:22:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226172222.GG8883@sunbeam.de.gnumonks.org>
References: <1045530785.1570.12.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lIrNkN/7tmsD/ALM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Content-Disposition: inline
In-Reply-To: <1045530785.1570.12.camel@exile>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lIrNkN/7tmsD/ALM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2003 at 02:13:05AM +0100, Filip Sneppe (Cronos) wrote:
> Hi Harald & others,
>=20
> This implements a NAT helper for the CuSeeMe protocol, both as a
> patch against 2.4.20 and as a patch-o-matic patch.

thanks, I have added your patch to patch-o-matic.

But please consider a update based on the comment by Laszlo Valko about
strict alignment issues...

> Regards,
> Filip

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lIrNkN/7tmsD/ALM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XPfOXaXGVTD0i/8RAuyJAJ9Y1FKW5WHKXcuqMEtcQgy5DR3UywCgi37W
nQ7tAXD3n7ZI8eVH9sVWAGk=
=W6Os
-----END PGP SIGNATURE-----

--lIrNkN/7tmsD/ALM--
