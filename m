From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next/nf_tables-experiments - PATCH 1/2] nf_tables: Add support for changing users chain's name
Date: Wed, 31 Oct 2012 11:28:28 +0200
Message-ID: <1351675709-14127-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351675709-14127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2JaJ2f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:28:35 -0400
In-Reply-To: <1351675709-14127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c       | 58 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0115a2f..542b654 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -67,6 +67,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_HOOK,
 	NFTA_CHAIN_POLICY,
 	NFTA_CHAIN_USE,
+	NFTA_CHAIN_NEW_NAME,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e0e4616..fd1b624 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -676,6 +676,62 @@ nf_tables_chain_policy(struct nft_chain *chain, const struct nlattr *attr)
 	return 0;
 }
 
+static int nf_tables_mvchain(struct sk_buff *skb, const struct nlmsghdr *nlh,
+			     struct nft_table *table,
+			     struct nft_chain *old_chain,
+			     const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	int family = nfmsg->nfgen_family;
+	struct nft_chain *new_chain;
+	const struct nlattr *name;
+	unsigned int size;
+
+	if (!nla[NFTA_CHAIN_NEW_NAME])
+		return -EINVAL;
+
+	if (old_chain->flags & NFT_CHAIN_BUILTIN ||
+	    old_chain->flags & NFT_BASE_CHAIN)
+		return -EOPNOTSUPP;
+
+	if (old_chain->use > 0)
+		return -EBUSY;
+
+	name = nla[NFTA_CHAIN_NEW_NAME];
+	new_chain = nf_tables_chain_lookup(table, name);
+	if (IS_ERR(new_chain)) {
+		if (PTR_ERR(new_chain) != -ENOENT)
+			return PTR_ERR(new_chain);
+		new_chain = NULL;
+	}
+
+	if (new_chain != NULL)
+		return -EEXIST;
+
+	size = nla_len(name);
+	new_chain = kzalloc(sizeof(*new_chain) + size, GFP_KERNEL);
+	if (new_chain == NULL)
+		return -ENOMEM;
+
+	list_del(&old_chain->list);
+
+	INIT_LIST_HEAD(&new_chain->rules);
+	nla_strlcpy(new_chain->name, name, size);
+
+	/* Copying content from old chain */
+	new_chain->flags = old_chain->flags;
+	list_replace_init(&old_chain->rules, &new_chain->rules);
+
+	list_add_tail(&new_chain->list, &table->chains);
+
+	nf_tables_chain_notify(skb, nlh, table, old_chain, NFT_MSG_DELCHAIN,
+			       family);
+	kfree(old_chain);
+	nf_tables_chain_notify(skb, nlh, table, new_chain, NFT_MSG_NEWCHAIN,
+			       family);
+	return 0;
+}
+
 static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -714,7 +770,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
-			return -EOPNOTSUPP;
+			return nf_tables_mvchain(skb, nlh, table, chain, nla);
 
 		if ((chain->flags & NFT_BASE_CHAIN) && nla[NFTA_CHAIN_POLICY]) {
 			return nf_tables_chain_policy(chain,
-- 
1.7.12.4

