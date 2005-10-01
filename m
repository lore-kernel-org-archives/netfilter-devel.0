From: Thomas Heinz <thomasheinz@gmx.net>
Subject: [PATCH/FIX]
	patch-o-matic-ng/patchlets/ipsec-02-input-hooks/linux-2.6.12.patch
Date: Sat, 1 Oct 2005 12:33:56 +0200
Message-ID: <200510011234.05949.thomasheinz@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1633415.TSnv1vB6IX";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--nextPart1633415.TSnv1vB6IX
Content-Type: multipart/mixed;
  boundary="Boundary-01=_UYmPDUr5Nm2wh0p"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_UYmPDUr5Nm2wh0p
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

The ipsec input hooks patch for linux 2.6.12 does not compile due to a=20
missing #endif in net/core/netfilter.c. The attached patch adds it.=20
Moreover, the "EXPORT_SYMBOL(nf_rcv_postxfrm_local);" at the end of=20
net/core/netfilter.c is protected by an #ifdef.


Regards,

Thomas

--Boundary-01=_UYmPDUr5Nm2wh0p
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.12.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="linux-2.6.12.patch"

diff -Nurp linux-2.6.12.org/include/linux/netfilter_ipv4.h linux-2.6.12/inc=
lude/linux/netfilter_ipv4.h
=2D-- linux-2.6.12.org/include/linux/netfilter_ipv4.h	2005-06-17 21:48:29.0=
00000000 +0200
+++ linux-2.6.12/include/linux/netfilter_ipv4.h	2005-09-30 22:42:11.0000000=
00 +0200
@@ -7,6 +7,8 @@
=20
 #include <linux/config.h>
 #include <linux/netfilter.h>
+#include <linux/netdevice.h>
+#include <net/protocol.h>
=20
 /* IP Cache bits. */
 /* Src IP address. */
