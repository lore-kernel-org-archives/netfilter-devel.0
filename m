Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8282A29ACDD
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Jan 2026 13:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767620846; cv=none; b=gaqCE7jh/4uolyuOJJ0rJKwXyc7OPngEdWU7SyC7Yje2g2eyA/9yq8Yk/i8v2HwMs9wBzqG6tyd5EwloDJs9c0PgYdqjo4oflst74cu2ijAswKk90Wkz9j4pir8vSpMa0j1Y79wq9CJ1VbzAQPkdw7/y+u1Y0B1J48nS8n6F1Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767620846; c=relaxed/simple;
	bh=SRfj9g9zZmMDMTQKiSyPllARiQ9U/qaY+4NDMlv7zBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q3qMIDOKs6vFaM74FXdUAJKD1oS9eMxfu4eYaxG+6rRDW2cIS8PuNNGEU39t9nyv4VLhmd2n+b5iK8zIxtfuiVY2dD8k4d/ZT5/FHm7hv/ZonrqBLwyBpn/PF3K8PEfzU/eAOWbIgtDSz6Il/p4KOFyM2+G5ydNFukZBBkaNBOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 62D9A60351; Mon, 05 Jan 2026 14:47:18 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: reset table validation state on abort
Date: Mon,  5 Jan 2026 14:47:10 +0100
Message-ID: <20260105134713.22944-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
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
 #time iptables-restore < /tmp/xxx
 real    1m22.355s [..]

After this patch, 2nd iptables-restore is back to ~0.5s.

Fixes: 9a32e9850686 ("netfilter: nf_tables: don't write table validation state without mutex")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 618af6e90773..e76af31f6a61 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11535,6 +11535,13 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
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

