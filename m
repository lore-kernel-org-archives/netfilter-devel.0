From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4 10/10]: add nf_reset function
Date: Mon, 21 Jun 2004 21:55:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621195516.GC24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bpE6J1YpKbp4MfuU"
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


--bpE6J1YpKbp4MfuU
Content-Type: multipart/mixed; boundary="aMW5LnGibACNzXXQ"
Content-Disposition: inline


--aMW5LnGibACNzXXQ
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.4 adds a new function nf_reset to reset netfilter
related skb-fields.

Author: Patrick McHardy <kaber@trash.net>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aMW5LnGibACNzXXQ
Content-Type: text/plain; charset=us-ascii; name="10.diff"
Content-Disposition: inline; filename="10.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:50:43+02:00 kaber@trash.net=20
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv6/sit.c
#   2004/06/20 22:50:41+02:00 kaber@trash.net +2 -14
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/netfilter/ipt_REJECT.c
#   2004/06/20 22:50:41+02:00 kaber@trash.net +1 -5
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ipmr.c
#   2004/06/20 22:50:41+02:00 kaber@trash.net +3 -12
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ipip.c
#   2004/06/20 22:50:41+02:00 kaber@trash.net +2 -14
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ip_input.c
#   2004/06/20 22:50:41+02:00 kaber@trash.net +1 -4
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ip_gre.c
#   2004/06/20 22:50:41+02:00 kaber@trash.net +2 -14
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# include/linux/skbuff.h
#   2004/06/20 22:50:41+02:00 kaber@trash.net +11 -0
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
diff -Nru a/include/linux/skbuff.h b/include/linux/skbuff.h
--- a/include/linux/skbuff.h	2004-06-20 23:03:04 +02:00
+++ b/include/linux/skbuff.h	2004-06-20 23:03:04 +02:00
@@ -1166,7 +1166,18 @@
 	if (nfct)
 		atomic_inc(&nfct->master->use);
 }
+static inline void
+nf_reset(struct sk_buff *skb)
+{
+	nf_conntrack_put(skb->nfct);
+	skb->nfct =3D NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug =3D 0;
 #endif
+}
+#else /* CONFIG_NETFILTER */
+static inline void nf_reset(struct sk_buff *skb) {}
+#endif /* CONFIG_NETFILTER */
=20
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff -Nru a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
--- a/net/ipv4/ip_gre.c	2004-06-20 23:03:04 +02:00
+++ b/net/ipv4/ip_gre.c	2004-06-20 23:03:04 +02:00
@@ -644,13 +644,7 @@
 		skb->dev =3D tunnel->dev;
 		dst_release(skb->dst);
 		skb->dst =3D NULL;
-#ifdef CONFIG_NETFILTER
-		nf_conntrack_put(skb->nfct);
-		skb->nfct =3D NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug =3D 0;
-#endif
-#endif
+		nf_reset(skb);
 		ipgre_ecn_decapsulate(iph, skb);
 		netif_rx(skb);
 		read_unlock(&ipgre_lock);
@@ -876,13 +870,7 @@
 		}
 	}
=20
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug =3D 0;
-#endif
-#endif
+	nf_reset(skb);
=20
 	IPTUNNEL_XMIT();
 	tunnel->recursion--;
diff -Nru a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c	2004-06-20 23:03:04 +02:00
+++ b/net/ipv4/ip_input.c	2004-06-20 23:03:04 +02:00
@@ -226,12 +226,9 @@
=20
 	__skb_pull(skb, ihl);
=20
-#ifdef CONFIG_NETFILTER
 	/* Free reference early: we don't need it any more, and it may
            hold ip_conntrack module loaded indefinitely. */
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#endif /*CONFIG_NETFILTER*/
+	nf_reset(skb);
=20
         /* Point into the IP datagram, just past the header. */
         skb->h.raw =3D skb->data;
diff -Nru a/net/ipv4/ipip.c b/net/ipv4/ipip.c
--- a/net/ipv4/ipip.c	2004-06-20 23:03:04 +02:00
+++ b/net/ipv4/ipip.c	2004-06-20 23:03:04 +02:00
@@ -495,13 +495,7 @@
 		skb->dev =3D tunnel->dev;
 		dst_release(skb->dst);
 		skb->dst =3D NULL;
