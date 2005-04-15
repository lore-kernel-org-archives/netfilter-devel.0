From: Harald Welte <laforge@netfilter.org>
Subject: Re: arbitary length matchinfo
Date: Fri, 15 Apr 2005 17:55:45 +0200
Message-ID: <20050415155545.GH25433@sunbeam.de.gnumonks.org>
References: <425FA638.5010601@evtek.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dJYoYR7BBxNWbWWH"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <425FA638.5010601@evtek.fi>
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


--dJYoYR7BBxNWbWWH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2005 at 02:32:08PM +0300, Juha Heljoranta wrote:
> Is it possible to create arbitary length matchinfo? I couldn't find any
> info on this.

no.
=20
> What I want is an path:
>=20
> 	struct ipt_foo_info {
> 		char *path;
> 	}
>=20
> maximum path length in Linux is 4096 and doing

you definitely don't want filename paths in an iptables rule.  this is
insane ;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dJYoYR7BBxNWbWWH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCX+QBXaXGVTD0i/8RAhcYAJ9CdGBycBlKAQp0RJKfIpGodeJpjgCfc4ue
eho0h1BB7dnSgjklxFIZ42g=
=7vU7
-----END PGP SIGNATURE-----

--dJYoYR7BBxNWbWWH--
