From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] ip_conntrack_ftp.c: cosmetic typo fix in debug macro
Date: Thu, 9 Jan 2003 15:51:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109145154.GL9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwwPlZPbpBX9O0Yk"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--rwwPlZPbpBX9O0Yk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is another patch of the series of patches you will receive from me tod=
ay.

Please apply to 2.4.x and 2.5.x, thanks.


Author: Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Cosmetic Fix:
Fixes a typo in a DEBUG statement (which is contained in an "#if 0" block,
so this would never end up causing a problem). =20


diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.4.20-plain/net/ipv4=
/netfilter/ip_conntrack_ftp.c linux-2.4.20-debugftp/net/ipv4/netfilter/ip_c=
onntrack_ftp.c
--- linux-2.4.20-plain/net/ipv4/netfilter/ip_conntrack_ftp.c	Fri Nov 29 00:=
53:15 2002
+++ linux-2.4.20-debugftp/net/ipv4/netfilter/ip_conntrack_ftp.c	Wed Jan  8 =
12:02:28 2003
@@ -200,9 +200,9 @@
=20
 		DEBUGP("ftp: string mismatch\n");
 		for (i =3D 0; i < plen; i++) {
-			DEBUGFTP("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
-				 i, data[i], data[i],
-				 pattern[i], pattern[i]);
+			DEBUGP("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
+				i, data[i], data[i],
+				pattern[i], pattern[i]);
 		}
 #endif
 		return 0;

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--rwwPlZPbpBX9O0Yk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HYyKXaXGVTD0i/8RAjL8AKCE6CqYDM4U3FfCwFs+hqCjZon4BQCdGojR
hGCcLJ8AXxNdcI88B7SD1g4=
=X7kv
-----END PGP SIGNATURE-----

--rwwPlZPbpBX9O0Yk--