@@ -88,6 +90,58 @@ extern int ip_route_me_harder(struct sk_
    Returns true or false. */
 extern int skb_ip_make_writable(struct sk_buff **pskb,
 				unsigned int writable_len);
+
+#if defined(CONFIG_XFRM) && defined(CONFIG_NETFILTER)
+#include <net/route.h>
+#include <net/xfrm.h>
+
+static inline int nf_hook_input_cond(struct sk_buff *skb)
+{
+	return !skb->sp || skb->sp->decap_done;
+}
+
+static inline int
+nf_xfrm_local_done(struct sk_buff *skb, struct net_protocol *ipprot)
+{
+	return skb->sp && !skb->sp->decap_done
+	       && (!ipprot || !ipprot->xfrm_prot);
+}
+
+static inline int nf_xfrm_nonlocal_done(struct sk_buff *skb)
+{
+	return skb->sp && !skb->sp->decap_done
+	       && !(((struct rtable *)skb->dst)->rt_flags & RTCF_LOCAL);
+}
+
+extern int nf_rcv_postxfrm_local(struct sk_buff *skb);
+extern int nf_rcv_postxfrm_nonlocal(struct sk_buff *skb);
+#else /* CONFIG_XFRM */
+static inline int nf_hook_input_cond(struct sk_buff *skb)
+{
+	return 1;
+}
+
+static inline int
+nf_xfrm_local_done(struct sk_buff *skb, struct net_protocol *ipprot)
+{
+	return 0;
+}
+
+static inline int nf_xfrm_nonlocal_done(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_rcv_postxfrm_local(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_rcv_postxfrm_nonlocal(struct sk_buff *skb)
+{
+	return 0;=20
+}
+#endif /* CONFIG_XFRM */
 #endif /*__KERNEL__*/
=20
 #endif /*__LINUX_IP_NETFILTER_H*/
diff -Nurp linux-2.6.12.org/include/net/protocol.h linux-2.6.12/include/net=
/protocol.h
=2D-- linux-2.6.12.org/include/net/protocol.h	2005-06-17 21:48:29.000000000=
 +0200
+++ linux-2.6.12/include/net/protocol.h	2005-09-30 22:42:11.000000000 +0200
@@ -38,6 +38,7 @@ struct net_protocol {
 	int			(*handler)(struct sk_buff *skb);
 	void			(*err_handler)(struct sk_buff *skb, u32 info);
 	int			no_policy;
+	int			xfrm_prot;
 };
=20
 #if defined(CONFIG_IPV6) || defined (CONFIG_IPV6_MODULE)
diff -Nurp linux-2.6.12.org/include/net/xfrm.h linux-2.6.12/include/net/xfr=
m.h
=2D-- linux-2.6.12.org/include/net/xfrm.h	2005-06-17 21:48:29.000000000 +02=
00
+++ linux-2.6.12/include/net/xfrm.h	2005-09-30 22:42:11.000000000 +0200
@@ -546,6 +546,9 @@ struct sec_path
 {
 	atomic_t		refcnt;
 	int			len;
+#ifdef CONFIG_NETFILTER
+	int			decap_done;
+#endif
 	struct sec_decap_state	x[XFRM_MAX_DEPTH];
 };
=20
diff -Nurp linux-2.6.12.org/net/core/netfilter.c linux-2.6.12/net/core/netf=
ilter.c
=2D-- linux-2.6.12.org/net/core/netfilter.c	2005-06-17 21:48:29.000000000 +=
0200
+++ linux-2.6.12/net/core/netfilter.c	2005-09-30 22:57:48.000000000 +0200
@@ -27,7 +27,8 @@
 #include <linux/icmp.h>
 #include <net/sock.h>
 #include <net/route.h>
=2D#include <linux/ip.h>
+#include <net/xfrm.h>
+#include <net/ip.h>
=20
 /* In this code, we can be waiting indefinitely for userspace to
  * service a packet if a hook returns NF_QUEUE.  We could keep a count
@@ -651,6 +652,28 @@ int ip_route_me_harder(struct sk_buff **
 }
 EXPORT_SYMBOL(ip_route_me_harder);
=20
+#ifdef CONFIG_XFRM
+inline int nf_rcv_postxfrm_nonlocal(struct sk_buff *skb)
+{
+	skb->sp->decap_done =3D 1;
+	dst_release(skb->dst);
+	skb->dst =3D NULL;
+	nf_reset(skb);
+	return netif_rx(skb);
+}
+
+int nf_rcv_postxfrm_local(struct sk_buff *skb)
+{
+	__skb_push(skb, skb->data - skb->nh.raw);
+	/* Fix header len and checksum if last xfrm was transport mode */
+	if (!skb->sp->x[skb->sp->len - 1].xvec->props.mode) {
+		skb->nh.iph->tot_len =3D htons(skb->len);
+		ip_send_check(skb->nh.iph);
+	}
+	return nf_rcv_postxfrm_nonlocal(skb);
+}
+#endif
+=20
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
 	struct sk_buff *nskb;
@@ -784,3 +807,6 @@ EXPORT_SYMBOL(nf_setsockopt);
 EXPORT_SYMBOL(nf_unregister_hook);
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 EXPORT_SYMBOL(nf_unregister_sockopt);
+#ifdef CONFIG_XFRM
+EXPORT_SYMBOL(nf_rcv_postxfrm_local);
+#endif
diff -Nurp linux-2.6.12.org/net/ipv4/ah4.c linux-2.6.12/net/ipv4/ah4.c
=2D-- linux-2.6.12.org/net/ipv4/ah4.c	2005-06-17 21:48:29.000000000 +0200
+++ linux-2.6.12/net/ipv4/ah4.c	2005-09-30 22:42:11.000000000 +0200
@@ -306,6 +306,7 @@ static struct net_protocol ah4_protocol=20
 	.handler	=3D	xfrm4_rcv,
 	.err_handler	=3D	ah4_err,
 	.no_policy	=3D	1,
+	.xfrm_prot	=3D	1,
 };
=20
 static int __init ah4_init(void)
diff -Nurp linux-2.6.12.org/net/ipv4/esp4.c linux-2.6.12/net/ipv4/esp4.c
=2D-- linux-2.6.12.org/net/ipv4/esp4.c	2005-06-17 21:48:29.000000000 +0200
+++ linux-2.6.12/net/ipv4/esp4.c	2005-09-30 22:42:11.000000000 +0200
@@ -472,6 +472,7 @@ static struct net_protocol esp4_protocol
 	.handler	=3D	xfrm4_rcv,
 	.err_handler	=3D	esp4_err,
 	.no_policy	=3D	1,
+	.xfrm_prot	=3D	1,
 };
=20
 static int __init esp4_init(void)
diff -Nurp linux-2.6.12.org/net/ipv4/ip_input.c linux-2.6.12/net/ipv4/ip_in=
put.c
=2D-- linux-2.6.12.org/net/ipv4/ip_input.c	2005-06-17 21:48:29.000000000 +0=
200
+++ linux-2.6.12/net/ipv4/ip_input.c	2005-09-30 22:42:11.000000000 +0200
@@ -224,6 +224,12 @@ static inline int ip_local_deliver_finis
 	resubmit:
 		hash =3D protocol & (MAX_INET_PROTOS - 1);
 		raw_sk =3D sk_head(&raw_v4_htable[hash]);
