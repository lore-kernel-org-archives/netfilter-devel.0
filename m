From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] ipt_hashlimit updates
Date: Tue, 22 Feb 2005 12:49:00 +0100
Message-ID: <20050222114900.GO29256@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q5Q2TEEGbX9oWZOX"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--Q5Q2TEEGbX9oWZOX
Content-Type: multipart/mixed; boundary="ULkDCyeHsmlwbqED"
Content-Disposition: inline


--ULkDCyeHsmlwbqED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

here are three incremental patches to ipt_hashlimit. =20

The first one is a bugfix, and should go in before 2.6.11 is released.

The other two are optimizations that can wait for 2.6.12.  If you'd
like, I can resubmit them at a later point.

Please apply,
	thanks.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ULkDCyeHsmlwbqED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="linux-2.6.11-rc4-hashlimit_checkentry_race.patch"
Content-Transfer-Encoding: quoted-printable

[PATCH] ipt_hashlimit rule load time race condition

This is the best we've got: We cannot release and re-grab lock,
since checkentry() is called before ip_tables.c grabs ipt_mutex. =20
We also cannot grab the hashtable spinlock, since htable_create will=20
call vmalloc, and that can sleep.  And we cannot just re-search
the list of htable's in htable_create(), since then we would
create duplicate proc files.

Signed-off-by: Harald Welte <laforge@netfilter.org>

--- c/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-13 13:52:06.000000000 +0100
+++ d/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-15 01:49:39.086401888 +0100
@@ -98,6 +98,7 @@
 };
=20
 static DECLARE_RWLOCK(hashlimit_lock);	/* protects htables list */
+static DECLARE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
 static LIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
=20
@@ -531,10 +532,19 @@
 	if (!r->cfg.expire)
 		return 0;
=20
+	/* This is the best we've got: We cannot release and re-grab lock,
+	 * since checkentry() is called before ip_tables.c grabs ipt_mutex. =20
+	 * We also cannot grab the hashtable spinlock, since htable_create will=
=20
+	 * call vmalloc, and that can sleep.  And we cannot just re-search
+	 * the list of htable's in htable_create(), since then we would
+	 * create duplicate proc files. -HW */
+	down(&hlimit_mutex);
 	r->hinfo =3D htable_find_get(r->name);
 	if (!r->hinfo && (htable_create(r) !=3D 0)) {
+		up(&hlimit_mutex);
 		return 0;
 	}
+	up(&hlimit_mutex);
=20
 	/* Ugly hack: For SMP, we only want to use one set */
 	r->u.master =3D r;

--ULkDCyeHsmlwbqED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="linux-2.6.11-rc4-bk2-incremental_get_rid_rwlock.patch"
Content-Transfer-Encoding: quoted-printable

[PATCH] ipt_hashlimit: replace rwlock with spinlock

As Samuel points out, the rwlock doesn't really make much sense.

Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--- d/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-14 20:48:33.000000000 -0500
+++ e/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-14 21:00:07.000000000 -0500
@@ -97,7 +97,7 @@ struct ipt_hashlimit_htable {
 	struct list_head hash[0];	/* hashtable itself */
 };
=20
-static DECLARE_RWLOCK(hashlimit_lock);	/* protects htables list */
+static DECLARE_LOCK(hashlimit_lock);	/* protects htables list */
 static DECLARE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
 static LIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
@@ -230,9 +230,9 @@ static int htable_create(struct ipt_hash
 	hinfo->timer.function =3D htable_gc;
 	add_timer(&hinfo->timer);
=20
-	WRITE_LOCK(&hashlimit_lock);
+	LOCK_BH(&hashlimit_lock);
 	list_add(&hinfo->list, &hashlimit_htables);
-	WRITE_UNLOCK(&hashlimit_lock);
+	UNLOCK_BH(&hashlimit_lock);
=20
 	return 0;
 }
@@ -296,15 +296,15 @@ static struct ipt_hashlimit_htable *htab
 {
 	struct ipt_hashlimit_htable *hinfo;
=20
-	READ_LOCK(&hashlimit_lock);
+	LOCK_BH(&hashlimit_lock);
 	list_for_each_entry(hinfo, &hashlimit_htables, list) {
 		if (!strcmp(name, hinfo->pde->name)) {
 			atomic_inc(&hinfo->use);
-			READ_UNLOCK(&hashlimit_lock);
+			UNLOCK_BH(&hashlimit_lock);
 			return hinfo;
 		}
 	}
-	READ_UNLOCK(&hashlimit_lock);
+	UNLOCK_BH(&hashlimit_lock);
=20
 	return NULL;
 }
@@ -312,9 +312,9 @@ static struct ipt_hashlimit_htable *htab
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



--ULkDCyeHsmlwbqED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="linux-2.6.11-rc4-bk2-hashlimit_hlist-based.patch"
Content-Transfer-Encoding: quoted-printable

[PATCH] ipt_hashlimit: use hlist instead of list head

