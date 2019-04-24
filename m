Return-Path: <SRS0=Os8a=S2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD32C10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 21:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D48B2183E
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 21:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbfDXVeg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 17:34:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:53536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731648AbfDXVeb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 17:34:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8AACAD6D;
        Wed, 24 Apr 2019 21:34:27 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 50939E0143; Wed, 24 Apr 2019 23:34:27 +0200 (CEST)
Message-Id: <a189cf17b3dbef8d250cefe90ca448f5dc3bf363.1556140270.git.mkubecek@suse.cz>
In-Reply-To: <cover.1556140270.git.mkubecek@suse.cz>
References: <cover.1556140270.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [RFC PATCH net-next 2/3] ipset: drop ipset_nest_start() and
 ipset_nest_end()
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Date:   Wed, 24 Apr 2019 23:34:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After the previous commit, both ipset_nest_start() and ipset_nest_end() are
just aliases for nla_nest_start() and nla_nest_end() so that there is no
need to keep them.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/netfilter/ipset/ip_set.h  | 11 ++++-------
 net/netfilter/ipset/ip_set_bitmap_gen.h | 14 +++++++-------
 net/netfilter/ipset/ip_set_hash_gen.h   | 14 +++++++-------
 net/netfilter/ipset/ip_set_list_set.c   | 14 +++++++-------
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 965dc6c6653e..e499d170f12d 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -401,33 +401,30 @@ ip_set_get_h16(const struct nlattr *attr)
 	return ntohs(nla_get_be16(attr));
 }
 
-#define ipset_nest_start(skb, attr) nla_nest_start(skb, attr)
-#define ipset_nest_end(skb, start)  nla_nest_end(skb, start)
-
 static inline int nla_put_ipaddr4(struct sk_buff *skb, int type, __be32 ipaddr)
 {
-	struct nlattr *__nested = ipset_nest_start(skb, type);
+	struct nlattr *__nested = nla_nest_start(skb, type);
 	int ret;
 
 	if (!__nested)
 		return -EMSGSIZE;
 	ret = nla_put_in_addr(skb, IPSET_ATTR_IPADDR_IPV4, ipaddr);
 	if (!ret)
-		ipset_nest_end(skb, __nested);
+		nla_nest_end(skb, __nested);
 	return ret;
 }
 
 static inline int nla_put_ipaddr6(struct sk_buff *skb, int type,
 				  const struct in6_addr *ipaddrptr)
 {
-	struct nlattr *__nested = ipset_nest_start(skb, type);
+	struct nlattr *__nested = nla_nest_start(skb, type);
 	int ret;
 
 	if (!__nested)
 		return -EMSGSIZE;
 	ret = nla_put_in6_addr(skb, IPSET_ATTR_IPADDR_IPV6, ipaddrptr);
 	if (!ret)
-		ipset_nest_end(skb, __nested);
+		nla_nest_end(skb, __nested);
 	return ret;
 }
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 257ca393e6f2..38ef2ea838cb 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -99,7 +99,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	struct nlattr *nested;
 	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
 
-	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
+	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
 	if (mtype_do_head(skb, map) ||
@@ -109,7 +109,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
-	ipset_nest_end(skb, nested);
+	nla_nest_end(skb, nested);
 
 	return 0;
 nla_put_failure:
@@ -213,7 +213,7 @@ mtype_list(const struct ip_set *set,
 	u32 id, first = cb->args[IPSET_CB_ARG0];
 	int ret = 0;
 
-	adt = ipset_nest_start(skb, IPSET_ATTR_ADT);
+	adt = nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!adt)
 		return -EMSGSIZE;
 	/* Extensions may be replaced */
@@ -230,7 +230,7 @@ mtype_list(const struct ip_set *set,
 #endif
 		     ip_set_timeout_expired(ext_timeout(x, set))))
 			continue;
