Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4B1C05026
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjITU5m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC9ECA
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LpCqGovgqpGRp0yYhc/iJRqd6A+6F7LBbM6V3t2YweQ=; b=S+S+WUJH2gkHNMPPzXcJFjNHXM
        xx8YSCG2J5x4G+bxU8+WXxXMm6Neu5RjaVhz4LOd6dBFZFMmdIr57cws/k4uFI8FptuZtKs+lyBMC
        XwQ/poB9gGlF/P7C2WwupCBYWjTJWuNoMx3AmODQOBlYo1eTPuSX0vFhzbaHRQ41qJiwLy2ykpuy0
        2KQ9Qb1EoCjNTTHf3Dgn5nzcyHYunvieZVWfCVDVfZ2SrKZSHYc7IkLBGZFdwRW6CLykMM4OQ2a6u
        RAd1Vp3xUx3Fj7SIqWtZzr+r208+6RkcyFJT2vCKyX4sIlryhaNt55pHi6YlBDbkWmkjprVoh+R8q
        +N+cjeqg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GK-0007qA-3F; Wed, 20 Sep 2023 22:57:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 8/9] parser_json: Catch nonsense ops in match statement
Date:   Wed, 20 Sep 2023 22:57:26 +0200
Message-ID: <20230920205727.22103-9-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since expr_op_symbols array includes binary operators and more, simply
checking the given string matches any of the elements is not sufficient.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index e33c470c7e224..15bb79a52bcc0 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1725,13 +1725,18 @@ static struct stmt *json_parse_match_stmt(struct json_ctx *ctx,
 		    !strcmp(opstr, expr_op_symbols[op]))
 			break;
 	}
-	if (op == __OP_MAX) {
+	switch (op) {
+	case OP_EQ ... OP_NEG:
+		break;
+	case __OP_MAX:
 		if (!strcmp(opstr, "in")) {
 			op = OP_IMPLICIT;
-		} else {
-			json_error(ctx, "Unknown relational op '%s'.", opstr);
-			return NULL;
+			break;
 		}
+		/* fall through */
+	default:
+		json_error(ctx, "Invalid relational op '%s'.", opstr);
+		return NULL;
 	}
 
 	left = json_parse_expr(ctx, jleft);
-- 
2.41.0

