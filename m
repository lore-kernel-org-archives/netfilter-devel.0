From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: don't flush MASQ if IP didn't change
Date: Sun, 30 Nov 2003 18:11:45 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130124145.GC26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
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


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This mail contains the second netfilter patch, please apply.


Author: Rusty Russell <rusty@rustcorp.com.au>
Status: Testing, already submitted to 2.6

Herve Eychenne noted that many ADSL connections get the same
address when the interface comes back up, so some users use SNAT
instead of masquerade.  The answer is that MASQUERADE should only
drop connections when the interface comes up, and then only if the
interface address has actually changed.


diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22-plain/net/ipv4/netfilt=
er/ipt_MASQUERADE.c linux-2.4.22-masq_noflush/net/ipv4/netfilter/ipt_MASQUE=
RADE.c
--- linux-2.4.22-plain/net/ipv4/netfilter/ipt_MASQUERADE.c	2001-09-30 21:26=
:08.000000000 +0200
+++ linux-2.4.22-masq_noflush/net/ipv4/netfilter/ipt_MASQUERADE.c	2003-09-1=
2 21:52:27.000000000 +0200
@@ -116,63 +116,37 @@
 }
=20
 static inline int
-device_cmp(const struct ip_conntrack *i, void *ifindex)
+device_cmp(const struct ip_conntrack *i, void *_ina)
 {
-	int ret;
+	int ret =3D 0;
+	struct in_ifaddr *ina =3D _ina;
=20
 	READ_LOCK(&masq_lock);
-	ret =3D (i->nat.masq_index =3D=3D (int)(long)ifindex);
+	/* If it's masquerading out this interface with a different address,
+	 * or we don't know the new address of this interface. */
+	if (i->nat.masq_index =3D=3D ina->ifa_dev->dev->ifindex
+	    && i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip !=3D ina->ifa_address)
+		ret =3D 1;
 	READ_UNLOCK(&masq_lock);
=20
 	return ret;
 }
=20
-static int masq_device_event(struct notifier_block *this,
-			     unsigned long event,
-			     void *ptr)
-{
-	struct net_device *dev =3D ptr;
-
-	if (event =3D=3D NETDEV_DOWN) {
-		/* Device was downed.  Search entire table for
-		   conntracks which were associated with that device,
-		   and forget them. */
-		IP_NF_ASSERT(dev->ifindex !=3D 0);
-
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
-	}
-
-	return NOTIFY_DONE;
-}
-
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	struct net_device *dev =3D ((struct in_ifaddr *)ptr)->ifa_dev->dev;
-
-	if (event =3D=3D NETDEV_DOWN) {
-		/* IP address was deleted.  Search entire table for
-		   conntracks which were associated with that device,
-		   and forget them. */
-		IP_NF_ASSERT(dev->ifindex !=3D 0);
-
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
-	}
+	/* For some configurations, interfaces often come back with
+	 * the same address.  If not, clean up old conntrack
+	 * entries. */
+	if (event =3D=3D NETDEV_UP)
+		ip_ct_selective_cleanup(device_cmp, ptr);
=20
 	return NOTIFY_DONE;
 }
=20
-static struct notifier_block masq_dev_notifier =3D {
-	masq_device_event,
-	NULL,
-	0
-};
-
 static struct notifier_block masq_inet_notifier =3D {
-	masq_inet_event,
-	NULL,
-	0
+	.notifier_call =3D masq_inet_event
 };
=20
 static struct ipt_target masquerade
@@ -185,12 +159,9 @@
=20
 	ret =3D ipt_register_target(&masquerade);
=20
-	if (ret =3D=3D 0) {
-		/* Register for device down reports */
-		register_netdevice_notifier(&masq_dev_notifier);
+	if (ret =3D=3D 0)
 		/* Register IP address change reports */
 		register_inetaddr_notifier(&masq_inet_notifier);
-	}
=20
 	return ret;
 }
@@ -198,7 +169,6 @@
 static void __exit fini(void)
 {
 	ipt_unregister_target(&masquerade);
-	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);=09
 }
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yeWfXaXGVTD0i/8RAk61AJ0RoZbpFoPOTCchoTzc+gRAKA18/wCgm1X/
XeEWfNzSjGqWinJkxc2kmmw=
=vuu8
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
