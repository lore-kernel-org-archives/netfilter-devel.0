From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 3/6] netfilter: ipset: Support comments in bitmap-type ipsets.
Date: Mon,  2 Sep 2013 08:35:54 +0200
Message-ID: <1378103757-14426-4-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:56610 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3IBGiH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:38:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 598C8A2D0F
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 07:38:05 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Vx5uk1OPp4jF for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 07:37:14 +0100 (BST)
In-Reply-To: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This provides kernel support for creating bitmap ipsets with comment
support.

As is the case for hashes, this incurs a penalty when flushing or
destroying the entire ipset as the entries must first be walked in order
to free the comment strings. This penalty is of course far less than the
cost of listing an ipset to userspace. Any set created without support
for comments will be flushed/destroyed as before.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h   | 77 +++++++++++++++++++-----
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c    | 31 +++++++++-
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c | 47 ++++++++++++++-
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c  | 30 ++++++++-
 4 files changed, 167 insertions(+), 18 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
index 097da65..42c84fb 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -37,6 +37,8 @@
 	(unsigned long *)((e) + (m)->offset[IPSET_OFFSET_TIMEOUT])
 #define ext_counter(e, m)	\
 	(struct ip_set_counter *)((e) + (m)->offset[IPSET_OFFSET_COUNTER])
+#define ext_comment(e, m)	\
+	(struct ip_set_comment *)((e) + (m)->offset[IPSET_OFFSET_COMMENT])
 #define get_ext(map, id)	((map)->extensions + (map)->dsize * (id))
 
 static void
@@ -52,6 +54,25 @@ mtype_gc_init(struct ip_set *set, void (*gc)(unsigned long ul_set))
 }
 
 static void
+mtype_flush(struct ip_set *set)
+{
+	struct mtype *map = set->data;
+	int id = 0;
+	void *x;
+
+	if (SET_WITH_COMMENT(set)) {
+		for (; id < map->elements; id++) {
+			if (test_bit(id, map->members)) {
+				x = get_ext(map, id);
+				ip_set_comment_free(ext_comment(x, map));
+			}
+		}
+	}
+
+	memset(map->members, 0, map->memsize);
+}
+
+static void
 mtype_destroy(struct ip_set *set)
 {
 	struct mtype *map = set->data;
@@ -59,6 +80,9 @@ mtype_destroy(struct ip_set *set)
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
 
+	if (SET_WITH_COMMENT(set))
+		mtype_flush(set);
+
 	ip_set_free(map->members);
 	if (map->dsize)
 		ip_set_free(map->extensions);
@@ -67,14 +91,6 @@ mtype_destroy(struct ip_set *set)
 	set->data = NULL;
 }
 
-static void
-mtype_flush(struct ip_set *set)
-{
-	struct mtype *map = set->data;
-
-	memset(map->members, 0, map->memsize);
-}
-
 static int
 mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
@@ -94,7 +110,10 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(map->timeout))) ||
 	    (SET_WITH_COUNTER(set) &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
-			   htonl(IPSET_FLAG_WITH_COUNTERS))))
+			   htonl(IPSET_FLAG_WITH_COUNTERS))) ||
+	    (SET_WITH_COMMENT(set) &&
+	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
+			   htonl(IPSET_FLAG_WITH_COMMENTS))))
 		goto nla_put_failure;
 	ipset_nest_end(skb, nested);
 
@@ -148,6 +167,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, map), ext);
+	if (SET_WITH_COMMENT(set))
+		ip_set_init_comment(ext_comment(x, map), ext);
 	return 0;
 }
 
@@ -164,6 +185,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	     ip_set_timeout_expired(ext_timeout(x, map))))
 		return -IPSET_ERR_EXIST;
 
+	if (SET_WITH_COMMENT(set))
+		ip_set_comment_free(ext_comment(x, map));
 	return 0;
 }
 
