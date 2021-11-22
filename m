Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC98C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Nov 2021 17:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbhKVRM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:12:57 -0500
Received: from mail.netfilter.org ([217.70.188.207]:33470 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbhKVRM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 12:12:56 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CA02D64AAB
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Nov 2021 18:07:38 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] cli: remove #include <editline/history.h>
Date:   Mon, 22 Nov 2021 18:09:45 +0100
Message-Id: <20211122170945.534434-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This header is not required to compile nftables with editline, remove
it, this unbreak compilation in several distros which have no symlink
from history.h to editline.h

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: really, remove history.h, not readline.h

 src/cli.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/cli.c b/src/cli.c
index 4845e5cf1454..8729176680cf 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -26,7 +26,6 @@
 #include <readline/history.h>
 #elif defined(HAVE_LIBEDIT)
 #include <editline/readline.h>
-#include <editline/history.h>
 #else
 #include <linenoise.h>
 #endif
-- 
2.30.2

