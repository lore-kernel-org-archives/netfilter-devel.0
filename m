From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] NETFILTER: tcp window tracking
Date: Sun, 25 Jul 2004 09:12:49 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040725131249.GA10342@obroa-skai.de.gnumonks.org>
References: <20040724153427.GV2848@obroa-skai.de.gnumonks.org> <20040724232239.29bd3ee3.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20040724232239.29bd3ee3.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 24, 2004 at 11:22:39PM -0700, David S. Miller wrote:

> All 12 incremental patches applied, plus this window
> tracking code.

wow, thanks a lot. =20

> Three comments:
>=20
> 1) Patch 7, the seq_file patch was slightly busted,
>    look at this hunk:

oh yes, sorry.  I discovered that, too - but though I sent you the fixed
version :(

> 2) ipt_sctp match had double slashes in the path names in
>    the diff, that confuses diffstat and thus my automated
>    scripts.

ok, I will try to check this next time.

> 3) Yes, I think the new window tracking code mode should
>    be on by default.
>=20

ok, that was our conclusion, too.

> Thanks a lot Harald.

Thank you :)

Now let's see how many people complain about some breakage before
2.6.9 gets released.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBA7HRXaXGVTD0i/8RAt2tAJ9hj5rHqpQMP3toVuuyjMfI73Ec0gCfeYeW
YTn5leNLcXCZiSaJ+FccZxw=
=tPgX
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
