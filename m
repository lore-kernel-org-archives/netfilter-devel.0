From: Harald Welte <laforge@netfilter.org>
Subject: [ADMIN] netfilter.org CVS now converted to subversion
Date: Thu, 7 Oct 2004 18:46:28 +0200
Sender: netfilter-bounces@lists.netfilter.org
Message-ID: <20041007164628.GN13901@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0kRkyLZR5zsR9u2P"
Cc: netfilter@lists.netfilter.org, netfilter-announce@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--0kRkyLZR5zsR9u2P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Important Announcement!

The netfilter.org CVS server (pserver.netfilter.org) has been deprecated
by the new subversion repository at svn.netfilter.org.  More information
about the subversion revision control system can be found at
http://subversion.tigris.org/.

Everybody has read-only access to the new subversion tree using either
svn+http or svn+https. We do not provide the native svn protocol.

The respective URL's for the root of the tree are:

	https://svn.netfilter.org/netfilter
	http://svn.netfilter.org/netfilter

The CVSweb/ViewCVS interface at http://cvs.netfilter.org/ now points to
the subversion tree, as does the http://svn.netfilter.org/ URL.

The old CVS tree will be available for 30 days, so people can still
create patches from their changes by using 'cvs diff'.  Startin from
November 7, 2004 the CVS pserver service will be deactivated.

The CVS changelog mailinglist and the snapshot scripts for providing
iptables and patch-o-matic snapshots have not yet been converted to
subversion.  They are expected to come back until Sunday, 10 Oct 2004.

In case you experience any problems, feel free to contact me.

Happy Hacking,
	Harald Welte, for the Netfilter Core Team.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0kRkyLZR5zsR9u2P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBZXLkXaXGVTD0i/8RAuCiAJ0ZHVw+MiHu4z7OETg6wWhMdCFq7wCfZKg9
v/wuns7QaOQudKSWZL7LbY8=
=DDPE
-----END PGP SIGNATURE-----

--0kRkyLZR5zsR9u2P--
