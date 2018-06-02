From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/20] netfilter: nf_tables: Add audit support to log statement
Date: Sat,  2 Jun 2018 02:22:53 +0200
Message-ID: <20180602002259.4024-15-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

This extends log statement to support the behaviour achieved with
AUDIT target in iptables.

Audit logging is enabled via a pseudo log level 8. In this case any
other settings like log prefix are ignored since audit log format is
fixed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  5 ++
 net/netfilter/nft_log.c                  | 92 +++++++++++++++++++++++++++++++-
 2 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 3d46c82a5ebd..5c7eb9b9f6d6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1081,6 +1081,11 @@ enum nft_log_attributes {
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
 
 /**
+ * LOGLEVEL_AUDIT - a pseudo log level enabling audit logging
+ */
+#define LOGLEVEL_AUDIT		8
+
+/**
  * enum nft_queue_attributes - nf_tables queue expression netlink attributes
  *
  * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index a27be36dc0af..7eef1cffbf1b 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -9,12 +9,15 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <linux/audit.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <net/ipv6.h>
+#include <net/ip.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_log.h>
 #include <linux/netdevice.h>
@@ -26,12 +29,93 @@ struct nft_log {
 	char			*prefix;
 };
 
+static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
+{
+	struct iphdr _iph;
+	const struct iphdr *ih;
+
+	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);
+	if (!ih)
+		return false;
+
+	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 proto=%hhu",
+			 &ih->saddr, &ih->daddr, ih->protocol);
+
+	return true;
+}
+
+static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
+{
+	struct ipv6hdr _ip6h;
+	const struct ipv6hdr *ih;
+	u8 nexthdr;
+	__be16 frag_off;
+
+	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_ip6h), &_ip6h);
+	if (!ih)
+		return false;
+
+	nexthdr = ih->nexthdr;
+	ipv6_skip_exthdr(skb, skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
+
+	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c proto=%hhu",
+			 &ih->saddr, &ih->daddr, nexthdr);
+
+	return true;
+}
+
+static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
+{
+	struct sk_buff *skb = pkt->skb;
+	struct audit_buffer *ab;
+	int fam = -1;
+
+	if (!audit_enabled)
+		return;
+
+	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "mark=%#x", skb->mark);
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_BRIDGE:
+		switch (eth_hdr(skb)->h_proto) {
+		case htons(ETH_P_IP):
+			fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
+			break;
+		case htons(ETH_P_IPV6):
+			fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
+			break;
+		}
+		break;
+	case NFPROTO_IPV4:
+		fam = audit_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
+		break;
+	case NFPROTO_IPV6:
+		fam = audit_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
+		break;
+	}
+
+	if (fam == -1)
+		audit_log_format(ab, " saddr=? daddr=? proto=-1");
+
+	audit_log_end(ab);
+}
+
 static void nft_log_eval(const struct nft_expr *expr,
 			 struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt)
 {
 	const struct nft_log *priv = nft_expr_priv(expr);
 
+	if (priv->loginfo.type == NF_LOG_TYPE_LOG &&
+	    priv->loginfo.u.log.level == LOGLEVEL_AUDIT) {
+		nft_log_eval_audit(pkt);
+		return;
+	}
+
 	nf_log_packet(nft_net(pkt), nft_pf(pkt), nft_hook(pkt), pkt->skb,
 		      nft_in(pkt), nft_out(pkt), &priv->loginfo, "%s",
 		      priv->prefix);
@@ -84,7 +168,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		} else {
 			li->u.log.level = LOGLEVEL_WARNING;
 		}
-		if (li->u.log.level > LOGLEVEL_DEBUG) {
+		if (li->u.log.level > LOGLEVEL_AUDIT) {
 			err = -EINVAL;
 			goto err1;
 		}
@@ -112,6 +196,9 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		break;
 	}
 
+	if (li->u.log.level == LOGLEVEL_AUDIT)
+		return 0;
+
 	err = nf_logger_find_get(ctx->family, li->type);
 	if (err < 0)
 		goto err1;
@@ -133,6 +220,9 @@ static void nft_log_destroy(const struct nft_ctx *ctx,
 	if (priv->prefix != nft_log_null_prefix)
 		kfree(priv->prefix);
 
+	if (li->u.log.level == LOGLEVEL_AUDIT)
+		return;
+
 	nf_logger_put(ctx->family, li->type);
 }
 
-- 
2.11.0
