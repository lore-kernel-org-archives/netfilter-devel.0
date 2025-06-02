Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4512519EEBD;
	Mon,  2 Jun 2025 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875374; cv=none; b=fZ2wdmFNMva2dnOo4OARt3f1xZWndTbqDFA/LOV2P7E3UhHn5yfG20IbyFeAMurZrDtSz8Iof1ldSFtuUrznL7tLLtel2RY+lyTV+Y63NuXwGfpxhhzAxO6HvzvAN/ViwyzGScyifNiRFhFhtWvqTNujHzkt753i/gp/Wvc3z8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875374; c=relaxed/simple;
	bh=UZTrlVEXgCkGAQtTXT87nfZiMahp5c/v2zz8g1mMNgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhNgNCQmy5racpO7rWdDRlgmITwv7pOtS8b/bOeteiyd07IF9yErF3rC/L/o2scYFEVN4Iz4mZkezNsfhxDxM9ZcFO1GwOtRVEsIm7vSUUpBEn/ioYaP04WeZiChA4kTu9RDH58+J46i9vfhMJTBifZg4b3D8z4D1OzTKBUjXWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpPWpJpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpPWpJpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71E2C4CEEB;
	Mon,  2 Jun 2025 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875374;
	bh=UZTrlVEXgCkGAQtTXT87nfZiMahp5c/v2zz8g1mMNgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpPWpJpDVExWWgPxIp5zIkdUbQGTWgMqqnnOsmAv+DI25WfKefdp32sd8iWciVUtq
	 jknuY5DRMAiDJt/FQNzxRmDraL+24P0ktvAcKpWwGG3Mt9A7Dgn3JcAVXlal6aix7e
	 P71QlRqCB5L9CtyhF6W628MiJf/j8K83qiKJ1+fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 114/270] netfilter: nf_tables: do not defer rule destruction via call_rcu
Date: Mon,  2 Jun 2025 15:46:39 +0200
Message-ID: <20250602134311.887199759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    3 ---
 net/netfilter/nf_tables_api.c     |   32 +++++++++++++++-----------------
 2 files changed, 15 insertions(+), 20 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -962,7 +962,6 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
-	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
@@ -1101,7 +1100,6 @@ static inline void nft_use_inc_restore(u
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
- *	@net: netnamespace this table belongs to
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1117,7 +1115,6 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
-	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1299,7 +1299,6 @@ static int nf_tables_newtable(struct net
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
-	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
@@ -3345,8 +3344,11 @@ void nf_tables_rule_destroy(const struct
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
@@ -4858,6 +4860,8 @@ void nf_tables_deactivate_set(const stru
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
 		nft_set_trans_unbind(ctx, set);
@@ -9571,19 +9575,6 @@ static void __nft_release_basechain_now(
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
@@ -9598,11 +9589,18 @@ int __nft_release_basechain(struct nft_c
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


