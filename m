From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] Restructuring patch-o-matic-ng
Date: Mon, 27 Jun 2005 10:54:35 +0200
Message-ID: <20050627085433.GA19928@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NJ5+aVN4Egd/eJfU"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--NJ5+aVN4Egd/eJfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I've just moved all the patchlet-directories of patch-o-matic-ng from
https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/*
to their future location below
https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/patchlets

The idea is not just to annoy all users, but to clean it up further and
allow for other stuff (such as pom2patch and patch2pom) to reside in the
same directory without coding kludgy exemptions into the
Netfilter_POM.pm code.

Sorry, but I didn't find any other clean solution...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NJ5+aVN4Egd/eJfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCv77JXaXGVTD0i/8RAk1bAJ9dYR3AX+9mpXg2wDlpx6/qQuGTVACdEUpV
a5TIumoiaNv5hLcIpeE/ej8=
=Kvee
-----END PGP SIGNATURE-----

--NJ5+aVN4Egd/eJfU--
