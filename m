From: heitzenberger@astaro.com
Subject: [ULOGD 15/15] NFCT: rework and let it scale
Date: Sat, 02 Feb 2008 21:48:41 +0100
Message-ID: <20080202205109.278286146@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-62.dex002.intermedia.net ([64.78.20.11]:43183 "EHLO
	dhost002-62.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933450AbYBBUvZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-NFCT-plugin.diff

Also implement garbage collection to account for the fact that netlink
messages are sometimes lost (ENOBUFS) on busy sites.  This is done by
implementing a tuple cache (indexed by tuple) and a sequence cache and
going regularly over part of both caches if need be.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter-stuffed/input/flow/linux_jhash.h
===================================================================
--- /dev/null
+++ ulogd-netfilter-stuffed/input/flow/linux_jhash.h
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
Index: ulogd-netfilter-stuffed/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter-stuffed.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter-stuffed/input/flow/ulogd_inpflow_NFCT.c
@@ -25,88 +25,121 @@
  * 	  the messages via IPFX to one aggregator who then runs ulogd with a 
  * 	  network wide connection hash table.
  */
-
-#include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-
-#include <sys/time.h>
-#include <time.h>
-#include <ulogd/linuxlist.h>
-
 #include <ulogd/ulogd.h>
+#include <ulogd/common.h>
+#include <ulogd/linuxlist.h>
 #include <ulogd/ipfix_protocol.h>
+#include <time.h>
+#include <sys/time.h>
+#include <netinet/in.h>
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <linux/netfilter/nf_conntrack_tcp.h>
+#include "linux_jhash.h"
 
-typedef enum TIMES_ { START, STOP, __TIME_MAX } TIMES;
- 
-struct ct_timestamp {
+#define ORIG	NFCT_DIR_ORIGINAL
+#define REPL	NFCT_DIR_REPLY
+
+/* configuration defaults */
+#define TCACHE_SIZE		8192
+#define SCACHE_SIZE		512
+#define TCACHE_REQ_MAX	100
+#define TIMEOUT			30 SEC
+
+#define RCVBUF_LEN		(1 << 18)
+
+typedef enum TIMES_ { START, UPDATE, STOP, __TIME_MAX } TIMES;
+typedef unsigned conntrack_hash_t;
+
+struct conntrack {
 	struct llist_head list;
+	struct llist_head seq_link;
+	struct nfct_tuple tuple;
+	unsigned last_seq;
 	struct timeval time[__TIME_MAX];
-	int id;
+	time_t t_req;
+	unsigned used;
 };
 
-struct ct_htable {
-	struct llist_head *buckets;
-	int num_buckets;
-	int prealloc;
-	struct llist_head idle;
-	struct ct_timestamp *ts;
+struct cache_head {
+	struct llist_head link;
+	unsigned cnt;
+};
+ 
+struct cache {
+	struct cache_head *c_head;
+	unsigned c_num_heads;
+	unsigned c_curr_head;
+	unsigned c_cnt;
+	conntrack_hash_t (* c_hash)(struct cache *, struct conntrack *);
+	int (* c_add)(struct cache *, struct conntrack *);
+	int (* c_del)(struct cache *, struct conntrack *);
 };
 
 struct nfct_pluginstance {
 	struct nfct_handle *cth;
 	struct ulogd_fd nfct_fd;
+	struct nf_conntrack *nfct_opaque;
+	struct cache *tcache;       /* tuple cache */
+	struct cache *scache;       /* sequence cache */
 	struct ulogd_timer timer;
-	struct ct_htable *ct_active;
+	struct {
+		unsigned nl_err;
+		unsigned nl_ovr;
+	} stats;
 };
 
-#define HTABLE_SIZE	(8192)
-#define MAX_ENTRIES	(4 * HTABLE_SIZE)
-
+static unsigned num_conntrack;
 static struct config_keyset nfct_kset = {
-	.num_ces = 5,
+	.num_ces = 3,
 	.ces = {
 		{
-			.key	 = "pollinterval",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
-		},
-		{
-			.key	 = "hash_enable",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 1,
-		},
-		{
-			.key	 = "hash_prealloc",
+			.key	 = "hash_buckets",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
-			.u.value = 1,
+			.u.value = TCACHE_SIZE,
 		},
 		{
-			.key	 = "hash_buckets",
+			.key	 = "disable",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
-			.u.value = HTABLE_SIZE,
+			.u.value = 0,
 		},
 		{
-			.key	 = "hash_max_entries",
+			.key	 = "timeout",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
-			.u.value = MAX_ENTRIES,
+			.u.value = TIMEOUT,
 		},
 	},
 };
-#define pollint_ce(x)	(x->ces[0])
-#define usehash_ce(x)	(x->ces[1])
-#define prealloc_ce(x)	(x->ces[2])
-#define buckets_ce(x)	(x->ces[3])
-#define maxentries_ce(x) (x->ces[4])
+#define buckets_ce(pi)    ((pi)->config_kset->ces[0].u.value)
+#define disable_ce(pi)    ((pi)->config_kset->ces[1].u.value)
+#define timeout_ce(pi)    ((pi)->config_kset->ces[2].u.value)
+
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
+	O_FLOW_END_SEC,
+	O_FLOW_END_USEC,
+	O_FLOW_DURATION,
+	__O_MAX
+};
 
-static struct ulogd_key nfct_okeys[] = {
+static struct ulogd_key nfct_okeys[__O_MAX] = {
 	{
 		.type 	= ULOGD_RET_IPADDR,
 		.flags 	= ULOGD_RETF_NONE,
@@ -155,7 +188,27 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "raw.pktlen",
+		.name	= "raw.in.pktlen",
+		.ipfix	= { 
+			.vendor 	= IPFIX_VENDOR_IETF,
+			.field_id 	= IPFIX_octetTotalCount,
+			/* FIXME: this could also be octetDeltaCount */
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
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
 		.ipfix	= { 
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_octetTotalCount,
@@ -165,7 +218,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "raw.pktcount",
+		.name	= "raw.out.pktcount",
 		.ipfix	= { 
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_packetTotalCount,
@@ -245,355 +298,927 @@ static struct ulogd_key nfct_okeys[] = {
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
+static int cache_del(struct cache *, struct conntrack *);
+static struct conntrack *tcache_find(const struct ulogd_pluginstance *,
+									 const struct nfct_tuple *);
+static struct conntrack *scache_find(const struct ulogd_pluginstance *,
+									 unsigned);
+
+
+static int
+nl_error(struct ulogd_pluginstance *pi, struct nlmsghdr *nlh, int *err)
 {
-	struct ct_htable *htable;
-	struct ct_timestamp *ct;
-	int i;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct nlmsgerr *e = NLMSG_DATA(nlh);
+	struct conntrack *ct;
 
-	htable = malloc(sizeof(*htable)
-			+ sizeof(struct llist_head)*htable_size);
-	if (!htable)
-		return NULL;
+	if (e->msg.nlmsg_seq == 0)
+		return 0;
 
-	htable->buckets = (void *)htable + sizeof(*htable);
-	htable->num_buckets = htable_size;
-	htable->prealloc = prealloc;
-	INIT_LLIST_HEAD(&htable->idle);
+	ct = scache_find(pi, e->msg.nlmsg_seq);
+	if (ct == NULL)
+		return 0;						/* already gone */
+
+	switch (-e->error) {
+	case ENOENT:
+		/* destroy message was lost (FIXME log all what we got) */
+		if (ct->used > 1) {
+			struct conntrack *ct_tmp = tcache_find(pi, &ct->tuple);
 
-	for (i = 0; i < htable->num_buckets; i++)
-		INIT_LLIST_HEAD(&htable->buckets[i]);
-	
-	if (!htable->prealloc)
-		return htable;
+			if (ct == ct_tmp)
+				cache_del(priv->tcache, ct);
+		}
+		cache_del(priv->scache, ct);
+		break;
 
-	ct = malloc(sizeof(struct ct_timestamp)
-		    * htable->num_buckets * htable->prealloc);
-	if (!ct) {
-		free(htable);
-		return NULL;
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
 	}
 
-	/* save the pointer for later free()ing */
-	htable->ts = ct;
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
+/*
+ * nfct_get_conntrack_seq()
+ *
+ * Do GET_CONNTRACK, return seq# used.
+ */
+static int
+nfct_get_conntrack_seq(struct nfct_handle *cth, struct nfct_tuple *t,
+					  uint32_t *seq)
+{
+	static char buf[NFNL_BUFFSIZE];
+	struct nfnlhdr *req = (void *)buf;
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
+	nfct_build_tuple(req, sizeof(buf), t, CTA_TUPLE_ORIG);
+
+	return nfnl_send(nfct_nfnlh(cth), &req->nlh);
+}
+
+/* time diff with second resolution */
+static inline unsigned
+tv_diff_sec(const struct timeval *tv1, const struct timeval *tv2)
+{
+	if (tv2->tv_sec >= tv1->tv_sec)
+		return max(tv2->tv_sec - tv1->tv_sec, 1);
+
+	return tv1->tv_sec - tv2->tv_sec;
+}
+
+struct conntrack *
+ct_alloc(const struct nfct_tuple *tuple)
+{
+	struct conntrack *ct;
+
+	if ((ct = calloc(1, sizeof(struct conntrack))) == NULL)
+		return NULL;
+
+	memcpy(&ct->tuple, tuple, sizeof(struct nfct_tuple));
+
+	num_conntrack++;
+
+	return ct;
+}
+
+static inline void
+ct_get(struct conntrack *ct)
+{
+	ct->used++;
+}
+
+static inline void
+ct_put(struct conntrack *ct)
+{
+	if (--ct->used == 0) {
+		assert(num_conntrack > 0);
 
-	for (i = 0; i < htable->num_buckets * htable->prealloc; i++)
-		llist_add(&ct[i].list, &htable->idle);
+		free(ct);
 
-	return htable;
+		num_conntrack--;
+	}
 }
 
-static void htable_free(struct ct_htable *htable)
+static struct cache *
+cache_alloc(int cache_size)
 {
-	struct llist_head *ptr, *ptr2;
+	struct cache *c;
 	int i;
 
-	if (htable->prealloc) {
-		/* the easy case */
-		free(htable->ts);
-		free(htable);
+	c = malloc(sizeof(*c) + sizeof(struct cache_head) * cache_size);
+	if (c == NULL)
+		return NULL;
+
+	c->c_head = (void *)c + sizeof(*c);
+	c->c_num_heads = cache_size;
+	c->c_curr_head = 0;
+	c->c_cnt = 0;
+
+	for (i = 0; i < c->c_num_heads; i++) {
+		INIT_LLIST_HEAD(&c->c_head[i].link);
+		c->c_head[i].cnt = 0;
+	}
+
+	return c;
+}
 
+static void
+cache_free(struct cache *c)
+{
+	int i;
+
+	if (c == NULL)
 		return;
+
+	for (i = 0; i < c->c_num_heads; i++) {
+		struct llist_head *ptr, *ptr2;
+
+		llist_for_each_safe(ptr, ptr2, &c->c_head[i].link)
+			free(container_of(ptr, struct conntrack, list));
 	}
 
-	/* non-prealloc case */
+	free(c);
+}
+
+int
+cache_add(struct cache *c, struct conntrack *ct)
+{
+	ct_get(ct);
+
+	ct->time[UPDATE].tv_sec = ct->time[START].tv_sec = t_now_local;
+
+	/* order of these two is important for debugging purposes */
+	c->c_cnt++;
+	c->c_add(c, ct);
+
+	return 0;
+}
+
+int
+cache_del(struct cache *c, struct conntrack *ct)
+{
+	assert(c->c_cnt > 0);
+	assert(ct->used > 0);
+
+	/* order of these two is important for debugging purposes */
+	c->c_del(c, ct);
+	c->c_cnt--;
+
+	ct_put(ct);
+
+	return 0;
+}
+
+static inline conntrack_hash_t
+cache_head_next(const struct cache *c)
+{
+	return (c->c_curr_head + 1) % c->c_num_heads;
+}
+
+static inline conntrack_hash_t
+cache_slice_end(const struct cache *c, unsigned n)
+{
+	return (c->c_curr_head + n) % c->c_num_heads;
+}
+
+/* tuple cache */
+static struct conntrack ct_search;		/* used by scache too */
+
+static conntrack_hash_t
+tcache_hash(struct cache *c, struct conntrack *ct)
+{
+	static unsigned rnd;
+	struct nfct_tuple *t = &ct->tuple;
+
+	if (rnd == 0U)
+		rnd = rand();
 
-	for (i = 0; i < htable->num_buckets; i++) {
-		llist_for_each_safe(ptr, ptr2, &htable->buckets[i])
-			free(container_of(ptr, struct ct_timestamp, list));
+	return jhash_3words(t->src.v4, t->dst.v4 ^ t->protonum,	t->l4src.all
+						| (t->l4dst.all << 16), rnd) % c->c_num_heads;
+}
+
+static int
+tcache_add(struct cache *c, struct conntrack *ct)
+{
+	conntrack_hash_t h = c->c_hash(c, ct);
+
+	llist_add(&ct->list, &c->c_head[h].link);
+	c->c_head[h].cnt++;
+
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
+
+	return 0;
+}
+
+static int
+tcache_del(struct cache *c, struct conntrack *ct)
+{
+	conntrack_hash_t h = c->c_hash(c, ct);
+
+	assert(c->c_head[h].cnt > 0);
+
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
+
+	llist_del(&ct->list);
+	c->c_head[h].cnt--;
+
+	return 0;
+}
+
+static struct conntrack *
+tcache_find(const struct ulogd_pluginstance *pi,
+			const struct nfct_tuple *tuple)
+{
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c = priv->tcache;
+	struct conntrack *ct;
+	conntrack_hash_t h;
+
+	memcpy(&ct_search.tuple, tuple, sizeof(struct nfct_tuple));
+	h = c->c_hash(c, &ct_search);
+
+	llist_for_each_entry(ct, &c->c_head[h].link, list) {
+		if (memcmp(&ct->tuple, tuple, sizeof(*tuple)) == 0)
+			return ct;
 	}
 
-	/* don't need to check for 'idle' list, since it is only used in
-	 * the preallocated case */
+	return NULL;
 }
 
-static int ct_hash_add(struct ct_htable *htable, unsigned int id)
+/* check entries in tuple cache */
+static int
+tcache_cleanup(struct ulogd_pluginstance *pi)
 {
-	struct ct_timestamp *ct;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c = priv->tcache;
+	conntrack_hash_t end = cache_slice_end(c, 32);
+	struct conntrack *ct;
+	int ret, req = 0;
+
+	do {
+		llist_for_each_entry_reverse(ct, &c->c_head[c->c_curr_head].link,
+									 list) {
+			if (tv_diff_sec(&ct->time[UPDATE], &tv_now) < timeout_ce(pi))
+				continue;
+
+			/* check if its still there */
+			ret = nfct_get_conntrack_seq(priv->cth, &ct->tuple,
+									   &ct->last_seq);
+			if (ret < 0) {
+				if (errno == EWOULDBLOCK)
+					break;
+
+				ulogd_log(ULOGD_ERROR, "nfct_get_conntrack: ct=%p: %m\n",
+						  ct);
+				break;
+			}
+
+			if (&ct->last_seq != 0) {
+				ct->t_req = t_now;
 
-	if (htable->prealloc) {
-		if (llist_empty(&htable->idle)) {
-			ulogd_log(ULOGD_ERROR, "Not enough ct_timestamp entries\n");
-			return -1;
+				assert(scache_find(pi, ct->last_seq) == NULL);
+
+				cache_add(priv->scache, ct);
+			}
+
+			if (++req > TCACHE_REQ_MAX)
+				break;
 		}
 
-		ct = container_of(htable->idle.next, struct ct_timestamp, list);
+		c->c_curr_head = cache_head_next(c);
 
-		ct->id = id;
-		gettimeofday(&ct->time[START], NULL);
+		if (req > TCACHE_REQ_MAX)
+			break;
+	} while (c->c_curr_head != end);
 
-		llist_move(&ct->list, &htable->buckets[id % htable->num_buckets]);
-	} else {
-		ct = malloc(sizeof *ct);
-		if (!ct) {
-			ulogd_log(ULOGD_ERROR, "Not enough memory\n");
-			return -1;
-		}
+	return req;
+}
 
-		ct->id = id;
-		gettimeofday(&ct->time[START], NULL);
+/* sequence cache */
+static conntrack_hash_t
+scache_hash(struct cache *c, struct conntrack *ct)
+{
+	static unsigned rnd;
 
-		llist_add(&ct->list, &htable->buckets[id % htable->num_buckets]);
-	}
+	if (rnd == 0U)
+		rnd = rand();
+
+	return (ct->last_seq ^ rnd) % c->c_num_heads;
+}
+
+static int
+scache_add(struct cache *c, struct conntrack *ct)
+{
+	conntrack_hash_t h = c->c_hash(c, ct);
+
+	llist_add(&ct->seq_link, &c->c_head[h].link);
+	c->c_head[h].cnt++;
+
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
 
 	return 0;
 }
 
-static struct ct_timestamp *ct_hash_get(struct ct_htable *htable, uint32_t id)
+static int
+scache_del(struct cache *c, struct conntrack *ct)
 {
-	struct ct_timestamp *ct = NULL;
-	struct llist_head *ptr;
+	conntrack_hash_t h = c->c_hash(c, ct);
 
-	llist_for_each(ptr, &htable->buckets[id % htable->num_buckets]) {
-		ct = container_of(ptr, struct ct_timestamp, list);
-		if (ct->id == id) {
-			gettimeofday(&ct->time[STOP], NULL);
-			if (htable->prealloc)
-				llist_move(&ct->list, &htable->idle);
-			else
-				free(ct);
-			break;
-		}
+	assert(c->c_head[h].cnt > 0);
+
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
+
+	llist_del(&ct->seq_link);
+	ct->last_seq = 0;
+
+	c->c_head[h].cnt--;
+
+	return 0;
+}
+
+static struct conntrack *
+scache_find(const struct ulogd_pluginstance *pi, unsigned seq)
+{
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c = priv->scache;
+	struct conntrack *ct;
+	conntrack_hash_t h;
+
+	ct_search.last_seq = seq;
+	h = c->c_hash(c, &ct_search);
+
+	llist_for_each_entry(ct, &c->c_head[h].link, seq_link) {
+		if (ct->last_seq == ct_search.last_seq)
+			return ct;
 	}
-	return ct;
+
+	return NULL;
+}
+
+static int
+scache_cleanup(struct ulogd_pluginstance *pi)
+{
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c = priv->scache;
+	conntrack_hash_t end = cache_slice_end(c, 16);
+	struct conntrack *ct;
+	int del = 0;
+
+	if (c->c_cnt == 0)
+		return 0;
+
+	do {
+		struct llist_head *curr, *tmp;
+
+		assert(c->c_curr_head < c->c_num_heads);
+
+		llist_for_each_prev_safe(curr, tmp, &c->c_head[c->c_curr_head].link) {
+			ct = container_of(curr, struct conntrack, seq_link);
+
+			assert(ct->t_req != 0);
+
+			if ((t_now - ct->t_req) < 5 SEC)
+				break;
+
+			cache_del(priv->scache, ct);
+			del++;
+		}
+
+		c->c_curr_head = cache_head_next(c);
+	} while (c->c_curr_head != end);
+
+	return del;
 }
 
-static int propagate_ct_flow(struct ulogd_pluginstance *upi, 
-		             struct nfct_conntrack *ct,
-			     unsigned int flags,
-			     int dir,
-			     struct ct_timestamp *ts)
+static int
+propagate_ct_flow(struct ulogd_pluginstance *upi, 
+				  const struct nfct_conntrack *nfct,
+				  const struct conntrack *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
-	ret[0].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
-	ret[0].flags |= ULOGD_RETF_VALID;
+	ret[O_IP_SADDR].u.value.ui32 = htonl(nfct->tuple[ORIG].src.v4);
+	ret[O_IP_SADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[1].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
-	ret[1].flags |= ULOGD_RETF_VALID;
+	ret[O_IP_DADDR].u.value.ui32 = htonl(nfct->tuple[REPL].src.v4);
+	ret[O_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[2].u.value.ui8 = ct->tuple[dir].protonum;
-	ret[2].flags |= ULOGD_RETF_VALID;
+	ret[O_IP_PROTO].u.value.ui8 = nfct->tuple[ORIG].protonum;
+	ret[O_IP_PROTO].flags |= ULOGD_RETF_VALID;
 
-	switch (ct->tuple[1].protonum) {
+	switch (nfct->tuple[ORIG].protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[3].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
-		ret[3].flags |= ULOGD_RETF_VALID;
-		ret[4].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
-		ret[4].flags |= ULOGD_RETF_VALID;
+		ret[O_L4_SPORT].u.value.ui16
+			= htons(nfct->tuple[ORIG].l4src.tcp.port);
+		ret[O_L4_SPORT].flags |= ULOGD_RETF_VALID;
+		ret[O_L4_DPORT].u.value.ui16
+			= htons(nfct->tuple[REPL].l4src.tcp.port);
+		ret[O_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[7].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
-		ret[7].flags |= ULOGD_RETF_VALID;
-		ret[8].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
-		ret[8].flags |= ULOGD_RETF_VALID;
+		ret[O_ICMP_CODE].u.value.ui8 = nfct->tuple[ORIG].l4src.icmp.code;
+		ret[O_ICMP_CODE].flags |= ULOGD_RETF_VALID;
+		ret[O_ICMP_TYPE].u.value.ui8 = nfct->tuple[ORIG].l4src.icmp.type;
+		ret[O_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
 		break;
 	}
 
-	if ((dir == NFCT_DIR_ORIGINAL && flags & NFCT_COUNTERS_ORIG) ||
-	    (dir == NFCT_DIR_REPLY && flags & NFCT_COUNTERS_RPLY)) {
-		ret[5].u.value.ui64 = ct->counters[dir].bytes;
-		ret[5].flags |= ULOGD_RETF_VALID;
+	ret[O_RAW_IN_PKTLEN].u.value.ui32 = nfct->counters[ORIG].bytes;
+	ret[O_RAW_IN_PKTLEN].flags |= ULOGD_RETF_VALID;
+	ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = nfct->counters[ORIG].packets;
+	ret[O_RAW_IN_PKTCOUNT].flags |= ULOGD_RETF_VALID;
+
+	ret[O_RAW_OUT_PKTLEN].u.value.ui32 = nfct->counters[REPL].bytes;
+	ret[O_RAW_OUT_PKTLEN].flags |= ULOGD_RETF_VALID;
+	ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = nfct->counters[REPL].packets;
+	ret[O_RAW_OUT_PKTCOUNT].flags |= ULOGD_RETF_VALID;
+
+	ret[O_CT_MARK].u.value.ui32 = nfct->mark;
+	ret[O_CT_MARK].flags |= ULOGD_RETF_VALID;
+
+	ret[O_CT_ID].u.value.ui32 = nfct->id;
+	ret[O_CT_ID].flags |= ULOGD_RETF_VALID;
+
+	ret[O_FLOW_START_SEC].u.value.ui32 = ct->time[START].tv_sec;
+	ret[O_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
+	ret[O_FLOW_START_USEC].u.value.ui32 = ct->time[START].tv_usec;
+	ret[O_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
+
+	ret[O_FLOW_END_SEC].u.value.ui32 = ct->time[STOP].tv_sec;
+	ret[O_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
+	ret[O_FLOW_END_USEC].u.value.ui32 = ct->time[STOP].tv_usec;
+	ret[O_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
+
+	ret[O_FLOW_DURATION].u.value.ui32 = tv_diff_sec(&ct->time[START],
+													&ct->time[STOP]);
+	ret[O_FLOW_DURATION].flags |= ULOGD_RETF_VALID;
 
-		ret[6].u.value.ui64 = ct->counters[dir].packets;
-		ret[6].flags |= ULOGD_RETF_VALID;
-	}
+	ulogd_propagate_results(upi);
 
-	if (flags & NFCT_MARK) {
-		ret[9].u.value.ui32 = ct->mark;
-		ret[9].flags |= ULOGD_RETF_VALID;
-	}
+	return 0;
+}
 
-	if (flags & NFCT_ID) {
-		ret[10].u.value.ui32 = ct->id;
-		ret[10].flags |= ULOGD_RETF_VALID;
-	}
+static int
+propagate_ct(struct ulogd_pluginstance *upi,
+			 struct nfct_conntrack *nfct, struct conntrack *ct)
+{
+	struct nfct_pluginstance *priv = (void *)upi->private;
 
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
+	do {
+		if (nfct->tuple[ORIG].src.v4 == INADDR_LOOPBACK
+			|| nfct->tuple[ORIG].dst.v4 == INADDR_LOOPBACK)
+			break;
 
-	ret[15].u.value.b = (dir == NFCT_DIR_ORIGINAL) ? 0 : 1;
-	ret[15].flags |= ULOGD_RETF_VALID;
+		ct->time[STOP].tv_sec = t_now_local;
 
-	ulogd_propagate_results(upi);
+		propagate_ct_flow(upi, nfct, ct);
+	} while (0);
+
+	cache_del(priv->tcache, ct);
 
 	return 0;
 }
 
-static int propagate_ct(struct ulogd_pluginstance *upi,
-			struct nfct_conntrack *ct,
-			unsigned int flags,
-			struct ct_timestamp *ctstamp)
+/* nfct_to_conntrack() - translate from opaque type to nfct_conntrack */
+static int
+nfct_to_conntrack(const struct ulogd_pluginstance *pi,
+				  const struct nf_conntrack *ct, struct nfct_conntrack *out)
 {
-	int rc;
+	bzero(out, sizeof(struct nfct_conntrack));
 
-	rc = propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ctstamp);
-	if (rc < 0)
-		return rc;
+	assert(nfct_attr_is_set(ct, ATTR_L3PROTO));
+	out->tuple[ORIG].l3protonum = nfct_get_attr_u8(ct, ATTR_L3PROTO);
 
-	return propagate_ct_flow(upi, ct, flags, NFCT_DIR_REPLY, ctstamp);
-}
+	assert(nfct_attr_is_set(ct, ATTR_L4PROTO));
+	out->tuple[ORIG].protonum = nfct_get_attr_u8(ct, ATTR_L4PROTO);
 
-static int event_handler(void *arg, unsigned int flags, int type,
-			 void *data)
-{
-	struct nfct_conntrack *ct = arg;
-	struct ulogd_pluginstance *upi = data;
-	struct nfct_pluginstance *cpi = 
-				(struct nfct_pluginstance *) upi->private;
-
-	if (type == NFCT_MSG_NEW) {
-		if (usehash_ce(upi->config_kset).u.value != 0)
-			ct_hash_add(cpi->ct_active, ct->id);
-	} else if (type == NFCT_MSG_DESTROY) {
-		struct ct_timestamp *ts = NULL;
+	out->tuple[ORIG].src.v4 = nfct_get_attr_u32(ct, ATTR_IPV4_SRC);
+	out->tuple[REPL].src.v4 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC);
+	out->tuple[ORIG].dst.v4 = nfct_get_attr_u32(ct, ATTR_IPV4_DST);
+	out->tuple[REPL].dst.v4 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST);
+
+	if (out->tuple[ORIG].l3protonum == IPPROTO_ICMP) {
+		out->tuple[ORIG].l4src.icmp.type
+			= nfct_get_attr_u8(ct, ATTR_ICMP_TYPE);
+		out->tuple[ORIG].l4src.icmp.code
+			= nfct_get_attr_u8(ct, ATTR_ICMP_CODE);
+		out->tuple[ORIG].l4src.icmp.id
+			= nfct_get_attr_u16(ct, ATTR_ICMP_ID);
+	}
 
-		if (usehash_ce(upi->config_kset).u.value != 0)
-			ts = ct_hash_get(cpi->ct_active, ct->id);
+	if (out->tuple[ORIG].protonum == IPPROTO_TCP
+		|| out->tuple[ORIG].protonum == IPPROTO_UDP) {
+		assert(nfct_attr_is_set(ct, ATTR_ORIG_PORT_SRC));
+		out->tuple[ORIG].l4src.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC);
+
+		assert(nfct_attr_is_set(ct, ATTR_ORIG_PORT_DST));
+		out->tuple[ORIG].l4dst.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST);
+
+		assert(nfct_attr_is_set(ct, ATTR_REPL_PORT_SRC));
+		out->tuple[REPL].l4src.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_REPL_PORT_SRC);
+
+		assert(nfct_attr_is_set(ct, ATTR_REPL_PORT_DST));
+		out->tuple[REPL].l4dst.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_REPL_PORT_DST);
 
-		return propagate_ct(upi, ct, flags, ts);
+		if (nfct_attr_is_set(ct, ATTR_TCP_STATE))
+			out->protoinfo.tcp.state = nfct_get_attr_u8(ct, ATTR_TCP_STATE);
 	}
+
+	if (nfct_attr_is_set(ct, ATTR_STATUS))
+		out->status = nfct_get_attr_u32(ct, ATTR_STATUS);
+	if (nfct_attr_is_set(ct, ATTR_TIMEOUT))
+		out->timeout = nfct_get_attr_u32(ct, ATTR_TIMEOUT);
+	if (nfct_attr_is_set(ct, ATTR_MARK))
+		out->mark = nfct_get_attr_u32(ct, ATTR_MARK);
+	if (nfct_attr_is_set(ct, ATTR_USE))
+		out->use = nfct_get_attr_u32(ct, ATTR_USE);
+
+	/* counter */
+	if (nfct_attr_is_set(ct, ATTR_ORIG_COUNTER_BYTES))
+		out->counters[ORIG].bytes
+			= nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES);
+	if (nfct_attr_is_set(ct, ATTR_ORIG_COUNTER_PACKETS))
+		out->counters[ORIG].packets
+			= nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS);
+	if (nfct_attr_is_set(ct, ATTR_REPL_COUNTER_BYTES))
+		out->counters[ORIG].bytes
+			= nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES);
+	if (nfct_attr_is_set(ct, ATTR_REPL_COUNTER_PACKETS))
+		out->counters[REPL].packets
+			= nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS);
+
 	return 0;
 }
 
-static int read_cb_nfct(int fd, unsigned int what, void *param)
+static int
+do_nfct_msg(struct nlmsghdr *nlh, void *arg)
 {
-	struct nfct_pluginstance *cpi = (struct nfct_pluginstance *) param;
+	struct ulogd_pluginstance *pi = arg;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct nfct_conntrack nfct;
+	struct conntrack *ct;
+	int type = nfct_msg_type(nlh);
 
-	if (!(what & ULOGD_FD_READ))
+	if (type == NFCT_MSG_UNKNOWN)
 		return 0;
 
-	/* FIXME: implement this */
-	nfct_event_conntrack(cpi->cth);
+	if (nfct_parse_conntrack(NFCT_T_ALL, nlh, priv->nfct_opaque) < 0)
+		return -1;
+
+	if (nfct_to_conntrack(pi, priv->nfct_opaque, &nfct) < 0)
+		return -1;
+
+	/* TODO handle NFCT_COUNTER_FILLING */
+
+	switch (type) { 
+	case NFCT_MSG_NEW:
+		if ((ct = ct_alloc(&nfct.tuple[ORIG])) == NULL)
+			return -1;
+
+		if (cache_add(priv->tcache, ct) < 0)
+			return -1;
+		break;
+
+	case NFCT_MSG_UPDATE:
+		if ((ct = tcache_find(pi, &nfct.tuple[ORIG])) == NULL) {
+			/* do not add CT to cache, as there would be no start
+			   information */
+			break;
+		}
+
+		ct->time[UPDATE].tv_sec = t_now_local;
+
+		if (ct->used > 1) {
+			struct conntrack *ct_tmp = scache_find(pi, nlh->nlmsg_seq);
+
+			if (ct_tmp != NULL) {
+				assert(ct_tmp == ct);
+
+				cache_del(priv->scache, ct);
+			}
+		}
+
+		/* handle TCP connections differently in order not to bloat CT
+		   hash with many TIME_WAIT connections */
+		if (nfct.tuple[ORIG].protonum == IPPROTO_TCP) {
+			if (nfct.protoinfo.tcp.state == TCP_CONNTRACK_TIME_WAIT)
+				return propagate_ct(pi, &nfct, ct);
+		}
+		break;
+		
+	case NFCT_MSG_DESTROY:
+		if ((ct = tcache_find(pi, &nfct.tuple[ORIG])) != NULL)
+			return propagate_ct(pi, &nfct, ct);
+		break;
+		
+	default:
+		break;
+	}
+
 	return 0;
 }
 
-static int get_ctr_zero(struct ulogd_pluginstance *upi)
+
+static int
+read_cb_nfct(int fd, unsigned what, void *param)
 {
-	struct nfct_pluginstance *cpi = 
-			(struct nfct_pluginstance *)upi->private;
+	struct ulogd_pluginstance *pi = param;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+
+	if (!(what & ULOGD_FD_READ))
+		return 0;
 
-	return nfct_dump_conntrack_table_reset_counters(cpi->cth, AF_INET);
+	return nfnl_recv_msgs(nfct_nfnlh(priv->cth), do_nfct_msg, pi);
 }
 
-static void getctr_timer_cb(void *data)
-{
-	struct ulogd_pluginstance *upi = data;
+/*
+  nfct_timer_cb()
 
-	get_ctr_zero(upi);
+  This is a synchronous timer, do whatever you want.
+*/
+static void
+nfct_timer_cb(struct ulogd_timer *t)
+{
+	struct ulogd_pluginstance *pi = t->data;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	unsigned sc_start, sc_end, tc_start, tc_end;
+
+	sc_start = priv->scache->c_curr_head;
+	tc_start = priv->tcache->c_curr_head;
+
+	scache_cleanup(pi);
+	tcache_cleanup(pi);
+
+	sc_end = priv->scache->c_curr_head;
+	tc_end = priv->tcache->c_curr_head;
+
+	ulogd_log(ULOGD_DEBUG, "%s: ct=%u t=%u [%u,%u[ s=%u [%u,%u[\n",
+			  pi->id, num_conntrack,
+			  priv->tcache->c_cnt, tc_start, tc_end,
+			  priv->scache->c_cnt, sc_start, sc_end);
 }
 
-static int configure_nfct(struct ulogd_pluginstance *upi,
-			  struct ulogd_pluginstance_stack *stack)
+static int
+nfct_configure(struct ulogd_pluginstance *upi,
+			   struct ulogd_pluginstance_stack *stack)
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
 
-static int constructor_nfct(struct ulogd_pluginstance *upi)
+static int
+init_caches(struct ulogd_pluginstance *pi)
 {
-	struct nfct_pluginstance *cpi = 
-			(struct nfct_pluginstance *)upi->private;
-	int prealloc;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c;
 
-	memset(cpi, 0, sizeof(*cpi));
+	assert(priv->tcache == NULL && priv->scache == NULL);
 
-	/* FIXME: make eventmask configurable */
-	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, NF_NETLINK_CONNTRACK_NEW|
-			     NF_NETLINK_CONNTRACK_DESTROY);
-	if (!cpi->cth) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+	/* tuple cache */
+	c = priv->tcache = cache_alloc(buckets_ce(pi));
+	if (priv->tcache == NULL) {
+		ulogd_log(ULOGD_FATAL, "%s: out of memory\n", pi->id);
 		return -1;
 	}
 
-	nfct_register_callback(cpi->cth, &event_handler, upi);
+	c->c_hash = tcache_hash;
+	c->c_add = tcache_add;
+	c->c_del = tcache_del;
+
+	/* sequence cache */
+	c = priv->scache = cache_alloc(SCACHE_SIZE);
+	if (priv->scache == NULL) {
+		ulogd_log(ULOGD_FATAL, "%s: out of memory\n", pi->id);
 
-	cpi->nfct_fd.fd = nfct_fd(cpi->cth);
-	cpi->nfct_fd.cb = &read_cb_nfct;
-	cpi->nfct_fd.data = cpi;
-	cpi->nfct_fd.when = ULOGD_FD_READ;
-
-	ulogd_register_fd(&cpi->nfct_fd);
-
-	if (prealloc_ce(upi->config_kset).u.value != 0)
-		prealloc = maxentries_ce(upi->config_kset).u.value / 
-				buckets_ce(upi->config_kset).u.value;
-	else
-		prealloc = 0;
+		cache_free(priv->tcache);
+		priv->tcache = NULL;
 
-	if (usehash_ce(upi->config_kset).u.value != 0) {
-		cpi->ct_active = htable_alloc(buckets_ce(upi->config_kset).u.value,
-					      prealloc);
-		if (!cpi->ct_active) {
-			ulogd_log(ULOGD_FATAL, "error allocating hash\n");
-			nfct_close(cpi->cth);
-			return -1;
-		}
+		return -1;
 	}
-	
+
+	c->c_hash = scache_hash;
+	c->c_add = scache_add;
+	c->c_del = scache_del;
+
 	return 0;
 }
 
-static int destructor_nfct(struct ulogd_pluginstance *pi)
+static int
+nfct_start(struct ulogd_pluginstance *upi)
 {
-	struct nfct_pluginstance *cpi = (void *) pi;
-	int rc;
-	
-	htable_free(cpi->ct_active);
+	struct nfct_pluginstance *priv = (void *)upi->private;
+
+	pr_debug("%s: pi=%p\n", __func__, upi);
+
+	if (disable_ce(upi) != 0) {
+		ulogd_log(ULOGD_INFO, "%s: disabled\n", upi->id);
+		return 0;
+	}
+
+	if (priv->nfct_opaque == NULL) {
+		if ((priv->nfct_opaque = nfct_new()) == NULL) {
+			ulogd_log(ULOGD_FATAL, "%s: out of memory\n", upi->id);
+			return -1;
+		}
+	}
+
+	if (init_caches(upi) < 0)
+		goto err_free;
+
+	priv->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, NFCT_ALL_CT_GROUPS);
+	if (priv->cth == NULL) {
+		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		goto err_free;
+	}
+
+	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection opened\n", upi->id);
 
-	rc = nfct_close(cpi->cth);
-	if (rc < 0)
-		return rc;
+	if (nfnl_rcvbufsiz(nfct_nfnlh(priv->cth), RCVBUF_LEN) < 0)
+		goto err_nfct_close;
+
+	priv->nfct_fd.fd = nfct_fd(priv->cth);
+	priv->nfct_fd.cb = &read_cb_nfct;
+	priv->nfct_fd.data = upi;
+	priv->nfct_fd.when = ULOGD_FD_READ;
+
+	if (ulogd_register_fd(&priv->nfct_fd) < 0)
+		goto err_nfct_close;
+
+	priv->timer.cb = nfct_timer_cb;
+	priv->timer.ival = 1 SEC;
+	priv->timer.flags = TIMER_F_PERIODIC;
+	priv->timer.data = upi;
+
+	if (ulogd_register_timer(&priv->timer) < 0)
+		goto err_unreg_fd;
+
+	ulogd_log(ULOGD_INFO, "%s: started (tcache %u, scache %u)\n", upi->id,
+			  priv->tcache->c_num_heads, priv->scache->c_num_heads);
 
 	return 0;
+
+ err_unreg_fd:
+	ulogd_unregister_fd(&priv->nfct_fd);
+ err_nfct_close:
+	nfct_close(priv->cth);
+	priv->cth = NULL;
+ err_free:
+	free(priv->nfct_opaque);
+	priv->nfct_opaque = NULL;
+	cache_free(priv->tcache);
+	priv->tcache = NULL;
+	cache_free(priv->scache);
+	priv->tcache = NULL;
+
+	return -1;
 }
 
-static void signal_nfct(struct ulogd_pluginstance *pi, int signal)
+static int
+nfct_stop(struct ulogd_pluginstance *pi)
 {
-	switch (signal) {
-	case SIGUSR2:
-		get_ctr_zero(pi);
-		break;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+
+	pr_debug("%s: pi=%p\n", __func__, pi);
+
+	if (disable_ce(pi) != 0)
+		return 0;				/* wasn't started */
+
+	if (priv->tcache == NULL)
+		return 0;				/* already stopped */
+
+	ulogd_unregister_timer(&priv->timer);
+
+	ulogd_unregister_fd(&priv->nfct_fd);
+
+	if (priv->cth != NULL) {
+		nfct_close(priv->cth);
+		priv->cth = NULL;
 	}
+
+	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection closed\n", pi->id);
+
+	cache_free(priv->tcache);
+	priv->tcache = NULL;
+	cache_free(priv->scache);
+	priv->scache = NULL;
+
+	free(priv->nfct_opaque);
+	priv->nfct_opaque = NULL;
+
+	return 0;
 }
 
 static struct ulogd_plugin nfct_plugin = {
 	.name = "NFCT",
+	.flags = ULOGD_PF_RECONF,
 	.input = {
 		.type = ULOGD_DTYPE_SOURCE,
 	},
@@ -604,17 +1229,17 @@ static struct ulogd_plugin nfct_plugin =
 	},
 	.config_kset 	= &nfct_kset,
 	.interp 	= NULL,
-	.configure	= &configure_nfct,
-	.start		= &constructor_nfct,
-	.stop		= &destructor_nfct,
-	.signal		= &signal_nfct,
+	.configure	= nfct_configure,
+	.start		= nfct_start,
+	.stop		= nfct_stop,
 	.priv_size	= sizeof(struct nfct_pluginstance),
 	.version	= ULOGD_VERSION,
 };
 
 void __attribute__ ((constructor)) init(void);
 
-void init(void)
+void
+init(void)
 {
 	ulogd_register_plugin(&nfct_plugin);
 }

-- 
