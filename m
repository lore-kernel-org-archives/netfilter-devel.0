Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7B91E515;
	Thu,  9 Jan 2025 12:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736426141; cv=none; b=NzUFp98k81+aez/iW2r6ANH2WDGAO+U9PNjKbh8bBV1cGrkfZlkOR+w2UTe4KyuWYkF6qk75EWlFfkkvpd11ePf2I1wJftXk5WbdimD3f5gfQ8y0jWscxYuKLN/VigRARPd8uNd1ac0DYspEeW04dRRamGMHFDRsr76540KNgaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736426141; c=relaxed/simple;
	bh=VrpoQ52emWyqkUGmWVhGMz5fW6VKRC+kZA4gj8SyEjM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NeuyHTOiamvLcZ4jApB9YDRQusntLFr2r/lu5Tk1H1gMWopavucWrjgRlG9upn5G/UWV5tNtTRiP4a3sfiG06B2ZAnRYbwxN/5u9Pv8yx2RNbv6X21l5ehdEXspsdLtXqG1XHGZyPWbAXA09iA9dePiUv34wbicAAHO628ZPS3I=
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
Subject: [PATCH nf] netfilter: conntrack: clamp maximum hashtable size to INT_MAX
Date: Thu,  9 Jan 2025 13:35:30 +0100
Message-Id: <20250109123532.41768-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250109123532.41768-1-pablo@netfilter.org>
References: <20250109123532.41768-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to 0708a0afe291 ("mm: Consider __GFP_NOWARN flag for oversized
kvmalloc() calls"), use INT_MAX as maximum size for the conntrack
hashtable. Otherwise, it is possible to hit WARN_ON_ONCE in
__kvmalloc_node_noprof() when __GFP_NOWARN flag is unset when resizing.

Note: hashtable resize is only possible from init_netns.

Fixes: 9cc1c73ad666 ("netfilter: conntrack: avoid integer overflow when resizing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8666d733b984..7f8b245e287a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2510,12 +2510,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	struct hlist_nulls_head *hash;
 	unsigned int nr_slots, i;
 
-	if (*sizep > (UINT_MAX / sizeof(struct hlist_nulls_head)))
+	if (*sizep > (INT_MAX / sizeof(struct hlist_nulls_head)))
 		return NULL;
 
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
 
+	if (nr_slots > (INT_MAX / sizeof(struct hlist_nulls_head)))
+		return NULL;
+
 	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);
 
 	if (hash && nulls)
-- 
2.30.2

