From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 00:55:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127235525.GG11761@sunbeam.de.gnumonks.org>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tQHaQFR6K/xpRpl8"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>, Willy Tarreau <willy@w.ods.org>,
	Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040127130739.GR11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tQHaQFR6K/xpRpl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I've now hacked a preliminary patch.  Be warned, I didn't even test if
it compiles.  Maybe someone who actually has a running 2.6.x ipsec setup
can give it a try.

What it should be doing
- traverse the additional chains as described in the last email
- have connection tracking recognize two seperate connections, one
  for the decapsulated traffic, one for the encapsulated
- thus, even SNAT/DNAT should be working.
- locally-encapsulated traffic shows up with input device "ah4" or
  "esp4" in POSTROUTING.
- locally-encapsulated traffic shows up with output device "ah4" or
  "esp4" in OUTPUT.

What is missing (TODO):
- no dummy device names in INPUT/PREROUTING for locally-decapsulated
  packets.  This is somewhat harder
- no real output device shown in OUTPUT for locally-encapsulated
  packets.  I'm not sure if it is legal to typecast the just-popped
  dst_entry to 'struct rtable' and derive the output interface from
  there.

Please give feedback.

P.S.: Yes, the #ifdef's are ugly. I know.


diff -Nru linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/ah4.c linuxppc25=
bh-031218-orinoco_monitor-gpl-netfipsec/net/ipv4/ah4.c
--- linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/ah4.c	2003-12-18 11:39=
:26.000000000 +0100
+++ linuxppc25bh-031218-orinoco_monitor-gpl-netfipsec/net/ipv4/ah4.c	2004-0=
1-28 00:40:38.923531384 +0100
@@ -9,6 +9,12 @@
 #include <net/icmp.h>
 #include <asm/scatterlist.h>
=20
+static struct net_device *ah_dummydev;
+
+static int ah_xmit_bypass(struct sk_buff *skb)
+{
+	return NET_XMIT_BYPASS;
+}
=20
 /* Clear mutable options and find final destination to substitute
  * into IP header for icv calculation. Options are already checked
@@ -54,7 +60,7 @@
 	return 0;
 }
=20
-static int ah_output(struct sk_buff *skb)
+static int ah_output_finish(struct sk_buff *skb)
 {
 	int err;
 	struct dst_entry *dst =3D skb->dst;
@@ -145,7 +151,17 @@
 		err =3D -EHOSTUNREACH;
 		goto error_nolock;
 	}
-	return NET_XMIT_BYPASS;
+
+#ifdef CONFIG_NETFILTER
+	nf_conntrack_put(skb->conntrack);
+	skb->nfct =3D NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug =3D 0;
+#endif
+#endif
+
+	return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, ah_dummydev, NULL,
+		       ah_xmit_bypass);
=20
 error:
 	spin_unlock_bh(&x->lock);
@@ -154,6 +170,12 @@
 	return err;
 }
=20
+static ah_output(struct sk_buff *skb)
+{
+	return NF_HOOK(PF_INET, IP_NF_POST_ROUTING, skb, skb->dev, ah_dummydev,
+		       ah_output_finish);
+}
+
 int ah_input(struct xfrm_state *x, struct xfrm_decap_state *decap, struct =
sk_buff *skb)
 {
 	int ah_hlen;
@@ -354,11 +376,18 @@
 		xfrm_unregister_type(&ah_type, AF_INET);
 		return -EAGAIN;
 	}
+	ah_dummydev =3D alloc_netdev(0, "ah4", NULL);
+	if (!ah_dummydev) {
+		printk(KERN_INFO "ip ah init: can't allocate dummydev\n");
+		inet_del_protocol(&ah4_protocol, IPPROTO_AH);
+		xfrm_unregister_type(&ah_type, AF_INET);
+	}
 	return 0;
 }
=20
 static void __exit ah4_fini(void)
 {
+	free_netdev(ah_dummydev);
 	if (inet_del_protocol(&ah4_protocol, IPPROTO_AH) < 0)
 		printk(KERN_INFO "ip ah close: can't remove protocol\n");
 	if (xfrm_unregister_type(&ah_type, AF_INET) < 0)
diff -Nru linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/esp4.c linuxppc2=
5bh-031218-orinoco_monitor-gpl-netfipsec/net/ipv4/esp4.c
--- linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/esp4.c	2003-12-18 11:3=
8:22.000000000 +0100
+++ linuxppc25bh-031218-orinoco_monitor-gpl-netfipsec/net/ipv4/esp4.c	2004-=
01-28 00:33:58.002480648 +0100
@@ -20,7 +20,16 @@
 	__u8		proto;
 };
=20
-int esp_output(struct sk_buff *skb)
+static struct net_device *esp_dummydev;
+
+/* dummy function for netfilter.  esp_output_finish() has to return
+ * that particular value upon success */
+static int esp_xmit_bypass(struct sk_buff *skb)
+{
+	return NET_XMIT_BYPASS;
+}
+
+static int esp_output_finish(struct sk_buff *skb)
 {
 	int err;
 	struct dst_entry *dst =3D skb->dst;
@@ -199,7 +208,17 @@
 		err =3D -EHOSTUNREACH;
 		goto error_nolock;
 	}
