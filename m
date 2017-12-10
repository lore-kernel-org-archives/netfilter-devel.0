From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/7] netfilter: remove checksum_partial indirection in struct nf_afinfo
Date: Sun, 10 Dec 2017 21:43:40 +0100
Message-ID: <20171210204345.13292-3-pablo@netfilter.org>
References: <20171210204345.13292-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47118 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752189AbdLJUny (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:43:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99A61DA73F
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8485CDA86C
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46B62DA812
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:50 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 28AA3426CC80
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:43:50 +0100 (CET)
In-Reply-To: <20171210204345.13292-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simplify this infrastructure by replacing it by direction call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h      | 25 +++----------------------
 include/linux/netfilter_ipv4.h |  3 +++
 include/linux/netfilter_ipv6.h | 11 +++++++++++
 net/ipv4/netfilter.c           |  7 +++----
 net/ipv6/netfilter.c           |  7 +++----
 net/netfilter/utils.c          | 21 +++++++++++++++++++++
 6 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3ae4cfb92b54..a2bb6fefde13 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -311,11 +311,6 @@ struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
-	__sum16		(*checksum_partial)(struct sk_buff *skb,
-					    unsigned int hook,
-					    unsigned int dataoff,
-					    unsigned int len,
-					    u_int8_t protocol);
 	int		(*route)(struct net *net, struct dst_entry **dst,
 				 struct flowi *fl, bool strict);
 	void		(*saveroute)(const struct sk_buff *skb,
@@ -334,23 +329,9 @@ static inline const struct nf_afinfo *nf_get_afinfo(unsigned short family)
 __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u_int8_t protocol,
 		    unsigned short family);
-
-static inline __sum16
-nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
-		    unsigned int dataoff, unsigned int len,
-		    u_int8_t protocol, unsigned short family)
-{
-	const struct nf_afinfo *afinfo;
-	__sum16 csum = 0;
-
-	rcu_read_lock();
-	afinfo = nf_get_afinfo(family);
-	if (afinfo)
-		csum = afinfo->checksum_partial(skb, hook, dataoff, len,
-						protocol);
-	rcu_read_unlock();
-	return csum;
-}
+__sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
+			    unsigned int dataoff, unsigned int len,
+			    u_int8_t protocol, unsigned short family);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo);
 void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 98c03b2462b5..6d61ec0a7695 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -9,4 +9,7 @@
 int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned addr_type);
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u_int8_t protocol);
+__sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
+			       unsigned int dataoff, unsigned int len,
+			       u_int8_t protocol);
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index ea8c99e5112a..729cc76cb3db 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -24,12 +24,23 @@ struct nf_ipv6_ops {
 #if defined(CONFIG_IPV6)
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
+__sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				unsigned int dataoff, unsigned int len,
+				u_int8_t protocol);
 #else
 static inline __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 				      unsigned int dataoff, u_int8_t protocol)
 {
 	return 0;
 }
+static inline__sum16 nf_ip6_checksum_partial(struct sk_buff *skb,
+					     unsigned int hook,
+					     unsigned int dataoff,
+					     unsigned int len,
+					     u_int8_t protocol)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_NETFILTER
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 2f7ffefd2732..050b614662f8 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -155,9 +155,9 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 }
 EXPORT_SYMBOL(nf_ip_checksum);
 
-static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
-				      unsigned int dataoff, unsigned int len,
-				      u_int8_t protocol)
+__sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
+			       unsigned int dataoff, unsigned int len,
+			       u_int8_t protocol)
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	__sum16 csum = 0;
@@ -188,7 +188,6 @@ static int nf_ip_route(struct net *net, struct dst_entry **dst,
 
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
-	.checksum_partial	= nf_ip_checksum_partial,
 	.route			= nf_ip_route,
 	.saveroute		= nf_ip_saveroute,
 	.reroute		= nf_ip_reroute,
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a24810ecc432..6e39b721136e 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -163,9 +163,9 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 }
 EXPORT_SYMBOL(nf_ip6_checksum);
 
-static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
-				       unsigned int dataoff, unsigned int len,
-				       u_int8_t protocol)
+__sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				unsigned int dataoff, unsigned int len,
+				u_int8_t protocol)
 {
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	__wsum hsum;
@@ -197,7 +197,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
-	.checksum_partial	= nf_ip6_checksum_partial,
 	.route			= nf_ip6_route,
 	.saveroute		= nf_ip6_saveroute,
 	.reroute		= nf_ip6_reroute,
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 92a51e507fab..3fdad0c7b189 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -21,3 +21,24 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 	return csum;
 }
 EXPORT_SYMBOL_GPL(nf_checksum);
+
+__sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
+			    unsigned int dataoff, unsigned int len,
+			    u_int8_t protocol, unsigned short family)
+{
+	__sum16 csum = 0;
+
+	switch (family) {
+	case AF_INET:
+		csum = nf_ip_checksum_partial(skb, hook, dataoff, len,
+					      protocol);
+		break;
+	case AF_INET6:
+		csum = nf_ip6_checksum_partial(skb, hook, dataoff, len,
+					       protocol);
+		break;
+	}
+
+	return csum;
+}
+EXPORT_SYMBOL_GPL(nf_checksum_partial);
-- 
2.11.0

