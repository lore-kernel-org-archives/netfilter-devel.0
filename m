From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.4/2.5 ip_conntrack bugfix for LOCAL_NAT and PPTP
Date: Sun, 30 Mar 2003 21:51:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330195113.GW7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q/AGl/UrDvkbRExF"
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


--Q/AGl/UrDvkbRExF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Author: Paul Mielke <paulm@routefree.com>
This patch fixes a bug introduced with the LOCAL_NAT support of linux
kernels  >=3D 2.4.19, which caused a problem with locally-terminated
connections and certain NAT application helpers (esp. PPTP).

Please apply to 2.4.x and 2.5.x (applies cleanly to 2.5.66), thanks.


--- linux.old/net/ipv4/netfilter/ip_nat_standalone.c	Mon Feb 17 23:53:17 20=
03
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_standalone.c	Mon Feb 17 23:59:16=
 2003
@@ -109,12 +109,6 @@
 		}
 		/* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
 	case IP_CT_NEW:
-#ifdef CONFIG_IP_NF_NAT_LOCAL
-		/* LOCAL_IN hook doesn't have a chain and thus doesn't care
-		 * about new packets -HW */
-		if (hooknum =3D=3D NF_IP_LOCAL_IN)
-			return NF_ACCEPT;
-#endif
 		info =3D &ct->nat.info;
=20
 		WRITE_LOCK(&ip_nat_lock);
@@ -130,6 +124,12 @@
 				ret =3D call_expect(master_ct(ct), pskb,=20
 						  hooknum, ct, info);
 			} else {
+#ifdef CONFIG_IP_NF_NAT_LOCAL
+				/* LOCAL_IN hook doesn't have a chain!  */
+				if (hooknum =3D=3D NF_IP_LOCAL_IN) {
+					ret =3D NF_ACCEPT;
+				} else
+#endif
 				ret =3D ip_nat_rule_find(pskb, hooknum, in, out,
 						       ct, info);
 			}
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Q/AGl/UrDvkbRExF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+h0qxXaXGVTD0i/8RAu1KAKCXdtMUD7NLZHEhi9n7ctTYW1/XCACggLQR
e0M3+SkHzQ0trrxcj0pcewo=
=tAxd
-----END PGP SIGNATURE-----

--Q/AGl/UrDvkbRExF--
