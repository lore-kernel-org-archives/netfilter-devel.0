From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] ipt_REJECT shouldn't send replies for wrong udp csum
Date: Thu, 9 Jan 2003 15:47:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109144750.GJ9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3h+hNn3PVp185ISI"
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


--3h+hNn3PVp185ISI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is another patch of the series of patches you will receive from me tod=
ay.

Please apply to 2.4.x and 2.5.x, thanks.

Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
As 2.4.20 came out with newnat included, there were several reports on
excessive logging of reused FTP expectations.

The patch fixes the problem by separating the two possible cases:
when the conntrack helper is registered with the reuse flag enabled, then
the logging is converted to debugging (not enabled by default), otherwise
the logging is kept to notify the admin on the violation of the given proto=
col.


diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.4.20-plain/net/ipv4=
/netfilter/ip_conntrack_core.c linux-2.4.20-ftp/net/ipv4/netfilter/ip_connt=
rack_core.c
--- linux-2.4.20-plain/net/ipv4/netfilter/ip_conntrack_core.c	Fri Nov 29 00=
:53:15 2002
+++ linux-2.4.20-ftp/net/ipv4/netfilter/ip_conntrack_core.c	Tue Jan  7 19:4=
3:29 2003
@@ -966,23 +966,28 @@
 		   related_to->expecting >=3D related_to->helper->max_expected) {
 		struct list_head *cur_item;
 		/* old =3D=3D NULL */
-	    	if (net_ratelimit())
-		    	printk(KERN_WARNING=20
-		    	       "ip_conntrack: max number of expected "
-			       "connections %i of %s reached for "
-			       "%u.%u.%u.%u->%u.%u.%u.%u%s\n",
-		    	       related_to->helper->max_expected,=20
-		    	       related_to->helper->name,
-		    	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.=
ip),
-		    	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.=
ip),
-		    	       related_to->helper->flags & IP_CT_HELPER_F_REUSE_EXPECT ?
-		    	       ", reusing" : "");
 		if (!(related_to->helper->flags &=20
 		      IP_CT_HELPER_F_REUSE_EXPECT)) {
 			WRITE_UNLOCK(&ip_conntrack_lock);
+ 		    	if (net_ratelimit())
+ 			    	printk(KERN_WARNING
+				       "ip_conntrack: max number of expected "
+				       "connections %i of %s reached for "
+				       "%u.%u.%u.%u->%u.%u.%u.%u\n",
+				       related_to->helper->max_expected,
+				       related_to->helper->name,
+ 		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].t=
uple.src.ip),
+ 		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].t=
uple.dst.ip));
 			return -EPERM;
 		}
-
+		DEBUGP("ip_conntrack: max number of expected "
+		       "connections %i of %s reached for "
+		       "%u.%u.%u.%u->%u.%u.%u.%u, reusing\n",
+ 		       related_to->helper->max_expected,
+		       related_to->helper->name,
+		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
+		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
+=20
 		/* choose the the oldest expectation to evict */
 		list_for_each(cur_item, &related_to->sibling_list) {=20
 			struct ip_conntrack_expect *cur;

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--3h+hNn3PVp185ISI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HYuWXaXGVTD0i/8RAhYUAJ9dKKtRBcBqCed8poToCdGHZzEGzwCgroZg
Km7LqmuPA/gPXdFxdAsuNCI=
=v9U9
-----END PGP SIGNATURE-----

--3h+hNn3PVp185ISI--
