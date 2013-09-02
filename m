From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 2/6] netfilter: ipset: Support comments in hash-type ipsets.
Date: Mon,  2 Sep 2013 08:35:53 +0200
Message-ID: <1378103757-14426-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:56612 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab3IBGiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:38:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 0EF7EA2CFB
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 07:38:07 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id o9BlEkAfbshV for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 07:37:13 +0100 (BST)
In-Reply-To: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This provides kernel support for creating ipsets with comment support.

This does incur a penalty to flushing/destroying an ipset since all
entries are walked in order to free the allocated strings, this penalty
is of course less expensive than the operation of listing an ipset to
userspace, so for general-purpose usage the overall impact is expected
to be little to none.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 72 +++++++++++++----
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        | 51 +++++++++++-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    | 75 +++++++++++++++++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  | 83 +++++++++++++++++++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c | 91 +++++++++++++++++++++-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       | 75 +++++++++++++++++-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  | 91 +++++++++++++++++++++-
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c    | 88 +++++++++++++++++++++
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   | 83 +++++++++++++++++++-
 9 files changed, 688 insertions(+), 21 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index 72e098f..cfeef09 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -184,6 +184,8 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
 (unsigned long *)(((void *)(e)) + (h)->offset[IPSET_OFFSET_TIMEOUT])
 #define ext_counter(e, h)	\
 (struct ip_set_counter *)(((void *)(e)) + (h)->offset[IPSET_OFFSET_COUNTER])
+#define ext_comment(e, h)	\
+(struct ip_set_comment *)(((void *)(e)) + (h)->offset[IPSET_OFFSET_COMMENT])
 
 #endif /* _IP_SET_HASH_GEN_H */
 
@@ -419,6 +421,10 @@ mtype_ahash_memsize(const struct htype *h, const struct htable *t,
 	return memsize;
 }
 
+/* Get the ith element from the array block n */
+#define ahash_data(n, i, dsize)	\
+	((struct mtype_elem *)((n)->value + ((i) * (dsize))))
+
 /* Flush a hash type of set: destroy all elements */
 static void
 mtype_flush(struct ip_set *set)
@@ -426,12 +432,19 @@ mtype_flush(struct ip_set *set)
 	struct htype *h = set->data;
 	struct htable *t;
 	struct hbucket *n;
-	u32 i;
+	struct mtype_elem *data;
+	u32 i, j;
 
 	t = rcu_dereference_bh_nfnl(h->table);
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
 		n = hbucket(t, i);
 		if (n->size) {
+			if (SET_WITH_COMMENT(set)) {
+				for (j = 0; j < n->pos; j++) {
+					data = ahash_data(n, j, h->dsize);
+					ip_set_comment_free(ext_comment(data, h));
+				}
+			}
 			n->size = n->pos = 0;
 			/* FIXME: use slab cache */
 			kfree(n->value);
@@ -453,6 +466,9 @@ mtype_destroy(struct ip_set *set)
 	if (set->extensions & IPSET_EXT_TIMEOUT)
 		del_timer_sync(&h->gc);
 
+	if (SET_WITH_COMMENT(set))
+		mtype_flush(set);
+
 	ahash_destroy(rcu_dereference_bh_nfnl(h->table));
 #ifdef IP_SET_HASH_WITH_RBTREE
 	rbtree_destroy(&h->rbtree);
@@ -491,10 +507,6 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 	       a->extensions == b->extensions;
 }
 
-/* Get the ith element from the array block n */
-#define ahash_data(n, i, dsize)	\
-	((struct mtype_elem *)((n)->value + ((i) * (dsize))))
-
 /* Delete expired elements from the hashtable */
 static void
 mtype_expire(struct htype *h, u8 nets_length, size_t dsize)
@@ -740,6 +752,8 @@ reuse_slot:
 		ip_set_timeout_set(ext_timeout(data, h), ext->timeout);
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, h), ext);
+	if(SET_WITH_COMMENT(set))
+		ip_set_init_comment(ext_comment(data, h), ext);
 
 out:
 	rcu_read_unlock_bh();
@@ -785,6 +799,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		mtype_del_cidr2(h, CIDR(d->cidr2), NETS_LENGTH(set->family));
 #endif
 #endif
+		if(SET_WITH_COMMENT(set))
+			ip_set_comment_free(ext_comment(data, h));
 		if (n->pos + AHASH_INIT_SIZE < n->size) {
 			void *tmp = kzalloc((n->size - AHASH_INIT_SIZE)
 					    * h->dsize,
@@ -949,7 +965,10 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(h->timeout))) ||
 	    ((set->extensions & IPSET_EXT_COUNTER) &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
-			   htonl(IPSET_FLAG_WITH_COUNTERS))))
+			   htonl(IPSET_FLAG_WITH_COUNTERS))) ||
+	    ((set->extensions & IPSET_EXT_COMMENT) &&
+	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
+			   htonl(IPSET_FLAG_WITH_COMMENTS))))
 		goto nla_put_failure;
 	ipset_nest_end(skb, nested);
 
