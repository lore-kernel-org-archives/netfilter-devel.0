Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC60C34050
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 14:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3C7924654
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 14:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBSOvd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 09:51:33 -0500
Received: from correo.us.es ([193.147.175.20]:53316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgBSOvd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 09:51:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D8131E2C70
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E1D6DA840
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 03BF7DA801; Wed, 19 Feb 2020 15:51:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E6FBDA788
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Feb 2020 15:51:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0926942EF4E1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] src: improve error reporting when remove rules
Date:   Wed, 19 Feb 2020 15:51:23 +0100
Message-Id: <20200219145123.667618-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200219145123.667618-1-pablo@netfilter.org>
References: <20200219145123.667618-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft delete rule ip y z handle 7
 Error: Could not process rule: No such file or directory
 delete rule ip y z handle 7
                ^

 # nft delete rule ip x z handle 7
 Error: Could not process rule: No such file or directory
 delete rule ip x z handle 7
                  ^

 # nft delete rule ip x x handle 7
 Error: Could not process rule: No such file or directory
 delete rule ip x x handle 7
                           ^

 # nft replace rule x y handle 10 ip saddr 1.1.1.2 counter
 Error: Could not process rule: No such file or directory
 replace rule x y handle 10 ip saddr 1.1.1.2 counter
                         ^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |  4 ++--
 src/mnl.c     | 34 +++++++++++++++++++++++-----------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 6d247ccae4d1..74b1b56fd686 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -31,8 +31,8 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 
 int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		     unsigned int flags);
-int mnl_nft_rule_del(struct netlink_ctx *ctx, const struct cmd *cmd);
-int mnl_nft_rule_replace(struct netlink_ctx *ctx, const struct cmd *cmd);
+int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd);
+int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx,
 					  int family);
diff --git a/src/mnl.c b/src/mnl.c
index 6d1e476444ef..3d21a0ed68a8 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -475,7 +475,7 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	return 0;
 }
 
-int mnl_nft_rule_replace(struct netlink_ctx *ctx, const struct cmd *cmd)
+int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct rule *rule = cmd->rule;
 	struct handle *h = &rule->handle;
@@ -491,15 +491,20 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, const struct cmd *cmd)
 		memory_allocation_error();
 
 	nftnl_rule_set_u32(nlr, NFTNL_RULE_FAMILY, h->family);
-	nftnl_rule_set_str(nlr, NFTNL_RULE_TABLE, h->table.name);
-	nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN, h->chain.name);
-	nftnl_rule_set_u64(nlr, NFTNL_RULE_HANDLE, h->handle.id);
 
 	netlink_linearize_rule(ctx, nlr, rule);
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWRULE,
 				    cmd->handle.family,
 				    NLM_F_REPLACE | flags, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
+	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
+	cmd_add_loc(cmd, nlh->nlmsg_len, &h->chain.location);
+	mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
+	cmd_add_loc(cmd, nlh->nlmsg_len, &h->handle.location);
+	mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(h->handle.id));
+
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 	nftnl_rule_free(nlr);
 
@@ -508,9 +513,9 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, const struct cmd *cmd)
 	return 0;
 }
 
-int mnl_nft_rule_del(struct netlink_ctx *ctx, const struct cmd *cmd)
+int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	const struct handle *h = &cmd->handle;
+	struct handle *h = &cmd->handle;
 	struct nftnl_rule *nlr;
 	struct nlmsghdr *nlh;
 
@@ -519,16 +524,23 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 		memory_allocation_error();
 
 	nftnl_rule_set_u32(nlr, NFTNL_RULE_FAMILY, h->family);
-	nftnl_rule_set_str(nlr, NFTNL_RULE_TABLE, h->table.name);
-	if (h->chain.name)
-		nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN, h->chain.name);
-	if (h->handle.id)
-		nftnl_rule_set_u64(nlr, NFTNL_RULE_HANDLE, h->handle.id);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELRULE,
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
 				    0, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
+	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
+	if (h->chain.name) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &h->chain.location);
+		mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
+	}
+	if (h->handle.id) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &h->handle.location);
+		mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(h->handle.id));
+	}
+
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 	nftnl_rule_free(nlr);
 
-- 
2.11.0

