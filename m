From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: [PATCH] ipt_hashlimit.c: avoid data corruption on checkentry
Date: Tue, 01 Feb 2005 23:14:18 -0500
Message-ID: <4200539A.6000408@cookinglinux.org>
References: <42005218.5000401@cookinglinux.org>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020103020609030906020906"
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42005218.5000401@cookinglinux.org>
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
--------------020103020609030906020906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Samuel Jean wrote:
> --- net/ipv4/netfilter/ipt_hashlimit.c.bk10     2005-02-01 
> 20:41:33.000000000 -0500
> +++ net/ipv4/netfilter/ipt_hashlimit.c  2005-02-01 22:49:48.000000000 -0500
> @@ -97,7 +97,7 @@ struct ipt_hashlimit_htable {
>         struct list_head hash[0];       /* hashtable itself */
>  };
> 
> -static DECLARE_RWLOCK(hashlimit_lock); /* protects htables list */
> +static DECLARE_LOCK(hashlimit_lock);   /* protects htables list */
>  static LIST_HEAD(hashlimit_htables);
>  static kmem_cache_t *hashlimit_cachep;
> 
> @@ -174,12 +174,17 @@ __dsthash_free(struct ipt_hashlimit_htab
>         atomic_dec(&ht->count);
>  }
>  static void htable_gc(unsigned long htlong);
> -
> -static int htable_create(struct ipt_hashlimit_info *minfo)
> +static struct ipt_hashlimit_htable *htable_find_get(char *name);

> +static void htable_put(struct ipt_hashlimit_htable *hinfo);
Please remove this ^^
or get the attached patch. Sorry, bad code review..

--------------020103020609030906020906
Content-Type: text/x-patch; name="ipt_hashlimit.c-avoid-data-corruption.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ipt_hashlimit.c-avoid-data-corruption.patch"

--- net/ipv4/netfilter/ipt_hashlimit.c.bk10	2005-02-01 20:41:33.000000000 -0500
+++ net/ipv4/netfilter/ipt_hashlimit.c	2005-02-01 23:12:02.000000000 -0500
@@ -97,7 +97,7 @@ struct ipt_hashlimit_htable {
 	struct list_head hash[0];	/* hashtable itself */
 };
 
-static DECLARE_RWLOCK(hashlimit_lock);	/* protects htables list */
+static DECLARE_LOCK(hashlimit_lock);	/* protects htables list */
 static LIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
 
@@ -174,12 +174,16 @@ __dsthash_free(struct ipt_hashlimit_htab
 	atomic_dec(&ht->count);
 }
 static void htable_gc(unsigned long htlong);
-
-static int htable_create(struct ipt_hashlimit_info *minfo)
+static struct ipt_hashlimit_htable *htable_find_get(char *name);
+	
+static struct ipt_hashlimit_htable *
+htable_create(struct ipt_hashlimit_info *minfo)
 {
 	int i;
 	unsigned int size;
-	struct ipt_hashlimit_htable *hinfo;
+	struct ipt_hashlimit_htable *hinfo, *s_hinfo;
+
+	MUST_BE_UNLOCKED(&hashlimit_lock);
 
 	if (minfo->cfg.size)
 		size = minfo->cfg.size;
@@ -196,9 +200,8 @@ static int htable_create(struct ipt_hash
 			+ (sizeof(struct list_head) * size));
 	if (!hinfo) {
 		printk(KERN_ERR "ipt_hashlimit: Unable to create hashtable\n");
-		return -1;
+		return NULL;
 	}
-	minfo->hinfo = hinfo;
 
 	/* copy match config into hashtable config */
 	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
@@ -215,10 +218,12 @@ static int htable_create(struct ipt_hash
 	atomic_set(&hinfo->use, 1);
 	hinfo->rnd = 0;
 	spin_lock_init(&hinfo->lock);
+
+	/* FIXME: This could lead to duplicated proc entries, no ? --peejix */
 	hinfo->pde = create_proc_entry(minfo->name, 0, hashlimit_procdir);
 	if (!hinfo->pde) {
 		vfree(hinfo);
-		return -1;
+		return NULL;
 	}
 	hinfo->pde->proc_fops = &dl_file_ops;
 	hinfo->pde->data = hinfo;
@@ -229,11 +234,22 @@ static int htable_create(struct ipt_hash
 	hinfo->timer.function = htable_gc;
 	add_timer(&hinfo->timer);
 
-	WRITE_LOCK(&hashlimit_lock);
+	LOCK_BH(&hashlimit_lock);
+	if ((s_hinfo = htable_find_get(minfo->name))) {
+		/* avoid data corruption */
+		UNLOCK_BH(&hashlimit_lock);
+		remove_proc_entry(minfo->name, hashlimit_procdir);
+		if (timer_pending(&hinfo->timer))
+			del_timer(&hinfo->timer);
+		
+		vfree(hinfo);
+		return s_hinfo;
+	}
+	
 	list_add(&hinfo->list, &hashlimit_htables);
-	WRITE_UNLOCK(&hashlimit_lock);
+	UNLOCK_BH(&hashlimit_lock);
 
-	return 0;
+	return hinfo;
 }
 
 static int select_all(struct ipt_hashlimit_htable *ht, struct dsthash_ent *he)
@@ -295,15 +311,14 @@ static struct ipt_hashlimit_htable *htab
 {
 	struct ipt_hashlimit_htable *hinfo;
 
-	READ_LOCK(&hashlimit_lock);
+	MUST_BE_LOCKED(&hashlimit_lock);
+	
 	list_for_each_entry(hinfo, &hashlimit_htables, list) {
 		if (!strcmp(name, hinfo->pde->name)) {
 			atomic_inc(&hinfo->use);
-			READ_UNLOCK(&hashlimit_lock);
 			return hinfo;
 		}
 	}
-	READ_UNLOCK(&hashlimit_lock);
 
 	return NULL;
 }
@@ -311,9 +326,9 @@ static struct ipt_hashlimit_htable *htab
 static void htable_put(struct ipt_hashlimit_htable *hinfo)
 {
 	if (atomic_dec_and_test(&hinfo->use)) {
-		WRITE_LOCK(&hashlimit_lock);
+		LOCK_BH(&hashlimit_lock);
 		list_del(&hinfo->list);
-		WRITE_UNLOCK(&hashlimit_lock);
+		UNLOCK_BH(&hashlimit_lock);
 		htable_destroy(hinfo);
 	}
 }
@@ -531,8 +546,11 @@ hashlimit_checkentry(const char *tablena
 	if (!r->cfg.expire)
 		return 0;
 
+	LOCK_BH(&hashlimit_lock);
 	r->hinfo = htable_find_get(r->name);
-	if (!r->hinfo && (htable_create(r) != 0)) {
+	UNLOCK_BH(&hashlimit_lock);
+	
+	if (!r->hinfo && ((r->hinfo = htable_create(r)) == NULL)) {
 		return 0;
 	}
 

--------------020103020609030906020906--
