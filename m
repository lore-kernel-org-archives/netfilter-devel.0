From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH 5/6] ipset/iptreemap: Whitespace cleanup
Date: Sun, 29 Jun 2008 19:45:02 +0200
Message-ID: <1214761503-1713-6-git-send-email-sven.wegener@stealer.net>
References: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44959 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbYF2RpT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:45:19 -0400
In-Reply-To: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove trailing whitespace.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 .../net/ipv4/netfilter/ip_set_iptreemap.c          |   34 ++++++++++----------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
index 62e8334..62fcf7b 100644
--- a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
+++ b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
@@ -293,13 +293,13 @@ testip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_i
 {
 	int res;
 
-	res = __testip(set, 
-		       ntohl(flags[index] & IPSET_SRC 
+	res = __testip(set,
+		       ntohl(flags[index] & IPSET_SRC
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
-				? ip_hdr(skb)->saddr 
+				? ip_hdr(skb)->saddr
 				: ip_hdr(skb)->daddr),
 #else
-				? skb->nh.iph->saddr 
+				? skb->nh.iph->saddr
 				: skb->nh.iph->daddr),
 #endif
 		       hash_ip);
@@ -383,12 +383,12 @@ addip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip
 {
 
 	return __addip_single(set,
-			ntohl(flags[index] & IPSET_SRC 
+			ntohl(flags[index] & IPSET_SRC
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
-				? ip_hdr(skb)->saddr 
+				? ip_hdr(skb)->saddr
 				: ip_hdr(skb)->daddr),
 #else
-				? skb->nh.iph->saddr 
+				? skb->nh.iph->saddr
 				: skb->nh.iph->daddr),
 #endif
 			hash_ip);
@@ -468,13 +468,13 @@ delip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
 static int
 delip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip, const u_int32_t *flags, unsigned char index)
 {
-	return __delip_single(set, 
-			ntohl(flags[index] & IPSET_SRC 
+	return __delip_single(set,
+			ntohl(flags[index] & IPSET_SRC
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
-				? ip_hdr(skb)->saddr 
+				? ip_hdr(skb)->saddr
 				: ip_hdr(skb)->daddr),
 #else
-				? skb->nh.iph->saddr 
+				? skb->nh.iph->saddr
 				: skb->nh.iph->daddr),
 #endif
 			hash_ip,
@@ -726,12 +726,12 @@ static int __init ip_set_iptreemap_init(void)
 	int a;
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
-	cachep_b = kmem_cache_create("ip_set_iptreemap_b", 
-				     sizeof(struct ip_set_iptreemap_b), 
+	cachep_b = kmem_cache_create("ip_set_iptreemap_b",
+				     sizeof(struct ip_set_iptreemap_b),
 				     0, 0, NULL);
 #else
-	cachep_b = kmem_cache_create("ip_set_iptreemap_b", 
-				     sizeof(struct ip_set_iptreemap_b), 
+	cachep_b = kmem_cache_create("ip_set_iptreemap_b",
+				     sizeof(struct ip_set_iptreemap_b),
 				     0, 0, NULL, NULL);
 #endif
 	if (!cachep_b) {
@@ -740,11 +740,11 @@ static int __init ip_set_iptreemap_init(void)
 	}
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
-	cachep_c = kmem_cache_create("ip_set_iptreemap_c", 
+	cachep_c = kmem_cache_create("ip_set_iptreemap_c",
 				     sizeof(struct ip_set_iptreemap_c),
 				     0, 0, NULL);
 #else
-	cachep_c = kmem_cache_create("ip_set_iptreemap_c", 
+	cachep_c = kmem_cache_create("ip_set_iptreemap_c",
 				     sizeof(struct ip_set_iptreemap_c),
 				     0, 0, NULL, NULL);
 #endif
-- 
1.5.6.1

