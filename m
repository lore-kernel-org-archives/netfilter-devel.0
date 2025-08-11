Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14AD78C9C
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Aug 2025 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754908293; cv=none; b=HvDjszki3w6kftci4+h/i/hJ+/s9JA8gzcGQyIJVRydl+jiN/aGgpqRSLP0y1QDoPodtkNM6oMf28oODCWdFyr226unKRTPn6/9K1URu1J7tp3XSkjoeibduC9kSx/ZKDZgkKFAU8Uosp52VCxUgMHXVGDMWCREf0ndY8OzLxgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754908293; c=relaxed/simple;
	bh=QOl4Q+iNdDmR3CLmeSe+qR1iv4dsUUzWSBPzuzTwOYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AeZCcuZxXwMiAb7sH0txqrlHToB8qxycXzfh134jw0q628pmj6blFc7Q/BDNJJZxO+LVIDpgMFWKcgYeNSpg/Er7TjDJZOhPvLlheZ/DU44e0yB3GMtf1026o+WW/KoUJd1S/EYnGOzOlhc6W7qxR3wWz1Rpp2IEnPLR77Tm0d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 50B25601B0; Mon, 11 Aug 2025 12:31:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_set_pipapo: fix null deref for empty set
Date: Mon, 11 Aug 2025 12:31:04 +0200
Message-ID: <20250811103118.15299-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Blamed commit broke the check for a null scratch map:
  -  if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
  +  if (unlikely(!raw_cpu_ptr(m->scratch)))

This should have been "if (!*raw_ ...)".
Use the pattern of the avx2 version which is more readable.

This can only be reproduced if avx2 support isn't available.

Fixes: d8d871a35ca9 ("netfilter: nft_set_pipapo: merge pipapo_get/lookup")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 1a19649c2851..601dd5ed0e0c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -426,10 +426,9 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 
 	local_bh_disable();
 
-	if (unlikely(!raw_cpu_ptr(m->scratch)))
-		goto out;
-
 	scratch = *raw_cpu_ptr(m->scratch);
+	if (!scratch)
+		goto out;
 
 	map_index = scratch->map_index;
 
-- 
2.49.1

