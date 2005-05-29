From: Harald Welte <laforge@netfilter.org>
Subject: Re: [IPTABLES PATCH] Fix leak in merge_opts
Date: Sun, 29 May 2005 20:55:17 +0200
Message-ID: <20050529185517.GS13114@sunbeam.de.gnumonks.org>
References: <427CD000.40002@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O0WzNXnlZrEJWrBT"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <427CD000.40002@eurodev.net>
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


--O0WzNXnlZrEJWrBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 07, 2005 at 04:26:08PM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> The function merge_opts doesn't release previously merged options, this r=
esults=20
> in a memory leak. This increases considerably memory comsumption in=20
> iptables-restore.
>=20
> This patch fixes a leak on error paths as well.

thanks, Committed revision 3936.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--O0WzNXnlZrEJWrBT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCmhAVXaXGVTD0i/8RAsLmAJ4uAzdFxq2XRmt9RDD+vKOH/SfPFQCglW9I
rYrtH9criyL8rQli3lesXZk=
=AtvV
-----END PGP SIGNATURE-----

--O0WzNXnlZrEJWrBT--
