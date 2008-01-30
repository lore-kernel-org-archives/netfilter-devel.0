From: heitzenberger@astaro.com
Subject: [ULOGD RFC 15/30] NFCT: add sequence cache
Date: Wed, 30 Jan 2008 19:59:02 +0100
Message-ID: <20080130190128.365211882@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-64.dex002.intermedia.net ([64.78.20.13]:4031 "EHLO
	dhost002-64.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633AbYA3TBp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:45 -0500
Content-Disposition: inline; filename=ulogd-NFCT-add-seq-cache.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On large sites it turns out that quite some time is spent in
ct_hash_find_seq() sequentially going over conntrack cache, which
sadly is indexed by tuple and not by netlink seq#.

I solve that by replacing the generic cache by a tuple cache and
a sequence cache.  The sequence cache is then used during garbage
collection to easily find the conntrack in question by seq#.

To keep the code maintainable I generalize out the cache and use it
then later for use by both cache implementations.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -25,19 +25,13 @@
  * 	  the messages via IPFX to one aggregator who then runs ulogd with a 
  * 	  network wide connection hash table.
  */
-
-#include <stdlib.h>
-#include <stdbool.h>
-#include <string.h>
-#include <errno.h>
-
-#include <sys/time.h>
-#include <time.h>
-
 #include <ulogd/ulogd.h>
 #include <ulogd/common.h>
 #include <ulogd/linuxlist.h>
 #include <ulogd/ipfix_protocol.h>
+#include <time.h>
+#include <sys/time.h>
+#include <netinet/in.h>
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
@@ -47,74 +41,79 @@
 						 | NF_NETLINK_CONNTRACK_UPDATE \
 						 | NF_NETLINK_CONNTRACK_DESTROY)
 
-#undef INADDR_LOOPBACK
-#define INADDR_LOOPBACK		0x0100007f /* 127.0.0.1 */
-
+/* configuration defaults */
+#define TCACHE_SIZE       8192
+#define SCACHE_SIZE       64
+#define SCACHE_REQ_MAX    100
+#define TIMEOUT           30 SEC
 
-typedef enum TIMES_ { START, STOP, __TIME_MAX } TIMES;
+typedef enum TIMES_ { START, UPDATE, STOP, __TIME_MAX } TIMES;
 typedef unsigned conntrack_hash_t;
 
