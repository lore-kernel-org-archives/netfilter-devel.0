From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_do_table accesss pskb after it has been freed
Date: Fri, 7 Nov 2003 09:57:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107085752.GH5741@sunbeam.de.gnumonks.org>
References: <3FAB00E7.1030507@metavize.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2pkNiL1PnZBJ6Nr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dirk Morris <dmorris@metavize.com>
Content-Disposition: inline
In-Reply-To: <3FAB00E7.1030507@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--p2pkNiL1PnZBJ6Nr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2003 at 06:18:15PM -0800, Dirk Morris wrote:
> I had a target in the mangle/PREROUTING that was freeing the skb and=20
> returning NF_STOLEN.
> ipt_do_table would then cause a kernel panic as it accesses the skb=20
> after its freed.
>=20
> Is this a bug? If so, here's the patch.

no, it's not a bug.  you should return NF_DROP if you want to have the
skb dropped.

> -dirk

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--p2pkNiL1PnZBJ6Nr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/q16QXaXGVTD0i/8RAufhAJoDfhuCMBd21d8R8MBfkb4GDVARegCgs0Av
2F5+biGEiynLSCbl3hkayvc=
=KFcv
-----END PGP SIGNATURE-----

--p2pkNiL1PnZBJ6Nr--
