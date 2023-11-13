Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79641C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 19:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjKMTrc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 14:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjKMTrc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 14:47:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C88CD46
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:47:28 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: bogus ENOENT when destroying element which does not exist
Date:   Mon, 13 Nov 2023 20:47:20 +0100
Message-Id: <20231113194720.123421-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

destroy element command bogusly reports ENOENT in case a set element
does not exist. ENOENT errors are skipped, however, err is still set
and propagated to userspace.

 # nft destroy element ip raw BLACKLIST { 1.2.3.4 }
 Error: Could not process rule: No such file or directory
 destroy element ip raw BLACKLIST { 1.2.3.4 }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a761ee6796f6..debea1c67701 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7263,10 +7263,11 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
-			break;
+			return err;
 		}
 	}
-	return err;
+
+	return 0;
 }
 
 /*
-- 
2.30.2

