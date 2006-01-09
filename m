From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Mon, 9 Jan 2006 14:15:07 +0100
Message-ID: <20060109131507.GN24266@sunbeam.de.gnumonks.org>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<43C247CF.2000608@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wg9FEZT+WCTrEXgJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Content-Disposition: inline
In-Reply-To: <43C247CF.2000608@cosmosbay.com>
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


--wg9FEZT+WCTrEXgJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 09, 2006 at 12:23:59PM +0100, Eric Dumazet wrote:
> Hi Harald
>=20
> Is there any chance we can get rid of the rwlock_t lock in 'struct=20
> xt_table' ?
> (Replacing it by an array of spinlocks)
>=20
>     /* Lock for the curtain */
> -   rwlock_t lock;
> +   spinlock_t *lockp;

should work.  But I don't want this to hold back x_tables, which
otherwise seems functional.  Also, it uses the same mechanism as
ip_tables, so there shouldn't be any performance impact.

We can always improve performance with incremental patches later on.

> On a dual processor machine, its quite common that all incoming frames ar=
e=20
> handled by CPU 0, while CPU 1 is doing the User level stuff and sends=20
> network trafic...

depends on how many NIC's you have and how your irq routing is
configured.

> ( I had a patch sent in September which was doing quite the same thing on=
=20
> ipt_tables, but keeping the rwlock_t : Correct me but I think we can just=
=20
> use spinlocks)

If you want to cook up an x_tables based patch, I'd be happy to give it
some testing.=20

Thanks,
	Harald

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wg9FEZT+WCTrEXgJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDwmHbXaXGVTD0i/8RAjrsAJ9pk0KB9Kvt2pD7BLbNc+S3RyGwBwCfdPvp
2B3nWzcf7XvgNqAJmsklLX8=
=drJR
-----END PGP SIGNATURE-----

--wg9FEZT+WCTrEXgJ--
