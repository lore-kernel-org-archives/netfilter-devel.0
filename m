From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] DSCP match/target patches
Date: Tue, 11 Jun 2002 09:41:30 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020611094130.E11177@sunbeam.de.gnumonks.org>
References: <20020610135311.246C1453D@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <zenadsl3030@zen.co.uk>
Content-Disposition: inline
In-Reply-To: <20020610135311.246C1453D@lists.samba.org>; from zenadsl3030@zen.co.uk on Mon, Jun 10, 2002 at 01:49:13PM +0000
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2002 at 01:49:13PM +0000, zenadsl3030@zen.co.uk wrote:
> Hi,
>=20
> Here is a simple patch to the DSCP match to allow the use of DiffServ cla=
ss
> names in the matches, in a similar manner to the target.
>=20
> Also attached is a one line fix for a typo in the DSCP target where CS6 w=
as
> defined twice in the match list.

thanks for your contribution.  What about putting all the class name <->
numerical resolving in a seperate .c file, which is then compiled once and
linked into both libipt_dscp.so and libipt_DSCP.so ?

I think this would be the ideal case, without any code duplication.

> Iain

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9BamqXaXGVTD0i/8RAsRtAJ92kbAp/htQNtOYlnuTrujrsEX0nACghqe4
oJ1cohOctU6J43wiRya0wjo=
=+A4Q
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
