From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Netfilter: Don't cachline align slab allocs
Date: Tue, 1 Feb 2005 13:57:31 +0100
Message-ID: <20050201125731.GD6878@sunbeam.de.gnumonks.org>
References: <1105947649.3954.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="15rqq6UvmZq3FwB1"
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Anton Blanchard <anton@samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1105947649.3954.39.camel@localhost.localdomain>
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


--15rqq6UvmZq3FwB1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2005 at 06:40:49PM +1100, Rusty Russell wrote:
> Anton points out that cacheline aligning conntrack entries is a wank.
> He's right: there's lots of them, and they're currently ~200 bytes.

I'm totally fine believing both of you... but ... So why is/was it a bad
idea? =20

> Same with the cargo-cult programming in ipt_hashlimit.

Mh, please elaborate about that 'cargo-cult programming' phrase - seems
to be an expression I'm not familiar with, as non-native english
speaker.

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--15rqq6UvmZq3FwB1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/3y7XaXGVTD0i/8RAiMEAJsEBZVG/r74U52DRnx9cB0CLqGWTQCgo8fO
Bcr+meQB4U44sp77WFoSN4A=
=UXDQ
-----END PGP SIGNATURE-----

--15rqq6UvmZq3FwB1--