@@ -215,6 +238,9 @@ mtype_list(const struct ip_set *set,
 		if (SET_WITH_COUNTER(set) &&
 		    ip_set_put_counter(skb, ext_counter(x, map)))
 			goto nla_put_failure;
+		if (SET_WITH_COMMENT(set) &&
+		    ip_set_put_comment(skb, ext_comment(x, map)))
+			goto nla_put_failure;
 		ipset_nest_end(skb, nested);
 	}
 	ipset_nest_end(skb, adt);
@@ -257,16 +283,17 @@ mtype_gc(unsigned long ul_set)
 	add_timer(&map->gc);
 }
 
-#define generate_offsets(X,C,T)						\
+#define generate_offsets(X,C,T,M)					\
 	map->dsize = sizeof(struct IPSET_TOKEN(mtype, X));		\
 	c_off = offsetof(struct IPSET_TOKEN(mtype, C), counter);	\
-	t_off = offsetof(struct IPSET_TOKEN(mtype, T), timeout);
+	t_off = offsetof(struct IPSET_TOKEN(mtype, T), timeout);	\
+	m_off = offsetof(struct IPSET_TOKEN(mtype, M), comment);
 
 static inline int
 mtype_do_create(struct mtype *map, struct nlattr *tb[], struct ip_set *set, create_args)
 {
 	unsigned int cadt_flags = 0, i = IPSET_FLAG_EXT_BEGIN;
-	int c_off = 0, t_off = 0;
+	int c_off = 0, t_off = 0, m_off = 0;
 
 	if(tb[IPSET_ATTR_CADT_FLAGS])
 		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]) & ~IPSET_FLAG_EXT_BEGIN;
