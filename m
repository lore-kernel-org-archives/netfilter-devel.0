From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH] netfilter: ipset: rework extensions handling to be more manageable.
Date: Sun,  1 Sep 2013 08:47:28 +0200
Message-ID: <1378018048-23389-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:53020 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3IAGsN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Sep 2013 02:48:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 4FE88A2C14
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Sep 2013 07:48:02 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id uHXhjIYIS460 for <netfilter-devel@vger.kernel.org>;
	Sun,  1 Sep 2013 07:47:30 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

The previous code that handled all the various combinations of ipset
extensions was a rather unwieldly tree of if/else statements. This code
makes some headway into cleaning that up by using a switch statement to
setup the appropriate offsets and then iterate all the possible flags so
we correctly setup the offsets in the hash.

This should significantly reduce the new lines of code that would have
to be introduced to add more extensions in the future.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   8 +-
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 121 ++++++++-------------
 2 files changed, 54 insertions(+), 75 deletions(-)

diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index 8024cdf..17779ca 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -166,7 +166,11 @@ enum ipset_cmd_flags {
 	IPSET_FLAG_CMD_MAX = 15,
 };
 
-/* Flags at CADT attribute level, upper half of cmdattrs */
+/* Flags at CADT attribute level, upper half of cmdattrs
+ *
+ * We recycle NOMATCH for TIMEOUT since it is only used for
+ * ipset creation.
+ */
 enum ipset_cadt_flags {
 	IPSET_FLAG_BIT_BEFORE	= 0,
 	IPSET_FLAG_BEFORE	= (1 << IPSET_FLAG_BIT_BEFORE),
@@ -174,6 +178,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_PHYSDEV	= (1 << IPSET_FLAG_BIT_PHYSDEV),
 	IPSET_FLAG_BIT_NOMATCH	= 2,
 	IPSET_FLAG_NOMATCH	= (1 << IPSET_FLAG_BIT_NOMATCH),
+	IPSET_FLAG_EXT_BEGIN = 2,
+	IPSET_FLAG_WITH_TIMEOUTS = (1 << IPSET_FLAG_EXT_BEGIN),
 	IPSET_FLAG_BIT_WITH_COUNTERS = 3,
 	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
 	IPSET_FLAG_CADT_MAX	= 15,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index 906c778..047a877 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1056,6 +1056,7 @@ IPSET_TOKEN(HTYPE, _create)(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u32 cadt_flags = 0;
 	u8 hbits;
+	int i = IPSET_FLAG_EXT_BEGIN, t_off = 0, c_off = 0;
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;
 #endif
@@ -1134,82 +1135,54 @@ IPSET_TOKEN(HTYPE, _create)(struct ip_set *set, struct nlattr *tb[], u32 flags)
 		set->variant = &IPSET_TOKEN(HTYPE, 6_variant);
 
 	if (tb[IPSET_ATTR_CADT_FLAGS])
-		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-	if (cadt_flags & IPSET_FLAG_WITH_COUNTERS) {
-		set->extensions |= IPSET_EXT_COUNTER;
-		if (tb[IPSET_ATTR_TIMEOUT]) {
-			h->timeout =
-				ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-			set->extensions |= IPSET_EXT_TIMEOUT;
-			if (set->family == NFPROTO_IPV4) {
-				h->dsize = sizeof(struct
-					IPSET_TOKEN(HTYPE, 4ct_elem));
-				h->offset[IPSET_OFFSET_TIMEOUT] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 4ct_elem),
-						timeout);
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 4ct_elem),
-						counter);
-				IPSET_TOKEN(HTYPE, 4_gc_init)(set,
-					IPSET_TOKEN(HTYPE, 4_gc));
-			} else {
-				h->dsize = sizeof(struct
-					IPSET_TOKEN(HTYPE, 6ct_elem));
-				h->offset[IPSET_OFFSET_TIMEOUT] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 6ct_elem),
-						timeout);
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 6ct_elem),
-						counter);
-				IPSET_TOKEN(HTYPE, 6_gc_init)(set,
-					IPSET_TOKEN(HTYPE, 6_gc));
-			}
-		} else {
-			if (set->family == NFPROTO_IPV4) {
-				h->dsize =
-					sizeof(struct
-						IPSET_TOKEN(HTYPE, 4c_elem));
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 4c_elem),
-						counter);
-			} else {
-				h->dsize =
-					sizeof(struct
-						IPSET_TOKEN(HTYPE, 6c_elem));
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 6c_elem),
-						counter);
-			}
+		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]) & ~IPSET_FLAG_EXT_BEGIN;
+	if (tb[IPSET_ATTR_TIMEOUT])
+		cadt_flags |= IPSET_FLAG_WITH_TIMEOUTS;
+/* Due to the inherent limitations of a preprocessor macro, all vars are set
+ * and we simply use the ones we need during the flag iteration stage.
+ */
+#define generate_offsets(X,C,T)							\
+if(set->family == NFPROTO_IPV4) {						\
+	h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, X)));	\
+	c_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, C)), counter);\
+	t_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, T)), timeout);\
+} else {									\
+	h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, X)));	\
+	c_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, C)), counter);\
+	t_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, T)), timeout);\
+}
+	if(!cadt_flags) {
+		generate_offsets(_elem,c_elem,t_elem);
+	} else {
+		switch(cadt_flags) {
+			case (IPSET_FLAG_WITH_COUNTERS |
+			     IPSET_FLAG_WITH_TIMEOUTS) :
+				generate_offsets(ct_elem, ct_elem, ct_elem);
+				break;
+			case IPSET_FLAG_WITH_TIMEOUTS :
+				generate_offsets(t_elem, c_elem, t_elem);
+				break;
+			case IPSET_FLAG_WITH_COUNTERS :
+				generate_offsets(c_elem, c_elem, t_elem);
+				break;
 		}
-	} else if (tb[IPSET_ATTR_TIMEOUT]) {
-		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-		set->extensions |= IPSET_EXT_TIMEOUT;
-		if (set->family == NFPROTO_IPV4) {
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 4t_elem));
-			h->offset[IPSET_OFFSET_TIMEOUT] =
-				offsetof(struct IPSET_TOKEN(HTYPE, 4t_elem),
-					 timeout);
-			IPSET_TOKEN(HTYPE, 4_gc_init)(set,
-				IPSET_TOKEN(HTYPE, 4_gc));
-		} else {
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 6t_elem));
-			h->offset[IPSET_OFFSET_TIMEOUT] =
-				offsetof(struct IPSET_TOKEN(HTYPE, 6t_elem),
-					 timeout);
-			IPSET_TOKEN(HTYPE, 6_gc_init)(set,
-				IPSET_TOKEN(HTYPE, 6_gc));
+		for(; i < (1 << IPSET_FLAG_CADT_MAX); i = (i << 1)) {
+			switch(cadt_flags & i) {
+				case IPSET_FLAG_WITH_COUNTERS:
+					set->extensions |= IPSET_EXT_COUNTER;
+					h->offset[IPSET_OFFSET_COUNTER] = c_off;
+					break;
+				case IPSET_FLAG_WITH_TIMEOUTS:
+					set->extensions |= IPSET_EXT_TIMEOUT;
+					h->offset[IPSET_OFFSET_TIMEOUT] = t_off;
+					h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
+					if(set->family == NFPROTO_IPV4)
+						IPSET_TOKEN(HTYPE, 4_gc_init)(set, IPSET_TOKEN(HTYPE, 4_gc));
+					else
+						IPSET_TOKEN(HTYPE, 6_gc_init)(set, IPSET_TOKEN(HTYPE, 6_gc));
+					break;
+			}
 		}
-	} else {
-		if (set->family == NFPROTO_IPV4)
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 4_elem));
-		else
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 6_elem));
 	}
 
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
-- 
1.8.2.1

