From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] Proceedings of Netfilter Developer Workshop 2004
Date: Mon, 27 Sep 2004 17:16:31 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040927151631.GS3236@sunbeam.de.gnumonks.org>
References: <20040925213322.GJ3236@sunbeam.de.gnumonks.org>
	<20040927143116.GB18298@barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EosnjXlKWIaKpj07"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr Gasid?o <quaker@pandora.barbara.ds.polsl.gliwice.pl>,
	netfilter-devel@lists.netfilter.org,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	lwn@lwn.net
Content-Disposition: inline
In-Reply-To: <20040927143116.GB18298@barbara.eu.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--EosnjXlKWIaKpj07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2004 at 04:31:16PM +0200, Piotr Gasid?o wrote:
> Target is useful when using MASQUERADE or SNAT. Using tc we are *unable*
> to put outgoing trafic from single IP (behind masquerade) into queue
> created on outgoing interface. With this target we can mark packets from
> each internal IP and then, using tc filter fw put it into queues. This
> target replaces many MARK rules, which can be really CPU hog.

if TC is all you care, why don't you write a new TC filter that
references the ip_conntrack and matches on adresses in there?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--EosnjXlKWIaKpj07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBWC7PXaXGVTD0i/8RAkQEAJwJqxoCWpPi06n0oHqh2doFcwlgBgCgrvYT
l84x2e9fpqvklx7WIbMZOr4=
=o9J0
-----END PGP SIGNATURE-----

--EosnjXlKWIaKpj07--
