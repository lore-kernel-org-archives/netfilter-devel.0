Return-Path: <SRS0=jBJt=42=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61402C10F27
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 11:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BE112051A
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 11:07:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="TfWBsWa/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCILHt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 07:07:49 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45678 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgCILHs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 07:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UK43FYs6ez37lKN3it0s+oGqClasn4p7W92VG5HL7bo=; b=TfWBsWa/5jz/0VOUUTHV3xNCr1
        6RV/HDYPkPrcNuT4Fji3WEsm8VbdDU2NqSbSeqrBzgogIAaeI/ZoPhrfsZ0u7fDoZwAUTPQgGWPVq
        D8C5pzQ7dJ09Il0fsqn2BqD5KuwqFh/3VLlRKh75ljxAgrpD3dVRR7Otqkr2xobiQ1RR+AB0rGXxb
        TOE0+eg7ksGitlxYI5fUV16k1X8Fj3BZfL9TT5U9HoUFEu6VfnM717oRXvEp5Qbf4Thou2pS2CXZZ
        fDVvk9jm7cbGo7GfnHJbAh6BGSWHQIrQgInD3wd99+vvczTVlkRl2NB/7AmliNAJAJdokVRq14NWX
        xgPW2Shg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1jBGGB-0000SO-Le; Mon, 09 Mar 2020 11:07:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] parser_bison: fix rshift statement expression.
Date:   Mon,  9 Mar 2020 11:07:47 +0000
Message-Id: <20200309110747.155907-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The RHS of RSHIFT statement expressions should be primary_stmt_expr, not
primary_rhs_expr.

Fixes: dccab4f646b4 ("parser_bison: consolidate stmt_expr rule")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b37e9e565cc1..26ce4e089e1e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3022,7 +3022,7 @@ shift_stmt_expr		:	primary_stmt_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_LSHIFT, $1, $3);
 			}
-			|	shift_stmt_expr		RSHIFT		primary_rhs_expr
+			|	shift_stmt_expr		RSHIFT		primary_stmt_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_RSHIFT, $1, $3);
 			}
-- 
2.25.1

