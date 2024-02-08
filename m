Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1759271B43;
	Thu,  8 Feb 2024 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707391726; cv=none; b=b1REOOiA0N4YzaklJwGenDxntM190FUwbglhGlo7vS3WGfHmBStdwUTNZsoOMGENUIhyLkAkARE00R5q8ZtjpifnY0R3sajZwzNa5mEM1GsDGVefxQ/62HU0dvZ6SaObU2EF9ms/xl+v/mUq8E3tUg+WbgJg9zhaTrY4XGm5bSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707391726; c=relaxed/simple;
	bh=2vGFEgm+Odw4iJi28aG6VmDYDdwp/Qn2xVdSKfnEG9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lkH8ADcKxoWrgGe9CK3U6DUO0ay8VQ9MwH2J7orxrsx8vjJntQWEpqr3VqYw8Cy/i/qfa3K0AvVCjf77+I9Cs/wRY8JXDaVfcXq5/8KSjJd9dy5HauB15mIb0KsljuMOF/UxlKwnnghYRbtwE9msCQIF8VSbZgQfvrsPBDhCcEA=
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
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net 09/13] netfilter: nfnetlink_queue: un-break NF_REPEAT
Date: Thu,  8 Feb 2024 12:28:30 +0100
Message-Id: <20240208112834.1433-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240208112834.1433-1-pablo@netfilter.org>
References: <20240208112834.1433-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Only override userspace verdict if the ct hook returns something
other than ACCEPT.

Else, this replaces NF_REPEAT (run all hooks again) with NF_ACCEPT
(move to next hook).

Fixes: 6291b3a67ad5 ("netfilter: conntrack: convert nf_conntrack_update to netfilter verdicts")
Reported-by: l.6diay@passmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

