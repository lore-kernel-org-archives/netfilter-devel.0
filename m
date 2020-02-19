Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F50C34051
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 14:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E6424654
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 14:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgBSOvc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 09:51:32 -0500
Received: from correo.us.es ([193.147.175.20]:53314 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgBSOvb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 09:51:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1EE81E2C64
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 926E3DA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 880C8DA7B6; Wed, 19 Feb 2020 15:51:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3BEFDA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Feb 2020 15:51:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9D77342EF4E0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] src: improve error reporting when setting policy on non-base chain
Date:   Wed, 19 Feb 2020 15:51:22 +0100
Message-Id: <20200219145123.667618-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200219145123.667618-1-pablo@netfilter.org>
References: <20200219145123.667618-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When trying to set a policy to non-base chain:

 # nft add chain x y { policy accept\; }
 Error: Could not process rule: Operation not supported
 add chain x y { policy accept; }
                 ^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c          | 12 +++++++-----
 src/parser_bison.y |  3 ++-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index f959196922fc..6d1e476444ef 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -619,11 +619,6 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
 					    cmd->chain->type);
 		}
-		if (cmd->chain->policy) {
-			mpz_export_data(&policy, cmd->chain->policy->value,
-					BYTEORDER_HOST_ENDIAN, sizeof(int));
-			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_POLICY, policy);
-		}
 		if (cmd->chain->dev_expr) {
 			dev_array = xmalloc(sizeof(char *) * 8);
 			dev_array_len = 8;
@@ -658,6 +653,13 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.chain.location);
 	mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
 
+	if (cmd && cmd->chain->policy) {
+		mpz_export_data(&policy, cmd->chain->policy->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->chain->policy->location);
+		mnl_attr_put_u32(nlh, NFTA_CHAIN_POLICY, htonl(policy));
+	}
+
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 	nftnl_chain_free(nlc);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 819c78bfa6d1..cc77d0420cb0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2160,7 +2160,8 @@ policy_spec		:	POLICY		policy_expr
 					expr_free($2);
 					YYERROR;
 				}
-				$<chain>0->policy	= $2;
+				$<chain>0->policy		= $2;
+				$<chain>0->policy->location	= @$;
 			}
 			;
 
-- 
2.11.0

