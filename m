Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1D1C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A1760FDC
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhCaOQI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 10:16:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48042 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbhCaOPh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 10:15:37 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 289BC630C2
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 16:15:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] mnl: do not set flowtable flags twice
Date:   Wed, 31 Mar 2021 16:15:32 +0200
Message-Id: <20210331141533.25158-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Flags are already set on from mnl_nft_flowtable_add(), remove duplicated
code.

Fixes: e6cc9f37385 ("nftables: add flags offload to flowtable")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index ffbfe48158de..deea586f9b00 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1779,11 +1779,6 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, 0);
 	}
 
-	if (cmd->flowtable->flags & FLOWTABLE_F_HW_OFFLOAD) {
-		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FLAGS,
-				    NFT_FLOWTABLE_HW_OFFLOAD);
-	}
-
 	if (cmd->flowtable->dev_expr) {
 		dev_array = nft_flowtable_dev_array(cmd);
 		nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
-- 
2.20.1

