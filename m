Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D57C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344882AbiDDMbA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344817AbiDDMbA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:00 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25619EF
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c6LLB7HSO3WzJIsdVcRpPiiBjvKbysBTpG6i7Sd+yzs=; b=Ju9QsIPWM9nbpfeP/FaxJeHwTn
        V0A/27ddEADIQfpyTs1Tul5XCzwc7liAHnMg2w8SvLwXYxftAqXLyQY91BrosKTFYKfHn1ai5DcNc
        Tih61tgWr6H6uRXTp9BrieRHbJWW949habceAgV7j+/4MsLJtT9I7wlk0PKRD1GUL7vomC3Wn8d6G
        B2aW/njYYS23I+eotZzHVs3AtPfC9O6ngCfaKmNtMeDdH4Eq/BcF+V6JDfY8jFqwODS7PKAwfVWa8
        iq5V5cfdOftN9fEVKTySJsSzl+nYf+0YVMGCFxKpYuYWVw/iOAluPUFRBPMpZX490ylR0tHpG2O9g
        HdBSYifw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-Ea; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 11/32] netlink_delinearize: correct length of right bitwise operand
Date:   Mon,  4 Apr 2022 13:13:49 +0100
Message-Id: <20220404121410.188509-12-jeremy@azazel.net>
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

Set it to match the length of the left operand.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8b010fe4d168..cf5359bf269e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2613,6 +2613,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 				      BYTEORDER_HOST_ENDIAN);
 			break;
 		default:
+			expr->right->len = expr->left->len;
 			expr_set_type(expr->right, expr->left->dtype,
 				      expr->left->byteorder);
 		}
-- 
2.35.1

