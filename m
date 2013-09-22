From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 4/7] netfilter: ipset: Support comments in the list-type ipset.
Date: Sun, 22 Sep 2013 20:56:33 +0200
Message-ID: <1379876196-46929-4-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:55773 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3IVS6N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:58:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 947F4A31F0
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2013 19:58:12 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id rnRLSCVNJ6-8 for <netfilter-devel@vger.kernel.org>;
	Sun, 22 Sep 2013 19:57:45 +0100 (BST)
In-Reply-To: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This provides kernel support for creating list ipsets with the comment
annotation extension.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_list_set.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_list_set.c b/kernel/net/netfilter/ipset/ip_set_list_set.c
index 30bf1dd..5dda05e 100644
--- a/kernel/net/netfilter/ipset/ip_set_list_set.c
+++ b/kernel/net/netfilter/ipset/ip_set_list_set.c
@@ -16,7 +16,8 @@
 #include <linux/netfilter/ipset/ip_set_list.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1 /* Counters support added */
+/*				1    Counters support added */
+#define IPSET_TYPE_REV_MAX	2 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -191,6 +192,8 @@ list_set_add(struct ip_set *set, u32 i, struct set_adt_elem *d,
 		ip_set_timeout_set(ext_timeout(e, set), ext->timeout);
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(e, set), ext);
+	if (SET_WITH_COMMENT(set) && ext->comment)
+		ip_set_init_comment(ext_comment(e, set), ext);
 	return 0;
 }
 
@@ -299,6 +302,8 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			ip_set_timeout_set(ext_timeout(e, set), ext->timeout);
 		if (SET_WITH_COUNTER(set))
 			ip_set_init_counter(ext_counter(e, set), ext);
+		if (SET_WITH_COMMENT(set))
+			ip_set_init_comment(ext_comment(e, set), ext);
 		/* Set is already added to the list */
 		ip_set_put_byindex(d->id);
 		return 0;
@@ -461,15 +466,12 @@ list_set_head(struct ip_set *set, struct sk_buff *skb)
 	if (!nested)
 		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_SIZE, htonl(map->size)) ||
-	    (SET_WITH_TIMEOUT(set) &&
-	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
-	    (SET_WITH_COUNTER(set) &&
-	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
-			   htonl(IPSET_FLAG_WITH_COUNTERS))) ||
 	    nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE,
 			  htonl(sizeof(*map) + map->size * set->dsize)))
 		goto nla_put_failure;
+	if (unlikely(ip_set_put_flags(skb, set)))
+		goto nla_put_failure;
 	ipset_nest_end(skb, nested);
 
 	return 0;
@@ -516,6 +518,9 @@ list_set_list(const struct ip_set *set,
 		if (SET_WITH_COUNTER(set) &&
 		    ip_set_put_counter(skb, ext_counter(e, set)))
 			goto nla_put_failure;
+		if (SET_WITH_COMMENT(set) &&
+		    ip_set_put_comment(skb, ext_comment(e, set)))
+			goto nla_put_failure;
 		ipset_nest_end(skb, nested);
 	}
 finish:
@@ -660,6 +665,7 @@ static struct ip_set_type list_set_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
-- 
1.8.3.2