@@ -279,14 +306,30 @@ mtype_do_create(struct mtype *map, struct nlattr *tb[], struct ip_set *set, crea
 	} else {
 		switch (cadt_flags) {
 			case (IPSET_FLAG_WITH_COUNTERS  |
+			      IPSET_FLAG_WITH_COMMENTS  |
 			      IPSET_FLAG_WITH_TIMEOUTS) :
-				generate_offsets(ct_elem, ct_elem, ct_elem);
+				generate_offsets(ctm_elem, ctm_elem, ctm_elem, ctm_elem);
+				break;
+			case (IPSET_FLAG_WITH_COUNTERS  |
+			      IPSET_FLAG_WITH_TIMEOUTS) :
+				generate_offsets(ct_elem, ct_elem, ct_elem, m_elem);
+				break;
+			case (IPSET_FLAG_WITH_TIMEOUTS  |
+			      IPSET_FLAG_WITH_COMMENTS) :
+				generate_offsets(tm_elem, c_elem, tm_elem, tm_elem);
+				break;
+			case (IPSET_FLAG_WITH_COUNTERS  |
+			      IPSET_FLAG_WITH_COMMENTS) :
+				generate_offsets(cm_elem, cm_elem, t_elem, cm_elem);
 				break;
 			case  IPSET_FLAG_WITH_TIMEOUTS  :
-				generate_offsets(t_elem, c_elem, t_elem);
+				generate_offsets(t_elem, c_elem, t_elem, m_elem);
 				break;
 			case  IPSET_FLAG_WITH_COUNTERS  :
-				generate_offsets(c_elem, c_elem, t_elem);
+				generate_offsets(c_elem, c_elem, t_elem, m_elem);
+				break;
+			case  IPSET_FLAG_WITH_COMMENTS  :
+				generate_offsets(m_elem, c_elem, t_elem, m_elem);
 				break;
 		}
 		for(; i < (1 << IPSET_FLAG_CADT_MAX) ; i = (i << 1)) {
@@ -295,6 +338,10 @@ mtype_do_create(struct mtype *map, struct nlattr *tb[], struct ip_set *set, crea
 					map->offset[IPSET_OFFSET_COUNTER] = c_off;
 					set->extensions |= IPSET_EXT_COUNTER;
 					break;
+				case IPSET_FLAG_WITH_COMMENTS:
+					map->offset[IPSET_OFFSET_COMMENT] = m_off;
+					set->extensions |= IPSET_EXT_COMMENT;
+					break;
 				case IPSET_FLAG_WITH_TIMEOUTS:
 					map->offset[IPSET_OFFSET_TIMEOUT] = t_off;
 					set->extensions |= IPSET_EXT_TIMEOUT;
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
index 8736e75..33fbeb6 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -26,7 +26,8 @@
 #include <linux/netfilter/ipset/ip_set_bitmap.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added */
+#define IPSET_TYPE_REV_MAX	2	/* Comment support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -221,6 +222,12 @@ struct bitmap_ipc_elem {
 	struct ip_set_counter counter;
 };
 
+/* Comment variant */
+
+struct bitmap_ipm_elem {
+	struct ip_set_comment comment;
+};
+
 /* Timeout variant with counter */
 
 struct bitmap_ipct_elem {
@@ -228,6 +235,28 @@ struct bitmap_ipct_elem {
 	struct ip_set_counter counter;
 };
 
+/* Timeout variant with comment */
+
+struct bitmap_iptm_elem {
+	unsigned long timeout;
+	struct ip_set_comment comment;
+};
+
+/* Counter variant with comment */
+
+struct bitmap_ipcm_elem {
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+/* Timeout + Counter + Comment */
+
+struct bitmap_ipctm_elem {
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Create bitmap:ip type of sets */
 
 static bool
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index ba2cd3e..235d314 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -26,7 +26,8 @@
 #include <linux/netfilter/ipset/ip_set_bitmap.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added */
+#define IPSET_TYPE_REV_MAX	2	/* Comment support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -311,6 +312,16 @@ struct bitmap_ipmacc_elem {
 	struct ip_set_counter counter;
 };
 
+/* Plain variant with comment */
+
+struct bitmap_ipmacm_elem {
+	struct {
+		unsigned char ether[ETH_ALEN];
+		unsigned char filled;
+	} __attribute__ ((aligned));
+	struct ip_set_comment comment;
+};
+
 /* Timeout variant with counter */
 
 struct bitmap_ipmacct_elem {
@@ -322,6 +333,40 @@ struct bitmap_ipmacct_elem {
 	struct ip_set_counter counter;
 };
 
+/* Timeout variant with comment */
+
+struct bitmap_ipmactm_elem {
+	struct {
+		unsigned char ether[ETH_ALEN];
+		unsigned char filled;
+	} __attribute__ ((aligned));
+	unsigned long timeout;
+	struct ip_set_comment comment;
+};
+
+/* Counter variant with comment */
+
+struct bitmap_ipmaccm_elem {
+	struct {
+		unsigned char ether[ETH_ALEN];
+		unsigned char filled;
+	} __attribute__ ((aligned));
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+/* Timeout + Counter + Comment */
+
+struct bitmap_ipmacctm_elem {
+	struct {
+		unsigned char ether[ETH_ALEN];
+		unsigned char filled;
+	} __attribute__ ((aligned));
+	unsigned long timeout;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
 /* Create bitmap:ip,mac type of sets */
 
 static bool
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
index 70a9c09..76e98b5 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -21,7 +21,8 @@
 #include <linux/netfilter/ipset/ip_set_getport.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added */
+#define IPSET_TYPE_REV_MAX	2	/* Comment support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -212,6 +213,12 @@ struct bitmap_portc_elem {
 	struct ip_set_counter counter;
 };
 
+/* Plain variant with comment */
+
+struct bitmap_portm_elem {
+	struct ip_set_comment comment;
+};
+
 /* Timeout variant with counter */
 
 struct bitmap_portct_elem {
@@ -219,6 +226,27 @@ struct bitmap_portct_elem {
 	struct ip_set_counter counter;
 };
 
+/* Timeout variant with comment */
+
+struct bitmap_porttm_elem {
+	unsigned long timeout;
+	struct ip_set_comment comment;
+};
+
+/* Counter variant with comment */
+
+struct bitmap_portcm_elem {
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+/* Timeout + Counter + Comment */
+struct bitmap_portctm_elem {
+	unsigned long timeout;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
 /* Create bitmap:ip type of sets */
 
 static bool
-- 
1.8.3.2

