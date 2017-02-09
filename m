From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/5] netfilter: nf_tables: add check_genid to the nfnetlink subsystem
Date: Thu,  9 Feb 2017 17:13:49 +0100
Message-ID: <1486656830-3245-5-git-send-email-pablo@netfilter.org>
References: <1486656830-3245-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752700AbdBIQOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 11:14:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 033FD11A12A
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4865DA844
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BED55DA7FA
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:03 +0100 (CET)
In-Reply-To: <1486656830-3245-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements the check generation id as provided by nfnetlink.
This allows us to reject ruleset updates against stale baseline, so
userspace can retry update with a fresh ruleset cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cb6ae46f6c48..71c60a04b66b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4972,6 +4972,11 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 	return 0;
 }
 
+static bool nf_tables_valid_genid(struct net *net, u32 genid)
+{
+	return net->nft.base_seq == genid;
+}
+
 static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.name		= "nf_tables",
 	.subsys_id	= NFNL_SUBSYS_NFTABLES,
@@ -4979,6 +4984,7 @@ static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.cb		= nf_tables_cb,
 	.commit		= nf_tables_commit,
 	.abort		= nf_tables_abort,
+	.valid_genid	= nf_tables_valid_genid,
 };
 
 int nft_chain_validate_dependency(const struct nft_chain *chain,
-- 
2.1.4

