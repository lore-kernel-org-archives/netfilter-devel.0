From: heitzenberger@astaro.com
Subject: [ULOGD RFC 23/30] NFCT: make sequence cache bigger, make handling smarter
Date: Wed, 30 Jan 2008 19:59:10 +0100
Message-ID: <20080130190129.468999710@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-48.dex002.intermedia.net ([64.78.21.144]:9357 "EHLO
	dhost002-48.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbYA3TBs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:48 -0500
Content-Disposition: inline; filename=ulogd-NFCT-make-scache-scale-better.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Increase sequence cache and therefore make cache handling smarter for
it too.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -42,10 +42,13 @@
 						 | NF_NETLINK_CONNTRACK_DESTROY)
 
 /* configuration defaults */
-#define TCACHE_SIZE       8192
-#define SCACHE_SIZE       64
-#define SCACHE_REQ_MAX    100
-#define TIMEOUT           30 SEC
+#define TCACHE_SIZE		8192
+#define SCACHE_SIZE		512
+#define TCACHE_REQ_MAX	100
+#define TIMEOUT			30 SEC
+
+#define RCVBUF_LEN		(1 << 18)
+#define SNDBUF_LEN		RCVBUF_LEN
 
 typedef enum TIMES_ { START, UPDATE, STOP, __TIME_MAX } TIMES;
 typedef unsigned conntrack_hash_t;
@@ -429,7 +432,7 @@ nfct_get_conntrack_x(struct nfct_handle 
 {
 	static char buf[NFNL_BUFFSIZE];
 	struct nfnlhdr *req = (void *)buf;
-	int cta_dir, nbytes;
+	int cta_dir;
 
 	memset(buf, 0, sizeof(buf));
 
@@ -445,9 +448,17 @@ nfct_get_conntrack_x(struct nfct_handle 
 
 	nfct_build_tuple(req, sizeof(buf), t, cta_dir);
 
-	nbytes = nfnl_send(nfct_nfnlh(cth), &req->nlh);
+	return nfnl_send(nfct_nfnlh(cth), &req->nlh);
+}
+
+/* time diff with second resolution */
+static inline unsigned
+tv_diff_sec(const struct timeval *tv1, const struct timeval *tv2)
+{
+	if (tv2->tv_sec >= tv1->tv_sec)
+		return max(tv2->tv_sec - tv1->tv_sec, 1);
 
-	return nbytes;
+	return tv1->tv_sec - tv2->tv_sec;
 }
 
 struct conntrack *
@@ -483,6 +494,85 @@ ct_put(struct conntrack *ct)
 	}
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
+
+static void
+cache_free(struct cache *c)
+{
+	int i;
+
+	for (i = 0; i < c->c_num_heads; i++) {
+		struct llist_head *ptr, *ptr2;
+
+		llist_for_each_safe(ptr, ptr2, &c->c_head[i].link)
+			free(container_of(ptr, struct conntrack, list));
+	}
+
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
 /* tuple cache */
 static struct conntrack ct_search;		/* used by scache too */
 
@@ -549,6 +639,55 @@ tcache_find(const struct ulogd_pluginsta
 	return NULL;
 }
 
+/* check entries in tuple cache */
+static int
+tcache_cleanup(struct ulogd_pluginstance *pi)
+{
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
+			ret = nfct_get_conntrack_x(priv->cth, &ct->tuple,
+									   NFCT_DIR_ORIGINAL, &ct->last_seq);
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
+
+				assert(scache_find(pi, ct->last_seq) == NULL);
+
+				cache_add(priv->scache, ct);
+			}
+
+			if (++req > TCACHE_REQ_MAX)
+				break;
+		}
+
+		c->c_curr_head = cache_head_next(c);
+
+		if (req > TCACHE_REQ_MAX)
+			break;
+	} while (c->c_curr_head != end);
+
+	return req;
+}
+
 /* sequence cache */
 static conntrack_hash_t
 scache_hash(struct cache *c, struct conntrack *ct)
@@ -612,81 +751,39 @@ scache_find(const struct ulogd_pluginsta
 	return NULL;
 }
 