@@ -1006,6 +1025,9 @@ mtype_list(const struct ip_set *set,
 			if (SET_WITH_COUNTER(set) &&
 			    ip_set_put_counter(skb, ext_counter(e, h)))
 				goto nla_put_failure;
+			if (SET_WITH_COMMENT(set) &&
+			    ip_set_put_comment(skb, ext_comment(e,h)))
+				goto nla_put_failure;
 			ipset_nest_end(skb, nested);
 		}
 	}
@@ -1059,7 +1081,7 @@ IPSET_TOKEN(HTYPE, _create)(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u32 cadt_flags = 0;
 	u8 hbits;
-	int i = IPSET_FLAG_EXT_BEGIN, t_off = 0, c_off = 0;
+	int i = IPSET_FLAG_EXT_BEGIN, t_off = 0, c_off = 0, m_off = 0;
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;
 #endif
@@ -1144,33 +1166,55 @@ IPSET_TOKEN(HTYPE, _create)(struct ip_set *set, struct nlattr *tb[], u32 flags)
 /* Due to the inherent limitations of a preprocessor macro, all vars are set
  * and we simply use the ones we need during the flag iteration stage.
  */
-#define generate_offsets(X,C,T)							\
+#define generate_offsets(X,C,T,M)						\
 if(set->family == NFPROTO_IPV4) {						\
 	h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, X)));	\
 	c_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, C)), counter);\
 	t_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, T)), timeout);\
+	m_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, M)), comment);\
 } else {									\
 	h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, X)));	\
 	c_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, C)), counter);\
 	t_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(4, T)), timeout);\
