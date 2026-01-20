Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0883477E52;
	Tue, 20 Jan 2026 19:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936695; cv=none; b=R8QGKCoy2TBW08OLCCLTtufSoWfVIfmUkO3ShP+xNsO8zBqnBOCDjBkH1ZJXJVVgnjKLxFG1HFBINqLqhZEtseP+Zc5p2f4USEJAU2CKfBGeuTYnxHuew43f/YuYZ0xJNvWoMxCkiF8OKdKfhDkeUAAeq/QtS1mXnD00uUx0AWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936695; c=relaxed/simple;
	bh=eCXB0RWsX+4MLQ7ThLb9Jwejv1CxviNUkA/L+MKp1pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTE/KaR9zCwi1DBekJe1Pn/1Ha5m07dVqA+u/aYZFeedmDzN8YRucqRnFaX3ivqSFUOOzBnGDr+JA7qUlarqHYVr5P0olCQfvoyg4K/OmRKY3pjx1mnP1kpbGNU0aaY+rvYd2dNiKHEKaFudUg96nYfpAA2Kvj2WXBOpli6NwxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9F2FB602AB; Tue, 20 Jan 2026 20:18:11 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 01/10] netfilter: nf_tables: reset table validation state on abort
Date: Tue, 20 Jan 2026 20:17:54 +0100
Message-ID: <20260120191803.22208-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120191803.22208-1-fw@strlen.de>
References: <20260120191803.22208-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a transaction fails the final validation in the commit hook, the table
validation state is changed to NFT_VALIDATE_DO and a replay of the batch is
performed.  Every rule insert will then do a graph validation.

This is much slower, but provides better error reporting to the user
because we can point at the rule that introduces the validation issue.

Without this reset the affected table(s) remain in full validation mode,
i.e. on next transaction we start with slow-mode.

This makes the next transaction after a failed incremental update very slow:

 # time iptables-restore < /tmp/ruleset
 real    0m0.496s [..]
 # time iptables -A CALLEE -j CALLER
 iptables v1.8.11 (nf_tables):  RULE_APPEND failed (Too many links): rule in chain CALLEE
 real    0m0.022s [..]
 # time iptables-restore < /tmp/ruleset
 real    1m22.355s [..]

After this patch, 2nd iptables-restore is back to ~0.5s.

Fixes: 9a32e9850686 ("netfilter: nf_tables: don't write table validation state without mutex")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 729a92781a1a..027bab30c238 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11536,6 +11536,13 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	ret = __nf_tables_abort(net, action);
 	nft_gc_seq_end(nft_net, gc_seq);
 
+	if (action == NFNL_ABORT_NONE) {
+		struct nft_table *table;
+
+		list_for_each_entry(table, &nft_net->tables, list)
+			table->validate_state = NFT_VALIDATE_SKIP;
+	}
+
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
 
 	/* module autoload needs to happen after GC sequence update because it
-- 
2.52.0

