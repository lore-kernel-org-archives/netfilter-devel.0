Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67FAC2FC03
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjITU5n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95152D3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nRdN5k/2N5PBA6HkJas21RKZ8mYV/hQo4UE20KnwmkQ=; b=CLTd3JvImDCLUjLpQvB/BtketV
        p6VpW55DYJLvOp9Kw3XHIQV2XM1+FYwhk0S4lfQaMtPCrcRTLozpiJZbRlF8IHadmd6CNWrotsxZj
        OWc/s+X3F6YPc998a0Rne9ndJP9EhbPv7tZN9FJOR16CHlt98PHDjqf3g89tV16uafBSbWkObIy4Z
        lQzjjHqcjKXzIM4CXR4l9xtKTGrGS7uHrAYJxChiSwkMCsWY9AnJVeFl+ru/IoXqN76z1fDRkfZ02
        kCPXaTOOgrIOpkdgSOKSgnN3oGroAcJTPjgLbCEtG5u49sx0OXl5iNdwG6GXOiHND382WbcB9dOQ0
        nH7FXHtg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GK-0007qP-V2; Wed, 20 Sep 2023 22:57:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/9] parser_json: Fix flowtable prio value parsing
Date:   Wed, 20 Sep 2023 22:57:22 +0200
Message-ID: <20230920205727.22103-5-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Using format specifier 'I' requires a 64bit variable to write into. The
temporary variable 'prio' is of type int, though.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 92168b9ab580e..1921f301c51be 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3374,7 +3374,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	if (op == CMD_DELETE || op == CMD_LIST || op == CMD_DESTROY)
 		return cmd_alloc(op, cmd_obj, &h, int_loc, NULL);
 
-	if (json_unpack_err(ctx, root, "{s:s, s:I}",
+	if (json_unpack_err(ctx, root, "{s:s, s:i}",
 			    "hook", &hook,
 			    "prio", &prio)) {
 		handle_free(&h);
-- 
2.41.0

