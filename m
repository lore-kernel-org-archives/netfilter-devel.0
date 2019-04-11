Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90D9C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 10:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 903E42084D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 10:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfDKKi6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:38:58 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45332 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfDKKi6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 06:38:58 -0400
Received: from localhost ([::1]:58422 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hEX6e-0005x3-K5; Thu, 11 Apr 2019 12:38:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_json: Disallow ct helper as type to map to
Date:   Thu, 11 Apr 2019 12:38:51 +0200
Message-Id: <20190411103851.27051-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When creating a map, users may either map dtype:dtype or dtype:object.
In the second case, only counter, quota, limit and secmark is allowed by
bison, but JSON parser wasn't as strict, allowing ct helper as well.
Remove that to avoid undefined behaviour.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 19d3ad4728130..53017935eba53 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2503,7 +2503,6 @@ static int string_to_nft_object(const char *str)
 	const char *obj_tbl[__NFT_OBJECT_MAX] = {
 		[NFT_OBJECT_COUNTER] = "counter",
 		[NFT_OBJECT_QUOTA] = "quota",
-		[NFT_OBJECT_CT_HELPER] = "ct helper",
 		[NFT_OBJECT_LIMIT] = "limit",
 		[NFT_OBJECT_SECMARK] = "secmark",
 	};
-- 
2.21.0

