Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCD65A7B7
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707835358; cv=none; b=ABxYjaH+QTvTkyIj5PXzhaU6HWEP7kPRKOHA1cRStldGhhDTnww7VGzAYwnxGFGu4gC1hksZejjeDnaWtcjEfpDYluUiZu61Tni3r9QlLUFDJoot8Eydxz+8xwjHDVpdST6yuN/UBLS/bSGQ8qDk9OID/v5Ag7qtCIb24e8QagI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707835358; c=relaxed/simple;
	bh=6HZU1Y+ZEmZmUL+E7TSa/AR4OfRD09hi7pqeXrIvAkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8xjqOIbstl1eJdPm+luDA0WyrD/I+ghJayiE75pymws/JJzsKrRMz1VyJC0f3Q185gIcM4QqMp4clJoh91GgJqXFXts4/PdWa4c1Y+2fMM7re3uRi0Dwzw2lqk+wTo07X2u29XSOqeL15ONaoQmoRxWC9iK0WwbwwkIDxBwKFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rZtzX-0000Ll-AE; Tue, 13 Feb 2024 15:42:35 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 4/4] netfilter: nft_set_pipapo: speed up bulk element insertions
Date: Tue, 13 Feb 2024 16:23:40 +0100
Message-ID: <20240213152345.10590-5-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240213152345.10590-1-fw@strlen.de>
References: <20240213152345.10590-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Insertions into the set are slow when we try to add many elements.
For 800k elements I get:

time nft -f pipapo_800k
real    19m34.849s
user    0m2.390s
sys     19m12.828s

perf stats:
 --95.39%--nft_pipapo_insert
     |--76.60%--pipapo_insert
     |           --76.37%--pipapo_resize
     |                     |--72.87%--memcpy_orig
     |                     |--1.88%--__free_pages_ok
     |                     |          --0.89%--free_tail_page_prepare
     |                      --1.38%--kvmalloc_node
     ..
     --18.56%--pipapo_get.isra.0
     |--13.91%--__bitmap_and
     |--3.01%--pipapo_refill
     |--0.81%--__kmalloc
     |           --0.74%--__kmalloc_large_node
     |                      --0.66%--__alloc_pages
     ..
     --0.52%--memset_orig

So lots of time is spent in copying exising elements to make space for
the next one.

Instead of allocating to the exact size of the new rule count, allocate
extra slack to reduce alloc/copy/free overhead.

After:
time nft -f pipapo_800k
real    1m54.110s
user    0m2.515s
sys     1m51.377s

 --80.46%--nft_pipapo_insert
     |--73.45%--pipapo_get.isra.0
     |--57.63%--__bitmap_and
     |          |--8.52%--pipapo_refill
     |--3.45%--__kmalloc
     |           --3.05%--__kmalloc_large_node
     |                      --2.58%--__alloc_pages
     --2.59%--memset_orig
     |--6.51%--pipapo_insert
            --5.96%--pipapo_resize
                     |--3.63%--memcpy_orig
                     --2.13%--kvmalloc_node

The new @rules_alloc fills a hole, so struct size doesn't go up.
Also make it so rule removal doesn't shrink unless the free/extra space
exceeds two pages.  This should be safe as well:

When a rule gets removed, the attempt to lower the allocated size is
already allowed to fail.

Exception: do exact allocations as long as set is very small (less
than one page needed).

v2: address comments from Stefano:
    kdoc comment
    formatting changes
    remove redundant assignment
    switch back to PAGE_SIZE

Link: https://lore.kernel.org/netfilter-devel/20240213141753.17ef27a6@elisabeth/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 83 +++++++++++++++++++++++++++-------
 net/netfilter/nft_set_pipapo.h |  2 +
 2 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index aa438b656484..bb7cb9bda579 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -621,6 +621,65 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	return &e->priv;
 }
 
