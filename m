From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH 2/2] ipt_hashlimit.c: hash only once
Date: Thu, 17 Feb 2005 00:17:38 -0500
Message-ID: <421428F2.4030404@cookinglinux.org>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010708080901070705010104"
Cc: netfilter-devel@lists.netfilter.org
To: Harald Welte <laforge@netfilter.org>
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

This is a multi-part message in MIME format.
--------------010708080901070705010104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Name: hash only once
Status: Tested on Linux 2.6.10.
          Patch against 2.6.11-rc4-bk2
          Incremental to previous hlist_head patch [1/2]
Signed-off-by: Samuel Jean <sjean@cookinglinux.org>

Harald: this patch might be crap.

I couldn't find the reason on why we initialize random seed only on first entry.
Making this obviously mean we hash to find the bucket. If entry's not in there,
we add it. To do so, we need to hash again, because we maybe initialized the seed.

This patch move the seed initializing at hashtable creation. So we can hash only
once to find and create.

Please review and comment. Thanks!

Patch is inlined and attached as I'm dumb and dunno how to inline the attachement.

--- a/net/ipv4/netfilter/ipt_hashlimit.c        2005-02-16 23:31:50.000000000 -0500
+++ b/net/ipv4/netfilter/ipt_hashlimit.c        2005-02-16 23:49:46.000000000 -0500
@@ -114,11 +114,12 @@ hash_dst(const struct ipt_hashlimit_htab
   }

   static inline struct dsthash_ent *
