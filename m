From: Tom Marshall <tommy@home.tig-grr.com>
Subject: Experimental RTSP modules
Date: Sat, 5 Apr 2003 19:24:36 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030406032436.GA23002@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Cc: netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Please note this is an experimental module.  It works for me.  It may work
for you, it may panic your kernel, or it may just sit there using ram.

Features:

 * Detects STUN and stays out of the way.
 * Understands proposed client_port=3DM/N syntax.
 * There is a configurable policy for the destination parameter.

TODO:

 * Handle multiple SETUP messages in a single packet.
 * Un-mangle client_port on return trip.
 * IPv6 modules
 * Much more...

This should work with 2.4.20 and all of 2.4.21-pre# series up to and
including pre7, at least.  It should not work with 2.4.19 or prior.  I am
making _no_ attempt to do p-o-m or non-kernel iptables support.  Others may
feel free if they wish (hey, it's GPL).

The diff was prepared against 2.4.21-pre6.  Please use the "-p1" option to
patch(1) for proper application:

        # cd linux-2.4.21-pre7
        # cat ../nf-rtsp.diff | patch -p1

Comments (especially bug reports and success reports) welcome.

Hints about IPv6 conntrack and nat modules very appreciated (why is there no
IRC or FTP modules for IPv6?)

	http://home.tig-grr.com/nf-rtsp.diff

--=20
To use violence is to already be defeated.
        -- Chinese proverb

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iEYEARECAAYFAj6PnfQACgkQFMm9uvwPXW7X3gCdGY7RfnEkOe/UXOtgtb3DeqHL
u+EAn0tcIAbET/9qIq1cKXrX0j92A9z3
=nQPY
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