-struct ct_timestamp {
+struct conntrack {
 	struct llist_head list;
+	struct llist_head seq_link;
 	struct nfct_tuple tuple;
 	unsigned last_seq;
 	struct timeval time[__TIME_MAX];
+	time_t t_req;
+	unsigned used;
 };
 
-struct ct_htable {
-	struct llist_head *buckets;
-	unsigned num_buckets;
-	unsigned curr_bucket;
-	unsigned used;
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
-	struct ct_htable *htable;
+	struct cache *tcache;       /* tuple cache */
+	struct cache *scache;       /* sequence cache */
 	struct ulogd_timer timer;
-	unsigned disable : 1;
 	struct {
 		unsigned nl_err;
 		unsigned nl_ovr;
 	} stats;
 };
 
-#define HTABLE_SIZE	(512)
-
+static unsigned num_conntrack;
 static struct config_keyset nfct_kset = {
-	.num_ces = 4,
+	.num_ces = 3,
 	.ces = {
 		{
-			.key	 = "pollinterval",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
-		},
-		{
 			.key	 = "hash_buckets",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
-			.u.value = HTABLE_SIZE,
+			.u.value = TCACHE_SIZE,
 		},
 		{
-			.key	 = "hash_max_entries",
+			.key	 = "disable",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
 		{
-			.key	 = "disable",
+			.key	 = "timeout",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
+			.u.value = TIMEOUT,
 		},
 	},
 };
-#define pollint_ce(x)	(x->ces[0])
-#define buckets_ce(x)	(x->ces[1])
-#define hash_max_entries(x)		((x)->ces[2])
-#define disable_ce(x)	(x->ces[3])
+#define buckets_ce(pi)    ((pi)->config_kset->ces[0].u.value)
+#define disable_ce(pi)    ((pi)->config_kset->ces[1].u.value)
+#define timeout_ce(pi)    ((pi)->config_kset->ces[2].u.value)
 
 enum {
 	O_IP_SADDR = 0,
@@ -311,9 +310,11 @@ static struct ulogd_key nfct_okeys[__O_M
 
 
 /* forward declarations */
-static struct ct_timestamp * ct_hash_find_seq(const struct ct_htable *,
-											  unsigned);
-static void ct_hash_free(struct ct_htable *, struct ct_timestamp *);
+static int cache_del(struct cache *, struct conntrack *);
+static struct conntrack *tcache_find(const struct ulogd_pluginstance *,
+									 const struct nfct_tuple *);
+static struct conntrack *scache_find(const struct ulogd_pluginstance *,
+									 unsigned);
 
 
 static int
@@ -321,16 +322,25 @@ nl_error(struct ulogd_pluginstance *pi, 
 {
 	struct nfct_pluginstance *priv = (void *)pi->private;
 	struct nlmsgerr *e = NLMSG_DATA(nlh);
-	struct ct_timestamp *ts;
+	struct conntrack *ct;
 
-	ts = ct_hash_find_seq(priv->htable, e->msg.nlmsg_seq);
-	if (ts == NULL)
+	if (e->msg.nlmsg_seq == 0)
+		return 0;
+
+	ct = scache_find(pi, e->msg.nlmsg_seq);
+	if (ct == NULL)
 		return 0;						/* already gone */
 
 	switch (-e->error) {
 	case ENOENT:
 		/* destroy message was lost (FIXME log all what we got) */
-		ct_hash_free(priv->htable, ts);
+		if (ct->used > 1) {
+			struct conntrack *ct_tmp = tcache_find(pi, &ct->tuple);
+
+			if (ct == ct_tmp)
+				cache_del(priv->tcache, ct);
+		}
+		cache_del(priv->scache, ct);
 		break;
 
 	case 0:								/* "Success" */
@@ -381,7 +391,7 @@ nfnl_recv_msgs(struct nfnl_handle *nfnlh
 
 			if (nlh->nlmsg_type == NLMSG_OVERRUN)
 				priv->stats.nl_ovr++;	/* continue?  payload? */
-				
+
 			(cb)(nlh, pi);
 
 			nlh = NLMSG_NEXT(nlh, nread);
@@ -440,206 +450,315 @@ nfct_get_conntrack_x(struct nfct_handle 
 	return nbytes;
 }
 
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
+
+		free(ct);
+
+		num_conntrack--;
+	}
+}
+
+/* tuple cache */
+static struct conntrack ct_search;		/* used by scache too */
 
 static conntrack_hash_t
-hash_conntrack(const struct nfct_tuple *t, size_t hash_sz)
+tcache_hash(struct cache *c, struct conntrack *ct)
 {
 	static unsigned rnd;
+	struct nfct_tuple *t = &ct->tuple;
 
 	if (rnd == 0U)
 		rnd = rand();
 
-	return jhash_3words(t->src.v4, t->dst.v4 ^ t->protonum,
-						t->l4src.all | (t->l4dst.all << 16), rnd) % hash_sz;
+	return jhash_3words(t->src.v4, t->dst.v4 ^ t->protonum,	t->l4src.all
+						| (t->l4dst.all << 16), rnd) % c->c_num_heads;
 }
 
-static inline bool
-ct_cmp(const struct nfct_tuple *t1, const struct nfct_tuple *t2)
+static int
+tcache_add(struct cache *c, struct conntrack *ct)
 {
-	return memcmp(t1, t2, sizeof(struct nfct_tuple)) == 0;
-}
+	conntrack_hash_t h = c->c_hash(c, ct);
+
+	llist_add(&ct->list, &c->c_head[h].link);
+	c->c_head[h].cnt++;
 
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
 
-static struct ct_htable *
-htable_alloc(int htable_size)
+	return 0;
+}
+
+static int
+tcache_del(struct cache *c, struct conntrack *ct)
 {
-	struct ct_htable *htable;
-	int i;
+	conntrack_hash_t h = c->c_hash(c, ct);
 
-	htable = malloc(sizeof(*htable)
-			+ sizeof(struct llist_head) * htable_size);
-	if (!htable)
-		return NULL;
+	assert(c->c_head[h].cnt > 0);
 
-	htable->buckets = (void *)htable + sizeof(*htable);
-	htable->num_buckets = htable_size;
-	htable->curr_bucket = 0;
-	htable->used = 0;
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
 
-	for (i = 0; i < htable->num_buckets; i++)
-		INIT_LLIST_HEAD(&htable->buckets[i]);
-	
-	return htable;
+	llist_del(&ct->list);
+	c->c_head[h].cnt--;
+
+	return 0;
 }
 
-static void
-htable_free(struct ct_htable *htable)
+static struct conntrack *
+tcache_find(const struct ulogd_pluginstance *pi,
+			const struct nfct_tuple *tuple)
 {
-	struct llist_head *ptr, *ptr2;
-	int i;
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c = priv->tcache;
+	struct conntrack *ct;
+	conntrack_hash_t h;
 
-	for (i = 0; i < htable->num_buckets; i++) {
-		llist_for_each_safe(ptr, ptr2, &htable->buckets[i])
-			free(container_of(ptr, struct ct_timestamp, list));
+	memcpy(&ct_search.tuple, tuple, sizeof(struct nfct_tuple));
+	h = c->c_hash(c, &ct_search);
+
+	llist_for_each_entry(ct, &c->c_head[h].link, list) {
+		if (memcmp(&ct->tuple, tuple, sizeof(*tuple)) == 0)
+			return ct;
 	}
 
-	free(htable);
+	return NULL;
 }
 
-static struct ct_timestamp *
-ct_hash_add(struct ct_htable *htable, const struct nfct_tuple *t)
+/* sequence cache */
+static conntrack_hash_t
+scache_hash(struct cache *c, struct conntrack *ct)
 {
-	struct ct_timestamp *ts;
-	conntrack_hash_t h;
+	static unsigned rnd;
 
-	h = hash_conntrack(t, htable->num_buckets);
+	if (rnd == 0U)
+		rnd = rand();
 
-	if ((ts = calloc(1, sizeof(struct ct_timestamp))) == NULL) {
-		ulogd_log(ULOGD_ERROR, "Out of memory\n");
-		return NULL;
-	}
+	return (ct->last_seq ^ rnd) % c->c_num_heads;
+}
 
-	memcpy(&ts->tuple, t, sizeof(struct nfct_tuple));
+static int
+scache_add(struct cache *c, struct conntrack *ct)
+{
+	conntrack_hash_t h = c->c_hash(c, ct);
 
-	llist_add(&ts->list, &htable->buckets[h]);
-	htable->used++;
+	llist_add(&ct->seq_link, &c->c_head[h].link);
+	c->c_head[h].cnt++;
 
-	return ts;
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
+
+	return 0;
 }
 
-static struct ct_timestamp *
-ct_hash_find(struct ct_htable *htable, const struct nfct_tuple *t)
-{  
-	struct llist_head *ptr;
-	conntrack_hash_t h = hash_conntrack(t, htable->num_buckets);
+static int
+scache_del(struct cache *c, struct conntrack *ct)
+{
+	conntrack_hash_t h = c->c_hash(c, ct);
+
+	assert(c->c_head[h].cnt > 0);
 
-	llist_for_each(ptr, &htable->buckets[h]) {
-		struct ct_timestamp *ts = container_of(ptr, struct ct_timestamp, list);
+	pr_debug("%s: ct=%p (h %u, %u/%u)\n", __func__, ct, h,
+			 c->c_head[h].cnt, c->c_cnt);
 
-		if (ct_cmp(t, &ts->tuple))
-			return ts;
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
 
 	return NULL;
 }
 
+static struct cache *
+cache_alloc(int cache_size)
+{
+	struct cache *c;
+	int i;
+
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
 
-static struct ct_timestamp *
-ct_hash_find_seq(const struct ct_htable *htable, unsigned seq)
+static void
+cache_free(struct cache *c)
 {
 	int i;
 
-	for (i = 0; i < htable->num_buckets; i++) {
-		struct ct_timestamp *ts;
+	for (i = 0; i < c->c_num_heads; i++) {
+		struct llist_head *ptr, *ptr2;
 
-		llist_for_each_entry(ts, &htable->buckets[i], list) {
-			if (ts->last_seq == seq)
-				return ts;
-		}
+		llist_for_each_safe(ptr, ptr2, &c->c_head[i].link)
+			free(container_of(ptr, struct conntrack, list));
 	}
 
-	return NULL;
+	free(c);
 }
 
+int
+cache_add(struct cache *c, struct conntrack *ct)
+{
+	ct_get(ct);
 
-/* time diff with second resolution */
-static inline unsigned
-tv_diff_sec(const struct ct_timestamp *ts)
+	ct->time[UPDATE].tv_sec = ct->time[START].tv_sec = t_now;
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
 {
-	if (ts->time[STOP].tv_sec >= ts->time[START].tv_sec)
-		return max(ts->time[STOP].tv_sec - ts->time[START].tv_sec, 1);
+	assert(c->c_cnt > 0);
+	assert(ct->used > 0);
 
-	return ts->time[START].tv_sec - ts->time[STOP].tv_sec;
+	/* order of these two is important for debugging purposes */
+	c->c_del(c, ct);
+	c->c_cnt--;
+
+	ct_put(ct);
+
+	return 0;
 }
 
-static void
-ct_hash_free(struct ct_htable *htable, struct ct_timestamp *ts)
+/* time diff with second resolution */
+static inline unsigned
+tv_diff_sec(const struct timeval *tv1, const struct timeval *tv2)
 {
-	llist_del(&ts->list);
+	if (tv2->tv_sec >= tv1->tv_sec)
+		return max(tv2->tv_sec - tv1->tv_sec, 1);
 
-	free(ts);
-	htable->used--;
+	return tv1->tv_sec - tv2->tv_sec;
 }
 
 static int
 propagate_ct_flow(struct ulogd_pluginstance *upi, 
-				  struct nfct_conntrack *ct, unsigned int flags,
-				  int dir, struct ct_timestamp *ts)
+				  struct nfct_conntrack *nfct, unsigned int flags,
+				  int dir, struct conntrack *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
-	ret[O_IP_SADDR].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
+	ret[O_IP_SADDR].u.value.ui32 = htonl(nfct->tuple[dir].src.v4);
 	ret[O_IP_SADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[O_IP_DADDR].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
+	ret[O_IP_DADDR].u.value.ui32 = htonl(nfct->tuple[dir].dst.v4);
 	ret[O_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[O_IP_PROTO].u.value.ui8 = ct->tuple[dir].protonum;
+	ret[O_IP_PROTO].u.value.ui8 = nfct->tuple[dir].protonum;
 	ret[O_IP_PROTO].flags |= ULOGD_RETF_VALID;
 
-	switch (ct->tuple[dir].protonum) {
+	switch (nfct->tuple[dir].protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[O_L4_SPORT].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
+		ret[O_L4_SPORT].u.value.ui16 = htons(nfct->tuple[dir].l4src.tcp.port);
 		ret[O_L4_SPORT].flags |= ULOGD_RETF_VALID;
-		ret[O_L4_DPORT].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
+		ret[O_L4_DPORT].u.value.ui16 = htons(nfct->tuple[dir].l4dst.tcp.port);
 		ret[O_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[O_ICMP_CODE].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
+		ret[O_ICMP_CODE].u.value.ui8 = nfct->tuple[dir].l4src.icmp.code;
 		ret[O_ICMP_CODE].flags |= ULOGD_RETF_VALID;
-		ret[O_ICMP_TYPE].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
+		ret[O_ICMP_TYPE].u.value.ui8 = nfct->tuple[dir].l4src.icmp.type;
 		ret[O_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
 		break;
 	}
 
 	if (flags & NFCT_COUNTERS_ORIG) {
-		ret[O_RAW_IN_PKTLEN].u.value.ui32 = ct->counters[0].bytes;
+		ret[O_RAW_IN_PKTLEN].u.value.ui32 = nfct->counters[0].bytes;
 		ret[O_RAW_IN_PKTLEN].flags |= ULOGD_RETF_VALID;
-		ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = ct->counters[0].packets;
+		ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = nfct->counters[0].packets;
 		ret[O_RAW_IN_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 
-		ret[O_RAW_OUT_PKTLEN].u.value.ui32 = ct->counters[1].bytes;
+		ret[O_RAW_OUT_PKTLEN].u.value.ui32 = nfct->counters[1].bytes;
 		ret[O_RAW_OUT_PKTLEN].flags |= ULOGD_RETF_VALID;
-		ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = ct->counters[1].packets;
+		ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = nfct->counters[1].packets;
 		ret[O_RAW_OUT_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (flags & NFCT_MARK) {
-		ret[O_CT_MARK].u.value.ui32 = ct->mark;
+		ret[O_CT_MARK].u.value.ui32 = nfct->mark;
 		ret[O_CT_MARK].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (flags & NFCT_ID) {
-		ret[O_CT_ID].u.value.ui32 = ct->id;
+		ret[O_CT_ID].u.value.ui32 = nfct->id;
 		ret[O_CT_ID].flags |= ULOGD_RETF_VALID;
 	}
 
-	ret[O_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
+	ret[O_FLOW_START_SEC].u.value.ui32 = ct->time[START].tv_sec;
 	ret[O_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
-	ret[O_FLOW_START_USEC].u.value.ui32 = ts->time[START].tv_usec;
+	ret[O_FLOW_START_USEC].u.value.ui32 = ct->time[START].tv_usec;
 	ret[O_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
-	ret[O_FLOW_START_DAY].u.value.ui16 = ts->time[START].tv_sec / (1 DAY);
+	ret[O_FLOW_START_DAY].u.value.ui16 = ct->time[START].tv_sec / (1 DAY);
 	ret[O_FLOW_START_DAY].flags |= ULOGD_RETF_VALID;
 
-	ret[O_FLOW_END_SEC].u.value.ui32 = ts->time[STOP].tv_sec;
+	ret[O_FLOW_END_SEC].u.value.ui32 = ct->time[STOP].tv_sec;
 	ret[O_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
-	ret[O_FLOW_END_USEC].u.value.ui32 = ts->time[STOP].tv_usec;
+	ret[O_FLOW_END_USEC].u.value.ui32 = ct->time[STOP].tv_usec;
 	ret[O_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
 
-	ret[O_FLOW_DURATION].u.value.ui32 = tv_diff_sec(ts);
+	ret[O_FLOW_DURATION].u.value.ui32 = tv_diff_sec(&ct->time[START],
+													&ct->time[STOP]);
 	ret[O_FLOW_DURATION].flags |= ULOGD_RETF_VALID;
 
 	ulogd_propagate_results(upi);
@@ -648,22 +767,22 @@ propagate_ct_flow(struct ulogd_pluginsta
 }
 
 static int
-propagate_ct(struct ulogd_pluginstance *upi, struct nfct_conntrack *ct,
-			 struct ct_timestamp *ts, unsigned int flags)
+propagate_ct(struct ulogd_pluginstance *upi, struct nfct_conntrack *nfct,
+			 struct conntrack *ct, unsigned int flags)
 {
 	struct nfct_pluginstance *priv = (void *)upi->private;
 
 	do {
-		if (ct->tuple[NFCT_DIR_ORIGINAL].src.v4 == INADDR_LOOPBACK
-			|| ct->tuple[NFCT_DIR_ORIGINAL].dst.v4 == INADDR_LOOPBACK)
+		if (nfct->tuple[NFCT_DIR_ORIGINAL].src.v4 == INADDR_LOOPBACK
+			|| nfct->tuple[NFCT_DIR_ORIGINAL].dst.v4 == INADDR_LOOPBACK)
 			break;
 
-		gettimeofday(&ts->time[STOP], NULL);
-		
-		propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ts);
+		ct->time[STOP].tv_sec = t_now;
+
+		propagate_ct_flow(upi, nfct, flags, NFCT_DIR_ORIGINAL, ct);
 	} while (0);
 
-	ct_hash_free(priv->htable, ts);
+	cache_del(priv->tcache, ct);
 
 	return 0;
 }
@@ -675,49 +794,64 @@ do_nfct_msg(struct nlmsghdr *nlh, void *
 	struct ulogd_pluginstance *pi = arg;
 	struct nfct_pluginstance *priv = (void *)pi->private;
 	struct nfgenmsg *nfh = NLMSG_DATA(nlh);
-	struct nfct_conntrack ct;
-	struct ct_timestamp *ts;
+	struct nfct_conntrack nfct;
+	struct conntrack *ct;
 	int flags, type = nfct_msg_type(nlh);
 
 	if (type == NFCT_MSG_UNKNOWN)
 		return 0;
 
-	bzero(&ct, sizeof(ct));
+	bzero(&nfct, sizeof(nfct));
 
-	ct.tuple[NFCT_DIR_ORIGINAL].l3protonum = 
-		ct.tuple[NFCT_DIR_REPLY].l3protonum = nfh->nfgen_family;
+	nfct.tuple[NFCT_DIR_ORIGINAL].l3protonum = 
+		nfct.tuple[NFCT_DIR_REPLY].l3protonum = nfh->nfgen_family;
 
-	if (nfct_netlink_to_conntrack(nlh, &ct, &flags) < 0)
+	if (nfct_netlink_to_conntrack(nlh, &nfct, &flags) < 0)
 		return -1;
 
+	/* TODO handle NFCT_COUNTER_FILLING */
+
 	switch (type) { 
 	case NFCT_MSG_NEW:
-		ts = ct_hash_add(priv->htable, &ct.tuple[NFCT_DIR_ORIGINAL]);
-		if (ts != NULL) {
-			gettimeofday(&ts->time[START], NULL);
-		}
+		if ((ct = ct_alloc(&nfct.tuple[NFCT_DIR_ORIGINAL])) == NULL)
+			return -1;
+
+		if (cache_add(priv->tcache, ct) < 0)
+			return -1;
 		break;
 
 	case NFCT_MSG_UPDATE:
-		ts = ct_hash_find(priv->htable, &ct.tuple[NFCT_DIR_ORIGINAL]);
-		if (ts == NULL) {
+		ct = tcache_find(pi, &nfct.tuple[NFCT_DIR_ORIGINAL]);
+		if (ct == NULL) {
 			/* do not add CT to cache, as there would be no start
 			   information */
 			break;
 		}
 
+		ct->time[UPDATE].tv_sec = t_now;
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
 		/* handle TCP connections differently in order not to bloat CT
 		   hash with many TIME_WAIT connections */
-		if (ct.tuple[NFCT_DIR_ORIGINAL].protonum == IPPROTO_TCP) {
-			if (ct.protoinfo.tcp.state == TCP_CONNTRACK_TIME_WAIT)
-				return propagate_ct(pi, &ct, ts, flags);
+		if (nfct.tuple[NFCT_DIR_ORIGINAL].protonum == IPPROTO_TCP) {
+			if (nfct.protoinfo.tcp.state == TCP_CONNTRACK_TIME_WAIT)
+				return propagate_ct(pi, &nfct, ct, flags);
 		}
 		break;
 		
 	case NFCT_MSG_DESTROY:
-		ts = ct_hash_find(priv->htable, &ct.tuple[NFCT_DIR_ORIGINAL]);
-		if (ts != NULL)
-			return propagate_ct(pi, &ct, ts, flags);
+		ct = tcache_find(pi, &nfct.tuple[NFCT_DIR_ORIGINAL]);
+		if (ct != NULL)
+			return propagate_ct(pi, &nfct, ct, flags);
 		break;
 		
 	default:
@@ -741,31 +875,68 @@ read_cb_nfct(int fd, unsigned what, void
 }
 
 
-/* choosing powers of two for all values helps here */
-#define STOP_HERE(h)	(((h)->curr_bucket + 16) % (h)->num_buckets)
+#define STOP_HERE(h)	(((h)->c_curr_head + 32) % (h)->c_num_heads)
 
+/*
+  nfct_timer_cb()
+
+  This is a synchronous timer, do whatever you want.
+*/
 static void
 nfct_timer_cb(struct ulogd_timer *t)
 {
 	struct ulogd_pluginstance *pi = t->data;
 	struct nfct_pluginstance *priv = (void *)pi->private;
-	struct ct_htable *ht = priv->htable;
-	struct ct_timestamp *ts;
-	int end = STOP_HERE(ht);
+	struct cache *ht = priv->tcache;
+	int i, req = 0, end = STOP_HERE(ht);
+	struct conntrack *ct;
+
+	/* cleanup stale entries from sequence cache */
+	for (i = 0; i < priv->scache->c_num_heads; i++) {
+		if (llist_empty(&priv->scache->c_head[i].link))
+			continue;
+
+		ct = container_of(priv->scache->c_head[i].link.prev,
+						  struct conntrack, seq_link);
+
+		assert(ct->t_req != 0);
+
+		if (ct->t_req > 0 && (t_now - ct->t_req) > 5 SEC)
+			cache_del(priv->scache, ct);
+	}
 
+	/* check entries in tuple cache */
 	do {
-		assert(ht->curr_bucket < ht->num_buckets);
+		assert(ht->c_curr_head < ht->c_num_heads);
+
+		llist_for_each_entry(ct, &ht->c_head[ht->c_curr_head].link, list) {
+			if (tv_diff_sec(&ct->time[UPDATE], &tv_now) < timeout_ce(pi))
+				continue;
 
-		llist_for_each_entry(ts, &ht->buckets[ht->curr_bucket], list) {
 			/* check if its still there */
-			nfct_get_conntrack_x(priv->cth, &ts->tuple, NFCT_DIR_ORIGINAL,
-								 &ts->last_seq);
+			nfct_get_conntrack_x(priv->cth, &ct->tuple, NFCT_DIR_ORIGINAL,
+								 &ct->last_seq);
+
+			if (&ct->last_seq != 0) {
+				ct->t_req = t_now;
+
+				assert(scache_find(pi, ct->last_seq) == NULL);
+
+				cache_add(priv->scache, ct);
+			}
+
+			if (++req > SCACHE_REQ_MAX)
+				break;
 		}
 
-		ht->curr_bucket = (ht->curr_bucket + 1) % ht->num_buckets;
-	} while (ht->curr_bucket != end);
+		ht->c_curr_head = (ht->c_curr_head + 1) % ht->c_num_heads;
 
-	pr_debug("%s: now=%ld\n", __func__, t_now);
+		if (req > SCACHE_REQ_MAX)
+			break;
+	} while (ht->c_curr_head != end);
+
+	ulogd_log(ULOGD_DEBUG, "%s: ct:%u t:%u s:%u\n", pi->id,
+			  num_conntrack, priv->tcache->c_cnt, priv->scache->c_cnt);
 }
 
 static int
@@ -775,19 +946,51 @@ nfct_configure(struct ulogd_pluginstance
 	struct nfct_pluginstance *priv = (void *)upi->private;
 	int ret;
 
-	pr_debug("%s: pi=%p\n", __func__, upi);
-
 	memset(priv, 0, sizeof(struct nfct_pluginstance));
 	
 	ret = config_parse_file(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;
 
-	priv->disable = disable_ce(upi->config_kset).u.value;
-
 	return 0;
 }
 
+static int
+init_caches(struct ulogd_pluginstance *pi)
+{
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c;
+
+	assert(priv->tcache == NULL && priv->scache == NULL);
+
+	/* tuple cache */
+	c = priv->tcache = cache_alloc(buckets_ce(pi));
+	if (priv->tcache == NULL) {
+		ulogd_log(ULOGD_FATAL, "%s: out of memory\n", pi->id);
+		return -1;
+	}
+
+	c->c_hash = tcache_hash;
+	c->c_add = tcache_add;
+	c->c_del = tcache_del;
+
+	/* sequence cache */
+	c = priv->scache = cache_alloc(SCACHE_SIZE);
+	if (priv->scache == NULL) {
+		ulogd_log(ULOGD_FATAL, "%s: out of memory\n", pi->id);
+
+		cache_free(priv->tcache);
+		priv->tcache = NULL;
+
+		return -1;
+	}
+
+	c->c_hash = scache_hash;
+	c->c_add = scache_add;
+	c->c_del = scache_del;
+
+	return 0;
+}
 
 static int
 nfct_start(struct ulogd_pluginstance *upi)
@@ -796,16 +999,13 @@ nfct_start(struct ulogd_pluginstance *up
 
 	pr_debug("%s: pi=%p\n", __func__, upi);
 
-	if (priv->disable) {
+	if (disable_ce(upi) != 0) {
 		ulogd_log(ULOGD_INFO, "%s: disabled\n", upi->id);
 		return 0;
 	}
 
-	priv->htable = htable_alloc(buckets_ce(upi->config_kset).u.value);
-	if (priv->htable == NULL) {
-		ulogd_log(ULOGD_FATAL, "%s: out of memory\n", upi->id);
+	if (init_caches(upi) < 0)
 		return -1;
-	}
 
 	priv->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, CT_EVENTS);
 	if (priv->cth == NULL) {
@@ -831,7 +1031,8 @@ nfct_start(struct ulogd_pluginstance *up
 	if (ulogd_register_timer(&priv->timer) < 0)
 		goto err_unreg_fd;
 
-	ulogd_log(ULOGD_INFO, "%s: started\n", upi->id);
+	ulogd_log(ULOGD_INFO, "%s: started (tcache %u, scache %u)\n", upi->id,
+			  priv->tcache->c_num_heads, priv->scache->c_num_heads);
 
 	return 0;
 
@@ -841,8 +1042,8 @@ nfct_start(struct ulogd_pluginstance *up
 	nfct_close(priv->cth);
 	priv->cth = NULL;
  err_free:
-	htable_free(priv->htable);
-	priv->htable = NULL;
+	cache_free(priv->tcache);
+	priv->tcache = NULL;
 
 	return -1;
 }
@@ -854,10 +1055,10 @@ nfct_stop(struct ulogd_pluginstance *pi)
 
 	pr_debug("%s: pi=%p\n", __func__, pi);
 
-	if (priv->disable)
+	if (disable_ce(pi) != 0)
 		return 0;				/* wasn't started */
 
-	if (priv->htable == NULL)
+	if (priv->tcache == NULL)
 		return 0;				/* already stopped */
 
 	ulogd_unregister_timer(&priv->timer);
@@ -871,9 +1072,9 @@ nfct_stop(struct ulogd_pluginstance *pi)
 
 	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection closed\n", pi->id);
 
-	if (priv->htable != NULL) {
-		htable_free(priv->htable);
-		priv->htable = NULL;
+	if (priv->tcache != NULL) {
+		cache_free(priv->tcache);
+		priv->tcache = NULL;
 	}
 
 	return 0;

-- 
