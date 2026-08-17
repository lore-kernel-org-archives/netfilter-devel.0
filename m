Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F13F4125;
	Mon, 17 Aug 2026 23:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009412; cv=none; b=G50e3Yj+sFL2KYgniJ4GxBFn9KflFJRAxAiqy4YxDfTGO/2/22FcPnrrRu0zdS2+UNoLBBI4ZACyp4DcRZ2paenA/Ter2AvXEHpgSR2WaDowbfEPiGzPNbsj4pV58D32UZ0ah1Zx3Br3j0JKO3LlsQz+lHTvAWCk5D6ShEJn9B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009412; c=relaxed/simple;
	bh=zpA6D/eY0cL9fMXBNXOYNF5uuXOypucqAW/eQr6T9w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1MqQpGbuk2Bry8Rrv+Hyo+iUdfASHui+NQxrLVsI5fsPAOuKNNh5uS96C1SyfaQx8rtC/41UTdGLPNiC17Q3kG/+BMFxD0RE2cfTZHG8KBWuOvWxlN6ivvsBKKb+Xcy5qHFEG9RvucYMQTrMLxaHgJxHg5FptSqtShzIxLSl4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AfpTxoBY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AfpTxoBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009408;
	bh=9/56w0Btqn1fjd33vy5mdxnog5RAMVHg6Ehzt98RYmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfpTxoBYEi0CIF358Sz4e2mnANelp61oAoF8LLHhFXL3I7pb1wAAC2ltw6PrOJ0/6
	 MuQb7QLy+pLLqXLiUCr/GrAFkJsR8EzQTmmGmgLkQYVUyWRmvmgveqG6xALqZ338kb
	 Pg4xdYwIChQqvDuHChUtuqlQPXcUp5M0b26YMpwFhQe1oLjahxolocjX6A1oAFa89G
	 nosFlvlpHlrhAZ/tR9y4DZtCamEwAQEjrSmEsnHOY+lUnqh07zcGZHWmzY7vpnOLpj
	 rY0wkat8GQBKQO7M7+NljsNVCbuqDwXYBguuHtaSAuuMZIsDmQ+9ddePljplNcJ65i
	 2lrbczTwW47hg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BF1846008E;
	Tue, 18 Aug 2026 01:30:07 +0200 (CEST)
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
Subject: [PATCH net-next 3/8] netfilter: nf_tables: don't queue packet path object notifications
Date: Tue, 18 Aug 2026 01:29:52 +0200
Message-ID: <20260817232957.1281637-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fourie Zhang <littleddfu@gmail.com>

All file:line references below are against v7.2-rc4 (ac5b0e5651b1). The
trace was captured on 7.2.0-rc6-kasan72rc6 (075b74841bd0), where the same
lines apply.

nft_obj_notify() is exported and reached from the packet path. Its only
in-tree caller is nft_quota_obj_eval() (net/netfilter/nft_quota.c:68),
which notifies with GFP_ATOMIC while evaluating a rule for a transiting
packet, holding no mutex.

