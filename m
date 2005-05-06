From: Harald Welte <laforge@netfilter.org>
Subject: Re: CLUSTERIP failover daemon?
Date: Fri, 6 May 2005 13:43:14 +0200
Message-ID: <20050506114314.GK30482@sunbeam.de.gnumonks.org>
References: <000001c54655$7799a690$aa28abc1@Vagabond>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GAc89RRdceylj63L"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alex <alex_oz@gmx.net>
Content-Disposition: inline
In-Reply-To: <000001c54655$7799a690$aa28abc1@Vagabond>
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


--GAc89RRdceylj63L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 21, 2005 at 11:35:33AM +0200, Alex wrote:
> Hi all,
>=20
> =20
>=20
> Is there any daemon which supports failover within CLUSTERIP-nodes?

not that I am aware of.  I never wanted to get involved with a cluster
resource manager.  This subject is a whole field of science on it's own.
All I'd like to provide from CLUSTERIP and things like ct_sync is a
clean interface for cluster resource managers.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GAc89RRdceylj63L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCe1hSXaXGVTD0i/8RAnlIAKCDflmAEe8hGiu1P2EhIrq2OZj1pQCdFuZe
/s/HANcDHxZkrvNb45D2iQY=
=foVl
-----END PGP SIGNATURE-----

--GAc89RRdceylj63L--
