Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C0BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344971AbiDDMcB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345118AbiDDMb7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:59 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436B62529A
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WfV1SGtGk5R4tCCmJjmmMmgfNFwAHsSFPDC1ZWHZH+A=; b=XlNSDFzHpTb2q1ZjnBh7weA5QJ
        +EDVnlbFsHX8R5stJCTveprVPD+fdX4qJmcYB9Nh4/jZ9UwhwVo3dpcW07TjJSDNk3qSJZmSm0VZ+
        xwR+Efvhx+eFj5m/beUioETHPr/1ktz5rBeA99g7mcDADaIb/pbpyDZEckz1VLrwUMEM4UzdI5VMK
        BMgyccicUww2ZGtH884F8EKOFp3+9W/X7e9WOd7Fwubi/zSCeJVk7MsrB1k4yTfmccbiCFLUO4jbY
        MSiKS7Tn7ou0QQ0iYsNVC5bMIyz98J9FhrRDbeuXZLQwB3IG6VNy8G0WBGw4sBt18mcvoTOk+Nd+j
        jopVwBSA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-Nl; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 14/32] evaluate: relax type-checking for integer arguments in mark statements
Date:   Mon,  4 Apr 2022 13:13:52 +0100
Message-Id: <20220404121410.188509-15-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to be able to set ct and meta marks to values derived from
payload expressions, we need to relax the requirement that the type of
the statement argument must match that of the statement key.  Instead,
we require that the base-type of the argument is integer and that the
argument is small enough to fit.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ee4da5a2b889..f975dd197de3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2393,8 +2393,12 @@ static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 					 "expression has type %s with length %d",
 					 dtype->desc, (*expr)->dtype->desc,
 					 (*expr)->len);
-	else if ((*expr)->dtype->type != TYPE_INTEGER &&
-		 !datatype_equal((*expr)->dtype, dtype))
+
+	if ((dtype->type == TYPE_MARK &&
+	     !datatype_equal(datatype_basetype(dtype), datatype_basetype((*expr)->dtype))) ||
+	    (dtype->type != TYPE_MARK &&
+	     (*expr)->dtype->type != TYPE_INTEGER &&
+	     !datatype_equal((*expr)->dtype, dtype)))
 		return stmt_binary_error(ctx, *expr, stmt,		/* verdict vs invalid? */
 					 "datatype mismatch: expected %s, "
 					 "expression has type %s",
-- 
2.35.1

