From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] netfilter: nf_tables: delete chains via chain handle
Date: Wed, 10 Jan 2018 00:42:50 +0530
Message-ID: <20180109191250.13089-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36180 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933944AbeAITNK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 14:13:10 -0500
Received: by mail-pg0-f65.google.com with SMTP id j2so7420209pgv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jan 2018 11:13:10 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows deletion of chains via unique chain handle which can be
listed via '-a' option and table family and table name.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 net/netfilter/nf_tables_api.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f12671e0ec48..b4db7bd836d9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1660,6 +1660,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
 	u32 use;
+	u64 handle;
 	int err;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
@@ -1670,7 +1671,12 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME], genmask);
+	if (nla[NFTA_CHAIN_HANDLE]) {
+		handle = be64_to_cpu(nla_get_be64(nla[NFTA_CHAIN_HANDLE]));
+		chain = nf_tables_chain_lookup_byhandle(table, handle, genmask);
+	} else {
+		chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME], genmask);
+	}
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
-- 
2.11.0

