Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A492C4320E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E9561165
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhHVQjC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhHVQjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:00 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0394C061756
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ejx+0mX8Mj0w6fuGZGT8Po3hvfjfB6MGdxsusfpcnnw=; b=R7g6l9SqQKREuQ38F/IffiUlB7
        rnX8iBKtvYvHj330v31xHZpWPfbFd+evULczG5dh65lCyuWvv1L8f6sGilkncKVXYOXyvr2bRRXad
        eT+8X1Il8VFNLGDvPgxAEmV6wCdnjZbaP5IY37rk/+oY0zU2uHsgatB2Sm5jCkChdFwEuTm4A0+J+
        Bt+qEtmiwmS86wh3+XCVtgnAalzx+73rJ1u0V8BKm0n+hdqM7xNaMlbD5FVoghS+JvrsO7L8Zg3/B
        tSQgtt4dRiAT5Sr/RSRGQslKhtvlFOrcsQIQsdpXvluO1I4CnjfGMWXuAuKs+sLB/J/Dh9qEg0gHB
        apuBF3HA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUC-008Q2I-UN; Sun, 22 Aug 2021 17:38:17 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 4/8] xt_condition: make mutex per-net.
Date:   Sun, 22 Aug 2021 17:35:52 +0100
Message-Id: <20210822163556.693925-5-jeremy@azazel.net>
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

The mutex protects per-net resources, so make it per-net too.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_condition.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/extensions/xt_condition.c b/extensions/xt_condition.c
index 1d9d7352f069..e1672985e59b 100644
--- a/extensions/xt_condition.c
+++ b/extensions/xt_condition.c
@@ -58,11 +58,10 @@ struct condition_variable {
 	char name[sizeof_field(struct xt_condition_mtinfo, name)];
 };
 
-/* proc_lock is a user context only semaphore used for write access */
-/*           to the conditions' list.                               */
-static DEFINE_MUTEX(proc_lock);
-
 struct condition_net {
+	/* proc_lock is a user context only semaphore used for write access */
+	/*           to the conditions' list.                               */
+	struct mutex proc_lock;
 	struct list_head conditions_list;
 	struct proc_dir_entry *proc_net_condition;
 	bool after_clear;
@@ -145,11 +144,11 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	 * Let's acquire the lock, check for the condition and add it
 	 * or increase the reference counter.
 	 */
-	mutex_lock(&proc_lock);
+	mutex_lock(&condition_net->proc_lock);
 	list_for_each_entry(var, &condition_net->conditions_list, list) {
 		if (strcmp(info->name, var->name) == 0) {
 			var->refcount++;
-			mutex_unlock(&proc_lock);
+			mutex_unlock(&condition_net->proc_lock);
 			info->condvar = var;
 			return 0;
 		}
@@ -158,7 +157,7 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	/* At this point, we need to allocate a new condition variable. */
 	var = kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
 	if (var == NULL) {
-		mutex_unlock(&proc_lock);
+		mutex_unlock(&condition_net->proc_lock);
 		return -ENOMEM;
 	}
 
@@ -168,7 +167,7 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	                   condition_net->proc_net_condition, &condition_proc_fops, var);
 	if (var->status_proc == NULL) {
 		kfree(var);
-		mutex_unlock(&proc_lock);
+		mutex_unlock(&condition_net->proc_lock);
 		return -ENOMEM;
 	}
 
@@ -179,7 +178,7 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	var->enabled  = false;
 	wmb();
 	list_add(&var->list, &condition_net->conditions_list);
-	mutex_unlock(&proc_lock);
+	mutex_unlock(&condition_net->proc_lock);
 	info->condvar = var;
 	return 0;
 }
@@ -193,15 +192,15 @@ static void condition_mt_destroy(const struct xt_mtdtor_param *par)
 	if (cnet->after_clear)
 		return;
 
-	mutex_lock(&proc_lock);
+	mutex_lock(&cnet->proc_lock);
 	if (--var->refcount == 0) {
 		list_del(&var->list);
 		remove_proc_entry(var->name, cnet->proc_net_condition);
-		mutex_unlock(&proc_lock);
+		mutex_unlock(&cnet->proc_lock);
 		kfree(var);
 		return;
 	}
-	mutex_unlock(&proc_lock);
+	mutex_unlock(&cnet->proc_lock);
 }
 
 static struct xt_match condition_mt_reg[] __read_mostly = {
@@ -232,6 +231,8 @@ static const char *const dir_name = "nf_condition";
 static int __net_init condition_net_init(struct net *net)
 {
 	struct condition_net *condition_net = condition_pernet(net);
+
+	mutex_init(&condition_net->proc_lock);
 	INIT_LIST_HEAD(&condition_net->conditions_list);
 	condition_net->proc_net_condition = proc_mkdir(dir_name, net->proc_net);
 	if (condition_net->proc_net_condition == NULL)
@@ -247,13 +248,13 @@ static void __net_exit condition_net_exit(struct net *net)
 	struct condition_variable *var = NULL;
 
 	remove_proc_subtree(dir_name, net->proc_net);
-	mutex_lock(&proc_lock);
+	mutex_lock(&condition_net->proc_lock);
 	list_for_each_safe(pos, q, &condition_net->conditions_list) {
 		var = list_entry(pos, struct condition_variable, list);
 		list_del(pos);
 		kfree(var);
 	}
-	mutex_unlock(&proc_lock);
+	mutex_unlock(&condition_net->proc_lock);
 	condition_net->after_clear = true;
 }
 
@@ -269,7 +270,6 @@ static int __init condition_mt_init(void)
 {
 	int ret;
 
-	mutex_init(&proc_lock);
 	ret = register_pernet_subsys(&condition_net_ops);
 	if (ret != 0)
 		return ret;
-- 
2.32.0