Use hlist instead of list_head to save lots of memory for the hash buckets.

Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--- a/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-14 21:21:49.000000000 -0500
+++ b/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-16 23:19:19.000000000 -0500
@@ -33,11 +33,7 @@
 #include <linux/sctp.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-
-#define ASSERT_READ_LOCK(x)=20
-#define ASSERT_WRITE_LOCK(x)=20
-#include <linux/netfilter_ipv4/lockhelp.h>
-#include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/list.h>
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_hashlimit.h>
@@ -67,7 +63,7 @@ struct dsthash_dst {
=20
 struct dsthash_ent {
 	/* static / read-only parts in the beginning */
-	struct list_head list;
+	struct hlist_node node;
 	struct dsthash_dst dst;
=20
 	/* modified structure members in the end */
@@ -80,7 +76,7 @@ struct dsthash_ent {
 };
=20
 struct ipt_hashlimit_htable {
-	struct list_head list;		/* global list of all htables */
+	struct hlist_node node;		/* global list of all htables */
 	atomic_t use;
=20
 	struct hashlimit_cfg cfg;	/* config */
@@ -94,12 +90,12 @@ struct ipt_hashlimit_htable {
 	/* seq_file stuff */
 	struct proc_dir_entry *pde;
=20
-	struct list_head hash[0];	/* hashtable itself */
+	struct hlist_head hash[0];	/* hashtable itself */
 };
=20
 static DECLARE_LOCK(hashlimit_lock);	/* protects htables list */
 static DECLARE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
-static LIST_HEAD(hashlimit_htables);
+static HLIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
=20
 static inline int dst_cmp(const struct dsthash_ent *ent, struct dsthash_ds=
t *b)
@@ -120,9 +116,17 @@ hash_dst(const struct ipt_hashlimit_htab
 static inline struct dsthash_ent *
 __dsthash_find(const struct ipt_hashlimit_htable *ht, struct dsthash_dst *=
dst)
 {
-	struct dsthash_ent *ent;
+	struct dsthash_ent *ent =3D NULL;
+	struct hlist_node *pos;
 	u_int32_t hash =3D hash_dst(ht, dst);
-	ent =3D LIST_FIND(&ht->hash[hash], dst_cmp, struct dsthash_ent *, dst);
+
+	if (!hlist_empty(&ht->hash[hash]))
+		hlist_for_each_entry(ent, pos, &ht->hash[hash], node) {
+			if (dst_cmp(ent, dst)) {
+				break;
+			}
+		}
+=09
 	return ent;
 }
=20
@@ -162,7 +166,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
 	ent->dst.src_ip =3D dst->src_ip;
 	ent->dst.src_port =3D dst->src_port;
=20
-	list_add(&ent->list, &ht->hash[hash_dst(ht, dst)]);
+	hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);
=20
 	return ent;
 }
@@ -170,7 +174,7 @@ __dsthash_alloc_init(struct ipt_hashlimi
 static inline void=20
 __dsthash_free(struct ipt_hashlimit_htable *ht, struct dsthash_ent *ent)
 {
-	list_del(&ent->list);
+	hlist_del(&ent->node);
 	kmem_cache_free(hashlimit_cachep, ent);
 	atomic_dec(&ht->count);
 }
@@ -210,7 +214,7 @@ static int htable_create(struct ipt_hash
 		hinfo->cfg.max =3D hinfo->cfg.size;
=20
 	for (i =3D 0; i < hinfo->cfg.size; i++)
-		INIT_LIST_HEAD(&hinfo->hash[i]);
+		INIT_HLIST_HEAD(&hinfo->hash[i]);
=20
 	atomic_set(&hinfo->count, 0);
 	atomic_set(&hinfo->use, 1);
@@ -231,7 +235,7 @@ static int htable_create(struct ipt_hash
 	add_timer(&hinfo->timer);
=20
 	LOCK_BH(&hashlimit_lock);
-	list_add(&hinfo->list, &hashlimit_htables);
+	hlist_add_head(&hinfo->node, &hashlimit_htables);
 	UNLOCK_BH(&hashlimit_lock);
=20
 	return 0;
@@ -258,8 +262,9 @@ static void htable_selective_cleanup(str
 	/* lock hash table and iterate over it */
 	spin_lock_bh(&ht->lock);
 	for (i =3D 0; i < ht->cfg.size; i++) {
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
=20
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
 	struct proc_dir_entry *pde =3D s->private;
 	struct ipt_hashlimit_htable *htable =3D pde->data;
 	unsigned int *bucket =3D (unsigned int *)v;
+	struct dsthash_ent *ent;
+	struct hlist_node *pos;
=20
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
+=09
 	return 0;
 }
=20


--ULkDCyeHsmlwbqED--

--Q5Q2TEEGbX9oWZOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCGxwsXaXGVTD0i/8RAkKaAKCEKM7dbpxc6DpOeFM3+1CMWqcrjACfdPxC
LKXyXgs8wH3zfma96fRJS8E=
=6bta
-----END PGP SIGNATURE-----

--Q5Q2TEEGbX9oWZOX--
