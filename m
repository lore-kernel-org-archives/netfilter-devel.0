Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBE5EE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 15:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbjHVPoT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbjHVPoS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 11:44:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73F1CDD;
        Tue, 22 Aug 2023 08:44:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qYTYD-0003Hj-Gx; Tue, 22 Aug 2023 17:44:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Justin Stitt <justinstitt@google.com>
Subject: [PATCH net-next 08/10] netfilter: x_tables: refactor deprecated strncpy
Date:   Tue, 22 Aug 2023 17:43:29 +0200
Message-ID: <20230822154336.12888-9-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230822154336.12888-1-fw@strlen.de>
References: <20230822154336.12888-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Justin Stitt <justinstitt@google.com>

Prefer `strscpy_pad` to `strncpy`.

Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 470282cf3fae..21624d68314f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -768,7 +768,7 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 	m->u.user.match_size = msize;
 	strscpy(name, match->name, sizeof(name));
 	module_put(match->me);
-	strncpy(m->u.user.name, name, sizeof(m->u.user.name));
+	strscpy_pad(m->u.user.name, name, sizeof(m->u.user.name));
 
 	*size += off;
 	*dstptr += msize;
@@ -1148,7 +1148,7 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 	t->u.user.target_size = tsize;
 	strscpy(name, target->name, sizeof(name));
 	module_put(target->me);
-	strncpy(t->u.user.name, name, sizeof(t->u.user.name));
+	strscpy_pad(t->u.user.name, name, sizeof(t->u.user.name));
 
 	*size += off;
 	*dstptr += tsize;
@@ -2014,4 +2014,3 @@ static void __exit xt_fini(void)
 
 module_init(xt_init);
 module_exit(xt_fini);
-
-- 
2.41.0

