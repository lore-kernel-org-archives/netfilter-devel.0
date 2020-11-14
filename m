Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98847C5519F
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 17:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E69221F9
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 17:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="JHzvazaG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKNRgJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Nov 2020 12:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKNRgJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Nov 2020 12:36:09 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBD4C0613D1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2020 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SasLK5AOHbA/fh4Nz6Y4rt6JYWexBR2yyV/zzZIn8pg=; b=JHzvazaGucjXTgGsRLtxH421YF
        q59sM5FHYG/GsJpnN4effriYsszhXwOg0ci+b7b6gbHs7LJLnMesMHNDSos1QkF4fBzWrkDRQddkE
        Lc8vyky8wKYnXt+Frj6ttx/Vw1C4fTEzUSPW3wiWNiFce0lpRAWfXx4DCgCxfDoslkTVfmtT5snrK
        xI89sergTiHozJnjiTiMZq4wjSWlUY/aSyQ1TqQPT9pFbpwIQ8qcfXNVb4UX1hocce3YiuhWEYhSb
        JtL+oElPLVCyI8Ic0uMkHYJs5UhcaTHnA8j2cUw0fu0myy6+WJyBJCXGDMbRLJEqVfAVOjRX7eWlM
        0KzrU5Aw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kdzT5-0001wO-5O; Sat, 14 Nov 2020 17:36:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 1/1] bitwise: improve formatting of registers in bitwise dumps.
Date:   Sat, 14 Nov 2020 17:36:05 +0000
Message-Id: <20201114173605.244338-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201114173605.244338-1-jeremy@azazel.net>
References: <20201114173605.244338-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Registers are formatted as 'reg %u' everywhere apart from in bitwise
expressions where they are formatted as 'reg=%u'.  Change bitwise to
match.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9ea2f662b3e6..ba379a84485e 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -215,7 +215,7 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 {
 	int remain = size, offset = 0, ret;
 
-	ret = snprintf(buf, remain, "reg %u = (reg=%u & ",
+	ret = snprintf(buf, remain, "reg %u = ( reg %u & ",
 		       bitwise->dreg, bitwise->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-- 
2.29.2

