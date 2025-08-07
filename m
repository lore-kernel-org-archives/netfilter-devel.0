Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7432797A5;
	Thu,  7 Aug 2025 11:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566215; cv=none; b=o5sf2ApbexQkum2OQQg82iVH6XKFA3ou9ULNiRKsGimLhzhYLpuqJTg2Z8EmfVmsBRu8uQP3a+20q6gIVGroovch6Q78PvTyCps2/y1bbSsZYWXQfJAlFLwDfE00v/dJZeMuoW3bEWjwZhNoxn/a14aEyLs+Vun6vHG97WBF6/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566215; c=relaxed/simple;
	bh=x1lVdRLos0A+TUBzc9Pk/ANKKiK0fMfMPW2SOqpJDCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ucF4SkJ2UqDdspduxQfiRo/x4hqRbjF8abJxZ9DI9vq6hQnNUdp5mRsLtjaOchWHyNNc1TQgV9+IQtcwHH8AUJ0xoddIxkhtgGrS2pSWuSQbgcb30ss0YT7XSMme2OM9ezwSke9dq2NgkJCryTw1nx+8/ncKKOXvmkcPRcrxpi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BtlcJgJf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gQrVA64v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BtlcJgJf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gQrVA64v"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 63033608E0; Thu,  7 Aug 2025 13:30:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566202;
	bh=srD3Yio0TY5lfrCJaDq1p6/LtFqKQav0PKiqwgQig0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtlcJgJfJ4Y5zr76UHgH2s47zHQIt4PuT0M6YFOKT2vEvrElzztnxT43rGToOglI7
	 QofLK+mBAZBdxBF81wTECSw5oRratCB07aW32Yxi9dw/54SN9lN2oRw+NCL9/kVZoN
	 I4X/7UhNjyG6SE809RfPPXo3M3hjfYruD/kbyMjCUWHVnyRyIkbkpT0XfmW7ijFohV
	 LcM+V20bRZ0VBRWDgCw7kyqncm79UayFPJMyBWOXBuhBrrQxrYBF+08e8boJz1r5yG
	 144//kqugmvF+imVmma4aN1PcagGMtV0b4l8uWwfDVbSKY8SCkMNp8uUCHW6K3MM4U
	 XdYCbI6RA+1mA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 05D0260A6D;
	Thu,  7 Aug 2025 13:29:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566196;
	bh=srD3Yio0TY5lfrCJaDq1p6/LtFqKQav0PKiqwgQig0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQrVA64v3W32B45NEXW9uRsd8GcmE/I3i9B5ZnKHedLpcju0GZqne2MIv1xmG4G5V
	 aZPFPAcBR+LNTSyqnybrCUQzzQ6BC0o+2nYA7Ph/LbVK7mY8kwlaUkwj3WA5y4AssX
	 eoHhGSPJPWmufTH+WHs+36bGtmuGoHC7AXKv31qnC3521pweQuvw/wl6yFMuEaYGzI
	 fnHtuWqPEilzxN01TK88cHIVzHC8TE710Gcs8t1LWUWMJhYIvVHglr/X2TCX9n2vwm
	 HTVcOU+MzcBIIubKCleSEhD2WO3lqkuCR+5DP2vluRYumTFVdZsQaKdclTblafE3U4
	 RXQchPUWTuneg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/7] netfilter: ctnetlink: fix refcount leak on table dump
Date: Thu,  7 Aug 2025 13:29:44 +0200
Message-Id: <20250807112948.1400523-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250807112948.1400523-1-pablo@netfilter.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 486d52b45fe5..f403acd82437 100644
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
2.30.2