+		ipprot =3D rcu_dereference(inet_protos[hash]);
+
+		if (nf_xfrm_local_done(skb, ipprot)) {
+			nf_rcv_postxfrm_local(skb);
+			goto out;
+		}
=20
 		/* If there maybe a raw socket we must check - if not we
 		 * don't care less
@@ -231,7 +237,7 @@ static inline int ip_local_deliver_finis
 		if (raw_sk)
 			raw_v4_input(skb, skb->nh.iph, hash);
=20
=2D		if ((ipprot =3D rcu_dereference(inet_protos[hash])) !=3D NULL) {
+		if (ipprot !=3D NULL) {
 			int ret;
=20
 			if (!ipprot->no_policy &&
@@ -278,8 +284,8 @@ int ip_local_deliver(struct sk_buff *skb
 			return 0;
 	}
=20
=2D	return NF_HOOK(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
=2D		       ip_local_deliver_finish);
+	return NF_HOOK_COND(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
+	                    ip_local_deliver_finish, nf_hook_input_cond(skb));
 }
=20
 static inline int ip_rcv_finish(struct sk_buff *skb)
@@ -296,6 +302,9 @@ static inline int ip_rcv_finish(struct s
 			goto drop;=20
 	}
=20
+	if (nf_xfrm_nonlocal_done(skb))
+		return nf_rcv_postxfrm_nonlocal(skb);
+
 #ifdef CONFIG_NET_CLS_ROUTE
 	if (skb->dst->tclassid) {
 		struct ip_rt_acct *st =3D ip_rt_acct + 256*smp_processor_id();
@@ -416,8 +425,8 @@ int ip_rcv(struct sk_buff *skb, struct n
 		}
 	}
=20
=2D	return NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
=2D		       ip_rcv_finish);
+	return NF_HOOK_COND(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
+	                    ip_rcv_finish, nf_hook_input_cond(skb));
=20
 inhdr_error:
 	IP_INC_STATS_BH(IPSTATS_MIB_INHDRERRORS);
diff -Nurp linux-2.6.12.org/net/ipv4/ipcomp.c linux-2.6.12/net/ipv4/ipcomp.c
=2D-- linux-2.6.12.org/net/ipv4/ipcomp.c	2005-06-17 21:48:29.000000000 +0200
+++ linux-2.6.12/net/ipv4/ipcomp.c	2005-09-30 22:42:11.000000000 +0200
@@ -491,6 +491,7 @@ static struct net_protocol ipcomp4_proto
 	.handler	=3D	xfrm4_rcv,
 	.err_handler	=3D	ipcomp4_err,
 	.no_policy	=3D	1,
+	.xfrm_prot	=3D	1,
 };
=20
 static int __init ipcomp4_init(void)
diff -Nurp linux-2.6.12.org/net/ipv4/ipip.c linux-2.6.12/net/ipv4/ipip.c
=2D-- linux-2.6.12.org/net/ipv4/ipip.c	2005-06-17 21:48:29.000000000 +0200
+++ linux-2.6.12/net/ipv4/ipip.c	2005-09-30 22:42:11.000000000 +0200
@@ -476,6 +476,11 @@ static int ipip_rcv(struct sk_buff *skb)
=20
 	read_lock(&ipip_lock);
 	if ((tunnel =3D ipip_tunnel_lookup(iph->saddr, iph->daddr)) !=3D NULL) {
+		/* IPIP packets decapsulated by IPsec missed netfilter hooks */
+		if (nf_xfrm_local_done(skb, NULL)) {
+			nf_rcv_postxfrm_local(skb);
+			return 0;
+		}
 		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
 			read_unlock(&ipip_lock);
 			kfree_skb(skb);
diff -Nurp linux-2.6.12.org/net/ipv4/xfrm4_tunnel.c linux-2.6.12/net/ipv4/x=
frm4_tunnel.c
=2D-- linux-2.6.12.org/net/ipv4/xfrm4_tunnel.c	2005-06-17 21:48:29.00000000=
0 +0200
+++ linux-2.6.12/net/ipv4/xfrm4_tunnel.c	2005-09-30 22:42:11.000000000 +0200
@@ -115,6 +115,7 @@ static struct net_protocol ipip_protocol
 	.handler	=3D	ipip_rcv,
 	.err_handler	=3D	ipip_err,
 	.no_policy	=3D	1,
+	.xfrm_prot	=3D	1,
 };
=20
 static int __init ipip_init(void)
diff -Nurp linux-2.6.12.org/net/xfrm/xfrm_input.c linux-2.6.12/net/xfrm/xfr=
m_input.c
=2D-- linux-2.6.12.org/net/xfrm/xfrm_input.c	2005-06-17 21:48:29.000000000 =
+0200
+++ linux-2.6.12/net/xfrm/xfrm_input.c	2005-09-30 22:42:11.000000000 +0200
@@ -31,6 +31,9 @@ struct sec_path *secpath_dup(struct sec_
 	if (!sp)
 		return NULL;
=20
+#ifdef CONFIG_NETFILTER
+	sp->decap_done =3D 0;
+#endif
 	sp->len =3D 0;
 	if (src) {
 		int i;

--Boundary-01=_UYmPDUr5Nm2wh0p--

--nextPart1633415.TSnv1vB6IX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDPmYd8oNQPJ8CvngRAut7AJwIyW+6YDF03oakl7V3ws6+Gm/QFACgmKoG
O9yeKeDh697tUQZ/i7iwcNc=
=hKo7
-----END PGP SIGNATURE-----

--nextPart1633415.TSnv1vB6IX--
