Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A555C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Feb 2022 21:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiBUVFB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 16:05:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiBUVE6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 16:04:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91723BCD
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 13:04:31 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nMFrB-0003ib-7W; Mon, 21 Feb 2022 22:04:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>
Subject: [PATCH nf] netfilter: nf_tables: make sure err is initialised to sane value
Date:   Mon, 21 Feb 2022 22:04:23 +0100
Message-Id: <20220221210423.28805-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All warnings (new ones prefixed by >>):

net/netfilter/nf_tables_api.c:6561:6: warning: variable 'err' is used uninitialized whenever 'if' condition is true

Fixes: 33170d18fd2c ("netfilter: nf_tables: fix memory leak during stateful obj update")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 For some reason gcc 11.2 doesn't emit such a warning.

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 49060f281342..9cd1d7a62804 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6551,7 +6551,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 {
 	struct nft_object *newobj;
 	struct nft_trans *trans;
-	int err;
+	int err = -ENOMEM;
 
 	if (!try_module_get(type->owner))
 		return -ENOENT;
-- 
2.34.1

