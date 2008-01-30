From: heitzenberger@astaro.com
Subject: [ULOGD RFC 08/30] NFCT: rework
Date: Wed, 30 Jan 2008 19:58:55 +0100
Message-ID: <20080130190127.400747893@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-28.dex002.intermedia.net ([64.78.21.113]:20892 "EHLO
	dhost002-28.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbYA3TBp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:45 -0500
Content-Disposition: inline; filename=ulogd-NFCT-plugin.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also implement garbage collection to account for the fact that netlink
messages are sometimes lost (ENOBUFS) on busy sites.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/linux_jhash.h
===================================================================
--- /dev/null
+++ ulogd-netfilter/input/flow/linux_jhash.h
@@ -0,0 +1,146 @@
+#ifndef _LINUX_JHASH_H
+#define _LINUX_JHASH_H
+
+/* jhash.h: Jenkins hash support.
+ *
+ * Copyright (C) 1996 Bob Jenkins (bob_jenkins@burtleburtle.net)
+ *
+ * http://burtleburtle.net/bob/hash/
+ *
+ * These are the credits from Bob's sources:
+ *
+ * lookup2.c, by Bob Jenkins, December 1996, Public Domain.
+ * hash(), hash2(), hash3, and mix() are externally useful functions.
+ * Routines to test the hash are included if SELF_TEST is defined.
+ * You can use this free for any purpose.  It has no warranty.
+ *
+ * Copyright (C) 2003 David S. Miller (davem@redhat.com)
+ *
+ * I've modified Bob's hash to be useful in the Linux kernel, and
+ * any bugs present are surely my fault.  -DaveM
+ */
+
+#define u32		uint32_t
+#define u8		uint8_t
+
+/* NOTE: Arguments are modified. */
+#define __jhash_mix(a, b, c) \
+{ \
+  a -= b; a -= c; a ^= (c>>13); \
+  b -= c; b -= a; b ^= (a<<8); \
+  c -= a; c -= b; c ^= (b>>13); \
+  a -= b; a -= c; a ^= (c>>12);  \
+  b -= c; b -= a; b ^= (a<<16); \
+  c -= a; c -= b; c ^= (b>>5); \
+  a -= b; a -= c; a ^= (c>>3);  \
+  b -= c; b -= a; b ^= (a<<10); \
+  c -= a; c -= b; c ^= (b>>15); \
+}
+
+/* The golden ration: an arbitrary value */
+#define JHASH_GOLDEN_RATIO	0x9e3779b9
+
+/* The most generic version, hashes an arbitrary sequence
+ * of bytes.  No alignment or length assumptions are made about
+ * the input key.
+ */
+static inline u32 jhash(const void *key, u32 length, u32 initval)
+{
+	u32 a, b, c, len;
+	const u8 *k = key;
+
+	len = length;
+	a = b = JHASH_GOLDEN_RATIO;
+	c = initval;
+
+	while (len >= 12) {
+		a += (k[0] +((u32)k[1]<<8) +((u32)k[2]<<16) +((u32)k[3]<<24));
+		b += (k[4] +((u32)k[5]<<8) +((u32)k[6]<<16) +((u32)k[7]<<24));
+		c += (k[8] +((u32)k[9]<<8) +((u32)k[10]<<16)+((u32)k[11]<<24));
+
+		__jhash_mix(a,b,c);
+
+		k += 12;
+		len -= 12;
+	}
+
+	c += length;
+	switch (len) {
+	case 11: c += ((u32)k[10]<<24);
+	case 10: c += ((u32)k[9]<<16);
+	case 9 : c += ((u32)k[8]<<8);
+	case 8 : b += ((u32)k[7]<<24);
+	case 7 : b += ((u32)k[6]<<16);
+	case 6 : b += ((u32)k[5]<<8);
+	case 5 : b += k[4];
+	case 4 : a += ((u32)k[3]<<24);
+	case 3 : a += ((u32)k[2]<<16);
+	case 2 : a += ((u32)k[1]<<8);
+	case 1 : a += k[0];
+	};
+
+	__jhash_mix(a,b,c);
+
+	return c;
+}
+
+/* A special optimized version that handles 1 or more of u32s.
+ * The length parameter here is the number of u32s in the key.
+ */
+static inline u32 jhash2(u32 *k, u32 length, u32 initval)
+{
+	u32 a, b, c, len;
+
+	a = b = JHASH_GOLDEN_RATIO;
+	c = initval;
+	len = length;
+
+	while (len >= 3) {
+		a += k[0];
+		b += k[1];
+		c += k[2];
+		__jhash_mix(a, b, c);
+		k += 3; len -= 3;
+	}
+
+	c += length * 4;
+
+	switch (len) {
+	case 2 : b += k[1];
+	case 1 : a += k[0];
+	};
+
+	__jhash_mix(a,b,c);
+
+	return c;
+}
+
+
+/* A special ultra-optimized versions that knows they are hashing exactly
+ * 3, 2 or 1 word(s).
+ *
+ * NOTE: In partilar the "c += length; __jhash_mix(a,b,c);" normally
+ *       done at the end is not done here.
+ */
+static inline u32 jhash_3words(u32 a, u32 b, u32 c, u32 initval)
+{
+	a += JHASH_GOLDEN_RATIO;
+	b += JHASH_GOLDEN_RATIO;
+	c += initval;
+
+	__jhash_mix(a, b, c);
+
+	return c;
+}
+
+static inline u32 jhash_2words(u32 a, u32 b, u32 initval)
+{
+	return jhash_3words(a, b, 0, initval);
+}
+
+static inline u32 jhash_1word(u32 a, u32 initval)
+{
+	return jhash_3words(a, 0, 0, initval);
+}
+
+#endif /* _LINUX_JHASH_H */
Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -27,6 +27,7 @@
  */
 
 #include <stdlib.h>
+#include <stdbool.h>
 #include <string.h>
 #include <errno.h>
 
@@ -35,38 +36,53 @@
 #include <ulogd/linuxlist.h>
 
 #include <ulogd/ulogd.h>
+#include <ulogd/common.h>
 #include <ulogd/ipfix_protocol.h>
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <linux/netfilter/nf_conntrack_tcp.h>
+#include "linux_jhash.h"
+
+#define CT_EVENTS		(NF_NETLINK_CONNTRACK_NEW \
+						 | NF_NETLINK_CONNTRACK_UPDATE \
+						 | NF_NETLINK_CONNTRACK_DESTROY)
+
+#undef INADDR_LOOPBACK
+#define INADDR_LOOPBACK		0x0100007f /* 127.0.0.1 */
+
 
 typedef enum TIMES_ { START, STOP, __TIME_MAX } TIMES;
