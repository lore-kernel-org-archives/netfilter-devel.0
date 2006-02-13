From: Harald Welte <laforge@netfilter.org>
Subject: Re: [LIBNFNETLINK 2/3] Fix wrong nfnetlink header size
Date: Mon, 13 Feb 2006 12:35:56 +0100
Message-ID: <20060213113556.GX4601@sunbeam.de.gnumonks.org>
References: <43EFAB1B.3040309@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aKl9HDSa9q6Cj3fk"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43EFAB1B.3040309@eurodev.net>
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


--aKl9HDSa9q6Cj3fk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2006 at 10:39:39PM +0100, Pablo Neira Ayuso wrote:
> [LIBNFNETLINK] Fix wrong nfnetlink header size
>=20
> Fix wrong size of the netfilter netlink header. This implicitely fixes an
> alignment issue when nfnl_handle_packet is called as well.

thanks, applied, too.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aKl9HDSa9q6Cj3fk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8G8cXaXGVTD0i/8RArh6AJ9vbX6DB/gnYWwzLKhleeKeNsIpzACfYPSe
/iBBjDGeZw9ux2sApclLmVw=
=uyOE
-----END PGP SIGNATURE-----

--aKl9HDSa9q6Cj3fk--
