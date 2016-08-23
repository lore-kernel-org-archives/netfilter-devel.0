From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nf-next] netfilter: nf_tables: reject hook configuration updates on existing chains
Date: Tue, 23 Aug 2016 17:46:28 +0200
Message-ID: <1471967188-3090-2-git-send-email-pablo@netfilter.org>
References: <1471967188-3090-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752594AbcHWPqq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 11:46:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49FA82E7843
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:46:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C3E3114D61
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:46:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A55C100A68
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:46:35 +0200 (CEST)
In-Reply-To: <1471967188-3090-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, if you add a base chain whose name clashes with an existing
non-base chain, nf_tables doesn't complain about this. Similarly, if you
update the chain type, the hook number and priority.

With this patch, nf_tables bails out in case any of this unsupported
operations occur by returning EBUSY.

 # nft add table x
 # nft add chain x y
 # nft add chain x y { type nat hook input priority 0\; }
 <cmdline>:1:1-49: Error: Could not process rule: Device or resource busy
 add chain x y { type nat hook input priority 0; }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 463fcad..221d27f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1348,6 +1348,37 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		if (nla[NFTA_CHAIN_HOOK]) {
+			struct nft_base_chain *basechain;
+			struct nft_chain_hook hook;
+			struct nf_hook_ops *ops;
+
+			if (!(chain->flags & NFT_BASE_CHAIN))
+				return -EBUSY;
+
+			err = nft_chain_parse_hook(net, nla, afi, &hook,
+						   create);
+			if (err < 0)
+				return err;
+
+			basechain = nft_base_chain(chain);
+			if (basechain->type != hook.type) {
+				nft_chain_release_hook(&hook);
+				return -EBUSY;
+			}
+
+			for (i = 0; i < afi->nops; i++) {
+				ops = &basechain->ops[i];
+				if (ops->hooknum != hook.num ||
+				    ops->priority != hook.priority ||
+				    ops->dev != hook.dev) {
+					nft_chain_release_hook(&hook);
+					return -EBUSY;
+				}
+			}
+			nft_chain_release_hook(&hook);
+		}
+
 		if (nla[NFTA_CHAIN_HANDLE] && name) {
 			struct nft_chain *chain2;
 
-- 
2.1.4

