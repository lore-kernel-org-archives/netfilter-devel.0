Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D772DCF67
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 01:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787621833; cv=none; b=EjkiPrV68bBv1NrvZBXGggXJnY9v9TLYdAHIVf9DXXWnaYHe3A7yZSLU3qRKJv7OqIGvDCqKaMAgN0ej/7iYRaO1M5EpHAHO1BAsQsCPkOa0IDl76Y8j0DlIlz0AkYsTsL0o31FWWmwOykN61kpPle1f5k5F5YOelKdZX9xry4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787621833; c=relaxed/simple;
	bh=kehOJRs/jI4RTQ43GYo0vCMqwmMgwmZv/vSFIG6Vkug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p8nPsH9mnO4HXsRG2EjoLj7pFz41Via3FR7EJqxibkAstwEgcT+ro/f47LBxf99EFlLDKXqCoVCTxo55Pk2SClO2EMaqNXNQP+qPFe/7GhkkNPQbpF82b52VzCelEhYMzKeMhlLu8VFuj7OvKaRu8s7YhwZNgbASfXtzj5j3pHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 022BF6008A; Tue, 25 Aug 2026 03:37:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
Date: Tue, 25 Aug 2026 03:36:52 +0200
Message-ID: <20260825013652.27505-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We must serialize the release notifier and the config netlink function.
A concurrent thread can issue close() which can call the release function
while unrelated socket processes UNBIND request for same portid:

Oops: general protection fault, [..]
RIP: 0010:__instance_destroy+0x60/0x210 [nfnetlink_queue]
Call Trace:
 nfqnl_recv_config+0x9b0/0xdc0 [nfnetlink_queue]
 nfnetlink_rcv_msg+0x7c2/0xeb0
 ? __pfx_nfnetlink_rcv_msg+0x10/0x10

After this, parallel UNBIND and URELEASE events are impossible.

This change isn't nice, but its the shortest fix given instances
are not refcounted and the nfnetlink config callback drops the
rcu read lock early due to need for sleeping allocations.

Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c727668b0c5b..a3bc00280051 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1593,6 +1593,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
 	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
 		int i;
 
+		nfnl_lock(NFNL_SUBSYS_QUEUE);
 		/* destroy all instances for this portid */
 		spin_lock(&q->instances_lock);
 		for (i = 0; i < INSTANCE_BUCKETS; i++) {
@@ -1606,6 +1607,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
 			}
 		}
 		spin_unlock(&q->instances_lock);
+		nfnl_unlock(NFNL_SUBSYS_QUEUE);
 	}
 	return NOTIFY_DONE;
 }
@@ -1925,9 +1927,9 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 
 	/* Lookup queue under RCU. After peer_portid check (or for new queue
 	 * in BIND case), the queue is owned by the socket sending this message.
-	 * A socket cannot simultaneously send a message and close, so while
-	 * processing this CONFIG message, nfqnl_rcv_nl_event() (triggered by
-	 * socket close) cannot destroy this queue. Safe to use without RCU.
+	 * nfqnl_rcv_nl_event() will block on the nfnl subsys mutex that is
+	 * held by the caller, so the queue cannot be destroyed in parallel,
+	 * even after we drop the RCU read lock.
 	 */
 	rcu_read_lock();
 	queue = instance_lookup(q, queue_num);
-- 
2.54.0

