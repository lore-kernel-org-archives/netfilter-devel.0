From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 33/33] netfilter: ipv4: remove useless export_symbol
Date: Tue, 29 Jan 2019 00:57:50 +0100
Message-ID: <20190128235750.18412-34-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only one caller; place it where needed and get rid of the EXPORT_SYMBOL.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4.h |  6 ------
 net/ipv4/netfilter.c           | 18 ------------------
 net/netfilter/utils.c          | 19 +++++++++++++++++++
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 95ab5cc64422..082e2c41b7ff 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -25,7 +25,6 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u_int8_t protocol);
 int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		bool strict);
-int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
 #else
 static inline __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 				     unsigned int dataoff, u_int8_t protocol)
@@ -37,11 +36,6 @@ static inline int nf_ip_route(struct net *net, struct dst_entry **dst,
 {
 	return -EOPNOTSUPP;
 }
-static inline int nf_ip_reroute(struct sk_buff *skb,
-				const struct nf_queue_entry *entry)
-{
-	return -EOPNOTSUPP;
-}
 #endif /* CONFIG_INET */
 
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 8d2e5dc9a827..a058213b77a7 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -80,24 +80,6 @@ int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned int addr_t
 }
 EXPORT_SYMBOL(ip_route_me_harder);
 
-int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry)
-{
-	const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
-
-	if (entry->state.hook == NF_INET_LOCAL_OUT) {
-		const struct iphdr *iph = ip_hdr(skb);
-
-		if (!(iph->tos == rt_info->tos &&
-		      skb->mark == rt_info->mark &&
-		      iph->daddr == rt_info->daddr &&
-		      iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(entry->state.net, skb,
-						  RTN_UNSPEC);
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_ip_reroute);
-
 int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		bool strict __always_unused)
 {
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index e8da9a9bba73..55af9f247993 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -180,6 +180,25 @@ int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 }
 EXPORT_SYMBOL_GPL(nf_route);
 
+static int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry)
+{
+#ifdef CONFIG_INET
+	const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
+
+	if (entry->state.hook == NF_INET_LOCAL_OUT) {
+		const struct iphdr *iph = ip_hdr(skb);
+
+		if (!(iph->tos == rt_info->tos &&
+		      skb->mark == rt_info->mark &&
+		      iph->daddr == rt_info->daddr &&
+		      iph->saddr == rt_info->saddr))
+			return ip_route_me_harder(entry->state.net, skb,
+						  RTN_UNSPEC);
+	}
+#endif
+	return 0;
+}
+
 int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 {
 	const struct nf_ipv6_ops *v6ops;
-- 
2.11.0
