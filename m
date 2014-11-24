From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] iptables: nft: create a separated object update
 type to rename chains
Date: Mon, 24 Nov 2014 11:12:15 +0100
Message-ID: <20141124101214.24914.2030.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48956 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871AbaKXKMa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:12:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds an explicit object update type to rename chains, so we avoid
calling the nf_tables API with NLM_F_EXCL.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index baaef3e..568faa1 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -253,6 +253,7 @@ enum obj_update_type {
 	NFT_COMPAT_CHAIN_USER_ADD,
 	NFT_COMPAT_CHAIN_USER_DEL,
 	NFT_COMPAT_CHAIN_UPDATE,
+	NFT_COMPAT_CHAIN_RENAME,
 	NFT_COMPAT_RULE_APPEND,
 	NFT_COMPAT_RULE_INSERT,
 	NFT_COMPAT_RULE_REPLACE,
@@ -1457,10 +1458,15 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	uint64_t handle;
 	int ret;
 
+	nft_fn = nft_chain_user_add;
+
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
 		nft_xt_builtin_init(h, table);
 
+	/* Config load changed errno. Ensure genuine info for our callers. */
+	errno = 0;
+
 	/* Find the old chain to be renamed */
 	c = nft_chain_find(h, table, chain);
 	if (c == NULL) {
@@ -1479,7 +1485,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
 
 	if (h->batch_support) {
-		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_RENAME, c);
 	} else {
 		char buf[MNL_SOCKET_BUFFER_SIZE];
 		struct nlmsghdr *nlh;
@@ -2225,6 +2231,10 @@ static int nft_action(struct nft_handle *h, int action)
 						     NLM_F_CREATE : 0,
 						   seq++, n->chain);
 			break;
+		case NFT_COMPAT_CHAIN_RENAME:
+			nft_compat_chain_batch_add(h, NFT_MSG_NEWCHAIN, 0,
+						   seq++, n->chain);
+			break;
 		case NFT_COMPAT_RULE_APPEND:
 			nft_compat_rule_batch_add(h, NFT_MSG_NEWRULE,
 						  NLM_F_CREATE | NLM_F_APPEND,

