Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF07210E4
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2024 10:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707733577; cv=none; b=fz104oCAzVa6KmjzO10r2GRnGc+2b9a/vgUm76klSJ2Knr8dsrJT62JowJHaio/Mu+NDj0OB8hfdZcp5Ba+3jGogbp8eFdX0upJQ33FymRtQ55pewyHVTiuHIr9Ibwg7HktkdhN8TQrNSEvX+aERuuSBCbkWWlIia3zqobNUnLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707733577; c=relaxed/simple;
	bh=zfcWA71SD9obVITPS36RmwVB3nDpGoekEvI2rhcLzTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmAwwYLOl7w1mt51UlhigwDKrLmR5eiZdi/fOAvKtwbwu6mE2oYermUMdPOB6yw9bdH/okC4kUAQuo7zR9TlBWfi03gd9n5lpQUfphetyHtEYVwhrvHuIcQhFBbh935ndmO/EgT+ZcmjERuaBbe16G5CtlLDcAcoOJVTZhfkcxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rZTVu-0005qC-5O; Mon, 12 Feb 2024 11:26:14 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: nft_set_pipapo: speed up bulk element insertions
Date: Mon, 12 Feb 2024 11:01:53 +0100
Message-ID: <20240212100202.10116-5-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240212100202.10116-1-fw@strlen.de>
References: <20240212100202.10116-1-fw@strlen.de>
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

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 80 +++++++++++++++++++++++++++-------
 net/netfilter/nft_set_pipapo.h |  2 +
 2 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index a0ddf24a8052..25cdf64a3139 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -622,6 +622,62 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	return &e->priv;
 }
 
+static int pipapo_realloc_mt(struct nft_pipapo_field *f, unsigned int old_rules, unsigned int rules)
+{
+	union nft_pipapo_map_bucket *new_mt = NULL, *old_mt = f->mt;
+	unsigned int extra = 4096 / sizeof(*new_mt);
+	unsigned int rules_alloc = rules;
+
+	might_sleep();
+
+	BUILD_BUG_ON(extra < 32);
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
+	/* small sets get precise count, else add extra slack
+	 * to avoid frequent reallocations.  Extra slack is
+	 * currently one 4k page worth of rules.
+	 *
+	 * Use no slack if the set only has a small number
+	 * of rules.
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
+	if (rules > old_rules)
+		memset(new_mt + old_rules, 0,
+		       (rules - old_rules) * sizeof(*new_mt));
+
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
@@ -637,9 +693,8 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 static int pipapo_resize(struct nft_pipapo_field *f, unsigned int old_rules, unsigned int rules)
 {
 	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
-	union nft_pipapo_map_bucket *new_mt, *old_mt = f->mt;
 	unsigned int new_bucket_size, copy;
-	int group, bucket;
+	int group, bucket, err;
 
 	if (rules >= NFT_PIPAPO_RULE0_MAX)
 		return -ENOSPC;
@@ -682,16 +737,10 @@ static int pipapo_resize(struct nft_pipapo_field *f, unsigned int old_rules, uns
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
@@ -700,9 +749,6 @@ static int pipapo_resize(struct nft_pipapo_field *f, unsigned int old_rules, uns
 		kvfree(old_lt);
 	}
 
-	f->mt = new_mt;
-	kvfree(old_mt);
-
 	return 0;
 }
 
@@ -1382,13 +1428,16 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
-			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt), GFP_KERNEL);
+			dst->mt = kvmalloc_array(src->rules_alloc, sizeof(*src->mt), GFP_KERNEL);
 			if (!dst->mt)
 				goto out_mt;
 
 			memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
+			dst->rules_alloc = src->rules_alloc;
+			dst->rules = src->rules;
 		} else {
 			dst->mt = NULL;
+			dst->rules_alloc = 0;
 		}
 
 		src++;
@@ -2203,6 +2252,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 
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

