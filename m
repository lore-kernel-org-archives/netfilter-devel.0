From: Harald Welte <laforge@gnumonks.org>
Subject: [ANNOUNCE] More info about new netfilter.org site
Date: Thu, 20 Jun 2002 21:12:42 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020620211242.V2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AMjohP+sXfBv/Fra"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: coreteam@netfilter.org, webmaster@netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--AMjohP+sXfBv/Fra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As previously stated, I've now finished moving all services from
coruscant.netfilter.org AKA netfilter.gnumonks.org to the new machine,
called kashyyyk.netfilter.org.

All user accounts have been moved, including their respective home director=
ies.

This means you should be able to log in as usual, just a different hostname.

For access to the developer CVS tree, please use the following repository:

cvs -essh -dusername@cvs.netfilter.org:/cvsroot co netfilter


For access to the anonymous CVS tree, the following cmd's can be used
[homepage will be updated accordingly]:

cvs -d:pserver:cvs@pserver.netfilter.org:/cvspublic login
cvs -d:pserver:cvs@pserver.netfilter.org:/cvspublic co netfilter


The scripts for the homepage update process will be changed accordingly.

As moving the mailinglists involves some more [synchronized with samba.org]
action, I'm going to postpone this until I'm back to Europe (about 15th of=
=20
July].

If you encounter any trouble or have any further questions, please feel fre=
e to
contact me.

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

--AMjohP+sXfBv/Fra
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9EikpXaXGVTD0i/8RAjG0AJ4xhP+Y7rOZZ7Nikqunkk7qJfxz4ACZAcAh
j1mkhUT0KOwL1QKvDeSNBe8=
=4lMS
-----END PGP SIGNATURE-----

--AMjohP+sXfBv/Fra--
