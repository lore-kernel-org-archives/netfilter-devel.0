From: Harald Welte <laforge@netfilter.org>
Subject: pserver.netfilter.org CVS tree reorganization
Date: Fri, 9 Jan 2004 14:29:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040109132906.GK31820@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+9faIjRurCDpBc7U"
Cc: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+9faIjRurCDpBc7U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As many of you will have noticed already, I took the liberty to reorganize
the CVS tree structure.  This was needed to get a better seperation
between independent parts of the project. =20

pserver.netfilter.org:/cvspublic now has the following modules:

iptables
	this is what netfilter/userspace used to be

pkttables
	this is what netfilter/iptables2 used to be.

patch-o-matic-ng
	this is the new patch-o-matic, used to live below=20
	/netfilter, too.

documentation
	this is the FAQ's and HOWTO's, used to be
	/netfilter/documentation

homepage
	this is the new docbook-website homepage, used to be
	/netfilter/homepage-xml

security-advisories
	a seperate, new module containing text files of the security
	advisories.  http://www.netfilter.org/security/* is built=20
	from those text files.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+9faIjRurCDpBc7U
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE//qyiXaXGVTD0i/8RAljAAJwPPyIgJxecYNO2byb/FsqkM9qxAgCfZNsa
3byyZPnsqUqTrMifXBajs2s=
=EkZm
-----END PGP SIGNATURE-----

--+9faIjRurCDpBc7U--
