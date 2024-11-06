Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A99F20E306;
	Wed,  6 Nov 2024 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936806; cv=none; b=XWylYeQeQygopIel9xAYi7zrHpOoVmaGg80ige+DKpiaqJuAKzrUDTv1cgwJZ7qAoFTVpUgGDK6C2LlmMdE+lhPXpkCZTMQc80yPz3PfU4uNZIcDQHEKUjlWWCM91bJs08PDBMoUPkDnAsKnhRagqFnGtT/VM+ZElaStpOqKWbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936806; c=relaxed/simple;
	bh=lmA1M+nRgDRNH7jgOfdg8eDIR/GW143ObDBeIRDcuN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TEh/UbFT0gNp5E7Ov4TEKzUNNvUMrjgz37TowaWxYljRPrd+swoS2YVjMHErFA+XUM21UGC2CBxD2B9vv2746WbPAnV2K1poTIr/4vL3iDldSaXFbJL5ri9YBbSBaSmTZO9u2pMoI+zBdHSrVGaNEN4yrclZ+psbcj8hK1FLRmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 05/11] netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion
Date: Thu,  7 Nov 2024 00:46:19 +0100
Message-Id: <20241106234625.168468-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

On rule delete we get:
 WARNING: suspicious RCU usage
 net/netfilter/nf_tables_api.c:3420 RCU-list traversed in non-reader section!!
 1 lock held by iptables/134:
   #0: ffff888008c4fcc8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid (include/linux/jiffies.h:101) nf_tables

Code is fine, no other CPU can change the list because we're holding
transaction mutex.

Pass the needed lockdep annotation to the iterator and fix
two comments for functions that are no longer restricted to rcu-only
context.

This is enough to resolve rule delete, but there are several other
missing annotations, added in followup-patches.

Fixes: 28875945ba98 ("rcu: Add support for consolidated-RCU reader checking")
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Tested-by: Matthieu Baerts <matttbe@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 30331688301e..80c285ac7e07 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3411,13 +3411,15 @@ void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr)
  * Rules
  */
 
-static struct nft_rule *__nft_rule_lookup(const struct nft_chain *chain,
+static struct nft_rule *__nft_rule_lookup(const struct net *net,
+					  const struct nft_chain *chain,
 					  u64 handle)
 {
 	struct nft_rule *rule;
 
 	// FIXME: this sucks
-	list_for_each_entry_rcu(rule, &chain->rules, list) {
+	list_for_each_entry_rcu(rule, &chain->rules, list,
+				lockdep_commit_lock_is_held(net)) {
 		if (handle == rule->handle)
 			return rule;
 	}
@@ -3425,13 +3427,14 @@ static struct nft_rule *__nft_rule_lookup(const struct nft_chain *chain,
 	return ERR_PTR(-ENOENT);
 }
 
-static struct nft_rule *nft_rule_lookup(const struct nft_chain *chain,
+static struct nft_rule *nft_rule_lookup(const struct net *net,
+					const struct nft_chain *chain,
 					const struct nlattr *nla)
 {
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	return __nft_rule_lookup(chain, be64_to_cpu(nla_get_be64(nla)));
+	return __nft_rule_lookup(net, chain, be64_to_cpu(nla_get_be64(nla)));
 }
 
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
@@ -3732,7 +3735,7 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 	return 0;
 }
 
-/* called with rcu_read_lock held */
+/* Caller must hold rcu read lock or transaction mutex */
 static struct sk_buff *
 nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 			 const struct nlattr * const nla[], bool reset)
@@ -3759,7 +3762,7 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 		return ERR_CAST(chain);
 	}
 
-	rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
+	rule = nft_rule_lookup(net, chain, nla[NFTA_RULE_HANDLE]);
 	if (IS_ERR(rule)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 		return ERR_CAST(rule);
@@ -4057,7 +4060,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (nla[NFTA_RULE_HANDLE]) {
 		handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_HANDLE]));
-		rule = __nft_rule_lookup(chain, handle);
+		rule = __nft_rule_lookup(net, chain, handle);
 		if (IS_ERR(rule)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 			return PTR_ERR(rule);
@@ -4079,7 +4082,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 		if (nla[NFTA_RULE_POSITION]) {
 			pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
-			old_rule = __nft_rule_lookup(chain, pos_handle);
+			old_rule = __nft_rule_lookup(net, chain, pos_handle);
 			if (IS_ERR(old_rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
 				return PTR_ERR(old_rule);
@@ -4296,7 +4299,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (chain) {
 		if (nla[NFTA_RULE_HANDLE]) {
-			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
+			rule = nft_rule_lookup(info->net, chain, nla[NFTA_RULE_HANDLE]);
 			if (IS_ERR(rule)) {
 				if (PTR_ERR(rule) == -ENOENT &&
 				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
@@ -8101,7 +8104,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 	return 0;
 }
 
-/* called with rcu_read_lock held */
+/* Caller must hold rcu read lock or transaction mutex */
 static struct sk_buff *
 nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 			const struct nlattr * const nla[], bool reset)
-- 
2.30.2

