Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1232EC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 11:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E314A205C9
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 11:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfHNLoz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 07:44:55 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33476 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbfHNLoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 07:44:55 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hxri1-00029K-Cj; Wed, 14 Aug 2019 13:44:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables] src: json: fix constant parsing on bigendian
Date:   Wed, 14 Aug 2019 13:45:19 +0200
Message-Id: <20190814114519.13612-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

json restore is broken on big-endian because we errounously
passed uint8_t with 64 bit size indicator.

On bigendian, this causes all values to get shifted by 56 bit,
this will then cause the eval step to bail because all values
are outside of the 8bit 0-255 protocol range.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index d42bab704f7c..a969bd4c3676 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -304,7 +304,7 @@ static struct expr *json_parse_constant(struct json_ctx *ctx, const char *name)
 		return constant_expr_alloc(int_loc,
 					   constant_tbl[i].dtype,
 					   BYTEORDER_HOST_ENDIAN,
-					   8 * BITS_PER_BYTE,
+					   BITS_PER_BYTE,
 					   &constant_tbl[i].data);
 	}
 	json_error(ctx, "Unknown constant '%s'.", name);
-- 
2.21.0

