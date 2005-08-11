From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK] {alloc,free}_conntrack to ip_conntrack style
Date: Thu, 11 Aug 2005 18:14:41 +0900 (JST)
Message-ID: <200508110914.j7B9EfDp025206@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Aug_11_18_14_41_2005_571)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Aug_11_18_14_41_2005_571)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

This patch moves initialization of conntrack in init_conntrack() to
alloc_conntrack(), renames {alloc,free}_conntrack() to
nf_conntrack_{alloc,free}(), and moves them to just before init_conntrack(),
like ip_conntrack.

Please apply to nf_conntrack tree.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Aug_11_18_14_41_2005_571)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="alloc.patch"

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilter/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -210,6 +210,10 @@ extern int nf_ct_no_defrag;
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
 nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data);
+extern void nf_conntrack_free(struct nf_conn *ct);
+extern struct nf_conn *
+nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
+		   const struct nf_conntrack_tuple *repl);
 
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int nf_ct_is_confirmed(struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -215,51 +215,6 @@ hash_conntrack(const struct nf_conntrack
 	       % nf_conntrack_htable_size;
 }
 
-struct nf_conn *
-alloc_conntrack(u_int32_t features)
-{
-	struct nf_conn *conntrack = NULL;
-
-	DEBUGP("alloc_conntrack: features=0x%x\n", features);
-
-	read_lock_bh(&nf_ct_cache_lock);
-
-	if (!nf_ct_cache[features].use) {
-		DEBUGP("alloc_conntrack: not supported features = 0x%x\n",
-			features);
-		goto out;
-	}
-
-	conntrack = kmem_cache_alloc(nf_ct_cache[features].cachep, GFP_ATOMIC);
-	if (conntrack == NULL) {
-		DEBUGP("alloc_conntrack: Can't alloc conntrack from cache\n");
-		goto out;
-	}
-	memset(conntrack, 0, nf_ct_cache[features].size);
-	conntrack->features = features;
-	if (nf_ct_cache[features].init_conntrack &&
-	    nf_ct_cache[features].init_conntrack(conntrack, features) < 0) {
-		DEBUGP("alloc_conntrack: failed to init\n");
-		kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
-		conntrack = NULL;
-		goto out;
-	}
-
-out:
-	read_unlock_bh(&nf_ct_cache_lock);
-	return conntrack;
-}
-
-void
-free_conntrack(struct nf_conn *conntrack)
-{
-	u_int32_t features = conntrack->features;
-	NF_CT_ASSERT(features >= NF_CT_F_BASIC && features < NF_CT_F_NUM);
-	DEBUGP("free_conntrack: features = 0x%x, conntrack=%p\n", features,
-	       conntrack);
-	kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
-}
-
 /* Initialize "struct nf_conn" which has spaces for helper */
 static int
 init_conntrack_for_helper(struct nf_conn *conntrack, u_int32_t features)
@@ -555,8 +510,7 @@ destroy_conntrack(struct nf_conntrack *n
 		nf_ct_put(ct->master);
 
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
-	free_conntrack(ct);
-	atomic_dec(&nf_conntrack_count);
+	nf_conntrack_free(ct);
 }
 
 static void death_by_timeout(unsigned long ul_conntrack)
@@ -758,31 +712,22 @@ nf_ct_find_helper(const struct nf_conntr
 			 tuple);
 }
 
-/* Allocate a new conntrack: we return -ENOMEM if classification
-   failed due to stress.  Otherwise it really is unclassifiable. */
-static struct nf_conntrack_tuple_hash *
-init_conntrack(const struct nf_conntrack_tuple *tuple,
-	       struct nf_conntrack_l3proto *l3proto,
-	       struct nf_conntrack_protocol *protocol,
-	       struct sk_buff *skb,
-	       unsigned int dataoff)
+static struct nf_conn *
+__nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
+		     const struct nf_conntrack_tuple *repl,
+		     const struct nf_conntrack_l3proto *l3proto)
 {
-	struct nf_conn *conntrack;
-	struct nf_conntrack_tuple repl_tuple;
-	size_t hash;
-	struct nf_conntrack_expect *exp;
+	struct nf_conn *conntrack = NULL;
 	u_int32_t features = 0;
-	int helper_used = 0;
 
 	if (!nf_conntrack_hash_rnd_initted) {
 		get_random_bytes(&nf_conntrack_hash_rnd, 4);
 		nf_conntrack_hash_rnd_initted = 1;
 	}
 
-	hash = hash_conntrack(tuple);
-
 	if (nf_conntrack_max
 	    && atomic_read(&nf_conntrack_count) >= nf_conntrack_max) {
+		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
 		if (!early_drop(&nf_conntrack_hash[hash])) {
 			if (net_ratelimit())
@@ -793,40 +738,103 @@ init_conntrack(const struct nf_conntrack
 		}
 	}
 
-	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, protocol)) {
-		DEBUGP("Can't invert tuple.\n");
-		return NULL;
-	}
-
 	/*  find features needed by this conntrack. */