-static struct cache *
-cache_alloc(int cache_size)
-{
-	struct cache *c;
-	int i;
-
-	c = malloc(sizeof(*c) + sizeof(struct cache_head) * cache_size);
-	if (c == NULL)
-		return NULL;
-
-	c->c_head = (void *)c + sizeof(*c);
-	c->c_num_heads = cache_size;
-	c->c_curr_head = 0;
-	c->c_cnt = 0;
-
-	for (i = 0; i < c->c_num_heads; i++) {
-		INIT_LLIST_HEAD(&c->c_head[i].link);
-		c->c_head[i].cnt = 0;
-	}
-	
-	return c;
-}
-
-static void
-cache_free(struct cache *c)
-{
-	int i;
-
-	for (i = 0; i < c->c_num_heads; i++) {
-		struct llist_head *ptr, *ptr2;
-
-		llist_for_each_safe(ptr, ptr2, &c->c_head[i].link)
-			free(container_of(ptr, struct conntrack, list));
-	}
-
-	free(c);
-}
-
-int
-cache_add(struct cache *c, struct conntrack *ct)
+static int
+scache_cleanup(struct ulogd_pluginstance *pi)
 {
-	ct_get(ct);
+	struct nfct_pluginstance *priv = (void *)pi->private;
+	struct cache *c = priv->scache;
+	conntrack_hash_t end = cache_slice_end(c, 16);
+	struct conntrack *ct;
+	int del = 0;
 
-	ct->time[UPDATE].tv_sec = ct->time[START].tv_sec = t_now_local;
+	if (c->c_cnt == 0)
+		return 0;
 
-	/* order of these two is important for debugging purposes */
-	c->c_cnt++;
-	c->c_add(c, ct);
+	do {
+		struct llist_head *curr, *tmp;
 
-	return 0;
-}
+		assert(c->c_curr_head < c->c_num_heads);
 
-int
-cache_del(struct cache *c, struct conntrack *ct)
-{
-	assert(c->c_cnt > 0);
-	assert(ct->used > 0);
+		llist_for_each_prev_safe(curr, tmp, &c->c_head[c->c_curr_head].link) {
+			ct = container_of(curr, struct conntrack, seq_link);
 
-	/* order of these two is important for debugging purposes */
-	c->c_del(c, ct);
-	c->c_cnt--;
+			assert(ct->t_req != 0);
 
-	ct_put(ct);
+			if ((t_now - ct->t_req) < 5 SEC)
+				break;
 
-	return 0;
-}
+			cache_del(priv->scache, ct);
+			del++;
+		}
 
-/* time diff with second resolution */
-static inline unsigned
-tv_diff_sec(const struct timeval *tv1, const struct timeval *tv2)
-{
-	if (tv2->tv_sec >= tv1->tv_sec)
-		return max(tv2->tv_sec - tv1->tv_sec, 1);
+		c->c_curr_head = cache_head_next(c);
+	} while (c->c_curr_head != end);
 
-	return tv1->tv_sec - tv2->tv_sec;
+	return del;
 }
 
 static int
@@ -874,9 +971,6 @@ read_cb_nfct(int fd, unsigned what, void
 	return nfnl_recv_msgs(nfct_nfnlh(priv->cth), do_nfct_msg, pi);
 }
 
-
-#define STOP_HERE(h)	(((h)->c_curr_head + 32) % (h)->c_num_heads)
-
 /*
   nfct_timer_cb()
 
@@ -887,56 +981,21 @@ nfct_timer_cb(struct ulogd_timer *t)
 {
 	struct ulogd_pluginstance *pi = t->data;
 	struct nfct_pluginstance *priv = (void *)pi->private;
-	struct cache *ht = priv->tcache;
-	int i, req = 0, end = STOP_HERE(ht);
-	struct conntrack *ct;
-
-	/* cleanup stale entries from sequence cache */
-	for (i = 0; i < priv->scache->c_num_heads; i++) {
-		if (llist_empty(&priv->scache->c_head[i].link))
-			continue;
-
-		ct = container_of(priv->scache->c_head[i].link.prev,
-						  struct conntrack, seq_link);
-
-		assert(ct->t_req != 0);
-
-		if (ct->t_req > 0 && (t_now - ct->t_req) > 5 SEC)
-			cache_del(priv->scache, ct);
-	}
-
-	/* check entries in tuple cache */
-	do {
-		assert(ht->c_curr_head < ht->c_num_heads);
-
-		llist_for_each_entry(ct, &ht->c_head[ht->c_curr_head].link, list) {
-			if (tv_diff_sec(&ct->time[UPDATE], &tv_now) < timeout_ce(pi))
-				continue;
+	unsigned sc_start, sc_end, tc_start, tc_end;
 
-			/* check if its still there */
-			nfct_get_conntrack_x(priv->cth, &ct->tuple, NFCT_DIR_ORIGINAL,
-								 &ct->last_seq);
+	sc_start = priv->scache->c_curr_head;
+	tc_start = priv->tcache->c_curr_head;
 
-			if (&ct->last_seq != 0) {
-				ct->t_req = t_now;
+	scache_cleanup(pi);
+	tcache_cleanup(pi);
 
-				assert(scache_find(pi, ct->last_seq) == NULL);
-
-				cache_add(priv->scache, ct);
-			}
-
-			if (++req > SCACHE_REQ_MAX)
-				break;
-		}
-
-		ht->c_curr_head = (ht->c_curr_head + 1) % ht->c_num_heads;
-
-		if (req > SCACHE_REQ_MAX)
-			break;
-	} while (ht->c_curr_head != end);
+	sc_end = priv->scache->c_curr_head;
+	tc_end = priv->tcache->c_curr_head;
 
-	ulogd_log(ULOGD_DEBUG, "%s: ct:%u t:%u s:%u\n", pi->id,
-			  num_conntrack, priv->tcache->c_cnt, priv->scache->c_cnt);
+	ulogd_log(ULOGD_DEBUG, "%s: ct=%u t=%u [%u,%u[ s=%u [%u,%u[\n",
+			  pi->id, num_conntrack,
+			  priv->tcache->c_cnt, tc_start, tc_end,
+			  priv->scache->c_cnt, sc_start, sc_end);
 }
 
 static int

-- 
