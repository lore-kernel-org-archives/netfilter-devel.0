Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20902C11D2F
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFF4820828
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 13:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Gk4RyHhN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBXNME (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:12:04 -0500
Received: from kadath.azazel.net ([81.187.231.250]:58256 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgBXNME (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 08:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IK0jvmYNfFJN2q9YWNf2mKjnCIx/WqG/OjuuE8wF7Cg=; b=Gk4RyHhNKak/zcfIjdSL8biS6Y
        PraBCYJlta9a+lLI7+aZcZBZixTfl1tdtlUta8oLeCc27HhF5EtewlnX+8t3pL/pHUVRtSs4WQzKb
        bb80UYUxflb0Uqc2xYYM/pSkBNSbXcJFBFcs2YwESMYioyVeJzGEVnzLWK8bEN6GrAWmq4o/bmAO7
        lwbFBeRh8oDGr8z9yY/z6hHBZmFfo6hW7F3K4oOxmq4gjpD68Uo+j9ILk7+AS1S08Nr/IB2enJf0t
        0gYET3/G405BsIDTOIJK8nNiuTEuilZbCrqtZdTfgQHszw8iOMmU5oJqYrJP7KnWVrSEpBTLeqV9c
        OZDwwYfQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j6DWj-0001wB-Sc; Mon, 24 Feb 2020 13:12:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 1/3] tests: bitwise: fix error message.
Date:   Mon, 24 Feb 2020 13:11:59 +0000
Message-Id: <20200224131201.512755-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224131201.512755-1-jeremy@azazel.net>
References: <20200224131201.512755-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In one case, the boolean test was reporting the wrong mismatched
attribute.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/nft-expr_bitwise-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 74a0e2aa6933..f134728fdd86 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -44,7 +44,7 @@ static void cmp_nftnl_expr_bool(struct nftnl_expr *rule_a,
 		print_err("bool", "Expr BITWISE_OP mismatches");
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("bool", "Expr BITWISE_DREG mismatches");
+		print_err("bool", "Expr BITWISE_LEN mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
 	if (maska != maskb)
-- 
2.25.0

