From: netfilter@interlinx.bc.ca
Subject: testing checksum in helpers is redundant with tcp_window_tracking
Date: Thu, 27 Feb 2003 17:21:55 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030227222154.GA9692@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
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


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Would it not be a good idea to have some kind of macro defined when
tcp_window_tracking in built into netfilter so that all of the helpers
and other code that are doing things like TCP checksum verification
and whatnot, can avoid wasting cycles doing it a second time?

Then helpers could wrap their tcp checksum calls with something like:

#ifndef TCP_WINDOW_TRACKING
=2E..
#endif

Or is a runtime check a better idea?  If so what test could be done at
runtime to know that tcp_window_tracking is checking TCP checksums?

b.

--=20
Brian J. Murrell

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+Xo+Cl3EQlGLyuXARAqcLAJ9WsAwNwRM/U4DK6OTygKGe6ZTfJwCfQFbo
n5vZSMtu/BzZHwBeoeuHkKs=
=jG7Q
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
