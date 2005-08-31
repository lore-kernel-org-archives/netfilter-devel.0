From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CLUSTERIP: iptables extension update
Date: Wed, 31 Aug 2005 09:48:50 +0200
Message-ID: <20050831074850.GF4556@rama.de.gnumonks.org>
References: <200508301742.08929@nienna>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
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


--MAH+hnPXVZWQ5cD/
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

Thanks, Krisztian!

>   Harald, could you please review this patch and commit it to SVN if
> you have no objections?

I have no objections to the patch, but to the line-wrapping or other
disturbance that your client inserted.  At least for me, the patch
doesn't apply: =20

patch: **** malformed patch at line 79: combined with `--new'\n");


Please resend as mime attachment (which is my preferred
format anyway).  Also (for future patches), please make it apply with
"-p1" to make my job a bit easier. Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDFWDiXaXGVTD0i/8RAqa9AJoD8SWvKE4186UNLK3Q2y1a6SBkCQCeP4h5
6WhkHKiURQrousGo0X7J6qc=
=ofgI
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
