From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 11/14]: add nf_reset function
Date: Mon, 21 Jun 2004 21:44:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194451.GQ24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hi1pl0KEDnHSGXJ/"
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


--hi1pl0KEDnHSGXJ/
Content-Type: multipart/mixed; boundary="3rA5Es2VluvhcIdy"
Content-Disposition: inline


--3rA5Es2VluvhcIdy
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 adds a new function nf_reset to reset netfilter
related skb-fields.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3rA5Es2VluvhcIdy
Content-Type: text/plain; charset=us-ascii; name="11.diff"
Content-Disposition: inline; filename="11.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:47:23+02:00 kaber@trash.net=20
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv6/sit.c
#   2004/06/20 22:47:13+02:00 kaber@trash.net +2 -14
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv6/ip6_tunnel.c
#   2004/06/20 22:47:13+02:00 kaber@trash.net +1 -7
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/netfilter/ipt_REJECT.c
#   2004/06/20 22:47:13+02:00 kaber@trash.net +1 -5
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ipmr.c
#   2004/06/20 22:47:13+02:00 kaber@trash.net +3 -12
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ipip.c
#   2004/06/20 22:47:13+02:00 kaber@trash.net +2 -14
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ip_input.c
#   2004/06/20 22:47:13+02:00 kaber@trash.net +1 -5
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# net/ipv4/ip_gre.c
#   2004/06/20 22:47:13+02:00 kaber@trash.net +2 -14
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
# include/linux/skbuff.h
#   2004/06/20 22:47:13+02:00 kaber@trash.net +12 -3
#   [NETFILTER]: Add new function 'nf_reset' to reset netfilter related skb=
-fields
#=20
diff -Nru a/include/linux/skbuff.h b/include/linux/skbuff.h
--- a/include/linux/skbuff.h	2004-06-20 23:01:02 +02:00
+++ b/include/linux/skbuff.h	2004-06-20 23:01:02 +02:00
@@ -1073,6 +1073,14 @@
 	if (nfct)
 		atomic_inc(&nfct->master->use);
 }
+static inline void nf_reset(struct sk_buff *skb)
+{
+	nf_conntrack_put(skb->nfct);
+	skb->nfct =3D NULL;
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug =3D 0;
+#endif
+}
=20
 #ifdef CONFIG_BRIDGE_NETFILTER
 static inline void nf_bridge_put(struct nf_bridge_info *nf_bridge)
@@ -1085,9 +1093,10 @@
 	if (nf_bridge)
 		atomic_inc(&nf_bridge->use);
 }
-#endif
-
-#endif
+#endif /* CONFIG_BRIDGE_NETFILTER */
+#else /* CONFIG_NETFILTER */
+static inline void nf_reset(struct sk_buff *skb) {}
+#endif /* CONFIG_NETFILTER */
=20
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff -Nru a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
--- a/net/ipv4/ip_gre.c	2004-06-20 23:01:02 +02:00
+++ b/net/ipv4/ip_gre.c	2004-06-20 23:01:02 +02:00
@@ -643,13 +643,7 @@
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
@@ -877,13 +871,7 @@
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
--- a/net/ipv4/ip_input.c	2004-06-20 23:01:02 +02:00
+++ b/net/ipv4/ip_input.c	2004-06-20 23:01:02 +02:00
@@ -202,17 +202,13 @@
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 	nf_debug_ip_local_deliver(skb);
-	skb->nf_debug =3D 0;
 #endif /*CONFIG_NETFILTER_DEBUG*/
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
--- a/net/ipv4/ipip.c	2004-06-20 23:01:02 +02:00
+++ b/net/ipv4/ipip.c	2004-06-20 23:01:02 +02:00
@@ -497,13 +497,7 @@
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
@@ -648,13 +642,7 @@
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
--- a/net/ipv4/ipmr.c	2004-06-20 23:01:02 +02:00
+++ b/net/ipv4/ipmr.c	2004-06-20 23:01:02 +02:00
@@ -1105,10 +1105,7 @@
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
@@ -1461,10 +1458,7 @@
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
@@ -1520,10 +1514,7 @@
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
--- a/net/ipv4/netfilter/ipt_REJECT.c	2004-06-20 23:01:02 +02:00
+++ b/net/ipv4/netfilter/ipt_REJECT.c	2004-06-20 23:01:02 +02:00
@@ -142,12 +142,8 @@
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
 #ifdef CONFIG_BRIDGE_NETFILTER
 	nf_bridge_put(nskb->nf_bridge);
diff -Nru a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
--- a/net/ipv6/ip6_tunnel.c	2004-06-20 23:01:02 +02:00
+++ b/net/ipv6/ip6_tunnel.c	2004-06-20 23:01:02 +02:00
@@ -722,13 +722,7 @@
 	ipv6h->nexthdr =3D proto;
 	ipv6_addr_copy(&ipv6h->saddr, &fl.fl6_src);
 	ipv6_addr_copy(&ipv6h->daddr, &fl.fl6_dst);
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
-	skb->nfct =3D NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug =3D 0;
-#endif
-#endif
+	nf_reset(skb);
 	pkt_len =3D skb->len;
 	err =3D NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, skb, NULL,=20
 		      skb->dst->dev, dst_output);
diff -Nru a/net/ipv6/sit.c b/net/ipv6/sit.c
--- a/net/ipv6/sit.c	2004-06-20 23:01:02 +02:00
+++ b/net/ipv6/sit.c	2004-06-20 23:01:02 +02:00
@@ -388,13 +388,7 @@
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
@@ -580,13 +574,7 @@
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


--3rA5Es2VluvhcIdy--

--hi1pl0KEDnHSGXJ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zqzXaXGVTD0i/8RAj+VAKCj+SswJxoNVUOM1McKlzm00XNMigCgtMsv
lxeUuO6xoOlJ0UjPLohuAuQ=
=Z4+R
-----END PGP SIGNATURE-----

--hi1pl0KEDnHSGXJ/--