-#ifdef CONFIG_NETFILTER
-		nf_conntrack_put(skb->nfct);
-		skb->nfct =3D NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug =3D 0;
-#endif
-#endif
+		nf_reset(skb);
 		ipip_ecn_decapsulate(iph, skb);
 		netif_rx(skb);
 		read_unlock(&ipip_lock);
@@ -646,13 +640,7 @@
 	if ((iph->ttl =3D tiph->ttl) =3D=3D 0)
 		iph->ttl	=3D	old_iph->ttl;
=20
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug =3D 0;
-#endif
-#endif
+	nf_reset(skb);
=20
 	IPTUNNEL_XMIT();
 	tunnel->recursion--;
diff -Nru a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c	2004-06-20 23:03:04 +02:00
+++ b/net/ipv4/ipmr.c	2004-06-20 23:03:04 +02:00
@@ -1097,10 +1097,7 @@
 	skb->h.ipiph =3D skb->nh.iph;
 	skb->nh.iph =3D iph;
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#endif
+	nf_reset(skb);
 }
=20
 static inline int ipmr_forward_finish(struct sk_buff *skb)
@@ -1446,10 +1443,7 @@
 	skb->dst =3D NULL;
 	((struct net_device_stats*)reg_dev->priv)->rx_bytes +=3D skb->len;
 	((struct net_device_stats*)reg_dev->priv)->rx_packets++;
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#endif
+	nf_reset(skb);
 	netif_rx(skb);
 	dev_put(reg_dev);
 	return 0;
@@ -1513,10 +1507,7 @@
 	((struct net_device_stats*)reg_dev->priv)->rx_bytes +=3D skb->len;
 	((struct net_device_stats*)reg_dev->priv)->rx_packets++;
 	skb->dst =3D NULL;
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#endif
+	nf_reset(skb);
 	netif_rx(skb);
 	dev_put(reg_dev);
 	return 0;
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT=
=2Ec
--- a/net/ipv4/netfilter/ipt_REJECT.c	2004-06-20 23:03:04 +02:00
+++ b/net/ipv4/netfilter/ipt_REJECT.c	2004-06-20 23:03:04 +02:00
@@ -126,12 +126,8 @@
 	nskb->dst =3D &rt->u.dst;
=20
 	/* This packet will not be the same as the other: clear nf fields */
-	nf_conntrack_put(nskb->nfct);
-	nskb->nfct =3D NULL;
+	nf_reset(nskb);
 	nskb->nfcache =3D 0;
-#ifdef CONFIG_NETFILTER_DEBUG
-	nskb->nf_debug =3D 0;
-#endif
 	nskb->nfmark =3D 0;
=20
 	tcph =3D (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->ihl);
diff -Nru a/net/ipv6/sit.c b/net/ipv6/sit.c
--- a/net/ipv6/sit.c	2004-06-20 23:03:04 +02:00
+++ b/net/ipv6/sit.c	2004-06-20 23:03:04 +02:00
@@ -402,13 +402,7 @@
 		skb->dev =3D tunnel->dev;
 		dst_release(skb->dst);
 		skb->dst =3D NULL;
-#ifdef CONFIG_NETFILTER
-		nf_conntrack_put(skb->nfct);
-		skb->nfct =3D NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug =3D 0;
-#endif
-#endif
+		nf_reset(skb);
 		ipip6_ecn_decapsulate(iph, skb);
 		netif_rx(skb);
 		read_unlock(&ipip6_lock);
@@ -599,13 +593,7 @@
 	if ((iph->ttl =3D tiph->ttl) =3D=3D 0)
 		iph->ttl	=3D	iph6->hop_limit;
=20
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug =3D 0;
-#endif
-#endif
+	nf_reset(skb);
=20
 	IPTUNNEL_XMIT();
 	tunnel->recursion--;


--aMW5LnGibACNzXXQ--

--bpE6J1YpKbp4MfuU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1z0kXaXGVTD0i/8RAlJCAJ4lmfDJvAlOMQlCTet+AJSYd9b0cgCgk/XA
4q88EP6KNeeJDSosauMeQeI=
=S+cC
-----END PGP SIGNATURE-----

--bpE6J1YpKbp4MfuU--
