From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Wed, 25 Feb 2004 19:28:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040225182828.GP13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dUCTBDm4d+mXXNar"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>
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


--dUCTBDm4d+mXXNar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I've been trying to finish patch-o-matic-ng during the last week.  At
least for 2.6.x kernels (specifically: 2.6.3) it seems to work just
fine.  It doesn't offer you any patches that are incompatible with 2.6
or have not yet been ported.

However, more testing is definitely needed before an official release.

This is where you come in :)  If you want to help, please grab the
latest patch-o-matic-ng, either from CVS or as snapshot.  Do some
testing, especially with 2.4.x kernels.

If you end up in any strange behaviour (like .rej rejects in the kernel
tree, patches that apply cleanly but don't compile, patches that apply
and compile cleanly but crash the machine, ...) - please report it back
to the netfilter-devel mailinglist.

btw: It might be advisable to use ftp/www mirrors like
ftp.hu.netfilter.org /   www.hu.netfilter.org , since tomorrow is a
scheduled downtime of the main netfilter site.

Thanks,
	Harald.

p.s.: Yes, the nf_log patch does currently not apply against 2.6.x.
This is know, and not really a bug since it fails gracefully.  Somebody
just needs to updat it. =20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dUCTBDm4d+mXXNar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAPOlMXaXGVTD0i/8RAl/AAJ42I0E5WpGZf8b45b+7wVsp5cIe9ACgstKG
CzQ+rdWB9yappsNsT1HDXLg=
=qyBB
-----END PGP SIGNATURE-----

--dUCTBDm4d+mXXNar--