-	features = l3proto->get_features(tuple);
+	features = l3proto->get_features(orig);
 	read_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_find_helper(&repl_tuple) != NULL) {
+	if (nf_ct_find_helper(repl) != NULL)
 		features |= NF_CT_F_HELP;
-		helper_used = 1;
-	}
 	read_unlock_bh(&nf_conntrack_lock);
 
-	conntrack = alloc_conntrack(features);
-	if (!conntrack) {
-		DEBUGP("Can't allocate conntrack.\n");
-		return ERR_PTR(-ENOMEM);
+	DEBUGP("nf_conntrack_alloc: features=0x%x\n", features);
+
+	read_lock_bh(&nf_ct_cache_lock);
+
+	if (!nf_ct_cache[features].use) {
+		DEBUGP("nf_conntrack_alloc: not supported features = 0x%x\n",
+			features);
+		goto out;
+	}
+
+	conntrack = kmem_cache_alloc(nf_ct_cache[features].cachep, GFP_ATOMIC);
+	if (conntrack == NULL) {
+		DEBUGP("nf_conntrack_alloc: Can't alloc conntrack from cache\n");
+		goto out;
+	}
+
+	memset(conntrack, 0, nf_ct_cache[features].size);
+	conntrack->features = features;
+	if (nf_ct_cache[features].init_conntrack &&
+	    nf_ct_cache[features].init_conntrack(conntrack, features) < 0) {
+		DEBUGP("nf_conntrack_alloc: failed to init\n");
+		kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
+		conntrack = NULL;
+		goto out;
 	}
 
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *tuple;
-	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = repl_tuple;
-	if (!protocol->new(conntrack, skb, dataoff)) {
-		free_conntrack(conntrack);
-		DEBUGP("init conntrack: can't track with proto module\n");
-		return NULL;
-	}
+	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
 	/* Don't set timer yet: wait for confirmation */
 	init_timer(&conntrack->timeout);
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
+	atomic_inc(&nf_conntrack_count);
+out:
+	read_unlock_bh(&nf_ct_cache_lock);
+	return conntrack;
+}
+
+struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
+				   const struct nf_conntrack_tuple *repl)
+{
+	struct nf_conntrack_l3proto *l3proto;
+
+	l3proto = nf_ct_find_l3proto(orig->src.l3num);
+	return __nf_conntrack_alloc(orig, repl, l3proto);
+}
+
+void nf_conntrack_free(struct nf_conn *conntrack)
+{
+	u_int32_t features = conntrack->features;
+	NF_CT_ASSERT(features >= NF_CT_F_BASIC && features < NF_CT_F_NUM);
+	DEBUGP("nf_conntrack_free: features = 0x%x, conntrack=%p\n", features,
+	       conntrack);
+	kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
+	atomic_dec(&nf_conntrack_count);
+}
+
+/* Allocate a new conntrack: we return -ENOMEM if classification
+   failed due to stress.  Otherwise it really is unclassifiable. */
+static struct nf_conntrack_tuple_hash *
+init_conntrack(const struct nf_conntrack_tuple *tuple,
+	       struct nf_conntrack_l3proto *l3proto,
+	       struct nf_conntrack_protocol *protocol,
+	       struct sk_buff *skb,
+	       unsigned int dataoff)
+{
+	struct nf_conn *conntrack;
+	struct nf_conntrack_tuple repl_tuple;
+	struct nf_conntrack_expect *exp;
+
+	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, protocol)) {
+		DEBUGP("Can't invert tuple.\n");
+		return NULL;
+	}
+
+	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto);
+	if (conntrack == NULL || IS_ERR(conntrack)) {
+		DEBUGP("Can't allocate conntrack.\n");
+		return (struct nf_conntrack_tuple_hash *)conntrack;
+	}
+
+	if (!protocol->new(conntrack, skb, dataoff)) {
+		nf_conntrack_free(conntrack);
+		DEBUGP("init conntrack: can't track with proto module\n");
+		return NULL;
+	}
+
 	write_lock_bh(&nf_conntrack_lock);
 	exp = find_expectation(tuple);
 
@@ -850,7 +858,6 @@ init_conntrack(const struct nf_conntrack
 	/* Overload tuple linked list to put us in unconfirmed list. */
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
 
-	atomic_inc(&nf_conntrack_count);
 	write_unlock_bh(&nf_conntrack_lock);
 
 	if (exp) {

----Next_Part(Thu_Aug_11_18_14_41_2005_571)----
