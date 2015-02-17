From: Eric B Munson <emunson@akamai.com>
Subject: [PATCH RESEND] Add element count to bitmap and hash headers
Date: Tue, 17 Feb 2015 10:35:35 -0500
Message-ID: <1424187335-5968-1-git-send-email-emunson@akamai.com>
Cc: kadlec@blackhole.kfki.hu, johunt@akamai.com,
	Eric B Munson <emunson@akamai.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:35630 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579AbbBQPfo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 10:35:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It would be useful for userspace to query the size of an ipset.  This
data is held for both the bitmask and hash types, however, it is not
exposed to userspace.  This patch uses the otherwise unused attribute
IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
exported to userspace.

Signed-off-by: Eric B Munson <emunson@akamai.com>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h |    3 ++-
 net/netfilter/ipset/ip_set_hash_gen.h   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 6f024a8..faa9f3e 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -101,7 +101,8 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE,
 			  htonl(sizeof(*map) +
 				map->memsize +
-				set->dsize * map->elements)))
+				set->dsize * map->elements)) ||
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(map->elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 974ff38..3734b2f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -930,7 +930,8 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 #endif
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
-	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
+	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(h->elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
-- 
1.7.9.5

