From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] iptables-1.2.8 feature freeze
Date: Sun, 30 Mar 2003 22:23:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330202322.GA7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qD80nKKiJWXm4UaL"
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


--qD80nKKiJWXm4UaL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi my fellow netfilter users ;)

iptbles-1.2.8 has been overdue for at least a couple of months now.  I'm
starting to get lots of bug reports for stuff that is fixed in CVS for
half a year.

I'm now officially announcing a feature freeze for the 1.2.8 iptables
release. =20

Please test the CVS snapshot of today (will be published in 2 hours,
just before midnight german time). The snapshot will be available at
ftp://ftp.netfilter.org/pub/iptables/snapshot/iptables-1.2.7a-20030330.tar.=
bz2

Report any bugs you encounter to http://bugzilla.netfilter.org/.

Apart from that, I will refuse to include any new features (for iptables
userspace) for 7 days; expect iptables-1.2.8 to come up at April 6,
2003.

Thanks for your patience,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qD80nKKiJWXm4UaL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+h1I6XaXGVTD0i/8RAkwZAJ92ATcDMjZaw0XMr1E+zjOGAl2LsQCeI5f+
B9UTrebeKllMwhcF3f9//lQ=
=Y91H
-----END PGP SIGNATURE-----

--qD80nKKiJWXm4UaL--
