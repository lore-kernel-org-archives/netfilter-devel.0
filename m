From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [patch] REJECT incorrectly inherits the current nfmark to the generated RST packet
Date: Fri, 14 Jun 2002 09:55:24 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020614095524.E2543@sunbeam.de.gnumonks.org>
References: <20020613175053.J2543@sunbeam.de.gnumonks.org> <200206131931.23688.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LP3HGykwGcUp63ex"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200206131931.23688.hno@marasystems.com>; from hno@marasystems.com on Thu, Jun 13, 2002 at 07:31:23PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LP3HGykwGcUp63ex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2002 at 07:31:23PM +0200, Henrik Nordstrom wrote:
> I have a smal patch not yet sent..
>=20
> REJECT incorrecly inherits the current nfmark to the generated packet,=20
> inhibiting mangle from rerouting the generated RST packet correcly if=20
> attempting to set the same mark as the original packet that was REJECT:ed.

hm. this is in fact a bug.  It might depend on one's point of view, and may=
be
there was a particular reason for the way it is currently implemented.

As far as I don't receive any complaints, I will submit this patch to the
kernel soon.  For now, it can be found in patch-o-matic/pending/

> Henrik

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

--LP3HGykwGcUp63ex
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9CaFsXaXGVTD0i/8RAqO6AKCcIIJlzrWUVIJ0ceI2k+An6jX++ACcCO0c
gJfM44DjB1vp4es6w3dcmFg=
=2V+z
-----END PGP SIGNATURE-----

--LP3HGykwGcUp63ex--
