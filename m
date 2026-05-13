Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAAD262808
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 05:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778651788; cv=none; b=QNKEqnxtIbYK/fAQ82JW47dpBYy+sNmajP11qFycTTxseDMrckYhFsWY6O+kRrB+Ssjhf7fjv4ZVVRPTekh0TYKXuZiMUznsl7RXoAKNxQTZCxdVYYofCzNip2inMhOYGtaL/rHMXqu2w5y7T4dQyoGZBuhLxVBjyD3v8zwPCM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778651788; c=relaxed/simple;
	bh=AoCpLQIqVBR7RlDAMNRc3danAkixrKHRB1F3Zf0FoDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XT2tOBnC1E5zXFqlG1hCEBBXunk1DVhmP4fqi0PKjLYTWVDwUGpqxznTxmSG3oh3HZrr1aKV1JzSU+JYbAh1/WXGcsCXvmSTeslWRG0YjCu+0eMagEJSKe60h78nxZSoaYzR7gi0U2yqT6FCVwcSQb6WSTfUOP6a0EC8YztafCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app2 (Coremail) with SMTP id zQmowABX9AtbEgRq4vAAAA--.1271S3;
	Wed, 13 May 2026 13:56:10 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org,
	kees@kernel.org,
	phil@nwl.cc,
	zhen.ni@easystack.cn,
	yifanwucs@gmail.com,
	kadlec@netfilter.org,
	yuantan098@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	caoruide123@gmail.com,
	enjou1224z@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: ipset: fix comment extension lifetime during hash resize
Date: Wed, 13 May 2026 13:54:56 +0800
Message-ID: <3a4502d6c2ee931eb7b9929d24cd35963b181c43.1778456999.git.caoruide123@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1778456999.git.caoruide123@gmail.com>
References: <cover.1778456999.git.caoruide123@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQmowABX9AtbEgRq4vAAAA--.1271S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrW5ZFyxXF15uFyrGFW7Arb_yoW7tr18pF
	1Yk3sxtrykWF47CrWkAw4xZryYgan5AFnrG34fW3say3s8trs5JanYkrySv3WUGryq9rWf
	G3Waka90vr1rWaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8V
	W8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQAGCWoCxO4ZQgAAsX

From: Ruide Cao <caoruide123@gmail.com>

Hash ipset resize can replay concurrent kernel-side updates after moving
entries into a new table. For sets with comments enabled, the resize path
copied element storage as-is, which let old and new tables temporarily
share comment extension state.

When a concurrent delete or timeout cleanup released the old-table entry
before replay completed, later processing could operate on already released
comment state and trigger warnings or crashes in debug configurations.

Fix this by cloning comment extensions while migrating entries so resized
tables own independent comment state, and make sure old resize tables are
destroyed with extension cleanup once they are no longer referenced.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix \"INFO: rcu detected stall in hash_xxx\" reports")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 include/linux/netfilter/ipset/ip_set.h |  2 ++
 net/netfilter/ipset/ip_set_core.c      | 25 +++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_gen.h  | 19 +++++++++++++------
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b98331572ad2..5722b36e95a1 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -501,6 +501,8 @@ ip_set_timeout_set(unsigned long *timeout, u32 value)
 
 void ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 			 const struct ip_set_ext *ext);
+int ip_set_clone_comment(struct ip_set *set, struct ip_set_comment *dst,
+			 const struct ip_set_comment *src);
 
 static inline void
 ip_set_init_counter(struct ip_set_counter *counter,
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c5a26236a0bb..d3e5358f1780 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -367,6 +367,31 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 }
 EXPORT_SYMBOL_GPL(ip_set_init_comment);
 
+int
+ip_set_clone_comment(struct ip_set *set, struct ip_set_comment *dst,
+		     const struct ip_set_comment *src)
+{
+	struct ip_set_comment_rcu *c, *newc;
+	size_t len;
+
+	c = rcu_dereference_bh(src->c);
+	RCU_INIT_POINTER(dst->c, NULL);
+	if (!c)
+		return 0;
+
+	len = strlen(c->str);
+	newc = kmalloc(sizeof(*newc) + len + 1, GFP_ATOMIC);
+	if (!newc)
+		return -ENOMEM;
+
+	memcpy(newc->str, c->str, len + 1);
+	set->ext_size += sizeof(*newc) + len + 1;
+	rcu_assign_pointer(dst->c, newc);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ip_set_clone_comment);
+
 /* Used only when dumping a set, protected by rcu_read_lock() */
 static int
 ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index b79e5dd2af03..17331bcbd4ec 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -584,7 +584,7 @@ mtype_gc(struct work_struct *work)
 
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by expire: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 
 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
@@ -743,6 +743,13 @@ mtype_resize(struct ip_set *set, bool retried)
 				}
 				d = ahash_data(m, m->pos, dsize);
 				memcpy(d, data, dsize);
+				if (SET_WITH_COMMENT(set)) {
+					ret = ip_set_clone_comment(set,
+								   ext_comment(d, set),
+								   ext_comment(data, set));
+					if (ret)
+						goto cleanup;
+				}
 				set_bit(m->pos++, m->used);
 				t->hregion[nr].elements++;
 #ifdef IP_SET_HASH_WITH_NETS
@@ -778,7 +785,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	/* If there's nobody else using the table, destroy it */
 	if (atomic_dec_and_test(&orig->uref)) {
 		pr_debug("Table destroy by resize %p\n", orig);
-		mtype_ahash_destroy(set, orig, false);
+		mtype_ahash_destroy(set, orig, true);
 	}
 
 out:
@@ -791,7 +798,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	rcu_read_unlock_bh();
 	atomic_set(&orig->ref, 0);
 	atomic_dec(&orig->uref);
-	mtype_ahash_destroy(set, t, false);
+	mtype_ahash_destroy(set, t, true);
 	if (ret == -EAGAIN)
 		goto retry;
 	goto out;
@@ -1023,7 +1030,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 out:
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by add: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 	return ret;
 }
@@ -1135,7 +1142,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by del: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+		mtype_ahash_destroy(set, t, true);
 	}
 	return ret;
 }
@@ -1341,7 +1348,7 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
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

