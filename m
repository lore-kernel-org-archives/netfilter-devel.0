From: Harald Welte <laforge@gnumonks.org>
Subject: Re: New target 'ROUTE' - cvs patch
Date: Thu, 13 Jun 2002 18:05:34 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020613180534.L2543@sunbeam.de.gnumonks.org>
References: <1023799780.3120.56.camel@descartes>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0aF+6pWUK5w8WdCh"
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: =?iso-8859-1?Q?C=E9dric_de_Launois_=3Cdelaunoi=40info=2Eucl=2Eac=2Ebe?=@samba.org,
	=?iso-8859-1?Q?=3E?=@samba.org
Content-Disposition: inline
In-Reply-To: <1023799780.3120.56.camel@descartes>; from delaunoi@info.ucl.ac.be on Tue, Jun 11, 2002 at 02:49:40PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0aF+6pWUK5w8WdCh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2002 at 02:49:40PM +0200, C=E9dric de Launois wrote:
> Hi,
>=20
> Here is the patch against the current CVS tree to include the new
> target 'ROUTE'. The patches have been tested, they work fine for me.
> Doing
>    patch -p0 < ROUTE.cvs.patch
> in the same directory as netfilter/ should apply the patch correctly.

great. applied.

two minor modifications:

1) move it to 'extra', since we consider it as experimental at the moment.
2) remove your change to extensions/Makefile.  Only targets in the kernel
   (or to be submitted to the kernel soon) are in extensions/Makefile.

> C=E9dric de Launois

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

--0aF+6pWUK5w8WdCh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9CMLNXaXGVTD0i/8RAmL7AJ9Qcig5XP6QjnS4TOO6HSbis5YoDgCfaw7l
0nDranQ3+p/Bm1bf9IpHlx0=
=0sam
-----END PGP SIGNATURE-----

--0aF+6pWUK5w8WdCh--
