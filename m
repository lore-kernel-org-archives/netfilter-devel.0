From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 5/7] netfilter: remove reroute indirection in struct nf_afinfo
Date: Sun, 10 Dec 2017 21:43:43 +0100
Message-ID: <20171210204345.13292-6-pablo@netfilter.org>
References: <20171210204345.13292-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752348AbdLJUn4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:43:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A7740DA72B
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94E44DA86D
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E790DA863
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:52 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1CDB94265A4E
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:52 +0100 (CET)
In-Reply-To: <20171210204345.13292-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is only used by nf_queue.c, and there we can replace it by a direct
function call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h      |  3 +--
 include/linux/netfilter_ipv4.h |  1 +
 include/linux/netfilter_ipv6.h |  6 ++++++
 net/ipv4/netfilter.c           |  7 +++----
 net/ipv6/netfilter.c           |  6 ++----
 net/netfilter/nf_queue.c       |  4 +---
 net/netfilter/utils.c          | 16 ++++++++++++++++
 7 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e703b26025ec..6bdb0e5706a9 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -311,8 +311,6 @@ struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
-	int		(*reroute)(struct net *net, struct sk_buff *skb,
-				   const struct nf_queue_entry *entry);
 	int		route_key_size;
 };
 
@@ -328,6 +326,7 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
 			    u_int8_t protocol, unsigned short family);
+int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry);
 void nf_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo);
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index d3a4c2d3f16b..43c217b861e7 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -14,5 +14,6 @@ __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			       u_int8_t protocol);
 int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		bool strict);
+int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
 void nf_ip_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index cf26146f4425..c5d077d785ac 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -29,6 +29,7 @@ __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 				u_int8_t protocol);
 int nf_ip6_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
                  bool strict);
+int nf_ip6_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
 void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 #else
 static inline __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
@@ -49,6 +50,11 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 {
 	return -EOPNOTSUPP;
 }
+static inline int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
+				 const struct nf_queue_entry *entry)
+{
+	return -EOPNOTSUPP;
+}
 static inline void nf_ip6_saveroute(const struct sk_buff *skb,
 				    struct nf_queue_entry *entry) {}
 #endif
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index c6ba5770af0a..57ed83687d35 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -106,8 +106,7 @@ void nf_ip_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
 	}
 }
 
-static int nf_ip_reroute(struct net *net, struct sk_buff *skb,
-			 const struct nf_queue_entry *entry)
+int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry)
 {
 	const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
@@ -118,7 +117,8 @@ static int nf_ip_reroute(struct net *net, struct sk_buff *skb,
 		      skb->mark == rt_info->mark &&
 		      iph->daddr == rt_info->daddr &&
 		      iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(net, skb, RTN_UNSPEC);
+			return ip_route_me_harder(entry->state.net, skb,
+						  RTN_UNSPEC);
 	}
 	return 0;
 }
@@ -188,7 +188,6 @@ EXPORT_SYMBOL(nf_ip_route);
 
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
-	.reroute		= nf_ip_reroute,
 	.route_key_size		= sizeof(struct ip_rt_info),
 };
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 72364f09253a..9a842c5e809f 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -93,8 +93,7 @@ void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(nf_ip6_saveroute);
 
-static int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
-			  const struct nf_queue_entry *entry)
+int nf_ip6_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry)
 {
 	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
@@ -103,7 +102,7 @@ static int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
 		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
 		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
 		    skb->mark != rt_info->mark)
-			return ip6_route_me_harder(net, skb);
+			return ip6_route_me_harder(entry->state.net, skb);
 	}
 	return 0;
 }
@@ -198,7 +197,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
-	.reroute		= nf_ip6_reroute,
 	.route_key_size		= sizeof(struct ip6_rt_info),
 };
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 833710ee7654..db87dfd1318e 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -226,7 +226,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	const struct nf_hook_entry *hook_entry;
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
-	const struct nf_afinfo *afinfo;
 	const struct net *net;
 	unsigned int i;
 	int err;
@@ -253,8 +252,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		verdict = nf_hook_entry_hookfn(hook_entry, skb, &entry->state);
 
 	if (verdict == NF_ACCEPT) {
-		afinfo = nf_get_afinfo(entry->state.pf);
-		if (!afinfo || afinfo->reroute(entry->state.net, skb, entry) < 0)
+		if (nf_reroute(skb, entry) < 0)
 			verdict = NF_DROP;
 	}
 
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 7d8c0fd283ee..f967d0a4f007 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -44,6 +44,22 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 }
 EXPORT_SYMBOL_GPL(nf_checksum_partial);
 
+int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
+{
+	int ret;
+
+	switch (entry->state.pf) {
+	case AF_INET:
+		ret = nf_ip_reroute(skb, entry);
+		break;
+	case AF_INET6:
+		ret = nf_ip6_reroute(skb, entry);
+		break;
+	}
+
+	return ret;
+}
+
 void nf_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
 {
 	switch (entry->state.pf) {
-- 
2.11.0

