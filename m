Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E66C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 12:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D7B620863
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 12:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgCCMeu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 07:34:50 -0500
Received: from correo.us.es ([193.147.175.20]:43260 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgCCMeu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 07:34:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A741115C103
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 13:34:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 976F7DA3C4
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 13:34:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 96D10DA3C3; Tue,  3 Mar 2020 13:34:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8CE0DA39F
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 13:34:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Mar 2020 13:34:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B671442EF4E1
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 13:34:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: support for offload chain flags
Date:   Tue,  3 Mar 2020 13:34:43 +0100
Message-Id: <20200303123443.8936-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends the basechain definition to allow users to specify
the offload flag. This flag enables hardware offload if your drivers
supports it.

 # cat file.nft
 table netdev x {
    chain y {
       type filter hook ingress device eth0 priority 10; flags offload;
    }
 }
 # nft -f file.nft

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 1 +
 src/mnl.c          | 4 ++++
 src/netlink.c      | 2 ++
 src/parser_bison.y | 7 +++++++
 src/rule.c         | 3 +++
 5 files changed, 17 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index ced63f3ea1b8..224e68717bc7 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -175,6 +175,7 @@ extern struct table *table_lookup_fuzzy(const struct handle *h,
  */
 enum chain_flags {
 	CHAIN_F_BASECHAIN	= 0x1,
+	CHAIN_F_HW_OFFLOAD	= 0x2,
 };
 
 /**
diff --git a/src/mnl.c b/src/mnl.c
index bca5add0f8eb..a517712c14eb 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -624,6 +624,10 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, cmd->handle.family);
 
 	if (cmd->chain) {
+		if (cmd->chain->flags & CHAIN_F_HW_OFFLOAD) {
+			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS,
+					    CHAIN_F_HW_OFFLOAD);
+		}
 		if (cmd->chain->flags & CHAIN_F_BASECHAIN) {
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_HOOKNUM,
 					    cmd->chain->hooknum);
diff --git a/src/netlink.c b/src/netlink.c
index 0c6b8c58238b..671923f3eeba 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -435,6 +435,8 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 		xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE));
 	chain->handle.handle.id =
 		nftnl_chain_get_u64(nlc, NFTNL_CHAIN_HANDLE);
+	if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_FLAGS))
+		chain->flags = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FLAGS);
 
 	if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_HOOKNUM) &&
 	    nftnl_chain_is_set(nlc, NFTNL_CHAIN_PRIO) &&
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4c27fcc635dc..b37e9e565cc1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1667,6 +1667,7 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			|	chain_block	stmt_separator
 			|	chain_block	hook_spec	stmt_separator
 			|	chain_block	policy_spec	stmt_separator
+			|	chain_block	flags_spec	stmt_separator
 			|	chain_block	rule		stmt_separator
 			{
 				list_add_tail(&$2->list, &$1->rules);
@@ -2154,6 +2155,12 @@ dev_spec		:	DEVICE	string
 			|	/* empty */		{ $$ = NULL; }
 			;
 
+flags_spec		:	FLAGS		OFFLOAD
+			{
+				$<chain>0->flags |= CHAIN_F_HW_OFFLOAD;
+			}
+			;
+
 policy_spec		:	POLICY		policy_expr
 			{
 				if ($<chain>0->policy) {
diff --git a/src/rule.c b/src/rule.c
index 9e58ee66f984..8e5852689091 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1177,6 +1177,9 @@ static void chain_print_declaration(const struct chain *chain,
 			nft_print(octx, " policy %s;",
 				  chain_policy2str(policy));
 		}
+		if (chain->flags & CHAIN_F_HW_OFFLOAD)
+			nft_print(octx, " flags offload;");
+
 		nft_print(octx, "\n");
 	}
 }
-- 
2.11.0