-	return NET_XMIT_BYPASS;
+
+#ifdef CONFIG_NETFILTER
+	nf_conntrack_put(skb->conntrack);
+	skb->nfct =3D NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug =3D 0;
+#endif
+#endif
+	/* FIXME: return real destination device */
+	return NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, esp_dummydev, NULL,
+		       esp_xmit_bypass);
=20
 error:
 	spin_unlock_bh(&x->lock);
@@ -208,6 +227,12 @@
 	return err;
 }
=20
+int esp_output(struct sk_buff *skb)
+{
+	return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, skb->dev, esp_dummydev,
+		       esp_output_finish);
+}
+
 /*
  * Note: detecting truncated vs. non-truncated authentication data is very
  * expensive, so we only support truncated data, which is the recommended
@@ -596,11 +621,19 @@
 		xfrm_unregister_type(&esp_type, AF_INET);
 		return -EAGAIN;
 	}
+	esp_dummydev =3D alloc_netdev(0, "esp4", NULL);
+	if (!esp_dummydev) {
+		printk(KERN_INFO "ip esp init: can't allocate dummydev\n");
+		inet_del_protocol(&esp4_protocol, IPPROTO_ESP);
+		xfrm_unregister_type(&esp_type, AF_INET);
+		return -EAGAIN;
+	}
 	return 0;
 }
=20
 static void __exit esp4_fini(void)
 {
+	free_netdev(esp_dummydev);
 	if (inet_del_protocol(&esp4_protocol, IPPROTO_ESP) < 0)
 		printk(KERN_INFO "ip esp close: can't remove protocol\n");
 	if (xfrm_unregister_type(&esp_type, AF_INET) < 0)
diff -Nru linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/xfrm4_input.c li=
nuxppc25bh-031218-orinoco_monitor-gpl-netfipsec/net/ipv4/xfrm4_input.c
--- linuxppc25bh-031218-orinoco_monitor-gpl/net/ipv4/xfrm4_input.c	2004-01-=
28 00:50:36.204730840 +0100
+++ linuxppc25bh-031218-orinoco_monitor-gpl-netfipsec/net/ipv4/xfrm4_input.=
c	2004-01-28 00:51:39.557099816 +0100
@@ -6,6 +6,8 @@
  *		Split up af-specific portion
  *	Derek Atkins <derek@ihtfp.com>
  *		Add Encapsulation support
+ *	Harald Welte <laforge@netfilter.org>
+ *		Drop conntrack reference before calling netif_rx()
  * =09
  */
=20
@@ -130,6 +132,13 @@
 			dst_release(skb->dst);
 			skb->dst =3D NULL;
 		}
+#ifdef CONFIG_NETFILTER
+		nf_conntrack_put(skb->conntrack);
+		skb->nfct =3D NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+		skb->nf_debug =3D 0;
+#endif
+#endif
 		netif_rx(skb);
 		return 0;
 	} else {
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tQHaQFR6K/xpRpl8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFvptXaXGVTD0i/8RApDnAJ4gjg9H3dHAqp+Dto9r74jFoUSUUgCdGJ/J
rZb+tqavfqbh6wP/7XeKAK8=
=y25q
-----END PGP SIGNATURE-----

--tQHaQFR6K/xpRpl8--
