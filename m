From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 3/4] netfilter: ipset: hash:ip: add support for new netmask types
Date: Tue, 21 Mar 2017 14:29:03 -0400
Message-ID: <1490120944-1770-4-git-send-email-johunt@akamai.com>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41444 "EHLO
        prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757921AbdCUSfC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:35:02 -0400
In-Reply-To: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Enable new netmask suport for hash:ip set types.

Example usage:

Legacy behavior:
ipset create foo hash:ip family inet6 netmask 64

New netmask support (equivalent to legacy example):
ipset create foo hash:ip family inet6 netmask ffff:ffff:ffff:ffff::

New wildcard mask support:
ipset create foo hash:ip family inet6 netmask ffff:ffff:ffff:0:0:ffff:ffff:ffff

The 3 mask types are supported for ipv4 sets as well.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 net/netfilter/ipset/ip_set_hash_ip.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 20bfbd3..74aa4a6 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -27,7 +27,8 @@
 /*				1	   Counters support */
 /*				2	   Comments support */
 /*				3	   Forceadd support */
-#define IPSET_TYPE_REV_MAX	4	/* skbinfo support  */
+/*				4	   skbinfo support  */
+#define IPSET_TYPE_REV_MAX	5	/* nf_inet_addr netmask support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -89,7 +90,7 @@ struct hash_ip4_elem {
 	__be32 ip;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
-	ip &= ip_set_netmask(h->netmask);
+	ip &= h->netmask.mask.ip;
 	if (ip == 0)
 		return -EINVAL;
 
@@ -122,7 +123,7 @@ struct hash_ip4_elem {
 	if (ret)
 		return ret;
 
-	ip &= ip_set_hostmask(h->netmask);
+	ip &= ntohl(h->netmask.mask.ip);
 
 	if (adt == IPSET_TEST) {
 		e.ip = htonl(ip);
@@ -146,7 +147,7 @@ struct hash_ip4_elem {
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
-	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
+	hosts = (h->netmask.cidr == 32 || !h->netmask.cidr) ? 1 : 2 << (32 - h->netmask.cidr - 1);
 
 	if (retried)
 		ip = ntohl(h->next.ip);
@@ -182,9 +183,9 @@ struct hash_ip6_elem {
 }
 
 static inline void
-hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
+hash_ip6_netmask(union nf_inet_addr *ip, const union nf_inet_addr *mask)
 {
-	ip6_netmask(ip, prefix);
+	nf_inet_addr_mask_inplace(ip, mask);
 }
 
 static bool
@@ -223,7 +224,7 @@ struct hash_ip6_elem {
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	hash_ip6_netmask(&e.ip, h->netmask);
+	hash_ip6_netmask(&e.ip, &h->netmask.mask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -EINVAL;
 
@@ -262,7 +263,7 @@ struct hash_ip6_elem {
 	if (ret)
 		return ret;
 
-	hash_ip6_netmask(&e.ip, h->netmask);
+	hash_ip6_netmask(&e.ip, &h->netmask.mask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -IPSET_ERR_HASH_ELEM;
 
@@ -286,7 +287,8 @@ struct hash_ip6_elem {
 		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
-		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8  },
+		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8 },
+		[IPSET_ATTR_NETMASK_MASK] = { .type = NLA_NESTED },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 	},
 	.adt_policy	= {
-- 
1.9.1

