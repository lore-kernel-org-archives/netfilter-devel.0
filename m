From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 03/22] netfilter: ipset: Improve skbinfo get/init helpers
Date: Sun, 23 Oct 2016 22:37:36 +0200
Message-ID: <1477255075-15255-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52270 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756724AbcJWUiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:02 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use struct ip_set_skbinfo in struct ip_set_ext instead of open
coded fields and assign structure members in get/init helpers
instead of copying members one by one.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h | 30 +++++++++++-------------------
 net/netfilter/ipset/ip_set_core.c      | 12 ++++++------
 net/netfilter/xt_set.c                 | 12 +++++++-----
 3 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 1ea28e3..7802621 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -92,17 +92,6 @@ struct ip_set_ext_type {
 
 extern const struct ip_set_ext_type ip_set_extensions[];
 
-struct ip_set_ext {
-	u64 packets;
-	u64 bytes;
-	u32 timeout;
-	u32 skbmark;
-	u32 skbmarkmask;
-	u32 skbprio;
-	u16 skbqueue;
-	char *comment;
-};
-
 struct ip_set_counter {
 	atomic64_t bytes;
 	atomic64_t packets;
@@ -122,6 +111,15 @@ struct ip_set_skbinfo {
 	u32 skbmarkmask;
 	u32 skbprio;
 	u16 skbqueue;
+	u16 __pad;
+};
+
+struct ip_set_ext {
+	struct ip_set_skbinfo skbinfo;
+	u64 packets;
+	u64 bytes;
+	char *comment;
+	u32 timeout;
 };
 
 struct ip_set;
@@ -360,10 +358,7 @@ struct ip_set {
 		   const struct ip_set_ext *ext,
 		   struct ip_set_ext *mext, u32 flags)
 {
-	mext->skbmark = skbinfo->skbmark;
-	mext->skbmarkmask = skbinfo->skbmarkmask;
-	mext->skbprio = skbinfo->skbprio;
-	mext->skbqueue = skbinfo->skbqueue;
+	mext->skbinfo = *skbinfo;
 }
 
 static inline bool
@@ -387,10 +382,7 @@ struct ip_set {
 ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 		    const struct ip_set_ext *ext)
 {
-	skbinfo->skbmark = ext->skbmark;
-	skbinfo->skbmarkmask = ext->skbmarkmask;
-	skbinfo->skbprio = ext->skbprio;
-	skbinfo->skbqueue = ext->skbqueue;
+	*skbinfo = ext->skbinfo;
 }
 
 /* Netlink CB args */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index a748b0c..3bca341 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -426,20 +426,20 @@ static inline struct ip_set_net *ip_set_pernet(struct net *net)
 		if (!SET_WITH_SKBINFO(set))
 			return -IPSET_ERR_SKBINFO;
 		fullmark = be64_to_cpu(nla_get_be64(tb[IPSET_ATTR_SKBMARK]));
-		ext->skbmark = fullmark >> 32;
-		ext->skbmarkmask = fullmark & 0xffffffff;
+		ext->skbinfo.skbmark = fullmark >> 32;
+		ext->skbinfo.skbmarkmask = fullmark & 0xffffffff;
 	}
 	if (tb[IPSET_ATTR_SKBPRIO]) {
 		if (!SET_WITH_SKBINFO(set))
 			return -IPSET_ERR_SKBINFO;
-		ext->skbprio = be32_to_cpu(nla_get_be32(
-					    tb[IPSET_ATTR_SKBPRIO]));
+		ext->skbinfo.skbprio =
+			be32_to_cpu(nla_get_be32(tb[IPSET_ATTR_SKBPRIO]));
 	}
 	if (tb[IPSET_ATTR_SKBQUEUE]) {
 		if (!SET_WITH_SKBINFO(set))
 			return -IPSET_ERR_SKBINFO;
-		ext->skbqueue = be16_to_cpu(nla_get_be16(
-					    tb[IPSET_ATTR_SKBQUEUE]));
+		ext->skbinfo.skbqueue =
+			be16_to_cpu(nla_get_be16(tb[IPSET_ATTR_SKBQUEUE]));
 	}
 	return 0;
 }
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 5669e5b..e6a8232 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -423,6 +423,8 @@ struct ip_set_adt_opt n = {		\
 
 /* Revision 3 target */
 
+#define MOPT(opt, member)	((opt).ext.skbinfo.member)
+
 static unsigned int
 set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -453,14 +455,14 @@ struct ip_set_adt_opt n = {		\
 		if (!ret)
 			return XT_CONTINUE;
 		if (map_opt.cmdflags & IPSET_FLAG_MAP_SKBMARK)
-			skb->mark = (skb->mark & ~(map_opt.ext.skbmarkmask))
-				    ^ (map_opt.ext.skbmark);
+			skb->mark = (skb->mark & ~MOPT(map_opt,skbmarkmask))
+				    ^ MOPT(map_opt, skbmark);
 		if (map_opt.cmdflags & IPSET_FLAG_MAP_SKBPRIO)
-			skb->priority = map_opt.ext.skbprio;
+			skb->priority = MOPT(map_opt, skbprio);
 		if ((map_opt.cmdflags & IPSET_FLAG_MAP_SKBQUEUE) &&
 		    skb->dev &&
-		    skb->dev->real_num_tx_queues > map_opt.ext.skbqueue)
-			skb_set_queue_mapping(skb, map_opt.ext.skbqueue);
+		    skb->dev->real_num_tx_queues > MOPT(map_opt, skbqueue))
+			skb_set_queue_mapping(skb, MOPT(map_opt, skbqueue));
 	}
 	return XT_CONTINUE;
 }
-- 
1.8.5.1

