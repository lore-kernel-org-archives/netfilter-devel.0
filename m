From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/3] CLUSTERIP: introduce reference counting for entries
Date: Fri, 23 Sep 2005 16:00:38 +0200
Message-ID: <20050923140038.GE731@sunbeam.de.gnumonks.org>
References: <20050830121535.985929000@nienna.balabit>
	<200508301726.08506@nienna>
	<20050913125405.GR29695@sunbeam.de.gnumonks.org>
	<200509131716.57282@nienna>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1C2QhcYtVTlNtC1j"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <200509131716.57282@nienna>
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


--1C2QhcYtVTlNtC1j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 13, 2005 at 05:16:57PM +0200, KOVACS Krisztian wrote:
> > as usual, the two days got a bit long.  But now I've reviewed the old
> > code and your changes.  I've applied them to my git tree with some
> > minor modifications/clarifications.
>=20
>   Thanks a lot. One more thing: what's up with the updated CLUSTERIP=20
> userspace?

submitted meanwhile.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1C2QhcYtVTlNtC1j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDNAqGXaXGVTD0i/8RAmLpAJ4ivJv0Zm3tGqlV6Sbw06PiyhLUJACeIitk
JL3wF8uzER1Qm57P10zB2hY=
=CAQu
-----END PGP SIGNATURE-----

--1C2QhcYtVTlNtC1j--
