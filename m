Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAD8C19F33
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65D8D6113B
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhHVQjD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhHVQjC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:02 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296A4C061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nU82T/ysR/4Dd/uUgNjzR1VgGqWClRKYrghKZ+Bhiu8=; b=hHTlqr92rrurRVZUqbSegI1Y9F
        n70NOFquzvpJUoaDDFCYikVJefc8fPgqdkxPwkM5ShIZPp6kn4HYH2PrARrhYpnRlYTJ/XjwRgUuY
        hRMi6pjPXDHTC5Dc56Vdt+1OBTX72EQRqyOPQFmFkaOlyjTlgdeZmtqhjuHO5VDH6BcrsLA/3M82n
        ejPAIYAlv4rqtgyyLXWkp9vTyagvh7AX0FC9SeFBYvqvH2DmByyUFeXeB3d+3JOafgOViKRH83lC+
        bmkssLYQxOUixQ74FHW2D+IeY3EDbkstzseXNVIz8kKZUA2Y7nzvLuYt7S7XceOKKTAo3rUIYWpPe
        KZC5VY2Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUE-008Q2I-6N; Sun, 22 Aug 2021 17:38:18 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 7/8] xt_condition: don't delete variables in `condition_net_exit`.
Date:   Sun, 22 Aug 2021 17:35:55 +0100
Message-Id: <20210822163556.693925-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822163556.693925-1-jeremy@azazel.net>
References: <20210822163556.693925-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`condition_mt_destroy` will be called for every match anyway, so we may
as well do the clean-up then, rather than duplicating it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_condition.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/extensions/xt_condition.c b/extensions/xt_condition.c
index cec232e30f1f..0b0508b7723c 100644
--- a/extensions/xt_condition.c
+++ b/extensions/xt_condition.c
@@ -188,13 +188,11 @@ static void condition_mt_destroy(const struct xt_mtdtor_param *par)
 	struct condition_variable *var = info->condvar;
 	struct condition_net *cnet = condition_pernet(par->net);
 
-	if (!cnet->proc_net_condition)
-		return;
-
 	mutex_lock(&cnet->proc_lock);
 	if (--var->refcount == 0) {
 		list_del(&var->list);
-		remove_proc_entry(var->name, cnet->proc_net_condition);
+		if (cnet->proc_net_condition)
+			remove_proc_entry(var->name, cnet->proc_net_condition);
 		mutex_unlock(&cnet->proc_lock);
 		kfree(var);
 		return;
@@ -242,17 +240,8 @@ static int __net_init condition_net_init(struct net *net)
 static void __net_exit condition_net_exit(struct net *net)
 {
 	struct condition_net *condition_net = condition_pernet(net);
-	struct list_head *pos, *q;
-	struct condition_variable *var = NULL;
 
 	remove_proc_subtree(dir_name, net->proc_net);
-	mutex_lock(&condition_net->proc_lock);
-	list_for_each_safe(pos, q, &condition_net->conditions_list) {
-		var = list_entry(pos, struct condition_variable, list);
-		list_del(pos);
-		kfree(var);
-	}
-	mutex_unlock(&condition_net->proc_lock);
 	condition_net->proc_net_condition = NULL;
 }
 
@@ -263,7 +252,6 @@ static struct pernet_operations condition_net_ops = {
 	.size   = sizeof(struct condition_net),
 };
 
-
 static int __init condition_mt_init(void)
 {
 	int ret;
-- 
2.32.0