-		nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
+		nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 		if (!nested) {
 			if (id == first) {
 				nla_nest_cancel(skb, adt);
@@ -244,9 +244,9 @@ mtype_list(const struct ip_set *set,
 			goto nla_put_failure;
 		if (ip_set_put_extensions(skb, set, x, mtype_is_filled(x)))
 			goto nla_put_failure;
-		ipset_nest_end(skb, nested);
+		nla_nest_end(skb, nested);
 	}
-	ipset_nest_end(skb, adt);
+	nla_nest_end(skb, adt);
 
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
@@ -259,7 +259,7 @@ mtype_list(const struct ip_set *set,
 		cb->args[IPSET_CB_ARG0] = 0;
 		ret = -EMSGSIZE;
 	}
-	ipset_nest_end(skb, adt);
+	nla_nest_end(skb, adt);
 out:
 	rcu_read_unlock();
 	return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 2c9609929c71..01d51f775f12 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1057,7 +1057,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
-	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
+	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_HASHSIZE,
@@ -1079,7 +1079,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
-	ipset_nest_end(skb, nested);
+	nla_nest_end(skb, nested);
 
 	return 0;
 nla_put_failure:
@@ -1124,7 +1124,7 @@ mtype_list(const struct ip_set *set,
 	void *incomplete;
 	int i, ret = 0;
 
-	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
+	atd = nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
 		return -EMSGSIZE;
 
@@ -1150,7 +1150,7 @@ mtype_list(const struct ip_set *set,
 				continue;
 			pr_debug("list hash %lu hbucket %p i %u, data %p\n",
 				 cb->args[IPSET_CB_ARG0], n, i, e);
-			nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
+			nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 			if (!nested) {
 				if (cb->args[IPSET_CB_ARG0] == first) {
 					nla_nest_cancel(skb, atd);
@@ -1163,10 +1163,10 @@ mtype_list(const struct ip_set *set,
 				goto nla_put_failure;
 			if (ip_set_put_extensions(skb, set, e, true))
 				goto nla_put_failure;
-			ipset_nest_end(skb, nested);
+			nla_nest_end(skb, nested);
 		}
 	}
-	ipset_nest_end(skb, atd);
+	nla_nest_end(skb, atd);
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
 
@@ -1180,7 +1180,7 @@ mtype_list(const struct ip_set *set,
 		cb->args[IPSET_CB_ARG0] = 0;
 		ret = -EMSGSIZE;
 	} else {
-		ipset_nest_end(skb, atd);
+		nla_nest_end(skb, atd);
 	}
 out:
 	rcu_read_unlock();
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 8da228da53ae..4f894165cdcd 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -466,7 +466,7 @@ list_set_head(struct ip_set *set, struct sk_buff *skb)
 	struct nlattr *nested;
 	size_t memsize = list_set_memsize(map, set->dsize) + set->ext_size;
 
-	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
+	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_SIZE, htonl(map->size)) ||
@@ -476,7 +476,7 @@ list_set_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
-	ipset_nest_end(skb, nested);
+	nla_nest_end(skb, nested);
 
 	return 0;
 nla_put_failure:
@@ -494,7 +494,7 @@ list_set_list(const struct ip_set *set,
 	struct set_elem *e;
 	int ret = 0;
 
-	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
+	atd = nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
 		return -EMSGSIZE;
 
@@ -506,7 +506,7 @@ list_set_list(const struct ip_set *set,
 			i++;
 			continue;
 		}
-		nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
+		nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 		if (!nested)
 			goto nla_put_failure;
 		ip_set_name_byindex(map->net, e->id, name);
@@ -514,11 +514,11 @@ list_set_list(const struct ip_set *set,
 			goto nla_put_failure;
 		if (ip_set_put_extensions(skb, set, e, true))
 			goto nla_put_failure;
-		ipset_nest_end(skb, nested);
+		nla_nest_end(skb, nested);
 		i++;
 	}
 
-	ipset_nest_end(skb, atd);
+	nla_nest_end(skb, atd);
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
 	goto out;
@@ -531,7 +531,7 @@ list_set_list(const struct ip_set *set,
 		ret = -EMSGSIZE;
 	} else {
 		cb->args[IPSET_CB_ARG0] = i;
-		ipset_nest_end(skb, atd);
+		nla_nest_end(skb, atd);
 	}
 out:
 	rcu_read_unlock();
-- 
2.21.0

