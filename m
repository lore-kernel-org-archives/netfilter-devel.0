Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEEC42F70D;
	Fri, 18 Sep 2026 11:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730936; cv=none; b=iPB68Cftb7wshdYEhs4IuCB3xloodg5aijcrtGMdqLBiwwX/Hter95SEW3SA2Dgb807euQJt9gT9gwuZJZAF2wUXRdpVapp7DeWGCFWt/vzG58JnYRdk3rtc+4j+VPopJkVtvySIq8RkuoE8LUP4Dc1P46yrqYZixf0z2CsypFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730936; c=relaxed/simple;
	bh=ss13MxwnGIx1g3X9fTYg5DYEkxDbZYEtajlyIUkHZKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKNIujm4QCP5ld01a9+lU9hociZgC4Xtpe9rqMtMQvZBdfXjq7DtIre+e3MuTOw+TqHRLZXO4AN87GKwAt7gjP57ei4eHPPlR8Y5rRgsAlJt7S5f2dn602fdS0BOQIY3+FOikDyzdPTlSS+RXGoH/V+ehcFpyFY/e4l7+cRpCfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UwFKbZiB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UwFKbZiB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730932;
	bh=/22HIQY5PgEk9H1q86B9JJ7/MyzfiEVxP7YLBHcOcIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwFKbZiBPyrDp1xWq1mgHCcJTy9iVwi2AVJb/RdJSykQdM/1S+ShZP2QhfeaOjCKn
	 qM/5kFf/tSoA0/B6m3+hhZRucLU0o5LA709aT1IvBZFZMP0fI6266pYk3QYpQniUnp
	 iVI9HEyEQfzAC9P0c4UudFz4hubOW7SsAsGdQIfSh9pX2+xqL66Q8iVlwOky2MWgnH
	 wnrh4aoyYy6uutFQNtHZYeonnobDTZ7EGvKNnVXD0CuHov9weS5dXnwrj2HzT3i6nS
	 MRceX9l8kpifxtCgtoA+WdPWXZZxT09EJKXEFUVy5/Y6tvUBDZZThUkf1rwgFyKU94
	 +klQcOUaJ+rGQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EB31060076;
	Fri, 18 Sep 2026 13:28:51 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 2/8] netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
Date: Fri, 18 Sep 2026 13:28:38 +0200
Message-ID: <20260918112844.194503-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918112844.194503-1-pablo@netfilter.org>
References: <20260918112844.194503-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.47.3

