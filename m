Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CF0C43216
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6424361165
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhHVQjC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhHVQjB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:01 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADAAC061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hplBS7TiK4hO999Q354yLMXUEIMfwlur5kvTU+GznN8=; b=tqJTHQ1tKP2hDagO5iW1ZQAgBe
        sehoIoVuhRTx/5avRceWDwLvKHAPe5DLcT9lMeYynzKaTz1BCDyQ4deGN1E65cxfmbQtIFF89WBSu
        VdIo4JEwZ+K6bR3qsMTDfsJF1JhsUihn9c3J2g+9e5+UU0xXYKGerQbAOomy1nnRl7tq1l69orqaq
        R9WTDwWZCgWpVlzpK4tdIK+UWjLFJPCIcNVLsBwaUJAsvR5tWhrs9L9hpq/WYLundZ9bxD93FaT6A
        wWgdZOX2ZcTBnhv4jsgfDfXS4eNHON4C215f7/5bzRNxa7iGB8f4cjkj28m5e9Gz3+Cq4F27OddFW
        NzuMTTVA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUD-008Q2I-CE; Sun, 22 Aug 2021 17:38:17 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 5/8] xt_condition: remove `wmb` when adding new variable.
Date:   Sun, 22 Aug 2021 17:35:53 +0100
Message-Id: <20210822163556.693925-6-jeremy@azazel.net>
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

Originally, some accesses to `conditions_list` were protected by RCU and
the memory-barrier was needed to ensure that the new variable was fully
initialized before being added to the list.  These days, however, all
accesses are protected by the `proc_lock` mutex, so the barrier is no
longer required.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_condition.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/xt_condition.c b/extensions/xt_condition.c
index e1672985e59b..d390faeac1b0 100644
--- a/extensions/xt_condition.c
+++ b/extensions/xt_condition.c
@@ -176,7 +176,7 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	              make_kgid(&init_user_ns, condition_gid_perms));
 	var->refcount = 1;
 	var->enabled  = false;
-	wmb();
+
 	list_add(&var->list, &condition_net->conditions_list);
 	mutex_unlock(&condition_net->proc_lock);
 	info->condvar = var;
-- 
2.32.0