- 
+typedef unsigned conntrack_hash_t;
+
 struct ct_timestamp {
 	struct llist_head list;
+	struct nfct_tuple tuple;
+	unsigned last_seq;
 	struct timeval time[__TIME_MAX];
-	int id;
 };
 
 struct ct_htable {
 	struct llist_head *buckets;
-	int num_buckets;
-	int prealloc;
-	struct llist_head idle;
-	struct ct_timestamp *ts;
+	unsigned num_buckets;
+	unsigned curr_bucket;
+	unsigned used;
 };
 
 struct nfct_pluginstance {
 	struct nfct_handle *cth;
 	struct ulogd_fd nfct_fd;
+	struct ct_htable *htable;
 	struct ulogd_timer timer;
-	struct ct_htable *ct_active;
+	struct {
+		unsigned nl_err;
+		unsigned nl_ovr;
+	} stats;
 };
 
-#define HTABLE_SIZE	(8192)
-#define MAX_ENTRIES	(4 * HTABLE_SIZE)
+#define HTABLE_SIZE	(512)
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 5,
+	.num_ces = 3,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -75,18 +91,6 @@ static struct config_keyset nfct_kset = 
 			.u.value = 0,
 		},
 		{
-			.key	 = "hash_enable",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 1,
-		},
-		{
-			.key	 = "hash_prealloc",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 1,
-		},
-		{
 			.key	 = "hash_buckets",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
@@ -96,17 +100,37 @@ static struct config_keyset nfct_kset = 
 			.key	 = "hash_max_entries",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
-			.u.value = MAX_ENTRIES,
+			.u.value = 0,
 		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
-#define usehash_ce(x)	(x->ces[1])
-#define prealloc_ce(x)	(x->ces[2])
-#define buckets_ce(x)	(x->ces[3])
-#define maxentries_ce(x) (x->ces[4])
+#define buckets_ce(x)	(x->ces[1])
 
-static struct ulogd_key nfct_okeys[] = {
+enum {
+	O_IP_SADDR = 0,
+	O_IP_DADDR,
+	O_IP_PROTO,
+	O_L4_SPORT,
+	O_L4_DPORT,
+	O_RAW_IN_PKTLEN,
+	O_RAW_IN_PKTCOUNT,
+	O_RAW_OUT_PKTLEN,
+	O_RAW_OUT_PKTCOUNT,
+	O_ICMP_CODE,
+	O_ICMP_TYPE,
+	O_CT_MARK,
+	O_CT_ID,
+	O_FLOW_START_SEC,
+	O_FLOW_START_USEC,
+	O_FLOW_START_DAY,
+	O_FLOW_END_SEC,
+	O_FLOW_END_USEC,
+	O_FLOW_DURATION,
+	__O_MAX
+};
+
+static struct ulogd_key nfct_okeys[__O_MAX] = {
 	{
 		.type 	= ULOGD_RET_IPADDR,
 		.flags 	= ULOGD_RETF_NONE,
@@ -155,7 +179,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "raw.pktlen",
+		.name	= "raw.in.pktlen",
 		.ipfix	= { 
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_octetTotalCount,
@@ -165,7 +189,27 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "raw.pktcount",
+		.name	= "raw.in.pktcount",
+		.ipfix	= { 
+			.vendor 	= IPFIX_VENDOR_IETF,
+			.field_id 	= IPFIX_packetTotalCount,
+			/* FIXME: this could also be packetDeltaCount */
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "raw.out.pktlen",
+		.ipfix	= { 
+			.vendor 	= IPFIX_VENDOR_IETF,
+			.field_id 	= IPFIX_octetTotalCount,
+			/* FIXME: this could also be octetDeltaCount */
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "raw.out.pktcount",
 		.ipfix	= { 
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_packetTotalCount,
@@ -227,6 +271,11 @@ static struct ulogd_key nfct_okeys[] = {
 		},
 	},
 	{
+		.type 	= ULOGD_RET_UINT16,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "flow.start.day",
+	},
+	{
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "flow.end.sec",
@@ -245,326 +294,520 @@ static struct ulogd_key nfct_okeys[] = {
 		},
 	},
 	{
-		.type = ULOGD_RET_BOOL,
+		.type = ULOGD_RET_UINT32,
 		.flags = ULOGD_RETF_NONE,
-		.name = "dir",
+		.name = "flow.duration",
 	},
 };
 
-static struct ct_htable *htable_alloc(int htable_size, int prealloc)
+
+/* forward declarations */
+static struct ct_timestamp * ct_hash_find_seq(const struct ct_htable *,
+											  unsigned);
+static void ct_hash_free(struct ct_htable *, struct ct_timestamp *);
+
+
+static int
+nl_error(struct ulogd_pluginstance *pi, struct nlmsghdr *nlh, int *err)
+{
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct nlmsgerr *e = NLMSG_DATA(nlh);
+	struct ct_timestamp *ts;
+
+	ts = ct_hash_find_seq(priv->htable, e->msg.nlmsg_seq);
+	if (ts == NULL)
+		return 0;						/* already gone */
+
+	switch (-e->error) {
+	case ENOENT:
+		/* destroy message was lost (FIXME log all what we got) */
+		ct_hash_free(priv->htable, ts);
+		break;
+
+	case 0:								/* "Success" */
+		break;
+
+	default:
+		ulogd_log(ULOGD_ERROR, "netlink error: %s (seq %u)\n",
+				  strerror(-e->error), e->msg.nlmsg_seq);
+		break;
+	}
+
+	*err = -e->error;
+
+	return 0;
+}
+
+
+/* this should go into its own file */
+static int
+nfnl_recv_msgs(struct nfnl_handle *nfnlh,
+			   int (* cb)(struct nlmsghdr *, void *arg), void *arg)
+{
+	static unsigned char buf[NFNL_BUFFSIZE];
+	struct ulogd_pluginstance *pi = arg;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+
+	for (;;) {
+		struct nlmsghdr *nlh = (void *)buf;
+		ssize_t nread;
+
+		nread = nfnl_recv(nfct_nfnlh(priv->cth), buf, sizeof(buf));
+		if (nread < 0) {
+			if (errno == EWOULDBLOCK)
+				break;
+
+			return -1;
+		}
+
+		while (NLMSG_OK(nlh, nread)) {
+			int err = 0;
+
+			if (nlh->nlmsg_type == NLMSG_ERROR) {
+				if (nl_error(pi, nlh, &err) == 0 && err != 0)
+					priv->stats.nl_err++;
+
+				break;
+			}
+
+			if (nlh->nlmsg_type == NLMSG_OVERRUN)
+				priv->stats.nl_ovr++;	/* continue?  payload? */
+				
+			(cb)(nlh, pi);
+
+			nlh = NLMSG_NEXT(nlh, nread);
+		}
+	}
+
+	return 0;
+}
+
+
+static int
+nfct_msg_type(const struct nlmsghdr *nlh)
+{
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	int nfct_type;
+
+	if (type == IPCTNL_MSG_CT_NEW) {
+		if (nlh->nlmsg_flags & (NLM_F_CREATE | NLM_F_EXCL))
+			nfct_type = NFCT_MSG_NEW;
+		else
+			nfct_type = NFCT_MSG_UPDATE;
+	} else if (type == IPCTNL_MSG_CT_DELETE)
+		nfct_type = NFCT_MSG_DESTROY;
+	else
+		nfct_type = NFCT_MSG_UNKNOWN;
+
+	return nfct_type;
+}
+
+
+/* seq: sequence number used for the request */
+static int
+nfct_get_conntrack_x(struct nfct_handle *cth, struct nfct_tuple *t,
+					 int dir, uint32_t *seq)
+{
+	static char buf[NFNL_BUFFSIZE];
+	struct nfnlhdr *req = (void *)buf;
+	int cta_dir, nbytes;
+
+	memset(buf, 0, sizeof(buf));
+
+	/* intendedly do not set NLM_F_ACK in order to skip the
+	   ACK message (but NACKs are still send) */
+	nfnl_fill_hdr(nfct_subsys_ct(cth), &req->nlh, 0, t->l3protonum,
+				  0, IPCTNL_MSG_CT_GET, NLM_F_REQUEST);
+
+	if (seq != NULL)
+		*seq = req->nlh.nlmsg_seq;
+
+	cta_dir = (dir == NFCT_DIR_ORIGINAL) ? CTA_TUPLE_ORIG : CTA_TUPLE_REPLY;
+
+	nfct_build_tuple(req, sizeof(buf), t, cta_dir);
+
+	nbytes = nfnl_send(nfct_nfnlh(cth), &req->nlh);
+
+	return nbytes;
+}
+
+
+static conntrack_hash_t
+hash_conntrack(const struct nfct_tuple *t, size_t hash_sz)
+{
+	static unsigned rnd;
+
+	if (rnd == 0U)
+		rnd = rand();
+
+	return jhash_3words(t->src.v4, t->dst.v4 ^ t->protonum,
+						t->l4src.all | (t->l4dst.all << 16), rnd) % hash_sz;
+}
+
+static inline bool
+ct_cmp(const struct nfct_tuple *t1, const struct nfct_tuple *t2)
+{
+	return memcmp(t1, t2, sizeof(struct nfct_tuple)) == 0;
+}
+
+
+static struct ct_htable *
+htable_alloc(int htable_size)
 {
 	struct ct_htable *htable;
-	struct ct_timestamp *ct;
 	int i;
 
 	htable = malloc(sizeof(*htable)
-			+ sizeof(struct llist_head)*htable_size);
+			+ sizeof(struct llist_head) * htable_size);
 	if (!htable)
 		return NULL;
 
 	htable->buckets = (void *)htable + sizeof(*htable);
 	htable->num_buckets = htable_size;
-	htable->prealloc = prealloc;
-	INIT_LLIST_HEAD(&htable->idle);
+	htable->used = 0;
 
 	for (i = 0; i < htable->num_buckets; i++)
 		INIT_LLIST_HEAD(&htable->buckets[i]);
 	
-	if (!htable->prealloc)
-		return htable;
-
-	ct = malloc(sizeof(struct ct_timestamp)
-		    * htable->num_buckets * htable->prealloc);
-	if (!ct) {
-		free(htable);
-		return NULL;
-	}
-
-	/* save the pointer for later free()ing */
-	htable->ts = ct;
-
-	for (i = 0; i < htable->num_buckets * htable->prealloc; i++)
-		llist_add(&ct[i].list, &htable->idle);
-
 	return htable;
 }
 
-static void htable_free(struct ct_htable *htable)
+static void
+htable_free(struct ct_htable *htable)
 {
 	struct llist_head *ptr, *ptr2;
 	int i;
 
-	if (htable->prealloc) {
-		/* the easy case */
-		free(htable->ts);
-		free(htable);
-
-		return;
-	}
-
-	/* non-prealloc case */
-
 	for (i = 0; i < htable->num_buckets; i++) {
 		llist_for_each_safe(ptr, ptr2, &htable->buckets[i])
 			free(container_of(ptr, struct ct_timestamp, list));
 	}
 
-	/* don't need to check for 'idle' list, since it is only used in
-	 * the preallocated case */
+	free(htable);
 }
 
-static int ct_hash_add(struct ct_htable *htable, unsigned int id)
+static struct ct_timestamp *
+ct_hash_add(struct ct_htable *htable, const struct nfct_tuple *t)
 {
-	struct ct_timestamp *ct;
+	struct ct_timestamp *ts;
+	conntrack_hash_t h;
 
-	if (htable->prealloc) {
-		if (llist_empty(&htable->idle)) {
-			ulogd_log(ULOGD_ERROR, "Not enough ct_timestamp entries\n");
-			return -1;
-		}
+	h = hash_conntrack(t, htable->num_buckets);
 
-		ct = container_of(htable->idle.next, struct ct_timestamp, list);
+	if ((ts = calloc(1, sizeof(struct ct_timestamp))) == NULL) {
+		ulogd_log(ULOGD_ERROR, "Out of memory\n");
+		return NULL;
+	}
 
-		ct->id = id;
-		gettimeofday(&ct->time[START], NULL);
+	memcpy(&ts->tuple, t, sizeof(struct nfct_tuple));
 
-		llist_move(&ct->list, &htable->buckets[id % htable->num_buckets]);
-	} else {
-		ct = malloc(sizeof *ct);
-		if (!ct) {
-			ulogd_log(ULOGD_ERROR, "Not enough memory\n");
-			return -1;
-		}
+	llist_add(&ts->list, &htable->buckets[h]);
+	htable->used++;
 
-		ct->id = id;
-		gettimeofday(&ct->time[START], NULL);
+	return ts;
+}
+
+static struct ct_timestamp *
+ct_hash_find(struct ct_htable *htable, const struct nfct_tuple *t)
+{  
+	struct llist_head *ptr;
+	conntrack_hash_t h = hash_conntrack(t, htable->num_buckets);
 
-		llist_add(&ct->list, &htable->buckets[id % htable->num_buckets]);
+	llist_for_each(ptr, &htable->buckets[h]) {
+		struct ct_timestamp *ts = container_of(ptr, struct ct_timestamp, list);
+
+		if (ct_cmp(t, &ts->tuple))
+			return ts;
 	}
 
-	return 0;
+	return NULL;
 }
 
-static struct ct_timestamp *ct_hash_get(struct ct_htable *htable, uint32_t id)
+
+static struct ct_timestamp *
+ct_hash_find_seq(const struct ct_htable *htable, unsigned seq)
 {
-	struct ct_timestamp *ct = NULL;
-	struct llist_head *ptr;
+	int i;
 
-	llist_for_each(ptr, &htable->buckets[id % htable->num_buckets]) {
-		ct = container_of(ptr, struct ct_timestamp, list);
-		if (ct->id == id) {
-			gettimeofday(&ct->time[STOP], NULL);
-			if (htable->prealloc)
-				llist_move(&ct->list, &htable->idle);
-			else
-				free(ct);
-			break;
+	for (i = 0; i < htable->num_buckets; i++) {
+		struct ct_timestamp *ts;
+
+		llist_for_each_entry(ts, &htable->buckets[i], list) {
+			if (ts->last_seq == seq)
+				return ts;
 		}
 	}
-	return ct;
+
+	return NULL;
+}
+
+
+/* time diff with second resolution */
+static inline unsigned
+tv_diff_sec(const struct ct_timestamp *ts)
+{
+	if (ts->time[STOP].tv_sec >= ts->time[START].tv_sec)
+		return max(ts->time[STOP].tv_sec - ts->time[START].tv_sec, 1);
+
+	return ts->time[START].tv_sec - ts->time[STOP].tv_sec;
 }
 
-static int propagate_ct_flow(struct ulogd_pluginstance *upi, 
-		             struct nfct_conntrack *ct,
-			     unsigned int flags,
-			     int dir,
-			     struct ct_timestamp *ts)
+static void
+ct_hash_free(struct ct_htable *htable, struct ct_timestamp *ts)
+{
+	llist_del(&ts->list);
+
+	free(ts);
+	htable->used--;
+}
+
+static int
+propagate_ct_flow(struct ulogd_pluginstance *upi, 
+				  struct nfct_conntrack *ct, unsigned int flags,
+				  int dir, struct ct_timestamp *ts)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
-	ret[0].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
-	ret[0].flags |= ULOGD_RETF_VALID;
+	ret[O_IP_SADDR].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
+	ret[O_IP_SADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[1].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
-	ret[1].flags |= ULOGD_RETF_VALID;
+	ret[O_IP_DADDR].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
+	ret[O_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[2].u.value.ui8 = ct->tuple[dir].protonum;
-	ret[2].flags |= ULOGD_RETF_VALID;
+	ret[O_IP_PROTO].u.value.ui8 = ct->tuple[dir].protonum;
+	ret[O_IP_PROTO].flags |= ULOGD_RETF_VALID;
 
-	switch (ct->tuple[1].protonum) {
+	switch (ct->tuple[dir].protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[3].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
-		ret[3].flags |= ULOGD_RETF_VALID;
-		ret[4].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
-		ret[4].flags |= ULOGD_RETF_VALID;
+		ret[O_L4_SPORT].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
+		ret[O_L4_SPORT].flags |= ULOGD_RETF_VALID;
+		ret[O_L4_DPORT].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
+		ret[O_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[7].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
-		ret[7].flags |= ULOGD_RETF_VALID;
-		ret[8].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
-		ret[8].flags |= ULOGD_RETF_VALID;
+		ret[O_ICMP_CODE].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
+		ret[O_ICMP_CODE].flags |= ULOGD_RETF_VALID;
+		ret[O_ICMP_TYPE].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
+		ret[O_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
 		break;
 	}
 
-	if ((dir == NFCT_DIR_ORIGINAL && flags & NFCT_COUNTERS_ORIG) ||
-	    (dir == NFCT_DIR_REPLY && flags & NFCT_COUNTERS_RPLY)) {
-		ret[5].u.value.ui64 = ct->counters[dir].bytes;
-		ret[5].flags |= ULOGD_RETF_VALID;
-
-		ret[6].u.value.ui64 = ct->counters[dir].packets;
-		ret[6].flags |= ULOGD_RETF_VALID;
+	if (flags & NFCT_COUNTERS_ORIG) {
+		ret[O_RAW_IN_PKTLEN].u.value.ui32 = ct->counters[0].bytes;
+		ret[O_RAW_IN_PKTLEN].flags |= ULOGD_RETF_VALID;
+		ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = ct->counters[0].packets;
+		ret[O_RAW_IN_PKTCOUNT].flags |= ULOGD_RETF_VALID;
+
+		ret[O_RAW_OUT_PKTLEN].u.value.ui32 = ct->counters[1].bytes;
+		ret[O_RAW_OUT_PKTLEN].flags |= ULOGD_RETF_VALID;
+		ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = ct->counters[1].packets;
+		ret[O_RAW_OUT_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (flags & NFCT_MARK) {
-		ret[9].u.value.ui32 = ct->mark;
-		ret[9].flags |= ULOGD_RETF_VALID;
+		ret[O_CT_MARK].u.value.ui32 = ct->mark;
+		ret[O_CT_MARK].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (flags & NFCT_ID) {
-		ret[10].u.value.ui32 = ct->id;
-		ret[10].flags |= ULOGD_RETF_VALID;
+		ret[O_CT_ID].u.value.ui32 = ct->id;
+		ret[O_CT_ID].flags |= ULOGD_RETF_VALID;
 	}
 
-	if (ts) {
-		ret[11].u.value.ui32 = ts->time[START].tv_sec;
-		ret[11].flags |= ULOGD_RETF_VALID;
-		ret[12].u.value.ui32 = ts->time[START].tv_usec;
-		ret[12].flags |= ULOGD_RETF_VALID;
-		ret[13].u.value.ui32 = ts->time[STOP].tv_sec;
-		ret[13].flags |= ULOGD_RETF_VALID;
-		ret[14].u.value.ui32 = ts->time[STOP].tv_usec;
-		ret[14].flags |= ULOGD_RETF_VALID;
-	}
+	ret[O_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
+	ret[O_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
+	ret[O_FLOW_START_USEC].u.value.ui32 = ts->time[START].tv_usec;
+	ret[O_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
+	ret[O_FLOW_START_DAY].u.value.ui16 = ts->time[START].tv_sec / (1 DAY);
+	ret[O_FLOW_START_DAY].flags |= ULOGD_RETF_VALID;
+
+	ret[O_FLOW_END_SEC].u.value.ui32 = ts->time[STOP].tv_sec;
+	ret[O_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
+	ret[O_FLOW_END_USEC].u.value.ui32 = ts->time[STOP].tv_usec;
+	ret[O_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
 
-	ret[15].u.value.b = (dir == NFCT_DIR_ORIGINAL) ? 0 : 1;
-	ret[15].flags |= ULOGD_RETF_VALID;
+	ret[O_FLOW_DURATION].u.value.ui32 = tv_diff_sec(ts);
+	ret[O_FLOW_DURATION].flags |= ULOGD_RETF_VALID;
 
 	ulogd_propagate_results(upi);
 
 	return 0;
 }
 
-static int propagate_ct(struct ulogd_pluginstance *upi,
-			struct nfct_conntrack *ct,
-			unsigned int flags,
-			struct ct_timestamp *ctstamp)
-{
-	int rc;
+static int
+propagate_ct(struct ulogd_pluginstance *upi, struct nfct_conntrack *ct,
+			 struct ct_timestamp *ts, unsigned int flags)
+{
+	struct nfct_pluginstance *priv = (void *)upi->private;
+
+	do {
+		if (ct->tuple[NFCT_DIR_ORIGINAL].src.v4 == INADDR_LOOPBACK
+			|| ct->tuple[NFCT_DIR_ORIGINAL].dst.v4 == INADDR_LOOPBACK)
+			break;
 
-	rc = propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ctstamp);
-	if (rc < 0)
-		return rc;
+		gettimeofday(&ts->time[STOP], NULL);
+		
+		propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ts);
+	} while (0);
 
-	return propagate_ct_flow(upi, ct, flags, NFCT_DIR_REPLY, ctstamp);
+	ct_hash_free(priv->htable, ts);
+
+	return 0;
 }
 
-static int event_handler(void *arg, unsigned int flags, int type,
-			 void *data)
+
+static int
+do_nfct_msg(struct nlmsghdr *nlh, void *arg)
 {
-	struct nfct_conntrack *ct = arg;
-	struct ulogd_pluginstance *upi = data;
-	struct nfct_pluginstance *cpi = 
-				(struct nfct_pluginstance *) upi->private;
+	struct ulogd_pluginstance *pi = arg;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct nfgenmsg *nfh = NLMSG_DATA(nlh);
+	struct nfct_conntrack ct;
+	struct ct_timestamp *ts;
+	int flags, type = nfct_msg_type(nlh);
+
+	if (type == NFCT_MSG_UNKNOWN)
+		return 0;
+
+	bzero(&ct, sizeof(ct));
+
+	ct.tuple[NFCT_DIR_ORIGINAL].l3protonum = 
+		ct.tuple[NFCT_DIR_REPLY].l3protonum = nfh->nfgen_family;
 
-	if (type == NFCT_MSG_NEW) {
-		if (usehash_ce(upi->config_kset).u.value != 0)
-			ct_hash_add(cpi->ct_active, ct->id);
-	} else if (type == NFCT_MSG_DESTROY) {
-		struct ct_timestamp *ts = NULL;
+	if (nfct_netlink_to_conntrack(nlh, &ct, &flags) < 0)
+		return -1;
+
+	switch (type) { 
+	case NFCT_MSG_NEW:
+		ts = ct_hash_add(priv->htable, &ct.tuple[NFCT_DIR_ORIGINAL]);
+		if (ts != NULL) {
+			gettimeofday(&ts->time[START], NULL);
+		}
+		break;
 
-		if (usehash_ce(upi->config_kset).u.value != 0)
-			ts = ct_hash_get(cpi->ct_active, ct->id);
+	case NFCT_MSG_UPDATE:
+		ts = ct_hash_find(priv->htable, &ct.tuple[NFCT_DIR_ORIGINAL]);
+		if (ts == NULL) {
+			/* do not add CT to cache, as there would be no start
+			   information */
+			break;
+		}
 
-		return propagate_ct(upi, ct, flags, ts);
+		/* handle TCP connections differently in order not to bloat CT
+		   hash with many TIME_WAIT connections */
+		if (ct.tuple[NFCT_DIR_ORIGINAL].protonum == IPPROTO_TCP) {
+			if (ct.protoinfo.tcp.state == TCP_CONNTRACK_TIME_WAIT)
+				return propagate_ct(pi, &ct, ts, flags);
+		}
+		break;
+		
+	case NFCT_MSG_DESTROY:
+		ts = ct_hash_find(priv->htable, &ct.tuple[NFCT_DIR_ORIGINAL]);
+		if (ts != NULL)
+			return propagate_ct(pi, &ct, ts, flags);
+		break;
+		
+	default:
+		break;
 	}
+
 	return 0;
 }
 
-static int read_cb_nfct(int fd, unsigned int what, void *param)
+
+static int
+read_cb_nfct(int fd, unsigned what, void *param)
 {
-	struct nfct_pluginstance *cpi = (struct nfct_pluginstance *) param;
+	struct ulogd_pluginstance *pi = param;
+	struct nfct_pluginstance *priv = (void *)pi->private;
 
 	if (!(what & ULOGD_FD_READ))
 		return 0;
 
-	/* FIXME: implement this */
-	nfct_event_conntrack(cpi->cth);
-	return 0;
+	return nfnl_recv_msgs(nfct_nfnlh(priv->cth), do_nfct_msg, pi);
 }
 
-static int get_ctr_zero(struct ulogd_pluginstance *upi)
-{
-	struct nfct_pluginstance *cpi = 
-			(struct nfct_pluginstance *)upi->private;
 
-	return nfct_dump_conntrack_table_reset_counters(cpi->cth, AF_INET);
-}
+/* choosing powers of two for all values helps here */
+#define STOP_HERE(h)	(((h)->curr_bucket + 16) % (h)->num_buckets)
 
-static void getctr_timer_cb(void *data)
+static void
+timer_cb(struct ulogd_timer *t)
 {
-	struct ulogd_pluginstance *upi = data;
+	struct ulogd_pluginstance *pi = t->data;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct ct_htable *ht = priv->htable;
+	struct ct_timestamp *ts;
+	int end = STOP_HERE(ht);
+
+	do {
+		assert(ht->curr_bucket < ht->num_buckets);
 
-	get_ctr_zero(upi);
+		llist_for_each_entry(ts, &ht->buckets[ht->curr_bucket], list) {
+			/* check if its still there */
+			nfct_get_conntrack_x(priv->cth, &ts->tuple, NFCT_DIR_ORIGINAL,
+								 &ts->last_seq);
+		}
+
+		ht->curr_bucket = (ht->curr_bucket + 1) % ht->num_buckets;
+	} while (ht->curr_bucket != end);
 }
 
 static int configure_nfct(struct ulogd_pluginstance *upi,
 			  struct ulogd_pluginstance_stack *stack)
 {
-	struct nfct_pluginstance *cpi = 
-			(struct nfct_pluginstance *)upi->private;
+	struct nfct_pluginstance *priv = (void *)upi->private;
 	int ret;
+
+	memset(priv, 0, sizeof(struct nfct_pluginstance));
 	
 	ret = config_parse_file(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;
-	
-	/* initialize getctrzero timer structure */
-	memset(&cpi->timer, 0, sizeof(cpi->timer));
-	cpi->timer.cb = &getctr_timer_cb;
-	cpi->timer.data = cpi;
-
-	if (pollint_ce(upi->config_kset).u.value != 0) {
-		cpi->timer.expires.tv_sec = 
-			pollint_ce(upi->config_kset).u.value;
-		ulogd_register_timer(&cpi->timer);
-	}
 
 	return 0;
 }
 
+
 static int constructor_nfct(struct ulogd_pluginstance *upi)
 {
-	struct nfct_pluginstance *cpi = 
-			(struct nfct_pluginstance *)upi->private;
-	int prealloc;
-
-	memset(cpi, 0, sizeof(*cpi));
-
-	/* FIXME: make eventmask configurable */
-	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, NF_NETLINK_CONNTRACK_NEW|
-			     NF_NETLINK_CONNTRACK_DESTROY);
+	struct nfct_pluginstance *cpi = (void *)upi->private;
+
+	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, CT_EVENTS);
 	if (!cpi->cth) {
 		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
 		return -1;
 	}
 
-	nfct_register_callback(cpi->cth, &event_handler, upi);
-
 	cpi->nfct_fd.fd = nfct_fd(cpi->cth);
 	cpi->nfct_fd.cb = &read_cb_nfct;
-	cpi->nfct_fd.data = cpi;
+	cpi->nfct_fd.data = upi;
 	cpi->nfct_fd.when = ULOGD_FD_READ;
 
 	ulogd_register_fd(&cpi->nfct_fd);
 
-	if (prealloc_ce(upi->config_kset).u.value != 0)
-		prealloc = maxentries_ce(upi->config_kset).u.value / 
-				buckets_ce(upi->config_kset).u.value;
-	else
-		prealloc = 0;
+	cpi->htable = htable_alloc(buckets_ce(upi->config_kset).u.value);
+	if (cpi->htable == NULL) {
+		ulogd_log(ULOGD_FATAL, "htable_alloc: out of memory\n");
 
-	if (usehash_ce(upi->config_kset).u.value != 0) {
-		cpi->ct_active = htable_alloc(buckets_ce(upi->config_kset).u.value,
-					      prealloc);
-		if (!cpi->ct_active) {
-			ulogd_log(ULOGD_FATAL, "error allocating hash\n");
-			nfct_close(cpi->cth);
-			return -1;
-		}
+		nfct_close(cpi->cth);
+		cpi->cth = NULL;
+
+		return -1;
 	}
+
+	cpi->timer.cb = timer_cb;
+	cpi->timer.ival = 1 SEC;
+	cpi->timer.flags = TIMER_F_PERIODIC;
+	cpi->timer.data = upi;
+
+	ulogd_register_timer(&cpi->timer);
+
+	ulogd_log(ULOGD_INFO, "%s: hashsize %u\n", upi->id,
+			  cpi->htable->num_buckets);
 	
 	return 0;
 }
@@ -572,13 +815,11 @@ static int constructor_nfct(struct ulogd
 static int destructor_nfct(struct ulogd_pluginstance *pi)
 {
 	struct nfct_pluginstance *cpi = (void *) pi;
-	int rc;
 	
-	htable_free(cpi->ct_active);
+	nfct_close(cpi->cth);
+	cpi->cth = NULL;
 
-	rc = nfct_close(cpi->cth);
-	if (rc < 0)
-		return rc;
+	htable_free(cpi->htable);
 
 	return 0;
 }
@@ -587,7 +828,6 @@ static void signal_nfct(struct ulogd_plu
 {
 	switch (signal) {
 	case SIGUSR2:
-		get_ctr_zero(pi);
 		break;
 	}
 }

-- 
