Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAF83559C9
	for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2026 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779029488; cv=none; b=QZltK09rMfrFhZXtebKwBylURqzSqYIJR6ape2heXVNdSsNBzRymkJV1T/u4HdHonhBwGsGQewsuZt8+q85ISO8OCHfeyUD5Yx1gE7+mEnJdIoFQs1MfyTTBJvPRHEsQbfhBdSPuZLyMm5LYSMAdyti+nMOpVF9zmRRGAKcztZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779029488; c=relaxed/simple;
	bh=HXFGyhcbJqUecq00NkdErggk+8Izgot5COP94xRoJ+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bZHvDrjPfLdPPCeh9ZycCUp22Bha4ZYVM8RY30HFUtVG7C+tO1C0PU/v71BAEisVDZfQRZl7m9wKNy0/Dsn3Ds4IacfBnO55ty2ZKbaddIdA1Rf6g/m09kGL/aHTkEqiff9k7554srBvZf1kEnjYVFdbyS/fP5BE713D/mLRpJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app2 (Coremail) with SMTP id zQmowAB3EgrO1Qlqk3UDAA--.3003S2;
	Sun, 17 May 2026 22:50:54 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org,
	kees@kernel.org,
	phil@nwl.cc,
	yifanwucs@gmail.com,
	yuantan098@gmail.com,
	zhen.ni@easystack.cn,
	kadlec@netfilter.org,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	zcliangcn@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf v2 1/1] netfilter: ipset: preserve comment lifetime across resize and gc expiry
Date: Sun, 17 May 2026 22:50:00 +0800
Message-ID: <9d4c26c4667896f5a48b665620d6a30d0138893d.1778865988.zcliangcn@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQmowAB3EgrO1Qlqk3UDAA--.3003S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Kw4fJr1xWrWUtw4UJF15twb_yoWDuF4xpF
	98u3srtr4kWF4xur4kAw4xZrya9ws5Cr1UJr93W3sIyr9xtrs5tFsYkryavF15CryUCr4r
	Ja1UKa909rWrXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQAKCWoJXG8B7wAEs4

From: Zhengchuan Liang <zcliangcn@gmail.com>

Hash resize rebuilds the table by copying live elements into a new
hash table while old-table garbage collection can still expire entries
in parallel. For comment-enabled hash sets, the old and new tables can
temporarily refer to the same comment extension object.

Use the existing resize add/del backlog to replay deletes that race
with resize, and make shared comment extensions safe across the old and
new tables until the replayed delete removes the copied entry. Add a
refcount to comment storage, acquire a reference when resize copies an
entry, and restore normal extension destruction in the old-table
teardown paths.

This avoids reallocating comment storage for every live element during
resize and fixes the stale comment lifetime bug triggered by old-table
gc.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
changes in v2:
 - Rework the fix to use the existing resize add/del backlog infrastructure.
 - Drop the v1 approach of duplicating comment extensions for all live entries copied during resize.
 - Refcount comment storage so old and new tables can share it safely during resize.
 - Take a comment reference when copying an entry during resize and release it via the normal extension destroy paths.
 - Queue delete replay for entries expired from the old table during resize.
 - Restore normal extension destruction in the old-table teardown paths.
 - v1 Link: https://lore.kernel.org/all/aa7edd8cd7d1c5d337d5b6bfb0747d1829862296.1776819297.git.zcliangcn@gmail.com/

 include/linux/netfilter/ipset/ip_set.h |  3 ++
 net/netfilter/ipset/ip_set_core.c      | 37 ++++++++++++++++++++---
 net/netfilter/ipset/ip_set_hash_gen.h  | 42 +++++++++++++++++++-------
 3 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b98331572ad2..ef352ae40716 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -11,6 +11,7 @@
 #include <linux/ipv6.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
+#include <linux/refcount.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/stringify.h>
 #include <linux/vmalloc.h>
@@ -97,6 +98,7 @@ struct ip_set_counter {
 };
 
 struct ip_set_comment_rcu {
+	refcount_t ref;
 	struct rcu_head rcu;
 	char str[];
 };
@@ -336,6 +338,7 @@ extern size_t ip_set_elem_len(struct ip_set *set, struct nlattr *tb[],
 			      size_t len, size_t align);
 extern int ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 				 struct ip_set_ext *ext);
+extern void ip_set_ext_get(struct ip_set *set, void *dst, const void *src);
 extern int ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 				 const void *e, bool active);
 extern bool ip_set_match_extensions(struct ip_set *set,
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c5a26236a0bb..2d70bf6f81ed 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -350,8 +350,10 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 	size_t len = ext->comment ? strlen(ext->comment) : 0;
 
 	if (unlikely(c)) {
-		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-		kfree_rcu(c, rcu);
+		if (refcount_dec_and_test(&c->ref)) {
+			set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+			kfree_rcu(c, rcu);
+		}
 		rcu_assign_pointer(comment->c, NULL);
 	}
 	if (!len)
@@ -361,12 +363,37 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
 	if (unlikely(!c))
 		return;
+	refcount_set(&c->ref, 1);
 	strscpy(c->str, ext->comment, len + 1);
 	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
 	rcu_assign_pointer(comment->c, c);
 }
 EXPORT_SYMBOL_GPL(ip_set_init_comment);
 
