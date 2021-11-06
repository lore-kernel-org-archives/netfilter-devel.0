Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CC8C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 150DF60F9D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhKFQxB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbhKFQwu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:50 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DF6C06120C
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XIbHk59mPmB2MkZ2y3h2D1KtzOBqwEYnam2G0Op1BE4=; b=L+A8rjzNpuyyN1qeYkH0xBubqi
        whWHXXz4SXZqt9JtHO/FP9omeLm0isXufQfn0HNHJ9ABQpdB5gluBLj2BHVEooWYG9yHgdmZU2uB8
        LhITTF8Lp2iQHxWHvgad0Me7XH+aRH3jBFDPBu2RECpqFUVXqZi8Yix1frOf4nefhJhZU4DyF8ofL
        MptA/xUT3AfhYL5oKyqLej+27FLELiDutArwwehCkjjJFJv4eQglKrAqjiV50cTttWfYGqwrUM0Y7
        BorFhiT91OQK+5MRyVDZson75YgSIIInKUl+yiydThq5W4aEPZfvNeo4C/m/I0qL2sAmKuEV3eZ1g
        GJ6FxrRQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-K4
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 07/27] db: add missing `break` to switch-case
Date:   Sat,  6 Nov 2021 16:49:33 +0000
Message-Id: <20211106164953.130024-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/db.c b/util/db.c
index c9aec418e9ed..f0711146867f 100644
--- a/util/db.c
+++ b/util/db.c
@@ -388,6 +388,7 @@ static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 		case ULOGD_RET_RAW:
 			ulogd_log(ULOGD_NOTICE,
 				"Unsupported RAW type is unsupported in SQL output");
+			break;
 		default:
 			ulogd_log(ULOGD_NOTICE,
 				"unknown type %d for %s\n",
-- 
2.33.0

