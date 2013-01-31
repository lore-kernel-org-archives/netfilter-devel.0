From: pablo@netfilter.org
Subject: [nftables 2/9] netfilter: nf_tables: fix chain after rule deletion
Date: Thu, 31 Jan 2013 01:03:58 +0100
Message-ID: <1359590645-4703-2-git-send-email-pablo@netfilter.org>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:51551 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3AaAEW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:22 -0500
In-Reply-To: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Rules are released via RCU and they may take longer to be released
than the chain. Since the chain refcounter is decremented by the
rcu callback, we may hit -EBUSY while deleting a chain since the
chain is released faster than the rule.

Make sure the chain is released after the rule by forcing that
the chain is released after all rules that reference it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c     |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5c75072..3ba63b6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -367,6 +367,7 @@ enum nft_chain_flags {
  *
  *	@rules: list of rules in the chain
  *	@list: used internally
+ *	@rcu_head: used internally
  *	@handle: chain handle
  *	@flags: bitmask of enum nft_chain_flags
  *	@use: number of jump references to this chain
@@ -376,6 +377,7 @@ enum nft_chain_flags {
 struct nft_chain {
 	struct list_head		rules;
 	struct list_head		list;
+	struct rcu_head			rcu_head;
 	u64				handle;
 	u8				flags;
 	u16				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a8ae0b4..db6150b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -882,6 +882,15 @@ notify:
 	return 0;
 }
 
+static void nf_tables_rcu_chain_destroy(struct rcu_head *head)
+{
+	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
+
+	BUG_ON(chain->use > 0);
+
+	kfree(chain);
+}
+
 static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -905,7 +914,7 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
-	if (!list_empty(&chain->rules) || chain->use > 0)
+	if (!list_empty(&chain->rules))
 		return -EBUSY;
 
 	list_del(&chain->list);
@@ -917,7 +926,8 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_DELCHAIN,
 			       family);
 
-	kfree(chain);
+	/* Make sure all rule references are gone before this is released */
+	call_rcu(&chain->rcu_head, nf_tables_rcu_chain_destroy);
 	return 0;
 }
 
-- 
1.7.10.4

