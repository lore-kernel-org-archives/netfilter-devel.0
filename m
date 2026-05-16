Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A345F3E0228;
	Sat, 16 May 2026 11:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932610; cv=none; b=DrglpSf9p/eat2HskdczTAmMTRDk1h2LF6q21e6aGfMBFlXMrSBFjsfA9qtmWBIEZPiDtLj06M+He6nws19pVMJr1zIisOwLmle7/WqnWNk1noJLsXsdnGAzVn6B/ZN0ZdJ2QcPfwC4r60yJrhM2ZhGiN/M9uBz5ztnXamh1MB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932610; c=relaxed/simple;
	bh=/mCwhYllecjs8nxYKsXlYlbNilMQRl4qLivhwgvteEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sT1gN/Qcy/NZ+IdTMLT7aRCkbaFCO+R4bm3uNoI/B02S2AX2DjqcWRs/QOA/5LHTMMLwa+WNpoSkWdknv3lrG8MRfC2yMDO6dCB+pY1E9akAckt0eguhSYVllRSSJHVJ13NEsy7VNiqLsB/rKLuR0mDO4D5lXBxF0L9WmvLcYHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=evR4PXHq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="evR4PXHq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9960D601A2;
	Sat, 16 May 2026 13:56:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932607;
	bh=gVHsNnzVjJ5CQ6vEFP7KwWXCZ1KRueCIiThEVTDS+9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evR4PXHqiCx3fYjbVH0YKmiOxDO98AfpwzkEj1LTfR2nP3vplIEohq3hyfFVdn/7/
	 HfwoFklSjX4mj9bLVuk/9Pf+LCIdTm29EPHZwvn3Yh9ajG6AOJWJj3+kV4VvQF951b
	 rrQSxZzjNvZSbXO+3ZBmWyIqoZp+JBiPxX99hwFnGxGH3i4iDRqGg8snisMxF/J09J
	 UeXgVPAZHPw6kaRzfWpHQ4nH2nw6DclaFxs3nH9eCqiot4EndJSZjaKVpRY/w8kky5
	 bZjWjiAnrtGOmVDOp4iv8cP1hUJ0OBwtz4MsjLGUvc1xK0nO7GOlmuYhDjzyZpqqNx
	 Cl6xkOx/SFT2g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/12] netfilter: nf_queue: hold bridge skb->dev while queued
Date: Sat, 16 May 2026 13:56:27 +0200
Message-ID: <20260516115627.967773-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haoze Xie <royenheart@gmail.com>

br_pass_frame_up() rewrites skb->dev from the ingress port to the bridge
master before queueing bridge LOCAL_IN packets. NFQUEUE only holds
references on state.in/out and bridge physdevs, so a queued bridge
packet can retain a freed bridge master in skb->dev until reinjection.

When the verdict is reinjected later, br_netif_receive_skb() re-enters
the receive path with skb->dev still pointing at the freed bridge master,
triggering a use-after-free.

Store skb->dev in the queue entry, hold a reference on it for the queue
lifetime, and use the saved device when dropping queued packets during
NETDEV_DOWN handling.

Fixes: ac2863445686 ("netfilter: bridge: add nf_afinfo to enable queuing to userspace")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_queue.h | 1 +
 net/netfilter/nf_queue.c         | 4 +++-
 net/netfilter/nfnetlink_queue.c  | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index d17035d14d96..3978c3174cdb 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -14,6 +14,7 @@ struct nf_queue_entry {
 	struct list_head	list;
 	struct rhash_head	hash_node;
 	struct sk_buff		*skb;
+	struct net_device	*skb_dev;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a6c81c04b3a5..57b450024a99 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -61,6 +61,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	struct nf_hook_state *state = &entry->state;
 
 	/* Release those devices we held, or Alexey will kill me. */
+	dev_put(entry->skb_dev);
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
@@ -102,6 +103,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
 		return false;
 
+	dev_hold(entry->skb_dev);
 	dev_hold(state->in);
 	dev_hold(state->out);
 
@@ -202,11 +204,11 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
+		.skb_dev = skb->dev,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
 	};
-
 	__nf_queue_entry_init_physdevs(entry);
 
 	if (!nf_queue_entry_get_refs(entry)) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 58304fd1f70f..984a0eb9e149 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1212,6 +1212,8 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
 #endif
+	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
+		return 1;
 	if (entry->state.in)
 		if (entry->state.in->ifindex == ifindex)
 			return 1;
-- 
2.47.3