+/**
+ * pipapo_realloc_mt() - Reallocate mapping table if needed upon resize
+ * @f:		Field containing mapping table
+ * @old_rules:	Amount of existing mapped rules
+ * @rules:	Amount of new rules to map
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int pipapo_realloc_mt(struct nft_pipapo_field *f,
+			     unsigned int old_rules, unsigned int rules)
+{
+	union nft_pipapo_map_bucket *new_mt = NULL, *old_mt = f->mt;
+	const unsigned int extra = PAGE_SIZE / sizeof(*new_mt);
+	unsigned int rules_alloc = rules;
+
+	might_sleep();
+
+	if (unlikely(rules == 0))
+		goto out_free;
+
+	/* growing and enough space left, no action needed */
+	if (rules > old_rules && f->rules_alloc > rules)
+		return 0;
+
+	/* downsize and extra slack has not grown too large */
+	if (rules < old_rules) {
+		unsigned int remove = f->rules_alloc - rules;
+
+		if (remove < (2u * extra))
+			return 0;
+	}
+
+	/* If set needs more than one page of memory for rules then
+	 * allocate another extra page to avoid frequent reallocation.
+	 */
+	if (rules > extra &&
+	    check_add_overflow(rules, extra, &rules_alloc))
+		return -EOVERFLOW;
+
+	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL);
+	if (!new_mt)
+		return -ENOMEM;
+
+	if (old_mt)
+		memcpy(new_mt, old_mt, min(old_rules, rules) * sizeof(*new_mt));
+
+	if (rules > old_rules) {
+		memset(new_mt + old_rules, 0,
+		       (rules - old_rules) * sizeof(*new_mt));
+	}
+out_free:
+	f->rules_alloc = rules_alloc;
+	f->mt = new_mt;
+
+	kvfree(old_mt);
+
+	return 0;
+}
+
 /**
  * pipapo_resize() - Resize lookup or mapping table, or both
  * @f:		Field containing lookup and mapping tables
@@ -637,9 +696,8 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 			 unsigned int old_rules, unsigned int rules)
 {
 	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
-	union nft_pipapo_map_bucket *new_mt, *old_mt = f->mt;
 	unsigned int new_bucket_size, copy;
-	int group, bucket;
+	int group, bucket, err;
 
 	if (rules >= NFT_PIPAPO_RULE0_MAX)
 		return -ENOSPC;
@@ -682,16 +740,10 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 	}
 
 mt:
-	new_mt = kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL);
-	if (!new_mt) {
+	err = pipapo_realloc_mt(f, old_rules, rules);
+	if (err) {
 		kvfree(new_lt);
-		return -ENOMEM;
-	}
-
-	memcpy(new_mt, f->mt, min(old_rules, rules) * sizeof(*new_mt));
-	if (rules > old_rules) {
-		memset(new_mt + old_rules, 0,
-		       (rules - old_rules) * sizeof(*new_mt));
+		return err;
 	}
 
 	if (new_lt) {
@@ -700,9 +752,6 @@ static int pipapo_resize(struct nft_pipapo_field *f,
 		kvfree(old_lt);
 	}
 
-	f->mt = new_mt;
-	kvfree(old_mt);
-
 	return 0;
 }
 
@@ -1382,14 +1431,15 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
-			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
-						 GFP_KERNEL);
+			dst->mt = kvmalloc_array(src->rules_alloc,
+						 sizeof(*src->mt), GFP_KERNEL);
 			if (!dst->mt)
 				goto out_mt;
 
 			memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
 		} else {
 			dst->mt = NULL;
+			dst->rules_alloc = 0;
 		}
 
 		src++;
@@ -2205,6 +2255,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 
 		f->bsize = 0;
 		f->rules = 0;
+		f->rules_alloc = 0;
 		f->lt = NULL;
 		f->mt = NULL;
 	}
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 8d9486ae0c01..bbcac2b38167 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -106,6 +106,7 @@ union nft_pipapo_map_bucket {
  * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
  * @rules:	Number of inserted rules
  * @bsize:	Size of each bucket in lookup table, in longs
+ * @rules_alloc Number of allocated rules, always >= rules
  * @groups:	Amount of bit groups
  * @bb:		Number of bits grouped together in lookup table buckets
  * @lt:		Lookup table: 'groups' rows of buckets
@@ -114,6 +115,7 @@ union nft_pipapo_map_bucket {
 struct nft_pipapo_field {
 	unsigned int rules;
 	unsigned int bsize;
+	unsigned int rules_alloc;
 	u8 groups;
 	u8 bb;
 	unsigned long *lt;
-- 
2.43.0

