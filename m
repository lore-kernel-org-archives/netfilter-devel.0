From: Harald Welte <laforge@netfilter.org>
Subject: Re: Protocol Internal State
Date: Wed, 11 Jun 2003 14:02:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611120233.GI32593@sunbeam.de.gnumonks.org>
References: <SEA2-F33vaKHY5UNLWh00006b16@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8PhoBjPxaQXD0vg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
Content-Disposition: inline
In-Reply-To: <SEA2-F33vaKHY5UNLWh00006b16@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--p8PhoBjPxaQXD0vg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 07, 2003 at 02:23:36AM +0000, Ricky Foo wrote:
> Hi all,
>=20
> In the ftp helper module, why is it that we need to keep the internal sta=
te=20
> of the ftp protocol by defining the structures in the header?=20

you are talking about the last newline stuff, etc?  This is to make sure
nobody abuses the FTP helper to drill holes in th firewall.

> Since we already have the ct and expect structure, would it already be
> sufficient to identify future incoming related streams? Fill me with
> the details.

yes, but firewalls are actually about restricting access.. helpers
should be very tight with what they allow.

>    Ricky

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--p8PhoBjPxaQXD0vg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+5xpZXaXGVTD0i/8RAvNJAKCRaKlNL1PWy3/UC1caDWM7bGZU6gCgoOBz
6ppwIpKtkr3vQfXWXCIr6UI=
=T3cq
-----END PGP SIGNATURE-----

--p8PhoBjPxaQXD0vg--
