From: Harald Welte <laforge@gnumonks.org>
Subject: Re: (no subject)
Date: Thu, 6 Jun 2002 07:41:16 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606074116.F28940@sunbeam.de.gnumonks.org>
References: <F591WZJ4kidNwZNDmb4000152bf@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Saaid Anwar Khan" <saaidak@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F591WZJ4kidNwZNDmb4000152bf@hotmail.com>; from saaidak@hotmail.com on Wed, Jun 05, 2002 at 12:49:05PM +0500
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2002 at 12:49:05PM +0500, Saaid Anwar Khan wrote:
> hello
>=20
> i would like to knnow the source and destination port in user space packe=
t=20
> provided by the libipq library.

you have the packet in userspace. just read out the values from the IP/TCP
header.

> Thank you
> Saaid Anwar Khan

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

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE8/vX8XaXGVTD0i/8RAmIBAJkBsyWkIXzAtkFS0sJx+bFxoi6rqQCfbXlq
WV5+k4HDmvrLO3gfdrvFnW0=
=ea2f
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--
