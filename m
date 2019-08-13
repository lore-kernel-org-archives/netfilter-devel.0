Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EE3C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FC232054F
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHMSn7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:43:59 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57252 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfHMSn6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 14:43:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hxbm0-0003gL-Ad; Tue, 13 Aug 2019 20:43:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 3/4] src: mnl: fix setting rcvbuffer size
Date:   Tue, 13 Aug 2019 20:44:08 +0200
Message-Id: <20190813184409.10757-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813184409.10757-1-fw@strlen.de>
References: <20190813184409.10757-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel expects socklen_t (int).
Using size_t causes kernel to read upper 0-bits.

This caused tests/shell/testcases/transactions/0049huge_0
to fail on s390x -- it uses 'echo' mode and will quickly
overrun the tiny buffer size set due to this bug.

Fixes: 89c82c261bb5 ("mnl: estimate receiver buffer size")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index f24d2ce0c56a..97a2e0765189 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -240,7 +240,7 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 
 static unsigned int nlsndbufsiz;
 
-static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
+static int mnl_set_rcvbuffer(const struct mnl_socket *nl, socklen_t bufsiz)
 {
 	socklen_t len = sizeof(nlsndbufsiz);
 	int ret;
-- 
2.21.0

