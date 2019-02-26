Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5857EC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EA0F21852
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfBZVNr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 16:13:47 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48000 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfBZVNq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 16:13:46 -0500
Received: from localhost ([::1]:32858 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gyk2r-0006n3-9W; Tue, 26 Feb 2019 22:13:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/5] parser_json: Duplicate chain name when parsing jump verdict
Date:   Tue, 26 Feb 2019 22:13:39 +0100
Message-Id: <20190226211342.15125-3-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190226211342.15125-1-phil@nwl.cc>
References: <20190226211342.15125-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since verdict expression frees the chain name, pass a newly allocated
string to it. Otherwise double free happens because json_decref() frees
the string property value as well.

Fixes: d1057a5feb5fd ("JSON: Simplify verdict statement parsing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index d00cf422c314e..78214f6519f2b 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1075,7 +1075,8 @@ static struct expr *json_parse_verdict_expr(struct json_ctx *ctx,
 			return NULL;
 
 		return verdict_expr_alloc(int_loc,
-					  verdict_tbl[i].verdict, chain);
+					  verdict_tbl[i].verdict,
+					  chain ? xstrdup(chain) : NULL);
 	}
 	json_error(ctx, "Unknown verdict '%s'.", type);
 	return NULL;
-- 
2.20.1

