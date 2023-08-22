Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C74DEE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbjHVPoZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237289AbjHVPoY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 11:44:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7656FCCB;
        Tue, 22 Aug 2023 08:44:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qYTYH-0003ID-JB; Tue, 22 Aug 2023 17:44:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Justin Stitt <justinstitt@google.com>
Subject: [PATCH net-next 09/10] netfilter: xtables: refactor deprecated strncpy
Date:   Tue, 22 Aug 2023 17:43:30 +0200
Message-ID: <20230822154336.12888-10-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230822154336.12888-1-fw@strlen.de>
References: <20230822154336.12888-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Justin Stitt <justinstitt@google.com>

Prefer `strscpy_pad` as it's a more robust interface whilst maintaing
zero-padding behavior.

There may have existed a bug here due to both `tbl->repl.name` and
`info->name` having a size of 32 as defined below:
|  #define XT_TABLE_MAXNAMELEN 32

This may lead to buffer overreads in some situations -- `strscpy` solves
this by guaranteeing NUL-termination of the dest buffer.

Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_repldata.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 68ccbe50bb1e..5d1fb7018dba 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -29,7 +29,7 @@
 	if (tbl == NULL) \
 		return NULL; \
 	term = (struct type##_error *)&(((char *)tbl)[term_offset]); \
-	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
+	strscpy_pad(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
 	*term = (struct type##_error)typ2##_ERROR_INIT;  \
 	tbl->repl.valid_hooks = hook_mask; \
 	tbl->repl.num_entries = nhooks + 1; \
-- 
2.41.0

