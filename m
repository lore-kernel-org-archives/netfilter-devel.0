From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Patch for ULOG save
Date: Sun, 15 Sep 2002 13:23:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020915132329.I3810@sunbeam.de.gnumonks.org>
References: <1031930509.1663.8.camel@goofy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DLy7ErigvZFpjC4N"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jimmy Hedman <jimmy.hedman@southpole.se>
Content-Disposition: inline
In-Reply-To: <1031930509.1663.8.camel@goofy>; from jimmy.hedman@southpole.se on Fri, Sep 13, 2002 at 05:21:49PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DLy7ErigvZFpjC4N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2002 at 05:21:49PM +0200, Jimmy Hedman wrote:
> Hi,
> i found that ULOG target doesn't get saved right when doing a
> iptables-save so i created a small patch for it. The problem was that it
> wasn't putting "'s around ulog-prefix arguments.
> Patch attached is against 1.2.7a but the cvs tree seem to have the same
> problem.

thanks, patch applied.

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

--DLy7ErigvZFpjC4N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hG2xXaXGVTD0i/8RAjtNAKCDMtPpf7YBmWDkA1/yrzEYCq+I9QCfTxM0
VjPBC3zRf3ICb9S3x7zlVNg=
=Wr9/
-----END PGP SIGNATURE-----

--DLy7ErigvZFpjC4N--
