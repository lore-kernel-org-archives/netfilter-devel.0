Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC166C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 13:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE6220725
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 13:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKNNYh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 08:24:37 -0500
Received: from correo.us.es ([193.147.175.20]:59386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfKNNYg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 08:24:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E65F2D28D6
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 14:24:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDDADDA4CA
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 14:24:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BBA02DA801; Thu, 14 Nov 2019 14:24:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B563DA3A9
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 14:24:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Nov 2019 14:24:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 13F2C42EE38F
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 14:24:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/3] netfilter: nf_tables_offload: undo updates if transaction fails
Date:   Thu, 14 Nov 2019 14:24:27 +0100
Message-Id: <20191114132427.10869-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191114132427.10869-1-pablo@netfilter.org>
References: <20191114132427.10869-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nft_flow_rule_offload_commit() might fail after several successful
commands leaving the hardware filtering policy in inconsistent state.
This patch adds nft_flow_rule_offload_abort() which undoes the updates
that have been already processed if one command of this transaction
fails. Hence, the hardware ruleset is left as is it was before the
update.

Thee deletion path needs to create the flow_rule object too, in case
that an existing rule needs to be re-added from the abort path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c     | 11 ++++++++
 net/netfilter/nf_tables_offload.c | 54 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1dcab99cb947..575791a36d59 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -361,6 +361,7 @@ static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
 
 static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 {
+	struct nft_flow_rule *flow;
 	struct nft_trans *trans;
 	int err;
 
@@ -368,6 +369,16 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	if (trans == NULL)
 		return -ENOMEM;
 
+	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
+		flow = nft_flow_rule_create(ctx->net, rule);
+		if (IS_ERR(flow)) {
+			nft_trans_destroy(trans);
+			return PTR_ERR(flow);
+		}
+
+		nft_trans_flow_rule(trans) = flow;
+	}
+
 	err = nf_tables_delrule_deactivate(ctx, rule);
 	if (err < 0) {
 		nft_trans_destroy(trans);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 6d5f3cd7f1b7..68f17a6921d8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -389,6 +389,55 @@ static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
 	return nft_flow_block_chain(basechain, NULL, cmd);
 }
 
+static void nft_flow_rule_offload_abort(struct net *net,
+					struct nft_trans *trans)
+{
+	int err = 0;
+
+	list_for_each_entry_continue_reverse(trans, &net->nft.commit_list, list) {
+		if (trans->ctx.family != NFPROTO_NETDEV)
+			continue;
+
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWCHAIN:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD) ||
+			    nft_trans_chain_update(trans))
+				continue;
+
+			err = nft_flow_offload_chain(trans->ctx.chain, NULL,
+						     FLOW_BLOCK_UNBIND);
+			break;
+		case NFT_MSG_DELCHAIN:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			err = nft_flow_offload_chain(trans->ctx.chain, NULL,
+						     FLOW_BLOCK_BIND);
+			break;
+		case NFT_MSG_NEWRULE:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    NULL, FLOW_CLS_DESTROY);
+			break;
+		case NFT_MSG_DELRULE:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    nft_trans_flow_rule(trans),
+						    FLOW_CLS_REPLACE);
+			break;
+		}
+
+		if (WARN_ON_ONCE(err))
+			break;
+	}
+}
+
 int nft_flow_rule_offload_commit(struct net *net)
 {
 	struct nft_trans *trans;
@@ -441,8 +490,10 @@ int nft_flow_rule_offload_commit(struct net *net)
 			break;
 		}
 
-		if (err)
+		if (err) {
+			nft_flow_rule_offload_abort(net, trans);
 			break;
+		}
 	}
 
 	list_for_each_entry(trans, &net->nft.commit_list, list) {
@@ -451,6 +502,7 @@ int nft_flow_rule_offload_commit(struct net *net)
 
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWRULE:
+		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-- 
2.11.0

