Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520C7C432BE
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380C761165
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhHVQjB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhHVQjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:00 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2B7C061757
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G+ZtOPIuxMDge10ZwTzoAUGfHvb31rrk9qj+1ONc3H0=; b=qppKYWlMjAkgOuJkDYKR3l7DjB
        W+cs/ZWLEy0Ad4kNx98IG4zIowv5rI7ulH04CrYlz0CIs5TK4k9AzWgr2G0GANde4Z9ln5pqxIy3O
        Nd2Nr/nMQv0lebbXNQ+E/qqYn4Yhb3JcypGETTWHbiNPdK7co0RVVij3eWbBHBltFu//O9UeJBEER
        gKgTo08wt7MuuEfubldpwxofSo5I5XbWIrejXboz2zYmqutd5Obecu7r0S4SDowv6OA78TD1bjqc8
        MN4b/nZOaQd5v5ascu4nr8RDJ4Npuncd2WcOpLxtIe+oXINkoGA9RYHoMRKGfW2KnJ4bxcJZ8efhr
        BN3bN4wQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUC-008Q2I-Ax; Sun, 22 Aug 2021 17:38:16 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 2/8] xt_condition: use sizeof_field macro to size variable name.
Date:   Sun, 22 Aug 2021 17:35:50 +0100
Message-Id: <20210822163556.693925-3-jeremy@azazel.net>
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

4.16 introduced a macro for getting the size of a struct member, so
let's use it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_condition.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/xt_condition.c b/extensions/xt_condition.c
index 8227c5d13f1a..c2c48670c788 100644
--- a/extensions/xt_condition.c
+++ b/extensions/xt_condition.c
@@ -55,7 +55,7 @@ struct condition_variable {
 	struct proc_dir_entry *status_proc;
 	unsigned int refcount;
 	bool enabled;
-	char name[sizeof(((struct xt_condition_mtinfo *)NULL)->name)];
+	char name[sizeof_field(struct xt_condition_mtinfo, name)];
 };
 
 /* proc_lock is a user context only semaphore used for write access */
-- 
2.32.0

