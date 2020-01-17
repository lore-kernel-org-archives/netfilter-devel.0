Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1F6C33CB7
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A8D12072B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="iMpO1Guz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgAQU6L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:58:11 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55990 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729795AbgAQU6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 15:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3c4fxv1uP6QkGO1efUJp2+TEKjMvontyAb+eSjqZZE8=; b=iMpO1GuzuWvd84F5/O5wvdd2yx
        Ru+5gDOp0UVu94qJpPCUjQviUjelj6j5b+fkFYae03gNxubsRpydT7DACW0VcbaB3VF9jY9FaCBrB
        Ue1GdidmD9pu4XkN2NlJPRcPHnaBTsncgnOSePtrsIuG71FjV6ZiSTxCbCNd6E75cXyiJ6uguZ7ka
        JKGFgwXGUf4GiKXqy5hvZxluc6ZwNaReuAjIQuuQeKFsiwzXP3DKfG/HqMYzBkUcebAEE6tAOMydq
        ot36OJ0u6HobHCAcV3aSpM3aRXf0zIhW8v9YVlQaYCPe/RbykrPqx5dXFw4BS/+I3HK9b8DqBm7gB
        zvThE4Eg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isYgz-0004I2-IW
        for netfilter-devel@vger.kernel.org; Fri, 17 Jan 2020 20:58:09 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v2 3/6] bitwise: add helper to print boolean expressions.
Date:   Fri, 17 Jan 2020 20:58:05 +0000
Message-Id: <20200117205808.172194-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117205808.172194-1-jeremy@azazel.net>
References: <20200117205808.172194-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the code for printing boolean expressions into a separate function.
Another function will be added for shifts later.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 489ee8420c44..472bf59f7ad5 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -174,10 +174,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
-					       const struct nftnl_expr *e)
+static int
+nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
+				 const struct nftnl_expr_bitwise *bitwise)
 {
-	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u = (reg=%u & ",
@@ -198,6 +198,14 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
+static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
+					       const struct nftnl_expr *e)
+{
+	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
+
+	return nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+}
+
 static int
 nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
 			    uint32_t flags, const struct nftnl_expr *e)
-- 
2.24.1

