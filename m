Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF894C69
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 16:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707238700; cv=none; b=a6rR+QENoQySl6eJzMx/aWUa9mI0s7Pq4iPxI7U1euLF90PjkvDGhZcZyTyr6sw49Xk8QoByyeTygYTGAGXz1Q3AH9B3qnPNzprK54BkiJ3nZR4i+7G5xZslmwNl5WNnwrv6gasWF4aV54zmlMKxLkS4v8HhY2ntevsfjowHJtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707238700; c=relaxed/simple;
	bh=K257pKnGiKQX6rLq6YMYfiTBQV/3SzFJxxBIXI7ZguQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tQTgGb2v9Q6sxHtCz2hbJK7hONtuFNCWm5YJsazrmfW2QHU5cMompDaP3p9wMx2EOaPeS8WeNnUNI1anZ305E4kLoh/CrETE6Xh2nbYLliIHyMDFY6p/OZ3ymctJvbVSl7yl9m1hC8C0ldnyNEjRC55dQFFVxPDmsiRYy6JWZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rXOm0-0003xw-5w; Tue, 06 Feb 2024 17:58:16 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	l.6diay@passmail.com
Subject: [PATCH nf] netfilter: nfnetlink_queue: un-break NF_REPEAT
Date: Tue,  6 Feb 2024 17:54:18 +0100
Message-ID: <20240206165421.30675-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only override userspace verdict if the ct hook returns something
other than ACCEPT.

Else, this replaces NF_REPEAT (run all hooks again) with NF_ACCEPT
(move to next hook).

Fixes: 6291b3a67ad5 ("netfilter: conntrack: convert nf_conntrack_update to netfilter verdicts")
Reported-by: l.6diay@passmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 171d1f52d3dd..5cf38fc0a366 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -232,18 +232,25 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	if (verdict == NF_ACCEPT ||
 	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
+		unsigned int ct_verdict = verdict;
+
 		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
 		if (ct_hook)
-			verdict = ct_hook->update(entry->state.net, entry->skb);
+			ct_verdict = ct_hook->update(entry->state.net, entry->skb);
 		rcu_read_unlock();
 
-		switch (verdict & NF_VERDICT_MASK) {
+		switch (ct_verdict & NF_VERDICT_MASK) {
+		case NF_ACCEPT:
+			/* follow userspace verdict, could be REPEAT */
+			break;
 		case NF_STOLEN:
 			nf_queue_entry_free(entry);
 			return;
+		default:
+			verdict = ct_verdict & NF_VERDICT_MASK;
+			break;
 		}
-
 	}
 	nf_reinject(entry, verdict);
 }
-- 
2.43.0

