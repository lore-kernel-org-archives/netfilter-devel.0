From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 07/13] netfilter: add ESP support for early ingress
Date: Thu, 14 Jun 2018 16:19:41 +0200
Message-ID: <20180614141947.3580-8-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

This patch adds the GSO logic for ESP and the codepath that allows
the xfrm infrastructure to signal the GRO layer that the packet is
following the fast forwarding path.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/early_ingress.h |  2 ++
 net/ipv4/netfilter/early_ingress.c    |  8 ++++++++
 net/ipv6/netfilter/early_ingress.c    |  8 ++++++++
 net/netfilter/early_ingress.c         | 36 +++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_output.c                |  4 ++++
 5 files changed, 58 insertions(+)

diff --git a/include/net/netfilter/early_ingress.h b/include/net/netfilter/early_ingress.h
index 9ba8e2875345..6653b294f25a 100644
--- a/include/net/netfilter/early_ingress.h
+++ b/include/net/netfilter/early_ingress.h
@@ -8,6 +8,8 @@ struct sk_buff **nft_udp_gro_receive(struct sk_buff **head,
 				     struct sk_buff *skb);
 struct sk_buff **nft_tcp_gro_receive(struct sk_buff **head,
 				     struct sk_buff *skb);
+struct sk_buff *nft_esp_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features);
 
 int nf_hook_early_ingress(struct sk_buff *skb);
 
diff --git a/net/ipv4/netfilter/early_ingress.c b/net/ipv4/netfilter/early_ingress.c
index 6ff6e34e5eff..74f3a7f1273d 100644
--- a/net/ipv4/netfilter/early_ingress.c
+++ b/net/ipv4/netfilter/early_ingress.c
@@ -5,6 +5,7 @@
 #include <net/arp.h>
 #include <net/udp.h>
 #include <net/tcp.h>
+#include <net/esp.h>
 #include <net/protocol.h>
 #include <net/netfilter/early_ingress.h>
 
@@ -303,9 +304,16 @@ static const struct net_offload nft_tcp4_offload = {
 	},
 };
 
+static const struct net_offload nft_esp4_offload = {
+	.callbacks = {
+		.gso_segment = nft_esp_gso_segment,
+	},
+};
+
 static const struct net_offload __rcu *nft_ip_offloads[MAX_INET_PROTOS] __read_mostly = {
 	[IPPROTO_UDP]	= &nft_udp4_offload,
 	[IPPROTO_TCP]	= &nft_tcp4_offload,
+	[IPPROTO_ESP]	= &nft_esp4_offload,
 };
 
 void nf_early_ingress_ip_enable(void)
diff --git a/net/ipv6/netfilter/early_ingress.c b/net/ipv6/netfilter/early_ingress.c
index 026d2814530a..fb00b083593b 100644
--- a/net/ipv6/netfilter/early_ingress.c
+++ b/net/ipv6/netfilter/early_ingress.c
@@ -5,6 +5,7 @@
 #include <net/arp.h>
 #include <net/udp.h>
 #include <net/tcp.h>
+#include <net/esp.h>
 #include <net/protocol.h>
 #include <net/netfilter/early_ingress.h>
 #include <net/ip6_route.h>
@@ -291,9 +292,16 @@ static const struct net_offload nft_tcp6_offload = {
 	},
 };
 
+static const struct net_offload nft_esp6_offload = {
+	.callbacks = {
+		.gso_segment = nft_esp_gso_segment,
+	},
+};
+
 static const struct net_offload __rcu *nft_ip6_offloads[MAX_INET_PROTOS] __read_mostly = {
 	[IPPROTO_UDP]	= &nft_udp6_offload,
 	[IPPROTO_TCP]	= &nft_tcp6_offload,
+	[IPPROTO_ESP]	= &nft_esp6_offload,
 };
 
 void nf_early_ingress_ip6_enable(void)
diff --git a/net/netfilter/early_ingress.c b/net/netfilter/early_ingress.c
index 4daf6cfea304..10d718bbe495 100644
--- a/net/netfilter/early_ingress.c
+++ b/net/netfilter/early_ingress.c
@@ -5,6 +5,7 @@
 #include <net/arp.h>
 #include <net/udp.h>
 #include <net/tcp.h>
+#include <net/esp.h>
 #include <net/protocol.h>
 #include <crypto/aead.h>
 #include <net/netfilter/early_ingress.h>
@@ -274,6 +275,41 @@ struct sk_buff **nft_tcp_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 	return pp;
 }
 
+struct sk_buff *nft_esp_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	netdev_features_t esp_features = features;
+	struct crypto_aead *aead;
+	struct ip_esp_hdr *esph;
+	struct xfrm_state *x;
+
+	if (!xo)
+		return ERR_PTR(-EINVAL);
+
+	x = skb->sp->xvec[skb->sp->len - 1];
+	aead = x->data;
+	esph = ip_esp_hdr(skb);
+
+	if (esph->spi != x->id.spi)
+		return ERR_PTR(-EINVAL);
+
+	if (!pskb_may_pull(skb, sizeof(*esph) + crypto_aead_ivsize(aead)))
+		return ERR_PTR(-EINVAL);
+
+	__skb_pull(skb, sizeof(*esph) + crypto_aead_ivsize(aead));
+
+	skb->encap_hdr_csum = 1;
+
+	if (!(features & NETIF_F_HW_ESP) || !x->xso.offload_handle ||
+	    (x->xso.dev != skb->dev))
+		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+
+	xo->flags |= XFRM_GSO_SEGMENT;
+
+	return x->outer_mode->gso_segment(x, skb, esp_features);
+}
+
 static inline bool nf_hook_early_ingress_active(const struct sk_buff *skb)
 {
 #ifdef HAVE_JUMP_LABEL
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 89b178a78dc7..c63b157f46ce 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -146,6 +146,10 @@ int xfrm_output_resume(struct sk_buff *skb, int err)
 	while (likely((err = xfrm_output_one(skb, err)) == 0)) {
 		nf_reset(skb);
 
+		if (!skb_dst(skb)->xfrm && skb->sp &&
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_NFT))
+			return -EREMOTE;
+
 		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
 		if (unlikely(err != 1))
 			goto out;
-- 
2.11.0
