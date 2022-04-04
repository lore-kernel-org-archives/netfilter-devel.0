Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BC4C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiDDMI2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbiDDMIZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:08:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D752A3DA7E
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WQwlmDZMI4sQ0WE712nKquGgmG3rQcl+8QulA3onZ2Q=; b=ctVM1jS3S2zoFkTAqWf8XJd17R
        QIxqOHerI1+gvsQoGOMfr9qcyakQEq/BvimQZWcZZU2jGtta3h1qbNUrtqvb/RaOOCsY9C+CC6d5W
        xbvQCh6SSIvg0gNXER5kHLoTHzxd4uh46H1mPpMwaPQaQBDq9I81JxqI+AhAb2+Oj7hSuBRyAi3oo
        Lh1EfVaIVPslCnNqAHkNKGOe0rt92JHraMcp97rKRGtdYWGmAj7jjf8SuWB5YFzQqkcxvvMMfoXId
        RrjzchXUE//cY5buR7n4QkO8qVA75ELWITGH2Swut+OxjEMy4xmj7kBWaw6Y8upzerwGzZoSK4yiN
        TvmSaQHQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLTY-007FNA-2D
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:06:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnftnl PATCH v2 5/9] expr: bitwise: fix a couple of white-space mistakes
Date:   Mon,  4 Apr 2022 13:06:19 +0100
Message-Id: <20220404120623.188439-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404120623.188439-1-jeremy@azazel.net>
References: <20220404120623.188439-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add spaces round an operator, and break a couple of long lines.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 3fa627d7905d..d695cb1cc3a9 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -182,7 +182,7 @@ static int
 nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
-	struct nlattr *tb[NFTA_BITWISE_MAX+1] = {};
+	struct nlattr *tb[NFTA_BITWISE_MAX + 1] = {};
 	int ret = 0;
 
 	if (mnl_attr_parse_nested(attr, nftnl_expr_bitwise_cb, tb) < 0)
@@ -279,10 +279,12 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
 		break;
 	case NFT_BITWISE_LSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<",
+							bitwise);
 		break;
 	case NFT_BITWISE_RSHIFT:
-		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>", bitwise);
+		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>",
+							bitwise);
 		break;
 	}
 
-- 
2.35.1

