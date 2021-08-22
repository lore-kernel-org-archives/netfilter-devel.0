Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1788C43214
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95076113B
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhHVQjB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhHVQjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:00 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFDAC061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oGhpPwTnWPg+zZpcnWzBvr0OUiYi1AzZnCpSC0EAK34=; b=s+oWl08QODo9QVrFTNqRNRGizX
        iKpy/ekWwa4ubCLokMMWlBZNhUX4QRvePYnLlsz2t6rcmf+kVgLv0TWr+Yz2/0mo7HiJHwUSrrczm
        bABpYs97nFhhgjCvrIwH1kYf+JVLAFXOsDqVRm4JUNkC09Npox79m19e8MnP3iyeJ+5rphO+eycbA
        an9J+Y9fTHIkcZ5jPsgjzpOZuifzrJnqEjW0fQi3ZMzodKdCC2ONL8teEWvaBRrXj7/ryFhjOQ8lm
        BAU66Gmw1Y8XZy55tXY6QaTux2WpM+wPVYmfTzQswIxNlnQqrWGAG/2i2FgwtZhG59Qe19IcOydQ2
        5pj1ObaA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUC-008Q2I-JZ; Sun, 22 Aug 2021 17:38:16 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 3/8] xt_condition: use `xt_check_proc_name` to validate /proc file-name.
Date:   Sun, 22 Aug 2021 17:35:51 +0100
Message-Id: <20210822163556.693925-4-jeremy@azazel.net>
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

4.16 introduced a standard function to do the job, so let's use it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_condition.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/extensions/xt_condition.c b/extensions/xt_condition.c
index c2c48670c788..1d9d7352f069 100644
--- a/extensions/xt_condition.c
+++ b/extensions/xt_condition.c
@@ -135,9 +135,7 @@ static int condition_mt_check(const struct xt_mtchk_param *par)
 	struct condition_net *condition_net = condition_pernet(par->net);
 
 	/* Forbid certain names */
-	if (*info->name == '\0' || *info->name == '.' ||
-	    info->name[sizeof(info->name)-1] != '\0' ||
-	    memchr(info->name, '/', sizeof(info->name)) != NULL) {
+	if (xt_check_proc_name(info->name, sizeof(info->name))) {
 		printk(KERN_INFO KBUILD_MODNAME ": name not allowed or too "
 		       "long: \"%.*s\"\n", (unsigned int)sizeof(info->name),
 		       info->name);
-- 
2.32.0

