Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2C21DFF0
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 12:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755262577; cv=none; b=dYD2KAwmExXKgYaE4o47dYR5gozUTSlNE4tAaXB+NYVmVM45jwz8B0zFhkg7yl4kcJT5G8FfoOvqVHfMat/pfaximxZh7iBJyy5PmXfOBxRFnCQpfB7mSK5FX2INReY4DSWdm1QEBskMSqZGppK/LrCN1X94T1kPJ7a6beKCcQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755262577; c=relaxed/simple;
	bh=tzS7FgTyPEZc6VzZTvwaqRXlfD1wXVpjq/6L6QYUDMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s2IxiRjpgrakx2u1O9lyAFWQBmTW7G1pMc2v2rGnkygyFKne31KygkiPLRWZ2UPRTb+2cuqrPveEUkIjlb05aSSEr42fHI7xB7w4IGo3PsgsWkZrEi3DA9Kxjti7wlW6u98IETzepXvLbHotWTVssPRbL8Addmy9e9qaMbjl4C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 75487605B5; Fri, 15 Aug 2025 14:56:06 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [nf-next v2] netfilter: ctnetlink: remove refcounting in dying list dumping
Date: Fri, 15 Aug 2025 14:55:49 +0200
Message-ID: <20250815125555.1791-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to keep the object alive via refcount, use a cookie and
then use that as the skip hint for dump resumption.

Unlike the two earlier, similar patches in this file, this is a cleanup
without intended side effects.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: place variable declaration in ifdef, else warning (kbuild robot)

 net/netfilter/nf_conntrack_netlink.c | 39 +++++++---------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 50fd6809380f..3a04665adf99 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -60,7 +60,7 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("List and change connection tracking table");
 
 struct ctnetlink_list_dump_ctx {
-	struct nf_conn *last;
+	unsigned long last_id;
 	unsigned int cpu;
 	bool done;
 };
@@ -1733,16 +1733,6 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
 	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 }
 
-static int ctnetlink_done_list(struct netlink_callback *cb)
-{
-	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
-
-	if (ctx->last)
-		nf_ct_put(ctx->last);
-
-	return 0;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 				    struct netlink_callback *cb,
@@ -1757,11 +1747,11 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 	if (l3proto && nf_ct_l3num(ct) != l3proto)
 		return 0;
 
-	if (ctx->last) {
-		if (ct != ctx->last)
+	if (ctx->last_id) {
+		if (ctnetlink_get_id(ct) != ctx->last_id)
 			return 0;
 
-		ctx->last = NULL;
+		ctx->last_id = 0;
 	}
 
 	/* We can't dump extension info for the unconfirmed
@@ -1775,12 +1765,8 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 				  cb->nlh->nlmsg_seq,
 				  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 				  ct, dying, 0);
-	if (res < 0) {
-		if (!refcount_inc_not_zero(&ct->ct_general.use))
-			return 0;
-
-		ctx->last = ct;
-	}
+	if (res < 0)
+		ctx->last_id = ctnetlink_get_id(ct);
 
 	return res;
 }
@@ -1796,10 +1782,10 @@ static int
 ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
-	struct nf_conn *last = ctx->last;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	const struct net *net = sock_net(skb->sk);
 	struct nf_conntrack_net_ecache *ecache_net;
+	unsigned long last_id = ctx->last_id;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 #endif
@@ -1807,7 +1793,7 @@ ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 	if (ctx->done)
 		return 0;
 
-	ctx->last = NULL;
+	ctx->last_id = 0;
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	ecache_net = nf_conn_pernet_ecache(net);
@@ -1818,24 +1804,21 @@ ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 		int res;
 
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (last && last != ct)
+		if (last_id && last_id != ctnetlink_get_id(ct))
 			continue;
 
 		res = ctnetlink_dump_one_entry(skb, cb, ct, true);
 		if (res < 0) {
 			spin_unlock_bh(&ecache_net->dying_lock);
-			nf_ct_put(last);
 			return skb->len;
 		}
 
-		nf_ct_put(last);
-		last = NULL;
+		last_id = 0;
 	}
 
 	spin_unlock_bh(&ecache_net->dying_lock);
 #endif
 	ctx->done = true;
-	nf_ct_put(last);
 
 	return skb->len;
 }
@@ -1847,7 +1830,6 @@ static int ctnetlink_get_ct_dying(struct sk_buff *skb,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_dump_dying,
-			.done = ctnetlink_done_list,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
@@ -1862,7 +1844,6 @@ static int ctnetlink_get_ct_unconfirmed(struct sk_buff *skb,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_dump_unconfirmed,
-			.done = ctnetlink_done_list,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
-- 
2.49.1

