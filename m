From: Harald Welte <laforge@gnumonks.org>
Subject: [ANNOUNCE] netfilter/iptables Anonymous CVS has been moved
Date: Thu, 20 Jun 2002 21:38:08 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020620213808.X2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="88ivsf4xsnd8HFHJ"
Cc: Netfilter Mailinglist <netfilter@lists.samba.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-announce@lists.samba.org
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


--88ivsf4xsnd8HFHJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The anonymous CVS repository for the netfilter/iptables project has been
moved.

Please don't use the old (pserver.samba.org) repository anymore, since it
is no longer updated and will run out of date very soon.

The new location for accessing the netfilter/iptables sourcecode via=20
anonymous CVS repository is:

cvs -d:pserver:cvs@pserver.netfilter.org:/cvspublic login
cvs -d:pserver:cvs@pserver.netfilter.org:/cvspublic co netfilter/userspace

Or if you want to check out the full repository, including homepage, HOWTO
sources, etc.:

cvs -d:pserver:cvs@pserver.netfilter.org:/cvspublic login
cvs -d:pserver:cvs@pserver.netfilter.org:/cvspublic co netfilter

Please also note that the URL for CVSweb access has changed:

http://cvs.netfilter.org/


Thanks!

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

--88ivsf4xsnd8HFHJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9Ei8gNfqJzMqajVsRApjdAJ4iK6VDVYZGE7yb0PJE7e3ZvKfUeQCgxaE2
B/gdBjztbmVoJECT2dL7NcU=
=KwGZ
-----END PGP SIGNATURE-----

--88ivsf4xsnd8HFHJ--
