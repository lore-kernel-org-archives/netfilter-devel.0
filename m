From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH 1/2] ipt_hashlimit.c: use hashlist (hlist_head) instead of
 list_head
Date: Thu, 17 Feb 2005 00:17:04 -0500
Message-ID: <421428D0.8020907@cookinglinux.org>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060009080403090902090305"
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
--------------060009080403090902090305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Name: use hashlist (hlist_head) instead of list_head
Status: Tested on Linux 2.6.10.
          Patch against 2.6.11-rc4-bk2
          Incremental to Harald's semaphore locking patch
Signed-off-by: Samuel Jean <sjean@cookinglinux.org>

A bucket is 8 bytes when using list_head's list. This is not really necessary
as we never use function requiering to access the tail in O(1).

By using hlist_head, we made a bucket down to 4 bytes. Quite a signifiant size
when one uses 2^20 buckets. (yes, there is...)

The root list doesn't need list_head too.

This patch just replaces list_head with hlist_head/node.

NOTE: I dropped listhelp.h as rusty mentioned he was going to
get rid of, someday.

Patch is inlined and attached as I'm dumb and dunno how to inline the attachement.

--- a/net/ipv4/netfilter/ipt_hashlimit.c        2005-02-14 21:21:49.000000000 -0500
+++ b/net/ipv4/netfilter/ipt_hashlimit.c        2005-02-16 23:19:19.000000000 -0500
@@ -33,11 +33,7 @@
   #include <linux/sctp.h>
   #include <linux/proc_fs.h>
   #include <linux/seq_file.h>
-
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-#include <linux/netfilter_ipv4/lockhelp.h>
-#include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/list.h>

   #include <linux/netfilter_ipv4/ip_tables.h>
   #include <linux/netfilter_ipv4/ipt_hashlimit.h>
