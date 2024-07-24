Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCBD1B7E9;
	Wed, 24 Jul 2024 08:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721808806; cv=none; b=Z0VAxFbX1xvOqLBg3+HQr8/o2zwEPFRPTogXfFm8gTki08T1AP4uDib9HJtUSbACoE1o9OdFj1jDa2vpCJFM8Dk6528mwvbXKQ5pB5mGbZHsmnnfN4XkRBzKMoeHvQiuamMRpFU8z3bNDc3N98nia228o2idmJYGwAhLfPJrngk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721808806; c=relaxed/simple;
	bh=7OcdB3PHUvwkvTIq44b47yWCfTmk9SztqnwB7M5hYlI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TBDrAa87kfTRI2aSwoQ3WL0uCWpJvt7vOkTN7wf5nbXY5S6859oQ8A2r9hjE5O9gPQ9R2q3/MLgNKmpY/oHtrVorQoMA/+uRZ+CFJZw9imzGXe/T74L3Ft4Ef1vki3osStG39MjdWId+1cbAqWFGtoGgtxl+PlCkcpSz10tASpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 1/1] netfilter: nft_set_pipapo_avx2: disable softinterrupts
Date: Wed, 24 Jul 2024 10:13:05 +0200
Message-Id: <20240724081305.3152-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240724081305.3152-1-pablo@netfilter.org>
References: <20240724081305.3152-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

We need to disable softinterrupts, else we get following problem:

1. pipapo_avx2 called from process context; fpu usable
2. preempt_disable() called, pcpu scratchmap in use
3. softirq handles rx or tx, we re-enter pipapo_avx2
4. fpu busy, fallback to generic non-avx version
5. fallback reuses scratch map and index, which are in use
   by the preempted process

Handle this same way as generic version by first disabling
softinterrupts while the scratchmap is in use.

Fixes: f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version")
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 8910a5ac7ed1..b8d3c3213efe 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1139,8 +1139,14 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	bool map_index;
 	int i, ret = 0;
 
-	if (unlikely(!irq_fpu_usable()))
-		return nft_pipapo_lookup(net, set, key, ext);
+	local_bh_disable();
+
+	if (unlikely(!irq_fpu_usable())) {
+		bool fallback_res = nft_pipapo_lookup(net, set, key, ext);
+
+		local_bh_enable();
+		return fallback_res;
+	}
 
 	m = rcu_dereference(priv->match);
 
@@ -1155,6 +1161,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	scratch = *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch)) {
 		kernel_fpu_end();
+		local_bh_enable();
 		return false;
 	}
 
@@ -1235,6 +1242,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	if (i % 2)
 		scratch->map_index = !map_index;
 	kernel_fpu_end();
+	local_bh_enable();
 
 	return ret >= 0;
 }
-- 
2.30.2

