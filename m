Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA0A45005
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2024 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733570617; cv=none; b=nYWQPwm1nLzRzIO1+Od4yqxtFDafPxMTd2kTvXjxdsgWgxqDfuI5uq0pwEMcD/dAIy6TVlmyHg5IZrfxVAUwZi4PWsJBUFKNGezbDizV6EgMBTnbG1sa1sjbzmKpOxdrJwGnamBlymQWb11p+4+T86MO3Xf/UKpHqUsMPJwLQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733570617; c=relaxed/simple;
	bh=WQYi7HA4LtlGTisogXMc9gzY2x5FqJftAcb8iTWmu5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBdBrnbvrdYenbt+00NBU5WJZfFA8zQoW/yFUAkMZ21yJ7c1DYngDhYv30k3/nHTHHnGDY5p7+P+4HIT4mZ1UKFwzhXAGA1FRFjfzCdsPNxtX/eZZVb4Ieodz3IDZ+9tYh5MLmM68r9cEvJY2pYHPsDozO+HOXHb5QRQo2x1UC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tJsm8-0002n6-GW; Sat, 07 Dec 2024 12:15:04 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Florian Westphal <fw@strlen.de>,
	syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: do not defer rule destruction via call_rcu
Date: Sat,  7 Dec 2024 12:14:48 +0100
Message-ID: <20241207111459.7191-1-fw@strlen.de>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <67478d92.050a0220.253251.0062.GAE@google.com>
References: <67478d92.050a0220.253251.0062.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 net/netfilter/nf_tables_api.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 21b6f7410a1f..a3b6b6b32f72 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3987,8 +3987,11 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
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
@@ -5757,6 +5760,8 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
 		nft_set_trans_unbind(ctx, set);
@@ -11695,19 +11700,6 @@ static void __nft_release_basechain_now(struct nft_ctx *ctx)
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
@@ -11722,11 +11714,18 @@ int __nft_release_basechain(struct nft_ctx *ctx)
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
2.47.1

