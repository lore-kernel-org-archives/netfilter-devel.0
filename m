From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CLUSTERIP: iptables extension update
Date: Mon, 19 Sep 2005 16:45:12 +0200
Message-ID: <20050919144512.GD4600@rama.de.gnumonks.org>
References: <200508301742.08929@nienna>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <200508301742.08929@nienna>
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


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2005 at 05:42:08PM +0200, KOVACS Krisztian wrote:
>=20
>   Hi,
>  =20
>   Some CLUSTERIP iptables extension updates:
>=20
>   * specifying random seed for the Jenkins hash works as documented
>   * iptables-save seems to work now
>  =20
>   Harald, could you please review this patch and commit it to SVN if
> you have no objections?

finally catching up, patch applied.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLs74XaXGVTD0i/8RAq7qAKCVe2NMB2Q3AqdgmtVeo4zn3iIMhACgrJ3l
0R0DAXXsxzmR7LgLC7Y5Lb8=
=+yKr
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
