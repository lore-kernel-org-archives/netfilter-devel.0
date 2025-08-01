Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914F22737E2
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754061937; cv=none; b=b9j3PpctS61eB9fjcxJJ5TXOJ8dlx13iRYrUs/EZlvD4EYadrX8maUbHGNZcidup7ebQBShQ8Z06xrOtJuPBjrm+RUBl2YcXRVjwEqa9iGSYv9Qp+6OwhJRCkp6BLj+xDEFcGjCycRLkl/4Oc22WuAlwNfhtboR6pI9wX+Y4/E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754061937; c=relaxed/simple;
	bh=3DqFxqhWbaOBh3ACNFn+PQngEV2YCWeZoK5unYmhnoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8xW8PDpWoh937BTcA5bEKm+fhBIXZx8Xp9iOY2cXMWdRry2wCqfI6YUPlFo6CUGDo6Z0ij174mFM5TUcGXHHyrGEH8+K08k3nvnjN9wH8xcONWrcP0vWKUfKa9grsozqUW6xfnKhwYKNjiscFr8FIzt6CUhgrSYiWxdLQI3BVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 303F4602A8; Fri,  1 Aug 2025 17:25:28 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: ctnetlink: fix refcount leak on table dump
Date: Fri,  1 Aug 2025 17:25:08 +0200
Message-ID: <20250801152515.20172-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250801152515.20172-1-fw@strlen.de>
References: <20250801152515.20172-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a reference count leak in ctnetlink_dump_table():
      if (res < 0) {
                nf_conntrack_get(&ct->ct_general); // HERE
                cb->args[1] = (unsigned long)ct;
                ...

While its very unlikely, its possible that ct == last.
If this happens, then the refcount of ct was already incremented.
This 2nd increment is never undone.

This prevents the conntrack object from being released, which in turn
keeps prevents cnet->count from dropping back to 0.

This will then block the netns dismantle (or conntrack rmmod) as
nf_conntrack_cleanup_net_list() will wait forever.

This can be reproduced by running conntrack_resize.sh selftest in a loop.
It takes ~20 minutes for me on a preemptible kernel on average before
I see a runaway kworker spinning in nf_conntrack_cleanup_net_list.

One fix would to change this to:
        if (res < 0) {
		if (ct != last)
	                nf_conntrack_get(&ct->ct_general);

But this reference counting isn't needed in the first place.
We can just store a cookie value instead.

A followup patch will do the same for ctnetlink_exp_dump_table,
it looks to me as if this has the same problem and like
ctnetlink_dump_table, we only need a 'skip hint', not the actual
object so we can apply the same cookie strategy there as well.

Fixes: d205dc40798d ("[NETFILTER]: ctnetlink: fix deadlock in table dumping")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2cc0fde23344..5fdcae45e0bc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -884,8 +884,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
-	if (cb->args[1])
-		nf_ct_put((struct nf_conn *)cb->args[1]);
 	kfree(cb->data);
 	return 0;
 }
@@ -1208,19 +1206,26 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	return 0;
 }
 
+static unsigned long ctnetlink_get_id(const struct nf_conn *ct)
+{
+	unsigned long id = nf_ct_get_id(ct);
+
+	return id ? id : 1;
+}
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	unsigned int flags = cb->data ? NLM_F_DUMP_FILTERED : 0;
 	struct net *net = sock_net(skb->sk);
-	struct nf_conn *ct, *last;
+	unsigned long last_id = cb->args[1];
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	struct nf_conn *nf_ct_evict[8];
+	struct nf_conn *ct;
 	int res, i;
 	spinlock_t *lockp;
 
-	last = (struct nf_conn *)cb->args[1];
 	i = 0;
 
 	local_bh_disable();
@@ -1257,7 +1262,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (cb->args[1]) {
-				if (ct != last)
+				if (ctnetlink_get_id(ct) != last_id)
 					continue;
 				cb->args[1] = 0;
 			}
@@ -1270,8 +1275,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 					    ct, true, flags);
 			if (res < 0) {
-				nf_conntrack_get(&ct->ct_general);
-				cb->args[1] = (unsigned long)ct;
+				cb->args[1] = ctnetlink_get_id(ct);
 				spin_unlock(lockp);
 				goto out;
 			}
@@ -1284,12 +1288,10 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 out:
 	local_bh_enable();
-	if (last) {
+	if (last_id) {
 		/* nf ct hash resize happened, now clear the leftover. */
-		if ((struct nf_conn *)cb->args[1] == last)
+		if (cb->args[1] == last_id)
 			cb->args[1] = 0;
-
-		nf_ct_put(last);
 	}
 
 	while (i) {
-- 
2.49.1

