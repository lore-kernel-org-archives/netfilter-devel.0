Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32CB351C0D;
	Sat, 20 Jun 2026 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994475; cv=none; b=LhiTnW1VNZ0U0509THUpR/enIKZqse0fEeeCDFe28dE+6dEzYjXMnkjCtdOBmtAdsuiLimxwsFiMjybPkK/ZiaHglT3TnvE9VKxh8GsO3xoKQkihd17JMw1Yvt+QEMYQHaiglPeBp1Uv+MtwEGpJzDmExtkSaUf9L2UgKHRGnUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994475; c=relaxed/simple;
	bh=GKxei/gwWs+LG9cWfqD5CW5tyC2e2c2Sg+S8bNrdPgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnpoHlmkViRj7vLQXmBhfnXwLv6/VoJYFc8veRRHr0DSiKpmd0x5KwJxB8oYShCLhMiTEuSACyq/G3nHEJMRweeljkJAgaql6wJM8tNQPT1jzpPkRDA3Y3MBWeiY8g7jWEW9gyIVBsKd07choX2Ou0U+TkoAZoaI+puFmqIhyBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=okAMdW4f; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="okAMdW4f"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5D6876019C;
	Sun, 21 Jun 2026 00:27:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994468;
	bh=jnQja1ZRxTiOgdompmbzJ3/VXLbFkJU5R6dIelIcZfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okAMdW4fG+lJ0t7KK5j2aJHpx82/QZWmyHEpWTIbHEviOQq024GE6E7vYGDByA9vk
	 QqJzcR8BZs6xCQIV9jk+iv4mPE0IV4qDHNJjoYCFT9G3eFQdsA7c5wmpXiVITovKcH
	 ywc/lDug9c445G6WMgbX/GFCGwK4GSyMkZKiUgmkL//esR8YVRZV5S1Lj0FfvQWGuU
	 IPLreb9AeJOwg4K6n84xAvqcU95wBbsh3OlV0cV7MzNiTM8Dq9/MpxgL3D1p7bD3ux
	 pK6YfGUgHWXFHsM6Ke9koiYY3Ua4bWzp4fk9wqASjHglKSFnC5G2drho3vbPuEYFjq
	 q499OwgejaD9w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/14] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
Date: Sun, 21 Jun 2026 00:27:29 +0200
Message-ID: <20260620222738.112506-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Sashiko pointed out that there are a few lockless RCU readers
using test_bit() which is a relaxed atomic operation and
provides no memory barrier guarantees. Use test_bit_acquire()
instead where the operation may run parallel with add/del/gc,
i.e. is not one from the next cases

- protected by region lock
- in a set destroy phase
- in a new/temporary set creation phase

Fixes: 18f84d41d34f ("netfilter: ipset: Introduce RCU locking in hash:* types")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 04e4627ddfc1..00c27b95207f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -689,7 +689,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
 				if (SET_ELEM_EXPIRED(set, data))
@@ -826,7 +826,7 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 				continue;
 			pos = smp_load_acquire(&n->pos);
 			for (j = 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, set->dsize);
 				if (!SET_ELEM_EXPIRED(set, data))
@@ -1201,7 +1201,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 			continue;
 		pos = smp_load_acquire(&n->pos);
 		for (i = 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			data = ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
@@ -1259,7 +1259,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 	pos = smp_load_acquire(&n->pos);
 	for (i = 0; i < pos; i++) {
-		if (!test_bit(i, n->used))
+		if (!test_bit_acquire(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
 		if (!mtype_data_equal(data, d, &multi))
@@ -1396,7 +1396,7 @@ mtype_list(const struct ip_set *set,
 			continue;
 		pos = smp_load_acquire(&n->pos);
 		for (i = 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			e = ahash_data(n, i, set->dsize);
 			if (SET_ELEM_EXPIRED(set, e))
-- 
2.47.3

