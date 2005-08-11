From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK] {alloc,
	free}_conntrack to ip_conntrack style
Date: Thu, 11 Aug 2005 21:19:03 +0200
Message-ID: <20050811191903.GF5353@rama.de.gnumonks.org>
References: <200508110914.j7B9Efd8021278@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508110914.j7B9Efd8021278@toshiba.co.jp>
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


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yasuyuki-san,

On Thu, Aug 11, 2005 at 06:14:41PM +0900, Yasuyuki KOZAKAI wrote:
=20
> This patch moves initialization of conntrack in init_conntrack() to
> alloc_conntrack(), renames {alloc,free}_conntrack() to
> nf_conntrack_{alloc,free}(), and moves them to just before init_conntrack=
(),
> like ip_conntrack.
>=20
> Please apply to nf_conntrack tree.

Thanks, applied.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC+6SnXaXGVTD0i/8RAgeWAKCsaQSAIphdLoNHHrfMRa46H+2lxACgkbNq
DnNDso9ug27Rxk7gWacg3Nc=
=cVYX
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
