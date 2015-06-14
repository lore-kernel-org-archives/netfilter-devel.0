From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 02/15] netfilter: ipset: Use SET_WITH_*() helpers to test set extensions
Date: Sun, 14 Jun 2015 10:56:19 +0200
Message-ID: <1434272192-8620-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:34890 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbbFNI4d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2015 04:56:33 -0400
In-Reply-To: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c     | 12 ++++++------
 net/netfilter/ipset/ip_set_hash_gen.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 475e496..347d97a 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -390,12 +390,12 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 {
 	u64 fullmark;
 	if (tb[IPSET_ATTR_TIMEOUT]) {
-		if (!(set->extensions & IPSET_EXT_TIMEOUT))
+		if (!SET_WITH_TIMEOUT(set))
 			return -IPSET_ERR_TIMEOUT;
 		ext->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 	}
 	if (tb[IPSET_ATTR_BYTES] || tb[IPSET_ATTR_PACKETS]) {
-		if (!(set->extensions & IPSET_EXT_COUNTER))
+		if (!SET_WITH_COUNTER(set))
 			return -IPSET_ERR_COUNTER;
 		if (tb[IPSET_ATTR_BYTES])
 			ext->bytes = be64_to_cpu(nla_get_be64(
@@ -405,25 +405,25 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 						   tb[IPSET_ATTR_PACKETS]));
 	}
 	if (tb[IPSET_ATTR_COMMENT]) {
-		if (!(set->extensions & IPSET_EXT_COMMENT))
+		if (!SET_WITH_COMMENT(set))
 			return -IPSET_ERR_COMMENT;
 		ext->comment = ip_set_comment_uget(tb[IPSET_ATTR_COMMENT]);
 	}
 	if (tb[IPSET_ATTR_SKBMARK]) {
-		if (!(set->extensions & IPSET_EXT_SKBINFO))
+		if (!SET_WITH_SKBINFO(set))
 			return -IPSET_ERR_SKBINFO;
 		fullmark = be64_to_cpu(nla_get_be64(tb[IPSET_ATTR_SKBMARK]));
 		ext->skbmark = fullmark >> 32;
 		ext->skbmarkmask = fullmark & 0xffffffff;
 	}
 	if (tb[IPSET_ATTR_SKBPRIO]) {
-		if (!(set->extensions & IPSET_EXT_SKBINFO))
+		if (!SET_WITH_SKBINFO(set))
 			return -IPSET_ERR_SKBINFO;
 		ext->skbprio = be32_to_cpu(nla_get_be32(
 					    tb[IPSET_ATTR_SKBPRIO]));
 	}
 	if (tb[IPSET_ATTR_SKBQUEUE]) {
-		if (!(set->extensions & IPSET_EXT_SKBINFO))
+		if (!SET_WITH_SKBINFO(set))
 			return -IPSET_ERR_SKBINFO;
 		ext->skbqueue = be16_to_cpu(nla_get_be16(
 					    tb[IPSET_ATTR_SKBQUEUE]));
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 7952869..8dd82db 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -431,7 +431,7 @@ mtype_destroy(struct ip_set *set)
 {
 	struct htype *h = set->data;
 
-	if (set->extensions & IPSET_EXT_TIMEOUT)
+	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&h->gc);
 
 	mtype_ahash_destroy(set, rcu_dereference_bh_nfnl(h->table), true);
-- 
1.8.5.1

