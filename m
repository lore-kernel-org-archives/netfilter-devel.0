Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2116C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 13:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhLHNxQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 08:53:16 -0500
Received: from dehost.average.org ([88.198.2.197]:47500 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhLHNxQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 08:53:16 -0500
Received: from wncross.fkb.profitbricks.net (unknown [IPv6:2a02:8106:1:6800:8b1c:cff2:1ce3:e09b])
        by dehost.average.org (Postfix) with ESMTPA id 9A074394DEA0;
        Wed,  8 Dec 2021 14:49:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638971383; bh=97jqR+AthCllV/GVlLRXrRkqaWSvadPFZS09xZfqapM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nL4l2YV0VGS/Z9gzd8eOezUNNBNOgLDg8GspU8771escrekEVL+0KJ+GJDEojAl6j
         HMEgAf5DsDbT9lu0xmmmFHpsNDm8pII2Z8rnjdUAdC7wuyrAMcMkKjo7yy+A2X0ep9
         eQyX+1tKvjC6MHx89GD4bP/0N0Gves5tq/dBi9Sc=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Eugene Crosser <crosser@average.org>
Subject: [PATCH nft 1/2] Use abort() in case of netlink_abi_error
Date:   Wed,  8 Dec 2021 14:49:13 +0100
Message-Id: <20211208134914.16365-2-crosser@average.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208134914.16365-1-crosser@average.org>
References: <20211208134914.16365-1-crosser@average.org>
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

