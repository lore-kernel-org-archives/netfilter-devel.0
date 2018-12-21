From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/37] netfilter: ipset: Make invalid MAC address checks consistent
Date: Fri, 21 Dec 2018 01:28:06 +0100
Message-ID: <20181221002841.28587-3-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Set types bitmap:ipmac and hash:ipmac check that MAC addresses
are not all zeroes.

Introduce one missing check, and make the remaining ones
consistent, using is_zero_ether_addr() instead of comparing
against an array containing zeroes.

This was already done for hash:mac sets in commit 26c97c5d8dac
("netfilter: ipset: Use is_zero_ether_addr instead of static and
memcmp").

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |  3 +++
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 11 ++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 13ade5782847..980000fc3b50 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -235,6 +235,9 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
+	if (is_zero_ether_addr(e.ether))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index fd87de3ed55b..c830c68142ff 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -36,9 +36,6 @@ MODULE_ALIAS("ip_set_hash:ip,mac");
 /* Type specific function prefix */
 #define HTYPE		hash_ipmac
 
-/* Zero valued element is not supported */
-static const unsigned char invalid_ether[ETH_ALEN] = { 0 };
-
 /* IPv4 variant */
 
 /* Member elements */
@@ -108,7 +105,7 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
@@ -144,7 +141,7 @@ hash_ipmac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 	memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -IPSET_ERR_HASH_ELEM;
 
 	return adtfn(set, &e, &ext, &ext, flags);
@@ -224,7 +221,7 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
@@ -264,7 +261,7 @@ hash_ipmac6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -IPSET_ERR_HASH_ELEM;
 
 	return adtfn(set, &e, &ext, &ext, flags);
-- 
2.11.0
