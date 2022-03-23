Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCD0C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Mar 2022 13:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244259AbiCWNYP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244261AbiCWNYO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 09:24:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31F47CDF9
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2022 06:22:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nX0wl-00015F-G2; Wed, 23 Mar 2022 14:22:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 08/16] netfilter: cttimeout: inc/dec module refcount per object, not per use refcount
Date:   Wed, 23 Mar 2022 14:22:06 +0100
Message-Id: <20220323132214.6700-9-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323132214.6700-1-fw@strlen.de>
References: <20220323132214.6700-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no need to increment the module refcount again, its enough to
obtain one reference per object, i.e. take a reference on object
creation and put it on object destruction.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cttimeout.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index b0d8888a539b..eea486f32971 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -158,6 +158,7 @@ static int cttimeout_new_timeout(struct sk_buff *skb,
 	timeout->timeout.l3num = l3num;
 	timeout->timeout.l4proto = l4proto;
 	refcount_set(&timeout->refcnt, 1);
+	__module_get(THIS_MODULE);
 	list_add_tail_rcu(&timeout->head, &pernet->nfct_timeout_list);
 
 	return 0;
@@ -506,13 +507,8 @@ static struct nf_ct_timeout *ctnl_timeout_find_get(struct net *net,
 		if (strncmp(timeout->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
 
-		if (!try_module_get(THIS_MODULE))
+		if (!refcount_inc_not_zero(&timeout->refcnt))
 			goto err;
-
-		if (!refcount_inc_not_zero(&timeout->refcnt)) {
-			module_put(THIS_MODULE);
-			goto err;
-		}
 		matching = timeout;
 		break;
 	}
@@ -525,10 +521,10 @@ static void ctnl_timeout_put(struct nf_ct_timeout *t)
 	struct ctnl_timeout *timeout =
 		container_of(t, struct ctnl_timeout, timeout);
 
-	if (refcount_dec_and_test(&timeout->refcnt))
+	if (refcount_dec_and_test(&timeout->refcnt)) {
 		kfree_rcu(timeout, rcu_head);
-
-	module_put(THIS_MODULE);
+		module_put(THIS_MODULE);
+	}
 }
 
 static const struct nfnl_callback cttimeout_cb[IPCTNL_MSG_TIMEOUT_MAX] = {
-- 
2.34.1

