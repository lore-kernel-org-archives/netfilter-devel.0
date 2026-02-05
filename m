Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14E35CBA4;
	Thu,  5 Feb 2026 07:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770277500; cv=none; b=l797pz6KO2v6Ts36289fHCnugpggHW4nZgmDqFJVNwjb9oSqAXXtVfI9GZ33hofwLeC/VU7OAsfBKpJ+9nnBP8ZxvwkmAjA4zfSpg1g6JnrVSENESaBixed9/YJRXj5U/VtqcqDcVg/wtJfRW7h1Q5Zrcx5GjUt4BryewG+GkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770277500; c=relaxed/simple;
	bh=PINlY56spVHNc0oamXzReG/1YHpa5H6b2gP5bwpJxLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5pfrQM+MtXf95vfzvyBTgGnsSOkuLEmIn3/tFwmas9ygQ0PFGIzU0lzT/MKKzoNUQkm+fR9Wp/vHLKIX7y4IWbMVt6eqY1SWRfx+HuVMAKjdOkAcGiIx6ioyHsh68zPZV/deTqMj8tH6mbSeOGfUk/w2RTEoMSTnUkzBPubLR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 07AEA6090B; Thu, 05 Feb 2026 08:44:59 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/1] netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate()
Date: Thu,  5 Feb 2026 08:44:50 +0100
Message-ID: <20260205074450.3187-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205074450.3187-1-fw@strlen.de>
References: <20260205074450.3187-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Fasano <andrew.fasano@nist.gov>

nft_map_catchall_activate() has an inverted element activity check
compared to its non-catchall counterpart nft_mapelem_activate() and
compared to what is logically required.

nft_map_catchall_activate() is called from the abort path to re-activate
catchall map elements that were deactivated during a failed transaction.
It should skip elements that are already active (they don't need
re-activation) and process elements that are inactive (they need to be
restored). Instead, the current code does the opposite: it skips inactive
elements and processes active ones.

Compare the non-catchall activate callback, which is correct:

  nft_mapelem_activate():
    if (nft_set_elem_active(ext, iter->genmask))
        return 0;   /* skip active, process inactive */

With the buggy catchall version:

  nft_map_catchall_activate():
    if (!nft_set_elem_active(ext, genmask))
        continue;   /* skip inactive, process active */

The consequence is that when a DELSET operation is aborted,
nft_setelem_data_activate() is never called for the catchall element.
For NFT_GOTO verdict elements, this means nft_data_hold() is never
called to restore the chain->use reference count. Each abort cycle
permanently decrements chain->use. Once chain->use reaches zero,
DELCHAIN succeeds and frees the chain while catchall verdict elements
still reference it, resulting in a use-after-free.

This is exploitable for local privilege escalation from an unprivileged
user via user namespaces + nftables on distributions that enable
CONFIG_USER_NS and CONFIG_NF_TABLES.

Fix by removing the negation so the check matches nft_mapelem_activate():
skip active elements, process inactive ones.

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Signed-off-by: Andrew Fasano <andrew.fasano@nist.gov>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 729a92781a1a..be92750e2af3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5914,7 +5914,7 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_set_elem_active(ext, genmask))
+		if (nft_set_elem_active(ext, genmask))
 			continue;
 
 		nft_clear(ctx->net, ext);
-- 
2.52.0