+	m_off = offsetof(struct IPSET_TOKEN(HTYPE, IPSET_TOKEN(6, M)), comment);\
 }
 	if(!cadt_flags) {
-		generate_offsets(_elem,c_elem,t_elem);
+		generate_offsets(_elem,c_elem,t_elem,m_elem);
 	} else {
 		switch(cadt_flags) {
 			case (IPSET_FLAG_WITH_COUNTERS |
+			     IPSET_FLAG_WITH_TIMEOUTS  |
+			     IPSET_FLAG_WITH_COMMENTS) :
+				generate_offsets(ctm_elem, ctm_elem, ctm_elem, ctm_elem);
+				break;
+			case (IPSET_FLAG_WITH_COUNTERS |
 			     IPSET_FLAG_WITH_TIMEOUTS) :
-				generate_offsets(ct_elem, ct_elem, ct_elem);
+				generate_offsets(ct_elem, ct_elem, ct_elem, m_elem);
 				break;
-			case IPSET_FLAG_WITH_TIMEOUTS :
-				generate_offsets(t_elem, c_elem, t_elem);
+			case (IPSET_FLAG_WITH_TIMEOUTS |
+			     IPSET_FLAG_WITH_COMMENTS) :
+				generate_offsets(tm_elem, c_elem, tm_elem, tm_elem);
 				break;
-			case IPSET_FLAG_WITH_COUNTERS :
-				generate_offsets(c_elem, c_elem, t_elem);
+			case (IPSET_FLAG_WITH_COUNTERS |
+			     IPSET_FLAG_WITH_COMMENTS) :
+				generate_offsets(cm_elem, cm_elem, t_elem, cm_elem);
+				break;
+			case IPSET_FLAG_WITH_TIMEOUTS  :
+				generate_offsets(t_elem, c_elem, t_elem, m_elem);
+				break;
+			case IPSET_FLAG_WITH_COUNTERS  :
+				generate_offsets(c_elem, c_elem, t_elem, m_elem);
+				break;
+			case IPSET_FLAG_WITH_COMMENTS  :
+				generate_offsets(m_elem, c_elem, t_elem, m_elem);
 				break;
 		}
 		for(; i < (1 << IPSET_FLAG_CADT_MAX); i = (i << 1)) {
 			switch(cadt_flags & i) {
+				case IPSET_FLAG_WITH_COMMENTS:
+					set->extensions |= IPSET_EXT_COMMENT;
+					h->offset[IPSET_OFFSET_COMMENT] = m_off;
+					break;
 				case IPSET_FLAG_WITH_COUNTERS:
 					set->extensions |= IPSET_EXT_COUNTER;
 					h->offset[IPSET_OFFSET_COUNTER] = c_off;
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index 260c9a8..9746cf8 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,8 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counters support */
+/*				1	   Counters support */
+#define IPSET_TYPE_REV_MAX	2	/* Comments support */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -53,12 +54,36 @@ struct hash_ip4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ip4m_elem {
+	__be32 ip;
+	struct ip_set_comment comment;
+};
+
 struct hash_ip4ct_elem {
 	__be32 ip;
 	struct ip_set_counter counter;
 	unsigned long timeout;
 };
 
+struct hash_ip4tm_elem {
+	__be32 ip;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ip4cm_elem {
+	__be32 ip;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ip4ctm_elem {
+	__be32 ip;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
@@ -195,12 +220,36 @@ struct hash_ip6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ip6m_elem {
+	union nf_inet_addr ip;
+	struct ip_set_comment comment;
+};
+
 struct hash_ip6ct_elem {
 	union nf_inet_addr ip;
 	struct ip_set_counter counter;
 	unsigned long timeout;
 };
 
+struct hash_ip6tm_elem {
+	union nf_inet_addr ip;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ip6cm_elem {
+	union nf_inet_addr ip;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ip6ctm_elem {
+	union nf_inet_addr ip;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 64caad3..5acef50 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -26,7 +26,8 @@
 
 #define IPSET_TYPE_REV_MIN	0
 /*				1    SCTP and UDPLITE support added */
-#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
+/*				2    Counters support added */
+#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -62,6 +63,14 @@ struct hash_ipport4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ipport4m_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+};
+
 struct hash_ipport4ct_elem {
 	__be32 ip;
 	__be16 port;
@@ -71,6 +80,34 @@ struct hash_ipport4ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_ipport4tm_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ipport4cm_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ipport4ctm_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
@@ -247,6 +284,14 @@ struct hash_ipport6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ipport6m_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+};
+
 struct hash_ipport6ct_elem {
 	union nf_inet_addr ip;
 	__be16 port;
@@ -256,6 +301,34 @@ struct hash_ipport6ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_ipport6tm_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ipport6cm_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ipport6ctm_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index 2873bbc..1863d20 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -26,7 +26,8 @@
 
 #define IPSET_TYPE_REV_MIN	0
 /*				1    SCTP and UDPLITE support added */
-#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
+/*				2    Counters support added */
+#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -65,6 +66,15 @@ struct hash_ipportip4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ipportip4m_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+};
+
 struct hash_ipportip4ct_elem {
 	__be32 ip;
 	__be32 ip2;
@@ -75,6 +85,37 @@ struct hash_ipportip4ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_ipportip4tm_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ipportip4cm_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ipportip4ctm_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 static inline bool
 hash_ipportip4_data_equal(const struct hash_ipportip4_elem *ip1,
 			  const struct hash_ipportip4_elem *ip2,
@@ -259,6 +300,15 @@ struct hash_ipportip6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ipportip6m_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+};
+
 struct hash_ipportip6ct_elem {
 	union nf_inet_addr ip;
 	union nf_inet_addr ip2;
@@ -269,6 +319,37 @@ struct hash_ipportip6ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_ipportip6tm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ipportip6cm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ipportip6ctm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 proto;
+	u8 padding;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index f111558..b66177d 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -28,7 +28,8 @@
 /*				1    SCTP and UDPLITE support added */
 /*				2    Range as input support for IPv4 added */
 /*				3    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
+/*				4    Counters support added */
+#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -78,6 +79,16 @@ struct hash_ipportnet4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ipportnet4m_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_comment comment;
+};
+
 struct hash_ipportnet4ct_elem {
 	__be32 ip;
 	__be32 ip2;
@@ -89,6 +100,40 @@ struct hash_ipportnet4ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_ipportnet4tm_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ipportnet4cm_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ipportnet4ctm_elem {
+	__be32 ip;
+	__be32 ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
@@ -359,6 +404,16 @@ struct hash_ipportnet6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_ipportnet6m_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_comment comment;
+};
+
 struct hash_ipportnet6ct_elem {
 	union nf_inet_addr ip;
 	union nf_inet_addr ip2;
@@ -370,6 +425,40 @@ struct hash_ipportnet6ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_ipportnet6tm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_ipportnet6cm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_ipportnet6ctm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	__be16 port;
+	u8 cidr:7;
+	u8 nomatch:1;
+	u8 proto;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index 0a64dad..3990b3f 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -25,7 +25,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1    Range as input support for IPv4 added */
 /*				2    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
+/*				3    Counters support added */
+#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -62,6 +63,14 @@ struct hash_net4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_net4m_elem {
+	__be32 ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	struct ip_set_comment comment;
+};
+
 struct hash_net4ct_elem {
 	__be32 ip;
 	u16 padding0;
@@ -71,6 +80,34 @@ struct hash_net4ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_net4tm_elem {
+	__be32 ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	unsigned long timeout;
+	struct ip_set_comment comment;
+};
+
+struct hash_net4cm_elem {
+	__be32 ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_net4ctm_elem {
+	__be32 ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
@@ -253,6 +290,14 @@ struct hash_net6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_net6m_elem {
+	union nf_inet_addr ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	struct ip_set_comment comment;
+};
+
 struct hash_net6ct_elem {
 	union nf_inet_addr ip;
 	u16 padding0;
@@ -262,6 +307,34 @@ struct hash_net6ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_net6tm_elem {
+	union nf_inet_addr ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	unsigned long timeout;
+	struct ip_set_comment comment;
+};
+
+struct hash_net6cm_elem {
+	union nf_inet_addr ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_net6ctm_elem {
+	union nf_inet_addr ip;
+	u16 padding0;
+	u8 nomatch;
+	u8 cidr;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 846371b..390490d 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -26,7 +26,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1    nomatch flag support added */
 /*				2    /0 support added */
-#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
+/*				3    Counters support added */
+#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -174,6 +175,16 @@ struct hash_netiface4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_netiface4m_elem {
+	__be32 ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_comment comment;
+};
+
 struct hash_netiface4ct_elem {
 	__be32 ip;
 	u8 physdev;
@@ -185,6 +196,40 @@ struct hash_netiface4ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_netiface4tm_elem {
+	__be32 ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_netiface4cm_elem {
+	__be32 ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_netiface4ctm_elem {
+	__be32 ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
@@ -438,6 +483,16 @@ struct hash_netiface6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_netiface6m_elem {
+	union nf_inet_addr ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_comment comment;
+};
+
 struct hash_netiface6ct_elem {
 	union nf_inet_addr ip;
 	u8 physdev;
@@ -449,6 +504,40 @@ struct hash_netiface6ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_netiface6tm_elem {
+	union nf_inet_addr ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_netiface6cm_elem {
+	union nf_inet_addr ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_netiface6ctm_elem {
+	union nf_inet_addr ip;
+	u8 physdev;
+	u8 cidr;
+	u8 nomatch;
+	u8 elem;
+	const char *iface;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
index de8e634..dc96604 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -68,6 +68,38 @@ struct hash_netnet4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_netnet4m_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_comment comment;
+};
+
+struct hash_netnet4cm_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_comment comment;
+	struct ip_set_counter counter;
+};
+
+struct hash_netnet4tm_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 struct hash_netnet4ct_elem {
 	__be32 ip;
 	__be32 ip2;
@@ -79,6 +111,18 @@ struct hash_netnet4ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_netnet4ctm_elem {
+	__be32 ip;
+	__be32 ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_comment comment;
+	struct ip_set_counter counter;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
@@ -316,6 +360,38 @@ struct hash_netnet6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_netnet6m_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_comment comment;
+};
+
+struct hash_netnet6tm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	unsigned long timeout;
+	struct ip_set_comment comment;
+};
+
+struct hash_netnet6cm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
 struct hash_netnet6ct_elem {
 	union nf_inet_addr ip;
 	union nf_inet_addr ip2;
@@ -327,6 +403,18 @@ struct hash_netnet6ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_netnet6ctm_elem {
+	union nf_inet_addr ip;
+	union nf_inet_addr ip2;
+	u8 padding0;
+	u8 nomatch;
+	u8 cidr;
+	u8 cidr2;
+	struct ip_set_comment comment;
+	struct ip_set_counter counter;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index d98a685..1ba5bc5 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -27,7 +27,8 @@
 /*				1    SCTP and UDPLITE support added */
 /*				2    Range as input support for IPv4 added */
 /*				3    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
+/*				4    Counters support added */
+#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -74,6 +75,15 @@ struct hash_netport4c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_netport4m_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_comment comment;
+};
+
 struct hash_netport4ct_elem {
 	__be32 ip;
 	__be16 port;
@@ -84,6 +94,37 @@ struct hash_netport4ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_netport4tm_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_netport4cm_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_netport4ctm_elem {
+	__be32 ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
@@ -315,6 +356,15 @@ struct hash_netport6c_elem {
 	struct ip_set_counter counter;
 };
 
+struct hash_netport6m_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_comment comment;
+};
+
 struct hash_netport6ct_elem {
 	union nf_inet_addr ip;
 	__be16 port;
@@ -325,6 +375,37 @@ struct hash_netport6ct_elem {
 	unsigned long timeout;
 };
 
+struct hash_netport6tm_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
+struct hash_netport6cm_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+};
+
+struct hash_netport6ctm_elem {
+	union nf_inet_addr ip;
+	__be16 port;
+	u8 proto;
+	u8 cidr:7;
+	u8 nomatch:1;
+	struct ip_set_counter counter;
+	struct ip_set_comment comment;
+	unsigned long timeout;
+};
+
 /* Common functions */
 
 static inline bool
-- 
1.8.3.2

