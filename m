Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D869C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ACC5208DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgEFReT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFReS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DA7C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:18 -0700 (PDT)
Received: from localhost ([::1]:58732 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNw1-0002lL-KE; Wed, 06 May 2020 19:34:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/15] nft: Free rule pointer in nft_cmd_free()
Date:   Wed,  6 May 2020 19:33:17 +0200
Message-Id: <20200506173331.9347-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most commands either don't assign to obj.rule or pass it on when
creating a batch job. Check and delete commands are the exception to
that.

One could free the rule inside nft_rule_check() and nft_rule_delete() as
well, but since only the pointer is passed to them via parameter, the
pointer would remain set afterwards. So instead do that from the proper
routine. At some point, structs nft_cmd and obj_update should be merged
and consequently the functions called from nft_prepare() be given full
control over that combined struct so they can zero pointers if data is
reused or leave set to get them freed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 3c0c6a34515e4..1f46dc6c369cc 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -57,7 +57,14 @@ void nft_cmd_free(struct nft_cmd *cmd)
 	free((void *)cmd->rename);
 	free((void *)cmd->jumpto);
 
-	/* cmd->obj.rule not released here. */
+	switch (cmd->command) {
+	case NFT_COMPAT_RULE_CHECK:
+	case NFT_COMPAT_RULE_DELETE:
+		free(cmd->obj.rule);
+		break;
+	default:
+		break;
+	}
 
 	list_del(&cmd->head);
 	free(cmd);
-- 
2.25.1

