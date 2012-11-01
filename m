From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next/nf_tables-experiments - v2 PATCH 3/4] nf_tables: Add support for changing users chain's name
Date: Thu,  1 Nov 2012 13:38:32 +0200
Message-ID: <1351769913-5851-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53694 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab2KALil (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:38:41 -0400
In-Reply-To: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c       | 45 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8962657..63297b4 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -69,6 +69,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_HOOK,
 	NFTA_CHAIN_POLICY,
 	NFTA_CHAIN_USE,
+	NFTA_CHAIN_NEW_NAME,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 14ae11d..43eccbb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -484,6 +484,8 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
 	[NFTA_CHAIN_USE]	= { .type = NLA_U32 },
+	[NFTA_CHAIN_NEW_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 };
 
 static const struct nla_policy nft_hook_policy[NFTA_HOOK_MAX + 1] = {
@@ -678,6 +680,47 @@ nf_tables_chain_policy(struct nft_chain *chain, const struct nlattr *attr)
 	return 0;
 }
 
+static int nf_tables_mvchain(struct sk_buff *skb, const struct nlmsghdr *nlh,
+			     struct nft_table *table,
+			     struct nft_chain *chain,
+			     const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	int family = nfmsg->nfgen_family;
+	struct nft_chain *new_chain;
+	struct nft_chain old_chain;
+
+	if (!nla[NFTA_CHAIN_NEW_NAME])
+		return -EINVAL;
+
+	if (chain->flags & NFT_CHAIN_BUILTIN ||
+	    chain->flags & NFT_BASE_CHAIN)
+		return -EOPNOTSUPP;
+
+	new_chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NEW_NAME]);
+	if (IS_ERR(new_chain)) {
+		if (PTR_ERR(new_chain) != -ENOENT)
+			return PTR_ERR(new_chain);
+		new_chain = NULL;
+	}
+
+	if (new_chain != NULL)
+		return -EEXIST;
+
+	new_chain = chain;
+
+	nla_strlcpy(old_chain.name,
+		    nla[NFTA_CHAIN_NAME], NFT_CHAIN_MAXNAMELEN);
+	nla_strlcpy(new_chain->name,
+		    nla[NFTA_CHAIN_NEW_NAME], NFT_CHAIN_MAXNAMELEN);
+
+	nf_tables_chain_notify(skb, nlh, table, &old_chain, NFT_MSG_DELCHAIN,
+			       family);
+	nf_tables_chain_notify(skb, nlh, table, new_chain, NFT_MSG_NEWCHAIN,
+			       family);
+	return 0;
+}
+
 static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -715,7 +758,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
-			return -EOPNOTSUPP;
+			return nf_tables_mvchain(skb, nlh, table, chain, nla);
 
 		if ((chain->flags & NFT_BASE_CHAIN) && nla[NFTA_CHAIN_POLICY]) {
 			return nf_tables_chain_policy(chain,
-- 
1.7.12.4