Since commit 67cc570edaa0 ("netfilter: nf_tables: coalesce multiple
notifications into one skbuff") that notification is no longer sent
immediately. __nft_obj_notify() queues it onto nft_net->notify_list via
nft_notify_enqueue() (net/netfilter/nf_tables_api.c:1211), which is a bare
list_add_tail(). notify_list has no lock of its own
(include/net/netfilter/nf_tables.h:1951), it is serialised by commit_mutex:
the six other enqueue sites all run inside a netlink transaction, and the
drain in nft_commit_notify() (net/netfilter/nf_tables_api.c:10746) does
list_del() + kfree_skb() from nf_tables_commit() with commit_mutex held.

Sending packets through a chain that references a depleted quota object
therefore races an unlocked list_add_tail() against list_del() +
kfree_skb() on another CPU. The WRITE_ONCE(prev->next, new) in __list_add()
then stores through an sk_buff that has already been freed:

  BUG: KASAN: slab-use-after-free in __nft_obj_notify+0x2c5/0x2d0
  Write of size 8 at addr ff110001047183c0 by task poc/76
  CPU: 0 UID: 1000 PID: 76 Comm: poc Tainted: G  W  7.2.0-rc6-kasan72rc6 #4
  Call Trace:
   <IRQ>
   __nft_obj_notify (include/linux/list.h:164 include/linux/list.h:191
                     net/netfilter/nf_tables_api.c:1211
                     net/netfilter/nf_tables_api.c:8743)
   nft_quota_obj_eval (net/netfilter/nft_quota.c:68)
   nft_do_chain_inet
   nf_hook_slow
   __ip_local_out
   ip_push_pending_frames
   udp_send_skb
   udp_sendmsg
   __x64_sys_sendto

  Allocated by task 77:
   __alloc_skb (net/core/skbuff.c:704)
   __nft_obj_notify (include/net/netlink.h:1055
                     net/netfilter/nf_tables_api.c:8731)
   nft_quota_obj_eval (net/netfilter/nft_quota.c:68)
   nft_do_chain

  Freed by task 79:
   nf_tables_commit (include/linux/skbuff.h:1332
                     net/netfilter/nf_tables_api.c:10759
                     net/netfilter/nf_tables_api.c:11185)
   nfnetlink_rcv_batch (net/netfilter/nfnetlink.c:574)
   netlink_unicast
   netlink_sendmsg

  The buggy address belongs to the cache skbuff_head_cache of size 232

Queueing from the packet path is wrong even leaving the race aside:
notify_list is only drained by nft_commit_notify() from nf_tables_commit()
(:11185), so a notification enqueued outside a transaction is not sent
until some later netlink batch commits, if one ever does.

The gfp argument that nft_obj_notify() still takes is a leftover of the
pre-67cc570edaa0 behaviour, where this path called nfnetlink_send()
directly. Restore that: split the message construction out into
nft_obj_notify_alloc() and let each caller decide what to do with the skb.
nft_obj_notify(), the exported one reached from the packet path, sends it
straight away; nf_tables_obj_notify(), which runs under commit_mutex, keeps
queueing it, so transaction notifications are still coalesced.

Fixes: 67cc570edaa0 ("netfilter: nf_tables: coalesce multiple notifications into one skbuff")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Assisted-by: tencentos-corvus-ai:kimi-k3
Signed-off-by: Fourie Zhang <fouriezhang@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 36 ++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index af357f6c5070..3a7c8f7a6304 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8715,18 +8715,17 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 	return nft_delobj(&ctx, obj);
 }
 
-static void
-__nft_obj_notify(struct net *net, const struct nft_table *table,
-		 struct nft_object *obj, u32 portid, u32 seq, int event,
-		 u16 flags, int family, int report, gfp_t gfp)
+static struct sk_buff *
+nft_obj_notify_alloc(struct net *net, const struct nft_table *table,
+		     struct nft_object *obj, u32 portid, u32 seq, int event,
+		     u16 flags, int family, int report, gfp_t gfp)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct sk_buff *skb;
 	int err;
 
 	if (!report &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return;
+		return NULL;
 
 	skb = nlmsg_new(NLMSG_GOODSIZE, gfp);
 	if (skb == NULL)
@@ -8740,10 +8739,10 @@ __nft_obj_notify(struct net *net, const struct nft_table *table,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, report, &nft_net->notify_list);
-	return;
+	return skb;
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
+	return NULL;
 }
 
 void nft_obj_notify(struct net *net, const struct nft_table *table,
@@ -8752,6 +8751,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 {
 	char *buf = kasprintf(gfp, "%s:%u",
 			      table->name, nft_base_seq(net));
+	struct sk_buff *skb;
 
 	audit_log_nfcfg(buf,
 			family,
@@ -8762,17 +8762,27 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 			gfp);
 	kfree(buf);
 
-	__nft_obj_notify(net, table, obj, portid, seq, event,
-			 flags, family, report, gfp);
+	/* Called from the packet path, holding no mutex: notify_list is
+	 * serialised by commit_mutex, so send this notification directly.
+	 */
+	skb = nft_obj_notify_alloc(net, table, obj, portid, seq, event,
+				   flags, family, report, gfp);
+	if (skb)
+		nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
 }
 EXPORT_SYMBOL_GPL(nft_obj_notify);
 
 static void nf_tables_obj_notify(const struct nft_ctx *ctx,
 				 struct nft_object *obj, int event)
 {
-	__nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
-			 ctx->seq, event, ctx->flags, ctx->family,
-			 ctx->report, GFP_KERNEL);
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	struct sk_buff *skb;
+
+	skb = nft_obj_notify_alloc(ctx->net, ctx->table, obj, ctx->portid,
+				   ctx->seq, event, ctx->flags, ctx->family,
+				   ctx->report, GFP_KERNEL);
+	if (skb)
+		nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 }
 
 /*
-- 
2.47.3

