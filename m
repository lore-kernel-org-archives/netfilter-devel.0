From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.4] netfilter ipt_conntrack/ipt_state moduse count
Date: Tue, 3 Feb 2004 09:24:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040203082427.GQ24449@obroa-skai.de.gnumonks.org>
References: <20040202152149.GG24449@obroa-skai.de.gnumonks.org> <20040203010224.387392C13E@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wr1Q/2bz0MCWWNYv"
Cc: Sergey Vlasov <vsu@altlinux.ru>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20040203010224.387392C13E@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wr1Q/2bz0MCWWNYv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 03, 2004 at 11:42:01AM +1100, Rusty Russell wrote:
> In message <20040202152149.GG24449@obroa-skai.de.gnumonks.org> you write:
> > ip_nat_standalone.c : is using conntrack functions anyway
>=20
> IIRC, this wasn't always the case, especially on UP (where the
> conntrack lock vanishes).

ip_conntrack_get() is now called from ip_nat_fn().  This should be
sufficient.

> If it is the case now, we're OK.

Ok, I'm going to prepare a patch

> Cheers,
> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wr1Q/2bz0MCWWNYv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAH1q7XaXGVTD0i/8RAhdrAJ40oOqh8gi45gLSy6u4fqEE9Hs22gCeIC0m
LDqk7/ks2i7Vy6LavUgrw4Y=
=9Fmr
-----END PGP SIGNATURE-----

--wr1Q/2bz0MCWWNYv--