-__dsthash_find(const struct ipt_hashlimit_htable *ht, struct dsthash_dst *dst)
+__dsthash_find(const struct ipt_hashlimit_htable *ht,
+               struct dsthash_dst *dst,
+               u_int32_t hash)
   {
          struct dsthash_ent *ent = NULL;
          struct hlist_node *pos;
-       u_int32_t hash = hash_dst(ht, dst);

          if (!hlist_empty(&ht->hash[hash]))
                  hlist_for_each_entry(ent, pos, &ht->hash[hash], node) {
@@ -132,14 +133,12 @@ __dsthash_find(const struct ipt_hashlimi

   /* allocate dsthash_ent, initialize dst, put in htable and lock it */
   static struct dsthash_ent *
-__dsthash_alloc_init(struct ipt_hashlimit_htable *ht, struct dsthash_dst *dst)
+__dsthash_alloc_init(struct ipt_hashlimit_htable *ht,
+               struct dsthash_dst *dst,
+               u_int32_t hash)
   {
          struct dsthash_ent *ent;

-       /* initialize hash with random val at the time we allocate
-        * the first hashtable entry */
-       if (!ht->rnd)
-               get_random_bytes(&ht->rnd, 4);

          if (ht->cfg.max &&
              atomic_read(&ht->count) >= ht->cfg.max) {
@@ -166,7 +165,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
          ent->dst.src_ip = dst->src_ip;
          ent->dst.src_port = dst->src_port;

-       hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);
+       hlist_add_head(&ent->node, &ht->hash[hash]);

          return ent;
   }
@@ -234,6 +233,8 @@ static int htable_create(struct ipt_hash
          hinfo->timer.function = htable_gc;
          add_timer(&hinfo->timer);

+       get_random_bytes(&hinfo->rnd, 4);
+
          LOCK_BH(&hashlimit_lock);
          hlist_add_head(&hinfo->node, &hashlimit_htables);
          UNLOCK_BH(&hashlimit_lock);
@@ -439,6 +440,7 @@ hashlimit_match(const struct sk_buff *sk
          unsigned long now = jiffies;
          struct dsthash_ent *dh;
          struct dsthash_dst dst;
+       u_int32_t hash;

          /* build 'dst' according to hinfo->cfg and current packet */
          memset(&dst, 0, sizeof(dst));
@@ -461,10 +463,12 @@ hashlimit_match(const struct sk_buff *sk
                          dst.dst_port = ports[1];
          }

+       hash = hash_dst(hinfo, &dst);
+
          spin_lock_bh(&hinfo->lock);
-       dh = __dsthash_find(hinfo, &dst);
+       dh = __dsthash_find(hinfo, &dst, hash);
          if (!dh) {
-               dh = __dsthash_alloc_init(hinfo, &dst);
+               dh = __dsthash_alloc_init(hinfo, &dst, hash);

                  if (!dh) {
                          /* enomem... don't match == DROP */



--------------010708080901070705010104
Content-Type: text/x-patch;
	name="linux-2.6.11-rc4-bk2-incremental_hash-once.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="linux-2.6.11-rc4-bk2-incremental_hash-once.patch"

--- a/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-16 23:31:50.000000000 -0500
+++ b/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-16 23:49:46.000000000 -0500
@@ -114,11 +114,12 @@ hash_dst(const struct ipt_hashlimit_htab
 }
 
 static inline struct dsthash_ent *
-__dsthash_find(const struct ipt_hashlimit_htable *ht, struct dsthash_dst *dst)
+__dsthash_find(const struct ipt_hashlimit_htable *ht,
+		struct dsthash_dst *dst,
+		u_int32_t hash)
 {
 	struct dsthash_ent *ent = NULL;
 	struct hlist_node *pos;
-	u_int32_t hash = hash_dst(ht, dst);
 
 	if (!hlist_empty(&ht->hash[hash]))
 		hlist_for_each_entry(ent, pos, &ht->hash[hash], node) {
@@ -132,14 +133,12 @@ __dsthash_find(const struct ipt_hashlimi
 
 /* allocate dsthash_ent, initialize dst, put in htable and lock it */
 static struct dsthash_ent *
-__dsthash_alloc_init(struct ipt_hashlimit_htable *ht, struct dsthash_dst *dst)
+__dsthash_alloc_init(struct ipt_hashlimit_htable *ht,
+		struct dsthash_dst *dst,
+		u_int32_t hash)
 {
 	struct dsthash_ent *ent;
 
-	/* initialize hash with random val at the time we allocate
-	 * the first hashtable entry */
-	if (!ht->rnd)
-		get_random_bytes(&ht->rnd, 4);
 
 	if (ht->cfg.max &&
 	    atomic_read(&ht->count) >= ht->cfg.max) {
@@ -166,7 +165,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
 	ent->dst.src_ip = dst->src_ip;
 	ent->dst.src_port = dst->src_port;
 
-	hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);
+	hlist_add_head(&ent->node, &ht->hash[hash]);
 
 	return ent;
 }
@@ -234,6 +233,8 @@ static int htable_create(struct ipt_hash
 	hinfo->timer.function = htable_gc;
 	add_timer(&hinfo->timer);
 
+	get_random_bytes(&hinfo->rnd, 4);
+
 	LOCK_BH(&hashlimit_lock);
 	hlist_add_head(&hinfo->node, &hashlimit_htables);
 	UNLOCK_BH(&hashlimit_lock);
@@ -439,6 +440,7 @@ hashlimit_match(const struct sk_buff *sk
 	unsigned long now = jiffies;
 	struct dsthash_ent *dh;
 	struct dsthash_dst dst;
+	u_int32_t hash;
 
 	/* build 'dst' according to hinfo->cfg and current packet */
 	memset(&dst, 0, sizeof(dst));
@@ -461,10 +463,12 @@ hashlimit_match(const struct sk_buff *sk
 			dst.dst_port = ports[1];
 	} 
 
+	hash = hash_dst(hinfo, &dst);
+	
 	spin_lock_bh(&hinfo->lock);
-	dh = __dsthash_find(hinfo, &dst);
+	dh = __dsthash_find(hinfo, &dst, hash);
 	if (!dh) {
-		dh = __dsthash_alloc_init(hinfo, &dst);
+		dh = __dsthash_alloc_init(hinfo, &dst, hash);
 
 		if (!dh) {
 			/* enomem... don't match == DROP */


--------------010708080901070705010104--
