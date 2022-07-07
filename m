Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB5CC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Jul 2022 13:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbiGGNSM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiGGNSL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 09:18:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EF0D2FFD7
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Jul 2022 06:18:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: crash when uncollapsing command with unexisting table or set
Date:   Thu,  7 Jul 2022 15:18:04 +0200
Message-Id: <20220707131804.1382046-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If ruleset update refers to an unexisting table or set, then
cmd->elem.set is NULL.

Fixes: 498a5f0c219d ("rule: collapse set element commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 79d4b77756e4..9c9eaec0c77b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1453,7 +1453,9 @@ void nft_cmd_uncollapse(struct list_head *cmds)
 		}
 
 		list_for_each_entry_safe(collapse_cmd, collapse_cmd_next, &cmd->collapse_list, list) {
-			collapse_cmd->elem.set = set_get(cmd->elem.set);
+			if (cmd->elem.set)
+				collapse_cmd->elem.set = set_get(cmd->elem.set);
+
 			list_add(&collapse_cmd->list, &cmd->list);
 		}
 	}
-- 
2.30.2

