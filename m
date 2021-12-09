Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025A7C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 18:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243302AbhLISaD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243297AbhLISaD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 13:30:03 -0500
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64561C061746
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 10:26:29 -0800 (PST)
Received: from wncross.lan (unknown [IPv6:2a02:8106:1:6800:300b:b575:41c4:b71a])
        by dehost.average.org (Postfix) with ESMTPA id 38B99394FB26;
        Thu,  9 Dec 2021 19:26:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1639074386; bh=97jqR+AthCllV/GVlLRXrRkqaWSvadPFZS09xZfqapM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkuyW4VIdT2OJkeCar7d1t4jYWYhIVem4KUt0VVQWC95JtEZUcPw6HXdVMWTbqoZD
         ZVtPmc2StGAKl/nny+VlhKWUY3c07swK34ovph2sK5r1lgJItcgkY0gGNENG4SgKia
         G6s1/KnQyEYj48TjiEorU3nNX+aKJ6rhfoCcQCCs=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Eugene Crosser <crosser@average.org>
Subject: [PATCH nft v2 1/2] Use abort() in case of netlink_abi_error
Date:   Thu,  9 Dec 2021 19:26:06 +0100
Message-Id: <20211209182607.18550-2-crosser@average.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211209182607.18550-1-crosser@average.org>
References: <20211209182607.18550-1-crosser@average.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Library functions should not use exit(), application that uses the
library may contain error handling path, that cannot be executed if
library functions calls exit(). For truly fatal errors, using abort() is
more acceptable than exit().

Signed-off-by: Eugene Crosser <crosser@average.org>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 359d801c..c25a7e79 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -59,7 +59,7 @@ void __noreturn __netlink_abi_error(const char *file, int line,
 {
 	fprintf(stderr, "E: Contact urgently your Linux kernel vendor. "
 		"Netlink ABI is broken: %s:%d %s\n", file, line, reason);
-	exit(NFT_EXIT_FAILURE);
+	abort();
 }
 
 int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
-- 
2.32.0

