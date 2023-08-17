Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECE0C3DA58
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Aug 2023 18:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348104AbjHQS31 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 14:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354452AbjHQS3F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 14:29:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D352D7E
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Aug 2023 11:28:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qWhjb-0003bz-Fj; Thu, 17 Aug 2023 20:28:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: validate all pending tables
Date:   Thu, 17 Aug 2023 20:28:32 +0200
Message-ID: <20230817182834.8217-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We have to validate all tables in the transaction that are in
VALIDATE_DO state, the blamed commit below did not move the break
statement to its right location so we only validate one table.

Moreover, we can't init table->validate to _SKIP when a table object
is allocated.

If we do, then if a transcaction creates a new table and then
fails the transaction, nfnetlink will loop and nft will hang until
user cancels the command.

Add back the pernet state as a place to stash the last state encountered.
This is either _DO (we hit an error during commit validation) or _SKIP
(transaction passed all checks).

Fixes: 00c320f9b755 ("netfilter: nf_tables: make validation state per table")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e9ae567c037d..ffcbdf08380f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1729,6 +1729,7 @@ struct nftables_pernet {
 	u64			table_handle;
 	unsigned int		base_seq;
 	unsigned int		gc_seq;
+	u8			validate_state;
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3e841e45f2c0..a76a62ebe9c9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1373,7 +1373,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (table == NULL)
 		goto err_kzalloc;
 
-	table->validate_state = NFT_VALIDATE_SKIP;
+	table->validate_state = nft_net->validate_state;
 	table->name = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (table->name == NULL)
 		goto err_strdup;
@@ -9051,9 +9051,8 @@ static int nf_tables_validate(struct net *net)
 				return -EAGAIN;
 
 			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
+			break;
 		}
-
-		break;
 	}
 
 	return 0;
@@ -9799,8 +9798,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* 0. Validate ruleset, otherwise roll back for error reporting. */
-	if (nf_tables_validate(net) < 0)
+	if (nf_tables_validate(net) < 0) {
+		nft_net->validate_state = NFT_VALIDATE_DO;
 		return -EAGAIN;
+	}
 
 	err = nft_flow_rule_offload_commit(net);
 	if (err < 0)
@@ -10059,6 +10060,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
 
 	nft_gc_seq_end(nft_net, gc_seq);
+	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	nf_tables_commit_release(net);
 
 	return 0;
@@ -11115,6 +11117,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
 	nft_net->gc_seq = 0;
+	nft_net->validate_state = NFT_VALIDATE_SKIP;
 
 	return 0;
 }
-- 
2.41.0

