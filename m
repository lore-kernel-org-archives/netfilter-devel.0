Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1001AC4361B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 15:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C29C222525
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 15:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgLNPyS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 10:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLNPyS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 10:54:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E45C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2020 07:53:37 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1koqAI-0007GZ-LB; Mon, 14 Dec 2020 16:53:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: don't leave dangling pointers on hlist
Date:   Mon, 14 Dec 2020 16:53:29 +0100
Message-Id: <20201214155329.4567-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

unshare -n tests/json_echo/run-test.py
[..]
Adding chain c
free(): double free detected in tcache 2
Aborted (core dumped)

The element must be deleted from the hlist prior to freeing it.

Fixes: 389a0e1edc89a ("json: echo: Speedup seqnum_to_json()")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 09e394dfc26d..f0486b77a225 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3786,8 +3786,10 @@ static void json_cmd_assoc_free(void)
 
 	for (i = 0; i < CMD_ASSOC_HSIZE; i++) {
 		hlist_for_each_entry_safe(cur, pos, n,
-					  &json_cmd_assoc_hash[i], hnode)
+					  &json_cmd_assoc_hash[i], hnode) {
+			hlist_del(&cur->hnode);
 			free(cur);
+		}
 	}
 }
 
-- 
2.26.2

