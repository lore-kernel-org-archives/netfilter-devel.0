From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] DSCP match/target patches
Date: Fri, 21 Jun 2002 19:28:29 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020621192829.I2543@sunbeam.de.gnumonks.org>
References: <20020610135311.246C1453D@lists.samba.org> <20020611094130.E11177@sunbeam.de.gnumonks.org> <1024336232.1301.3.camel@desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IaBBgDMWciIyOY7c"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Iain Barnes <zenadsl3030@zen.co.uk>
Content-Disposition: inline
In-Reply-To: <1024336232.1301.3.camel@desktop>; from zenadsl3030@zen.co.uk on Mon, Jun 17, 2002 at 06:50:32PM +0100
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IaBBgDMWciIyOY7c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2002 at 06:50:32PM +0100, Iain Barnes wrote:
> Harald
>=20
> The only thing missing is the Makefile modifications. My knowledge of
> the fine art of Makefile writing is sorely lacking, so any help on that
> front, from anybody, would be greatly appreciated.

I've now managed to solve the problem without Makefile modifications.
Feel free to look at the current CVS code :)

> Iain=20

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

--IaBBgDMWciIyOY7c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9E2I9XaXGVTD0i/8RAuN9AJ9osXU4CIgFkDSBPWcSCKNnncqwKgCaA4XT
M+gAXlPUxDbAjMUIVhGZBuY=
=tGz5
-----END PGP SIGNATURE-----

--IaBBgDMWciIyOY7c--
