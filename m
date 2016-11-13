From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 24/39] netfilter: ipset: Add element count to hash headers
Date: Sun, 13 Nov 2016 23:25:18 +0100
Message-ID: <1479075933-4491-25-git-send-email-pablo@netfilter.org>
References: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric B Munson <emunson@akamai.com>

It would be useful for userspace to query the size of an ipset hash,
however, this data is not exposed to userspace outside of counting the
number of member entries.  This patch uses the attribute
IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
exported to userspace.  This field is then printed by the userspace
tool for hashes.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Josh Hunt <johunt@akamai.com>
Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index d32fd6b036bf..f5acfb9709c9 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1083,7 +1083,8 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 #endif
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
-	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
+	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(h->elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
-- 
2.1.4
