Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C35E28F4;
	Wed, 13 Aug 2025 11:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085097; cv=none; b=TMjLiFisWIhi+0jGCMKGecAMhyIIcS/WH1IX2w5MdboyJdoPCsYojk1x+wvV3uCv73boFZj3CIbOrAk7WmY/kRtqbc3KfQ5lruhZCgR0FvPuXOTkTgjESQLGzyyz0EZtK6z6bPuz+FkzN5iITvO1I95/sxigy0r4u/ewt02opZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085097; c=relaxed/simple;
	bh=3/DkUOj8vBSY9ogz02GE5cDb+Sh+RGgdP4Dq03SelnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWSlRG5fzpAxbGSIToa/fNP5FbYusEVxxkaRNFqQc7hqrRlL5fky3XKKi41z0TgJON82oaYD+tQ8fXg32DbUziLDFl1jgLysaj3dBL7YoOYnxTwy0Rjjn72Uw9DgTkkSMt70WLS+d0e2AWtirWHQ+RLu0CrQ9+uGwu/XnAy7aLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CC14E605F7; Wed, 13 Aug 2025 13:38:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/3] netfilter: nft_set_pipapo: fix null deref for empty set
Date: Wed, 13 Aug 2025 13:36:36 +0200
Message-ID: <20250813113800.20775-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250813113800.20775-1-fw@strlen.de>
References: <20250813113800.20775-1-fw@strlen.de>
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
index 1a19649c2851..9a10251228fd 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -426,10 +426,9 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 
 	local_bh_disable();
 
-	if (unlikely(!raw_cpu_ptr(m->scratch)))
-		goto out;
-
 	scratch = *raw_cpu_ptr(m->scratch);
+	if (unlikely(!scratch))
+		goto out;
 
 	map_index = scratch->map_index;
 
-- 
2.49.1

