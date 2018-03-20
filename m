From: Joe Perches <joe@perches.com>
Subject: [PATCH] netfilter: ipset: Use is_zero_ether_addr instead of static and memcmp
Date: Tue, 20 Mar 2018 10:35:47 -0700
Message-ID: <687a4edaed07441681d3bfe3b63aa4feb55b9d61.1521567319.git.joe@perches.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

To make the test a bit clearer and to reduce object size a little.

Miscellanea:

o remove now unnecessary static const array

$ size ip_set_hash_mac.o*
   text	   data	    bss	    dec	    hex	filename
  22822	   4619	     64	  27505	   6b71	ip_set_hash_mac.o.allyesconfig.new
  22932	   4683	     64	  27679	   6c1f	ip_set_hash_mac.o.allyesconfig.old
  10443	   1040	      0	  11483	   2cdb	ip_set_hash_mac.o.defconfig.new
  10507	   1040	      0	  11547	   2d1b	ip_set_hash_mac.o.defconfig.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/ipset/ip_set_hash_mac.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 8f004edad396..f9d5a2a1e3d0 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -72,9 +72,6 @@ hash_mac4_data_next(struct hash_mac4_elem *next,
 #define IP_SET_PROTO_UNDEF
 #include "ip_set_hash_gen.h"
 
-/* Zero valued element is not supported */
-static const unsigned char invalid_ether[ETH_ALEN] = { 0 };
-
 static int
 hash_mac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	       const struct xt_action_param *par,
@@ -93,7 +90,7 @@ hash_mac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		return -EINVAL;
 
 	ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
-	if (memcmp(e.ether, invalid_ether, ETH_ALEN) == 0)
+	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -118,7 +115,7 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 	ether_addr_copy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]));
-	if (memcmp(e.ether, invalid_ether, ETH_ALEN) == 0)
+	if (is_zero_ether_addr(e.ether))
 		return -IPSET_ERR_HASH_ELEM;
 
 	return adtfn(set, &e, &ext, &ext, flags);
-- 
2.15.0
