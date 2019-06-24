Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3B1C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 17:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAC9720657
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 17:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732325AbfFXRKj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 13:10:39 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51474 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbfFXRKj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 13:10:39 -0400
Received: from localhost ([::1]:36332 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hfSUI-0003Z3-FT; Mon, 24 Jun 2019 19:10:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] json: Print newline at end of list output
Date:   Mon, 24 Jun 2019 19:10:37 +0200
Message-Id: <20190624171038.24672-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624171038.24672-1-phil@nwl.cc>
References: <20190624171038.24672-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If listing ruleset elements with '-j' flag, print a final newline to not
upset shell prompts.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/json.c b/src/json.c
index 4e64684201638..1484c21be819a 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1752,6 +1752,8 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	root = json_pack("{s:o}", "nftables", root);
 	json_dumpf(root, ctx->nft->output.output_fp, 0);
 	json_decref(root);
+	fprintf(ctx->nft->output.output_fp, "\n");
+	fflush(ctx->nft->output.output_fp);
 	return 0;
 }
 
-- 
2.21.0

