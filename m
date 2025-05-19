Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE99217722;
	Mon, 19 May 2025 23:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697693; cv=none; b=ZGMK5pwJvmr1gXONApnf1XdlosDe9OoRto+Aez06Q9Z/TOtRdwHoUHDUZp1xjN2lk/XmXEiu+h/5n+8nIaMwoTJa+gNiv3Y273RMqZnaz4ICJd3jIIJgooEJGxSE0jqUGZUO0+kzER5Id0Q+vKrbWg855+EfHMWGFUx3NrQcicg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697693; c=relaxed/simple;
	bh=fi25jgN3JmCjxwnwXSy/A7cikyEuFE8XYD5KThpBXSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OSR3Dz7e0fVgLTCwW6o/S5xTaiL38mePL3whFLkdkPPQGXk1fLl4iiBddwyDODJkLg7ERXpNFELK8Lij2j9Ov0VK/zob3JVxN/Zb7hBX2O/yBBx2Rnu61rRakzdFLxStpURBD0J7uR3hFLTHkCDgYKd8bNo6EJPbKM7DwQhU67s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=INzMzGrw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SY2lK9DN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="INzMzGrw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SY2lK9DN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 039506029C; Tue, 20 May 2025 01:34:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697690;
	bh=PTS8+OX0RMJKZi/Blyw3MfvJqD5RbXHd+5gYPQgLN8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INzMzGrw8Utv0P+BpUuN5DXZlZ+yc/iK0ixOfE64Jbn7Q7hGOPRZQWa5gn/c+EVRM
	 vMMPqxnTPtVkafN2fb1UcM7b9UWCj15vse65zCDon/gJbLi474WdI179rW8bLwqCtu
	 wT055Mgch/hq24Z2Irlzfk3viX6Is1docoeh/Is4YLt0YZf8yVjBiBR8ZimAFC8f7+
	 B6Am1IVniH4Tu9gIb5howsrnK8rf9HdY9cCIK1Beo5uW2Ytda3nxWz+D7HLBJmK5xz
	 gyu9yzdDmLb/4Q46Dc7X44nu4rlMOPhST8u1w7gQ2OZhVz7KnY+yXgj65TDDxlfAaK
	 0TKL1lP8Tgvaw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 913D06029D;
	Tue, 20 May 2025 01:34:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697688;
	bh=PTS8+OX0RMJKZi/Blyw3MfvJqD5RbXHd+5gYPQgLN8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SY2lK9DNVKoB/g/KomOv0ug1BrYwCxFkJwT+TPITs3vchDLjFgH/GAFs+L1IZSsZJ
	 //Pc7X1FnWl0i5qDVtJSTdpO2ZKLBklFdt+l12kLvALtLkMYEHtH/e+sWPnyBg6Z4T
	 GQ8TED3R5X6orQla2+nXyixrCWXnsJSBohqGott3VbzE64FoJJCwYIUDpEzZ+5jSyg
	 KgdOY/YHyc6P/KX0LOqE1w5CWuJthDFTyXW5XaznUnjJLUidTkCudWOW/QH4beE+3o
	 AaitbqFAFn9ftrBY6PKITROKkvOtkxi1kP8GDpP1jMzy2u79vwwRBGzsk0CPCZPDGx
	 LLPi78PNYX1Wg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1 3/3] netfilter: nf_tables: do not defer rule destruction via call_rcu
Date: Tue, 20 May 2025 01:34:38 +0200
Message-Id: <20250519233438.22640-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250519233438.22640-1-pablo@netfilter.org>
References: <20250519233438.22640-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit b04df3da1b5c6f6dc7cdccc37941740c078c4043 upstream.

nf_tables_chain_destroy can sleep, it can't be used from call_rcu
callbacks.

Moreover, nf_tables_rule_release() is only safe for error unwinding,
while transaction mutex is held and the to-be-desroyed rule was not
exposed to either dataplane or dumps, as it deactives+frees without
the required synchronize_rcu() in-between.

nft_rule_expr_deactivate() callbacks will change ->use counters
of other chains/sets, see e.g. nft_lookup .deactivate callback, these
must be serialized via transaction mutex.

Also add a few lockdep asserts to make this more explicit.

Calling synchronize_rcu() isn't ideal, but fixing this without is hard
and way more intrusive.  As-is, we can get:

WARNING: .. net/netfilter/nf_tables_api.c:5515 nft_set_destroy+0x..
Workqueue: events nf_tables_trans_destroy_work
RIP: 0010:nft_set_destroy+0x3fe/0x5c0
Call Trace:
 <TASK>
 nf_tables_trans_destroy_work+0x6b7/0xad0
 process_one_work+0x64a/0xce0
 worker_thread+0x613/0x10d0

In case the synchronize_rcu becomes an issue, we can explore alternatives.

One way would be to allocate nft_trans_rule objects + one nft_trans_chain
object, deactivate the rules + the chain and then defer the freeing to the
nft destroy workqueue.  We'd still need to keep the synchronize_rcu path as
a fallback to handle -ENOMEM corner cases though.

Reported-by: syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67478d92.050a0220.253251.0062.GAE@google.com/T/
Fixes: c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 ---
 net/netfilter/nf_tables_api.c     | 32 +++++++++++++++----------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 76a51ed432ca..7252a5aae069 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1062,7 +1062,6 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
-	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule_blob		*blob_next;
@@ -1205,7 +1204,6 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
- *	@net: netnamespace this table belongs to
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1221,7 +1219,6 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
-	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index aa1a85eff61b..0bf347a0a1dd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1413,7 +1413,6 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
-	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++nft_net->table_handle;
@@ -3511,8 +3510,11 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 	kfree(rule);
 }
 
+/* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
 }
@@ -5248,6 +5250,8 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
 		nft_set_trans_unbind(ctx, set);
@@ -10674,19 +10678,6 @@ static void __nft_release_basechain_now(struct nft_ctx *ctx)
 	nf_tables_chain_destroy(ctx->chain);
 }
 
-static void nft_release_basechain_rcu(struct rcu_head *head)
-{
-	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
-	struct nft_ctx ctx = {
-		.family	= chain->table->family,
-		.chain	= chain,
-		.net	= read_pnet(&chain->table->net),
-	};
-
-	__nft_release_basechain_now(&ctx);
-	put_net(ctx.net);
-}
-
 int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule;
@@ -10701,11 +10692,18 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
 
-	if (maybe_get_net(ctx->net))
-		call_rcu(&ctx->chain->rcu_head, nft_release_basechain_rcu);
-	else
+	if (!maybe_get_net(ctx->net)) {
 		__nft_release_basechain_now(ctx);
+		return 0;
+	}
+
+	/* wait for ruleset dumps to complete.  Owning chain is no longer in
+	 * lists, so new dumps can't find any of these rules anymore.
+	 */
+	synchronize_rcu();
 
+	__nft_release_basechain_now(ctx);
+	put_net(ctx->net);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__nft_release_basechain);
-- 
2.30.2

