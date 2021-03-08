Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FB0C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2721651D3
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhCHOLu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 09:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhCHOLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 09:11:32 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E033C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 06:11:32 -0800 (PST)
Received: from localhost ([::1]:53480 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJGbY-0003Rc-Cu; Mon, 08 Mar 2021 15:11:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/5] expr/socket: Kill dead code
Date:   Mon,  8 Mar 2021 15:11:15 +0100
Message-Id: <20210308141119.17809-2-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308141119.17809-1-phil@nwl.cc>
References: <20210308141119.17809-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Function str2socket_key() was never used.

Fixes: 038d226f2e6cc ("src: Add support for native socket matching")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/socket.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/src/expr/socket.c b/src/expr/socket.c
index 8cd4536a7a8e6..76fc90346141e 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -126,19 +126,6 @@ static const char *socket_key2str(uint8_t key)
 	return "unknown";
 }
 
-static inline int str2socket_key(const char *str)
-{
-	int i;
-
-	for (i = 0; i < NFT_SOCKET_MAX + 1; i++) {
-		if (strcmp(str, socket_key2str_array[i]) == 0)
-			return i;
-	}
-
-	errno = EINVAL;
-	return -1;
-}
-
 static int
 nftnl_expr_socket_snprintf_default(char *buf, size_t len,
 			       const struct nftnl_expr *e)
-- 
2.30.1

