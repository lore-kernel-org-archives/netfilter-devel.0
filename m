Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BB53783A0
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776872979; cv=none; b=ifUwhUoYq8abwUVt35BFNZYVi8GCRboNLE0VPhyjLI9meGln9GFLrMJ5XDuvG34frmYiDvO+PLrnBlt37R6spgQrcYlXtGMAQfEW+6CZJPQxj85WZqet2fE5GlK6OTsWFCt6HG/IiMCQeja+bX+7MKXbuPZ46O9y1oQPMus4Gno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776872979; c=relaxed/simple;
	bh=tWcZQ66fX8VN+MMQvWY55GqEOT5Ec5ncMvI8xiZ8EEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQaRbqUfsLVVxOomsA+XTW2+2knA5Gzvm8w0qd7C95ypROQzeGi9W0WsU4FgEe9AwWWyAhpu2/UQN88ZMuN5gO33SddBQMmsLCZIqQo870yIXePvOokaiLeFJVVMs3OCLzn83R47MZkdeRXuFh8P9t1liPKEGWaH6s6tmU12G+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowAAHe_v27ehpevPaAA--.16893S3;
	Wed, 22 Apr 2026 23:49:21 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kees@kernel.org,
	yuantan098@gmail.com,
	kadlec@netfilter.org,
	yifanwucs@gmail.com,
	zhen.ni@easystack.cn,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	zcliangcn@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: ipset: keep comment extensions private on resize
Date: Wed, 22 Apr 2026 23:41:41 +0800
Message-ID: <aa7edd8cd7d1c5d337d5b6bfb0747d1829862296.1776819297.git.zcliangcn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776819297.git.zcliangcn@gmail.com>
References: <cover.1776819297.git.zcliangcn@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAAHe_v27ehpevPaAA--.16893S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JFyxGFWUZF13tw1DZrW5Wrg_yoW7tr1fpF
	15C347trn5WF47CrWkAw4xZryYgan5Cr17J34fW3sayw1Dtrs5tanYkrySv3WUGryUKrWr
	J3W5Ka909r15WaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r10
	6r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUUxR6UUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQ0FCWnoi2EIXAAAs-

From: Zhengchuan Liang <zcliangcn@gmail.com>

Hash resize rebuilds the table by copying live elements into a new
table, while comment data is stored outside of the element body.

Recreate the comment extension for resized entries so the new table
does not share comment storage with the retired table. Once resize
gives each table its own comment data again, the old table can return
to destroying its extensions in the normal teardown paths.

This keeps comment lifetime and accounting consistent across resize
and the follow-up gc, dump, add, del and flush paths.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 include/linux/netfilter/ipset/ip_set.h |  1 +
 net/netfilter/ipset/ip_set_core.c      | 36 ++++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_gen.h  | 15 ++++++-----
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b98331572ad2..c3620899744c 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -336,6 +336,7 @@ extern size_t ip_set_elem_len(struct ip_set *set, struct nlattr *tb[],
 			      size_t len, size_t align);
 extern int ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 				 struct ip_set_ext *ext);
+extern int ip_set_ext_copy(struct ip_set *set, void *dst, const void *src);
 extern int ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 				 const void *e, bool active);
 extern bool ip_set_match_extensions(struct ip_set *set,
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c5a26236a0bb..0f5994ffec96 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -367,6 +367,42 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 }
 EXPORT_SYMBOL_GPL(ip_set_init_comment);
 
+static int
+ip_set_copy_comment(struct ip_set *set, struct ip_set_comment *dst,
+		    const struct ip_set_comment *src)
+{
+	struct ip_set_comment_rcu *c, *newc;
+	size_t len;
+
+	RCU_INIT_POINTER(dst->c, NULL);
+
+	c = rcu_dereference_bh(src->c);
+	if (!c)
+		return 0;
+
+	len = strlen(c->str);
+	newc = kmalloc(sizeof(*newc) + len + 1, GFP_ATOMIC);
+	if (unlikely(!newc))
+		return -ENOMEM;
+
+	memcpy(newc->str, c->str, len + 1);
+	set->ext_size += sizeof(*newc) + len + 1;
+	rcu_assign_pointer(dst->c, newc);
+
+	return 0;
+}
+
+int
+ip_set_ext_copy(struct ip_set *set, void *dst, const void *src)
+{
+	if (SET_WITH_COMMENT(set))
+		return ip_set_copy_comment(set, ext_comment(dst, set),
+					   ext_comment(src, set));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ip_set_ext_copy);
+
 /* Used only when dumping a set, protected by rcu_read_lock() */
 static int
 ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index b79e5dd2af03..b937a478f5ac 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -584,7 +584,7 @@ mtype_gc(struct work_struct *work)
 
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by expire: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 
 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
@@ -743,6 +743,9 @@ mtype_resize(struct ip_set *set, bool retried)
 				}
 				d = ahash_data(m, m->pos, dsize);
 				memcpy(d, data, dsize);
+				ret = ip_set_ext_copy(set, d, data);
+				if (ret < 0)
+					goto cleanup;
 				set_bit(m->pos++, m->used);
 				t->hregion[nr].elements++;
 #ifdef IP_SET_HASH_WITH_NETS
@@ -778,7 +781,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	/* If there's nobody else using the table, destroy it */
 	if (atomic_dec_and_test(&orig->uref)) {
 		pr_debug("Table destroy by resize %p\n", orig);
-		mtype_ahash_destroy(set, orig, false);
+		mtype_ahash_destroy(set, orig, true);
 	}
 
 out:
@@ -791,7 +794,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	rcu_read_unlock_bh();
 	atomic_set(&orig->ref, 0);
 	atomic_dec(&orig->uref);
-	mtype_ahash_destroy(set, t, false);
+	mtype_ahash_destroy(set, t, true);
 	if (ret == -EAGAIN)
 		goto retry;
 	goto out;
@@ -1023,7 +1026,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 out:
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by add: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 	return ret;
 }
@@ -1135,7 +1138,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by del: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 	return ret;
 }
@@ -1341,7 +1344,7 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 			pr_debug("Table destroy after resize "
 				 " by dump: %p\n", t);
-			mtype_ahash_destroy(set, t, false);
+			mtype_ahash_destroy(set, t, true);
 		}
 		cb->args[IPSET_CB_PRIVATE] = 0;
 	}
-- 
2.39.5

