Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8526958108
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707835350; cv=none; b=XgJUU1sDYkNp51xbYP+LF+OHeXHxyTqnHjr+aqm0x6b1pcbpdlgGSiKgEtCA9aHRUQV7dmEjgZ7eMxKHIhqnyKAJ2ynEROFhB7dmrrssosgp3wbR6oQiSkpjcXAsHe8RiWOf/sq2lymIpfrJIK0Jg1rZ1JQRfCj9rqECxMQQj+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707835350; c=relaxed/simple;
	bh=ty2pF88p1C5QOc8+OIJEsBjwuSHC9uBY1W3bcwOIdyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOMQPS9zHhSLNbgnoDqmA80dxFuYw7tqrsP6qHB2pP//WSjQFFOPsSVXFFCPlu4vUdfP/FWQ5PcVSU2OyZqZlmntmtZ0Ws4pvvJYr/VzylC9nrbe6Derv8UcPQ32Qs84V+pMKoUNoPTEPBZH7SxRdaqaYov7SO8X2bg79mwyL2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rZtzP-0000LH-5X; Tue, 13 Feb 2024 15:42:27 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 2/4] netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
Date: Tue, 13 Feb 2024 16:23:38 +0100
Message-ID: <20240213152345.10590-3-fw@strlen.de>
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

pipapo relies on kmalloc(0) returning ZERO_SIZE_PTR (i.e., not NULL
but pointer is invalid).

Rework this to not call slab allocator when we'd request a 0-byte
allocation.

While at it, also use GFP_KERNEL allocations here, this is only called
from control plane.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: reformat long lines, no other changes

 net/netfilter/nft_set_pipapo.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index dedb17a4e07c..87bfbae8a560 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -525,14 +525,16 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 	int i;
 
 	m = priv->clone;
+	if (m->bsize_max == 0)
+		return ret;
 
-	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
+	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_KERNEL);
 	if (!res_map) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
-	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
+	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_KERNEL);
 	if (!fill_map) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out;
@@ -1367,11 +1369,17 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
-		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
-		if (!dst->mt)
-			goto out_mt;
+		if (src->rules > 0) {
+			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
+						 GFP_KERNEL);
+			if (!dst->mt)
+				goto out_mt;
+
+			memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
+		} else {
+			dst->mt = NULL;
+		}
 
-		memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
 		src++;
 		dst++;
 	}
-- 
2.43.0

