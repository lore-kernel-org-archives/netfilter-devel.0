Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AD9C00144
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D01FF6113B
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhHVQjD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhHVQjB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:01 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F28DC061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b4SrvaBN8rIbsu6y2tuN1DnWxxOpfTOHc6v+kCJwKRA=; b=tdnuuwNYXQ3lgvPnluBALcIxFU
        UL0Z6RlW+9YXu045Y1KMSVNlhdOjhaMYMwUkxfAMH31GpC5MX8RQsargZl7R5CQ+FUldnDCTEizEt
        d4zkKDJJ5iZENfag/MI72EcusToj9MdaTiHHyT4F3uQN467f85AA7PdpajW4UFDFf6SBiiTn/sFxN
        xSygJGfjwV7IFnuoB5pFNAn+UCpDPHxxO5kbj4yRMAcnWdOlkAWCTHguxQjG7os95Jp15XsoMa1GW
        UlSim1z1HERQ9eTJOqetnE9Cm3M+NDvBKv57AIWi++4991/8LVS/RwTNYh+8Jsnn808Y0w9TZOPZc
        qh0dyM+g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUD-008Q2I-La; Sun, 22 Aug 2021 17:38:17 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 6/8] xt_condition: use `proc_net_condition` member of `struct condition_net`to signal that `condition_net_exit` has been called.
Date:   Sun, 22 Aug 2021 17:35:54 +0100
Message-Id: <20210822163556.693925-7-jeremy@azazel.net>
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

There's no need for a separate boolean flag when we can just set
`proc_net_condition` to `NULL` after the directory has been removed.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_condition.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/xt_condition.c b/extensions/xt_condition.c
index d390faeac1b0..cec232e30f1f 100644
--- a/extensions/xt_condition.c
+++ b/extensions/xt_condition.c
@@ -64,7 +64,6 @@ struct condition_net {
 	struct mutex proc_lock;
 	struct list_head conditions_list;
 	struct proc_dir_entry *proc_net_condition;
-	bool after_clear;
 };
 
 static int condition_net_id;
@@ -189,7 +188,7 @@ static void condition_mt_destroy(const struct xt_mtdtor_param *par)
 	struct condition_variable *var = info->condvar;
 	struct condition_net *cnet = condition_pernet(par->net);
 
-	if (cnet->after_clear)
+	if (!cnet->proc_net_condition)
 		return;
 
 	mutex_lock(&cnet->proc_lock);
@@ -237,7 +236,6 @@ static int __net_init condition_net_init(struct net *net)
 	condition_net->proc_net_condition = proc_mkdir(dir_name, net->proc_net);
 	if (condition_net->proc_net_condition == NULL)
 		return -EACCES;
-	condition_net->after_clear = 0;
 	return 0;
 }
 
@@ -255,7 +253,7 @@ static void __net_exit condition_net_exit(struct net *net)
 		kfree(var);
 	}
 	mutex_unlock(&condition_net->proc_lock);
-	condition_net->after_clear = true;
+	condition_net->proc_net_condition = NULL;
 }
 
 static struct pernet_operations condition_net_ops = {
-- 
2.32.0

