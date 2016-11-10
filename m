From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 09/22] netfilter: ipset: Add element count to hash headers
Date: Thu, 10 Nov 2016 13:57:43 +0100
Message-ID: <1478782676-9770-10-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48999 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933204AbcKJM6G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:06 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
index d32fd6b..f5acfb9 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1083,7 +1083,8 @@ struct htype {
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
1.8.5.1