+void
+ip_set_ext_get(struct ip_set *set, void *dst, const void *src)
+{
+	struct ip_set_comment_rcu *c;
+	struct ip_set_comment *dst_comment;
+	const struct ip_set_comment *src_comment;
+
+	if (!SET_WITH_COMMENT(set))
+		return;
+
+	dst_comment = ext_comment(dst, set);
+	src_comment = ext_comment(src, set);
+	RCU_INIT_POINTER(dst_comment->c, NULL);
+
+	c = rcu_dereference_bh(src_comment->c);
+	if (!c)
+		return;
+
+	if (!refcount_inc_not_zero(&c->ref))
+		return;
+	rcu_assign_pointer(dst_comment->c, c);
+}
+EXPORT_SYMBOL_GPL(ip_set_ext_get);
+
 /* Used only when dumping a set, protected by rcu_read_lock() */
 static int
 ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
@@ -392,9 +419,11 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	c = rcu_dereference_protected(comment->c, 1);
 	if (unlikely(!c))
 		return;
-	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-	kfree_rcu(c, rcu);
 	rcu_assign_pointer(comment->c, NULL);
+	if (refcount_dec_and_test(&c->ref)) {
+		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+		kfree_rcu(c, rcu);
+	}
 }
 
 typedef void (*destroyer)(struct ip_set *, void *);
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index b79e5dd2af03..086b17b48ca4 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -485,13 +485,14 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 {
 	struct hbucket *n, *tmp;
 	struct mtype_elem *data;
+	struct mtype_resize_ad *x;
+	LIST_HEAD(list);
 	u32 i, j, d;
 	size_t dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 k;
 #endif
 	u8 htable_bits = t->htable_bits;
-
 	spin_lock_bh(&t->hregion[r].lock);
 	for (i = ahash_bucket_start(r, htable_bits);
 	     i < ahash_bucket_end(r, htable_bits); i++) {
@@ -516,6 +517,16 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 					k);
 #endif
 			t->hregion[r].elements--;
+			if (atomic_read(&t->ref)) {
+				x = kzalloc_obj(struct mtype_resize_ad,
+						GFP_ATOMIC);
+				if (x) {
+					x->ad = IPSET_DEL;
+					memcpy(&x->d, data,
+					       sizeof(struct mtype_elem));
+					list_add_tail(&x->list, &list);
+				}
+			}
 			ip_set_ext_destroy(set, data);
 			d++;
 		}
@@ -551,6 +562,11 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 		}
 	}
 	spin_unlock_bh(&t->hregion[r].lock);
+	if (!list_empty(&list)) {
+		spin_lock_bh(&set->lock);
+		list_splice_tail_init(&list, &h->ad);
+		spin_unlock_bh(&set->lock);
+	}
 }
 
 static void
@@ -584,7 +600,7 @@ mtype_gc(struct work_struct *work)
 
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by expire: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 
 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
@@ -743,6 +759,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				}
 				d = ahash_data(m, m->pos, dsize);
 				memcpy(d, data, dsize);
+				ip_set_ext_get(set, d, data);
 				set_bit(m->pos++, m->used);
 				t->hregion[nr].elements++;
 #ifdef IP_SET_HASH_WITH_NETS
@@ -775,10 +792,9 @@ mtype_resize(struct ip_set *set, bool retried)
 		list_del(l);
 		kfree(l);
 	}
-	/* If there's nobody else using the table, destroy it */
 	if (atomic_dec_and_test(&orig->uref)) {
 		pr_debug("Table destroy by resize %p\n", orig);
-		mtype_ahash_destroy(set, orig, false);
+		mtype_ahash_destroy(set, orig, true);
 	}
 
 out:
@@ -791,7 +807,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	rcu_read_unlock_bh();
 	atomic_set(&orig->ref, 0);
 	atomic_dec(&orig->uref);
-	mtype_ahash_destroy(set, t, false);
+	mtype_ahash_destroy(set, t, true);
 	if (ret == -EAGAIN)
 		goto retry;
 	goto out;
@@ -1023,7 +1039,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 out:
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by add: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 	return ret;
 }
@@ -1040,6 +1056,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct mtype_elem *data;
 	struct hbucket *n;
 	struct mtype_resize_ad *x = NULL;
+	bool resize_in_progress;
 	int i, j, k, r, ret = -IPSET_ERR_EXIST;
 	u32 key, multi = 0;
 	size_t dsize = set->dsize;
@@ -1066,7 +1083,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		data = ahash_data(n, i, dsize);
 		if (!mtype_data_equal(data, d, &multi))
 			continue;
-		if (SET_ELEM_EXPIRED(set, data))
+		if (SET_ELEM_EXPIRED(set, data) && ext)
 			goto out;
 
 		ret = 0;
@@ -1075,6 +1092,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (i + 1 == n->pos)
 			n->pos--;
 		t->hregion[r].elements--;
+		resize_in_progress = atomic_read(&t->ref) && ext && ext->target;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
 			mtype_del_cidr(set, h,
@@ -1082,9 +1100,11 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #endif
 		ip_set_ext_destroy(set, data);
 
-		if (atomic_read(&t->ref) && ext->target) {
+		if (resize_in_progress) {
 			/* Resize is in process and kernel side del,
-			 * save values
+			 * save values. The old-table ref is dropped above;
+			 * the delete will be replayed on the resized table
+			 * to drop the copied ref there too.
 			 */
 			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
 			if (x) {
@@ -1135,7 +1155,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by del: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 	return ret;
 }
@@ -1341,7 +1361,7 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 			pr_debug("Table destroy after resize "
 				 " by dump: %p\n", t);
-			mtype_ahash_destroy(set, t, false);
+			mtype_ahash_destroy(set, t, true);
 		}
 		cb->args[IPSET_CB_PRIVATE] = 0;
 	}
-- 
2.34.1

