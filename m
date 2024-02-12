Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560317C74
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2024 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707733569; cv=none; b=aJsUtwNl9k73dGKwRbuA5okuzEnjHR9aDQ/tb0mHDkAMCeA1zw7XUrnplEPxF3JoeQNtqXyMhQMGxFz2X8HaJHYjDH2aTon2E2lsB4pQdnFLFy71Ay5ZXqHeYa0z7gcnpil2AVC0CpesYP5b1XYz3mwg+4iPU5SrclGjt5rGmas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707733569; c=relaxed/simple;
	bh=q77ORGrFFETKh8OVjrs3ZwpiOnYgVavNNz3FLDprB8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkPIcrAzujlIUR3E0vHwjq2sW+Oh27dLgjlEvgh38hNW0PoblkHFeoS/URG9ZwCnDTjsPSWBSEF5TQpT8/oKQdi8C0LsEHb5sWb7Xg0EPtCu3jTmP3VuOWrYipxnoyIUnFK/cH0kC9va34REvCz81oykpTUYkeFerhvKBfWq3G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rZTVl-0005pY-J6; Mon, 12 Feb 2024 11:26:05 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
Date: Mon, 12 Feb 2024 11:01:51 +0100
Message-ID: <20240212100202.10116-3-fw@strlen.de>
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

pipapo relies on kmalloc(0) returning ZERO_SIZE_PTR (i.e., not NULL
but pointer is invalid).

Rework this to not call slab allocator when we'd request a 0-byte
allocation.

While at it, also use GFP_KERNEL allocations here, this is only called
from control plane.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 395420fa71e5..6a79ec98de86 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -526,13 +526,16 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 	const struct nft_pipapo_field *f;
 	int i;
 
-	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
+	if (m->bsize_max == 0)
+		return ret;
+
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
@@ -1367,11 +1370,16 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
-		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
-		if (!dst->mt)
-			goto out_mt;
+		if (src->rules > 0) {
+			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt), GFP_KERNEL);
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

