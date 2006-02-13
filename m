From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/4] nf_conntrack_ipv[4|6] load on demand for x_tables
	matches/targets, take #2
Date: Mon, 13 Feb 2006 12:15:13 +0100
Message-ID: <20060213111513.GS4601@sunbeam.de.gnumonks.org>
References: <43EFF1E0.8090102@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f4HxWLVbzokH9yio"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <43EFF1E0.8090102@netfilter.org>
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


--f4HxWLVbzokH9yio
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2006 at 03:41:36AM +0100, Pablo Neira Ayuso wrote:
> Thanks to Yasuyuki Kozakai for all the feedback.
>=20
> [NF_CONNTRACK] nf_conntrack_ipv[4|6] load on demand for x_tables
> matches/targets, take #2

this also looks fine to me, but might clash with some (unpublished?)
work of Patrick McHardy on putting mist of the checkfn/... stuff into
data structures. =20

Patrick? What about pushing your changes to net-2.6.17?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--f4HxWLVbzokH9yio
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8GpBXaXGVTD0i/8RAjq3AKCvFqR55TGCTmG9SKGPBzydvxLZMwCfYWEN
JWSRTd7FcUzoK6Bay1dNq1s=
=Krmx
-----END PGP SIGNATURE-----

--f4HxWLVbzokH9yio--
