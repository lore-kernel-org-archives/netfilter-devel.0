Received: from mail-m81169.netease.com (mail-m81169.netease.com [47.88.81.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706EA270EBC
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.88.81.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461140; cv=none; b=l7+ADfTTts5svpwF2reNkaiRtQUmF7V+Wg/Fo3cvDrOUm5Yk2B4GJ+V/IJtTFoHvvUw2zdOKGdCgcBOD3eOMZO9f36qGsuL4RXUku5bYkWoPn8vuWnyHA7XAB9K+k4JPb0vai8Zh2KiwKjp++17AdLpTRql1WUH5WQDSkRIZKqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461140; c=relaxed/simple;
	bh=7xbn6G3PA9DZ43X18s2CgYiStsDHq2V/KT/yiX8xZGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jLXRlrg0aYeWqrau+cY4on01t1EMxnjNpKY/e5/fCMEohOJ/xMUBNfH1kBPIogEgevtalXZAWOmkXbOrvQoZNzDJkrtKgybagDxyEkiKZ2ncn1CbeZFmSA66Xyndgj6a1ElPAnABS184tjk+30PVwS7LI5q36l4QGjOxiSEzuYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=47.88.81.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id f62025e9;
	Fri, 29 Aug 2025 16:36:30 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH] netfilter: ipset: Remove unused htable_bits in macro ahash_region
Date: Fri, 29 Aug 2025 16:36:21 +0800
Message-Id: <20250829083621.1630638-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a98f4f89c990229kunm2b0d923a5a2865
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaSkodVkNKTE0dGBpCHU1OTFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0NMVUpLS1
	VLWQY+

Since the ahash_region() macro was redefined to calculate the region
index solely from HTABLE_REGION_BITS, the htable_bits parameter became
unused.

Remove the unused htable_bits argument and its call sites, simplifying
the code without changing semantics.

Fixes: 8478a729c046 ("netfilter: ipset: fix region locking in hash types")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 5251524b96af..5e4453e9ef8e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -63,7 +63,7 @@ struct hbucket {
 		: jhash_size((htable_bits) - HTABLE_REGION_BITS))
 #define ahash_sizeof_regions(htable_bits)		\
 	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
-#define ahash_region(n, htable_bits)		\
+#define ahash_region(n)		\
 	((n) / jhash_size(HTABLE_REGION_BITS))
 #define ahash_bucket_start(h,  htable_bits)	\
 	((htable_bits) < HTABLE_REGION_BITS ? 0	\
@@ -702,7 +702,7 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 				key = HKEY(data, h->initval, htable_bits);
 				m = __ipset_dereference(hbucket(t, key));
-				nr = ahash_region(key, htable_bits);
+				nr = ahash_region(key);
 				if (!m) {
 					m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
@@ -852,7 +852,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	elements = t->hregion[r].elements;
 	maxelem = t->maxelem;
@@ -1050,7 +1050,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	rcu_read_unlock_bh();
 
-- 
2.20.1

