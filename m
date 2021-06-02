Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EA3C4708F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B7C61246
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhFBLjb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 07:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhFBLjb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 07:39:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD18C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 04:37:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1loPBx-0007XD-Sg; Wed, 02 Jun 2021 13:37:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: fix base chain output
Date:   Wed,  2 Jun 2021 13:37:40 +0200
Message-Id: <20210602113740.25098-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft-test.py -j fails with
python: json.c:243: chain_print_json: Assertion `__out' failed.

The member was changed from char * to a struct, pass the name again.

Fixes: 5008798157e2114f ("libnftables: location-based error reporting for chain type")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/json.c b/src/json.c
index a3d1008fdae8..e588ef4c1722 100644
--- a/src/json.c
+++ b/src/json.c
@@ -241,7 +241,7 @@ static json_t *chain_print_json(const struct chain *chain)
 		mpz_export_data(&policy, chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		tmp = json_pack("{s:s, s:s, s:i, s:s}",
-				"type", chain->type,
+				"type", chain->type.str,
 				"hook", hooknum2str(chain->handle.family,
 						    chain->hook.num),
 				"prio", priority,
-- 
2.26.3

