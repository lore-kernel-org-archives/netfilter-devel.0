From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] ip_conntrack_irc update
Date: Thu, 2 Oct 2003 16:45:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002144525.GI5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cQHT7pPGdkbGIWPi"
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


--cQHT7pPGdkbGIWPi
Content-Type: multipart/mixed; boundary="N77v08gAD5x46FmO"
Content-Disposition: inline


--N77v08gAD5x46FmO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.4 tree and push it to Marcelo.
Thanks.


Author: Tiago Sousa <mirage@kaotik.org>
Status: pending for kernel inclusion

Add support for mIRC's "server lookup" DCC address detection to
ip_conntrack_irc.c

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--N77v08gAD5x46FmO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="65_irc-conntrack-mirc-serverlookup.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/net/ipv4/netfilter/ip_conntrack_irc.c.orig	2003-09-03 22:03:22.00=
0000000 +0100
+++ linux/net/ipv4/netfilter/ip_conntrack_irc.c	2003-09-03 22:54:11.0000000=
00 +0100
@@ -192,7 +192,10 @@
 			DEBUGP("DCC bound ip/port: %u.%u.%u.%u:%u\n",
 				HIPQUAD(dcc_ip), dcc_port);
=20
-			if (ct->tuplehash[dir].tuple.src.ip !=3D htonl(dcc_ip)) {
+			/* dcc_ip can be the internal OR external (NAT'ed) IP
+			 * Tiago Sousa <mirage@kaotik.org> */
+			if (ct->tuplehash[dir].tuple.src.ip !=3D htonl(dcc_ip)
+			    && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip !=3D htonl(dcc_ip)) {
 				if (net_ratelimit())
 					printk(KERN_WARNING
 						"Forged DCC command from "
@@ -218,7 +218,7 @@
=20
 			exp->tuple =3D ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
-				  { htonl(dcc_ip), { .tcp =3D { htons(dcc_port) } },
+				  { ct->tuplehash[dir].tuple.src.ip, { .tcp =3D { htons(dcc_port) } },
 				    IPPROTO_TCP }});
 			exp->mask =3D ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },

--N77v08gAD5x46FmO--

--cQHT7pPGdkbGIWPi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDoFXaXGVTD0i/8RAuDmAJ9/yOD9Fm/G73kjwv27SOTUzc+cKQCbB1de
zDIt2vTFx+dvIdxY8cXQr/4=
=f5UW
-----END PGP SIGNATURE-----

--cQHT7pPGdkbGIWPi--
