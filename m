Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661A1C76186
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 10:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27C992173B
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 10:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="MT5OTvg2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfGQKq5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 06:46:57 -0400
Received: from mx1.riseup.net ([198.252.153.129]:55688 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfGQKq4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 06:46:56 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 146A31B93A8
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 03:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563360416; bh=LrCVhlC3UIj2QBXjjJi/w1DfKZLATQmbk9xzJeCSb2U=;
        h=From:To:Cc:Subject:Date:From;
        b=MT5OTvg2UydTqcvspmAxTzZa7a9+W/eK712e8BUBDy2g/KnF4oX7QI7aSi/SfSKIo
         cp/xq7tUQh8p2FQpjbeoaztIxFEKXGrJ1h0XpMxaBDJM21AeTCwY0JjJ06jIZAH9/Z
         Lu8KIGn0ZoP16xGel4jzQ+/2P/KFqMja+nf4tGQA=
X-Riseup-User-ID: D2C992EFDB676677A61F75B5392D79D92DE62DE5BB2DD07289C008C216F9895C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 47B331204FF;
        Wed, 17 Jul 2019 03:46:55 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nft] src: json: fix synproxy flag parser typo
Date:   Wed, 17 Jul 2019 12:46:45 +0200
Message-Id: <20190717104646.3387-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/parser_json.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 42893c2..76c0a5c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2197,7 +2197,7 @@ static int json_parse_synproxy_flag(struct json_ctx *ctx,
 	assert(flags);
 
 	if (!json_is_string(root)) {
-		json_error(ctx, "Invalid log flag type %s, expected string.",
+		json_error(ctx, "Invalid synproxy flag type %s, expected string.",
 			   json_typename(root));
 		return 1;
 	}
@@ -2208,7 +2208,7 @@ static int json_parse_synproxy_flag(struct json_ctx *ctx,
 			return 0;
 		}
 	}
-	json_error(ctx, "Unknown log flag '%s'.", flag);
+	json_error(ctx, "Unknown synproxy flag '%s'.", flag);
 	return 1;
 }
 
@@ -2222,13 +2222,13 @@ static int json_parse_synproxy_flags(struct json_ctx *ctx, json_t *root)
 		json_parse_synproxy_flag(ctx, root, &flags);
 		return flags;
 	} else if (!json_is_array(root)) {
-		json_error(ctx, "Invalid log flags type %s.",
+		json_error(ctx, "Invalid synproxy flags type %s.",
 			   json_typename(root));
 		return -1;
 	}
 	json_array_foreach(root, index, value) {
 		if (json_parse_synproxy_flag(ctx, value, &flags))
-			json_error(ctx, "Parsing log flag at index %zu failed.",
+			json_error(ctx, "Parsing synproxy flag at index %zu failed.",
 				   index);
 	}
 	return flags;
-- 
2.20.1

