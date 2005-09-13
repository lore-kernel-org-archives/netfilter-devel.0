From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/3] CLUSTERIP: introduce reference counting for entries
Date: Tue, 13 Sep 2005 14:54:05 +0200
Message-ID: <20050913125405.GR29695@sunbeam.de.gnumonks.org>
References: <20050830121535.985929000@nienna.balabit>
	<20050830121550.397433000@nienna.balabit>
	<20050830140740.GC4221@rama.de.gnumonks.org>
	<200508301726.08506@nienna>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHrxbAcqt/LxKPZN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <200508301726.08506@nienna>
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


--eHrxbAcqt/LxKPZN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2005 at 05:26:07PM +0200, KOVACS Krisztian wrote:
>=20
>   Hi,
>=20
> On Tuesday 30 August 2005 16.07, Harald Welte wrote:
> > Thanks for your patches 2 and 3.  I want to review them in more
> > detail and need to re-read the CLUSTERIP code first.  Expect some
> > feedback in the next two days.
>=20
>   OK, thanks. BTW, I've just found a serious bug in patch 2, I knew I
> was missing something... So please apply this on top of patch 2.
=20
as usual, the two days got a bit long.  But now I've reviewed the old
code and your changes.  I've applied them to my git tree with some minor
modifications/clarifications.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eHrxbAcqt/LxKPZN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDJsvtXaXGVTD0i/8RAsWDAJ44qbeJE2pm613sPX6iEhuWXzywMwCeLdCV
WZeYav+ptF2tOzqT2TfoAZQ=
=U15D
-----END PGP SIGNATURE-----

--eHrxbAcqt/LxKPZN--
