From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] Fix logging of SIT tunnels in ip6t_LOG
Date: Mon, 14 Oct 2002 13:30:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014133050.P13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zd5GkkQQtETumrwc"
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


--zd5GkkQQtETumrwc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Below is a patch (by Andras Kis-Szabo) fixing the ip6tabels LOG target in o=
rder
to correctly display the IPv4 encapsulation when SIT is used.

Please apply, thanks.


--- linux-2.4.18.hoi.1.1/net/ipv6/netfilter/ip6t_LOG.c	Sat Mar 23 17:31:38 =
2002
+++ linux/net/ipv6/netfilter/ip6t_LOG.c	Tue Apr  2 23:25:12 2002
@@ -289,12 +289,39 @@
 		/* MAC logging for input chain only. */
 		printk("MAC=3D");
 		if ((*pskb)->dev && (*pskb)->dev->hard_header_len && (*pskb)->mac.raw !=
=3D (void*)ipv6h) {
-			int i;
-			unsigned char *p =3D (*pskb)->mac.raw;
-			for (i =3D 0; i < (*pskb)->dev->hard_header_len; i++,p++)
+			if ((*pskb)->dev->type !=3D ARPHRD_SIT){
+			  int i;
+			  unsigned char *p =3D (*pskb)->mac.raw;
+			  for (i =3D 0; i < (*pskb)->dev->hard_header_len; i++,p++)
 				printk("%02x%c", *p,
-				       i=3D=3D(*pskb)->dev->hard_header_len - 1
-				       ? ' ':':');
+			       		i=3D=3D(*pskb)->dev->hard_header_len - 1
+			       		? ' ':':');
+			} else {
+			  int i;
+			  unsigned char *p =3D (*pskb)->mac.raw;
+			  if ( p - (ETH_ALEN*2+2) > (*pskb)->head ){
+			    p -=3D (ETH_ALEN+2);
+			    for (i =3D 0; i < (ETH_ALEN); i++,p++)
+				printk("%02x%s", *p,
+					i =3D=3D ETH_ALEN-1 ? "->" : ":");
+			    p -=3D (ETH_ALEN*2);
+			    for (i =3D 0; i < (ETH_ALEN); i++,p++)
+				printk("%02x%c", *p,
+					i =3D=3D ETH_ALEN-1 ? ' ' : ':');
+			  }
+			 =20
+			  if (((*pskb)->dev->addr_len =3D=3D 4) &&
+			      (*pskb)->dev->hard_header_len > 20){
+			    printk("TUNNEL=3D");
+			    p =3D (*pskb)->mac.raw + 12;
+			    for (i =3D 0; i < 4; i++,p++)
+				printk("%3d%s", *p,
+					i =3D=3D 3 ? "->" : ".");
+			    for (i =3D 0; i < 4; i++,p++)
+				printk("%3d%c", *p,
+					i =3D=3D 3 ? ' ' : '.');
+			  }
+			}
 		} else
 			printk(" ");
 	}
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--zd5GkkQQtETumrwc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qqrpXaXGVTD0i/8RAjo8AJ9yPzWA5iEn8jfFPTuLVB3/lTVENwCePcSy
oOk7Mh14HKnFK70h8s8TIyg=
=4K5s
-----END PGP SIGNATURE-----

--zd5GkkQQtETumrwc--
