From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] ip_conntrack_irc update
Date: Thu, 2 Oct 2003 18:11:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002161154.GP5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0gg0sgNGafRAmBWE"
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


--0gg0sgNGafRAmBWE
Content-Type: multipart/mixed; boundary="bHonY5HBNyfnaPxm"
Content-Disposition: inline


--bHonY5HBNyfnaPxm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree, thanks.


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

--bHonY5HBNyfnaPxm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="82_irc-conntrack-mirc-serverlookup.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.0-test6-plain/net/ipv4/netfilter/ip_conntrack_irc.c	2003-09-2=
8 02:50:39.000000000 +0200
+++ linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_conntrack_irc.c	2003-1=
0-02 18:22:31.000000000 +0200
@@ -177,7 +177,10 @@
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
@@ -201,7 +204,7 @@
=20
 			exp->tuple =3D ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
-				  { htonl(dcc_ip), { .tcp =3D { htons(dcc_port) } },
+				  { ct->tuplehash[dir].tuple.src.ip, { .tcp =3D { htons(dcc_port) } },
 				    IPPROTO_TCP }});
 			exp->mask =3D ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },

--bHonY5HBNyfnaPxm--

--0gg0sgNGafRAmBWE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fE5KXaXGVTD0i/8RAhPbAJ9uljqG7H57SidpjI6oEixPCjgfigCfZAx6
2yECTHtlSqZxFhH1y/d07cg=
=rrlr
-----END PGP SIGNATURE-----

--0gg0sgNGafRAmBWE--
