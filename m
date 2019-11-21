Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD91C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CADBF20872
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfKULQI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 06:16:08 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40936 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKULQI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 06:16:08 -0500
Received: from localhost ([::1]:54026 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXkRS-0001D0-FN; Thu, 21 Nov 2019 12:16:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [arptables PATCH 2/3] Eliminate compiler warning about size passed to strncmp()
Date:   Thu, 21 Nov 2019 12:15:58 +0100
Message-Id: <20191121111559.27066-3-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121111559.27066-1-phil@nwl.cc>
References: <20191121111559.27066-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gcc complains about the size being equal to destination size, despite
the nul character being explicitly set in following line.

Reduce size by one to make gcc happy. While being at it, drop the
explicit nul character assignment - it is not needed as the buffer was
allocated by calloc().

Fixes: 8f586939999e0 ("fix potential buffer overflows reported by static analysis")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 arptables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arptables.c b/arptables.c
index 09c9ca25217d0..2b6618c2511ef 100644
--- a/arptables.c
+++ b/arptables.c
@@ -2065,8 +2065,7 @@ int do_command(int argc, char *argv[], char **table, arptc_handle_t *handle)
 
 				target->t = fw_calloc(1, size);
 				target->t->u.target_size = size;
-				strncpy(target->t->u.user.name, jumpto, sizeof(target->t->u.user.name));
-				target->t->u.user.name[sizeof(target->t->u.user.name)-1] = '\0';
+				strncpy(target->t->u.user.name, jumpto, sizeof(target->t->u.user.name) - 1);
 				target->t->u.user.revision = target->revision;
 /*
 				target->init(target->t, &fw.nfcache);
-- 
2.24.0