@@ -67,7 +63,7 @@ struct dsthash_dst {

   struct dsthash_ent {
          /* static / read-only parts in the beginning */
-       struct list_head list;
+       struct hlist_node node;
          struct dsthash_dst dst;

          /* modified structure members in the end */
@@ -80,7 +76,7 @@ struct dsthash_ent {
   };

   struct ipt_hashlimit_htable {
-       struct list_head list;          /* global list of all htables */
+       struct hlist_node node;         /* global list of all htables */
          atomic_t use;

          struct hashlimit_cfg cfg;       /* config */
@@ -94,12 +90,12 @@ struct ipt_hashlimit_htable {
          /* seq_file stuff */
          struct proc_dir_entry *pde;

-       struct list_head hash[0];       /* hashtable itself */
+       struct hlist_head hash[0];      /* hashtable itself */
   };

   static DECLARE_LOCK(hashlimit_lock);   /* protects htables list */
   static DECLARE_MUTEX(hlimit_mutex);    /* additional checkentry protection */
-static LIST_HEAD(hashlimit_htables);
+static HLIST_HEAD(hashlimit_htables);
   static kmem_cache_t *hashlimit_cachep;

   static inline int dst_cmp(const struct dsthash_ent *ent, struct dsthash_dst *b)
@@ -120,9 +116,17 @@ hash_dst(const struct ipt_hashlimit_htab
   static inline struct dsthash_ent *
   __dsthash_find(const struct ipt_hashlimit_htable *ht, struct dsthash_dst *dst)
   {
-       struct dsthash_ent *ent;
+       struct dsthash_ent *ent = NULL;
+       struct hlist_node *pos;
          u_int32_t hash = hash_dst(ht, dst);
-       ent = LIST_FIND(&ht->hash[hash], dst_cmp, struct dsthash_ent *, dst);
+
+       if (!hlist_empty(&ht->hash[hash]))
+               hlist_for_each_entry(ent, pos, &ht->hash[hash], node) {
+                       if (dst_cmp(ent, dst)) {
+                               break;
+                       }
+               }
+
          return ent;
   }

@@ -162,7 +166,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
          ent->dst.src_ip = dst->src_ip;
          ent->dst.src_port = dst->src_port;

-       list_add(&ent->list, &ht->hash[hash_dst(ht, dst)]);
+       hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);

          return ent;
   }
@@ -170,7 +174,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
   static inline void
   __dsthash_free(struct ipt_hashlimit_htable *ht, struct dsthash_ent *ent)
   {
-       list_del(&ent->list);
+       hlist_del(&ent->node);
          kmem_cache_free(hashlimit_cachep, ent);
          atomic_dec(&ht->count);
   }
@@ -210,7 +214,7 @@ static int htable_create(struct ipt_hash
                  hinfo->cfg.max = hinfo->cfg.size;

          for (i = 0; i < hinfo->cfg.size; i++)
-               INIT_LIST_HEAD(&hinfo->hash[i]);
+               INIT_HLIST_HEAD(&hinfo->hash[i]);

          atomic_set(&hinfo->count, 0);
          atomic_set(&hinfo->use, 1);
@@ -231,7 +235,7 @@ static int htable_create(struct ipt_hash
          add_timer(&hinfo->timer);

          LOCK_BH(&hashlimit_lock);
-       list_add(&hinfo->list, &hashlimit_htables);
+       hlist_add_head(&hinfo->node, &hashlimit_htables);
          UNLOCK_BH(&hashlimit_lock);

          return 0;
@@ -258,8 +262,9 @@ static void htable_selective_cleanup(str
          /* lock hash table and iterate over it */
          spin_lock_bh(&ht->lock);
          for (i = 0; i < ht->cfg.size; i++) {
-               struct dsthash_ent *dh, *n;
-               list_for_each_entry_safe(dh, n, &ht->hash[i], list) {
+               struct dsthash_ent *dh;
+               struct hlist_node *pos, *n;
+               hlist_for_each_entry_safe(dh, pos, n, &ht->hash[i], node) {
                          if ((*select)(ht, dh))
                                  __dsthash_free(ht, dh);
                  }
@@ -295,9 +300,10 @@ static void htable_destroy(struct ipt_ha
   static struct ipt_hashlimit_htable *htable_find_get(char *name)
   {
          struct ipt_hashlimit_htable *hinfo;
+       struct hlist_node *pos;

          LOCK_BH(&hashlimit_lock);
-       list_for_each_entry(hinfo, &hashlimit_htables, list) {
+       hlist_for_each_entry(hinfo, pos, &hashlimit_htables, node) {
                  if (!strcmp(name, hinfo->pde->name)) {
                          atomic_inc(&hinfo->use);
                          UNLOCK_BH(&hashlimit_lock);
@@ -313,7 +319,7 @@ static void htable_put(struct ipt_hashli
   {
          if (atomic_dec_and_test(&hinfo->use)) {
                  LOCK_BH(&hashlimit_lock);
-               list_del(&hinfo->list);
+               hlist_del(&hinfo->node);
                  UNLOCK_BH(&hashlimit_lock);
                  htable_destroy(hinfo);
          }
@@ -631,12 +637,17 @@ static int dl_seq_show(struct seq_file *
          struct proc_dir_entry *pde = s->private;
          struct ipt_hashlimit_htable *htable = pde->data;
          unsigned int *bucket = (unsigned int *)v;
+       struct dsthash_ent *ent;
+       struct hlist_node *pos;

-       if (LIST_FIND_W(&htable->hash[*bucket], dl_seq_real_show,
-                     struct dsthash_ent *, s)) {
-               /* buffer was filled and unable to print that tuple */
-               return 1;
-       }
+       if (!hlist_empty(&htable->hash[*bucket]))
+               hlist_for_each_entry(ent, pos, &htable->hash[*bucket], node) {
+                       if (dl_seq_real_show(ent, s)) {
+                               /* buffer was filled and unable to print that tuple */
+                               return 1;
+                       }
+               }
+
          return 0;
   }




--------------060009080403090902090305
Content-Type: text/x-patch;
	name="linux-2.6.11-rc4-bk2-hashlimit_hlist-based.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="linux-2.6.11-rc4-bk2-hashlimit_hlist-based.patch"

--- a/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-14 21:21:49.000000000 -0500
+++ b/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-16 23:19:19.000000000 -0500
@@ -33,11 +33,7 @@
 #include <linux/sctp.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-
-#define ASSERT_READ_LOCK(x) 
-#define ASSERT_WRITE_LOCK(x) 
-#include <linux/netfilter_ipv4/lockhelp.h>
-#include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/list.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_hashlimit.h>
@@ -67,7 +63,7 @@ struct dsthash_dst {
 
 struct dsthash_ent {
 	/* static / read-only parts in the beginning */
-	struct list_head list;
+	struct hlist_node node;
 	struct dsthash_dst dst;
 
 	/* modified structure members in the end */
@@ -80,7 +76,7 @@ struct dsthash_ent {
 };
 
 struct ipt_hashlimit_htable {
-	struct list_head list;		/* global list of all htables */
+	struct hlist_node node;		/* global list of all htables */
 	atomic_t use;
 
 	struct hashlimit_cfg cfg;	/* config */
@@ -94,12 +90,12 @@ struct ipt_hashlimit_htable {
 	/* seq_file stuff */
 	struct proc_dir_entry *pde;
 
-	struct list_head hash[0];	/* hashtable itself */
+	struct hlist_head hash[0];	/* hashtable itself */
 };
 
 static DECLARE_LOCK(hashlimit_lock);	/* protects htables list */
 static DECLARE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
-static LIST_HEAD(hashlimit_htables);
+static HLIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
 
 static inline int dst_cmp(const struct dsthash_ent *ent, struct dsthash_dst *b)
@@ -120,9 +116,17 @@ hash_dst(const struct ipt_hashlimit_htab
 static inline struct dsthash_ent *
 __dsthash_find(const struct ipt_hashlimit_htable *ht, struct dsthash_dst *dst)
 {
-	struct dsthash_ent *ent;
+	struct dsthash_ent *ent = NULL;
+	struct hlist_node *pos;
 	u_int32_t hash = hash_dst(ht, dst);
-	ent = LIST_FIND(&ht->hash[hash], dst_cmp, struct dsthash_ent *, dst);
+
+	if (!hlist_empty(&ht->hash[hash]))
+		hlist_for_each_entry(ent, pos, &ht->hash[hash], node) {
+			if (dst_cmp(ent, dst)) {
+				break;
+			}
+		}
+	
 	return ent;
 }
 
@@ -162,7 +166,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
 	ent->dst.src_ip = dst->src_ip;
 	ent->dst.src_port = dst->src_port;
 
-	list_add(&ent->list, &ht->hash[hash_dst(ht, dst)]);
+	hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);
 
 	return ent;
 }
@@ -170,7 +174,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
 static inline void 
 __dsthash_free(struct ipt_hashlimit_htable *ht, struct dsthash_ent *ent)
 {
-	list_del(&ent->list);
+	hlist_del(&ent->node);
 	kmem_cache_free(hashlimit_cachep, ent);
 	atomic_dec(&ht->count);
 }
@@ -210,7 +214,7 @@ static int htable_create(struct ipt_hash
 		hinfo->cfg.max = hinfo->cfg.size;
 
 	for (i = 0; i < hinfo->cfg.size; i++)
-		INIT_LIST_HEAD(&hinfo->hash[i]);
+		INIT_HLIST_HEAD(&hinfo->hash[i]);
 
 	atomic_set(&hinfo->count, 0);
 	atomic_set(&hinfo->use, 1);
@@ -231,7 +235,7 @@ static int htable_create(struct ipt_hash
 	add_timer(&hinfo->timer);
 
 	LOCK_BH(&hashlimit_lock);
-	list_add(&hinfo->list, &hashlimit_htables);
+	hlist_add_head(&hinfo->node, &hashlimit_htables);
 	UNLOCK_BH(&hashlimit_lock);
 
 	return 0;
@@ -258,8 +262,9 @@ static void htable_selective_cleanup(str
 	/* lock hash table and iterate over it */
 	spin_lock_bh(&ht->lock);
 	for (i = 0; i < ht->cfg.size; i++) {
-		struct dsthash_ent *dh, *n;
-		list_for_each_entry_safe(dh, n, &ht->hash[i], list) {
+		struct dsthash_ent *dh;
+		struct hlist_node *pos, *n;
+		hlist_for_each_entry_safe(dh, pos, n, &ht->hash[i], node) {
 			if ((*select)(ht, dh))
 				__dsthash_free(ht, dh);
 		}
@@ -295,9 +300,10 @@ static void htable_destroy(struct ipt_ha
 static struct ipt_hashlimit_htable *htable_find_get(char *name)
 {
 	struct ipt_hashlimit_htable *hinfo;
+	struct hlist_node *pos;
 
 	LOCK_BH(&hashlimit_lock);
-	list_for_each_entry(hinfo, &hashlimit_htables, list) {
+	hlist_for_each_entry(hinfo, pos, &hashlimit_htables, node) {
 		if (!strcmp(name, hinfo->pde->name)) {
 			atomic_inc(&hinfo->use);
 			UNLOCK_BH(&hashlimit_lock);
@@ -313,7 +319,7 @@ static void htable_put(struct ipt_hashli
 {
 	if (atomic_dec_and_test(&hinfo->use)) {
 		LOCK_BH(&hashlimit_lock);
-		list_del(&hinfo->list);
+		hlist_del(&hinfo->node);
 		UNLOCK_BH(&hashlimit_lock);
 		htable_destroy(hinfo);
 	}
@@ -631,12 +637,17 @@ static int dl_seq_show(struct seq_file *
 	struct proc_dir_entry *pde = s->private;
 	struct ipt_hashlimit_htable *htable = pde->data;
 	unsigned int *bucket = (unsigned int *)v;
+	struct dsthash_ent *ent;
+	struct hlist_node *pos;
 
-	if (LIST_FIND_W(&htable->hash[*bucket], dl_seq_real_show,
-		      struct dsthash_ent *, s)) {
-		/* buffer was filled and unable to print that tuple */
-		return 1;
-	}
+	if (!hlist_empty(&htable->hash[*bucket]))
+		hlist_for_each_entry(ent, pos, &htable->hash[*bucket], node) {
+			if (dl_seq_real_show(ent, s)) {
+				/* buffer was filled and unable to print that tuple */
+				return 1;
+			}
+		}
+	
 	return 0;
 }
 


--------------060009080403090902090305--
