From: Harald Welte <laforge@netfilter.org>
Subject: Re: per-cpu table information
Date: Thu, 16 Sep 2004 00:36:02 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040915223602.GF2678@sunbeam.de.gnumonks.org>
References: <41402D9E.5050906@rediffmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Swapnil Nagle <swapsn@rediffmail.com>
Content-Disposition: inline
In-Reply-To: <41402D9E.5050906@rediffmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 09, 2004 at 03:47:02PM +0530, Swapnil Nagle wrote:
>=20
> Hi all,
>=20
> Why is the table information (ipt_table_info to be specific) duplicated=
=20
> for each CPU in ipt_table?

Because we don't need any locking and we don't have cache line ping-pong
between the CPU's, if there is no shared data.

> Regards,
> Swapnil.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBSMPSXaXGVTD0i/8RAqpUAKCmvsUVlvQUd9I/YkknimnZ9OEZvgCffgG+
Jmi9M0KX7XHltXRXaflLO9A=
=65EE
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
