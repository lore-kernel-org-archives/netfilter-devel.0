Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7C1C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 14:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4770860F4B
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 14:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhHNOgy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Aug 2021 10:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhHNOgy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Aug 2021 10:36:54 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78D7C061764
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Aug 2021 07:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hxgCfkyvkHXr5M1jhrqmy0y0ZkkavGQmyp/M2esVA34=; b=utvbdtjV1I+j6uTz46Xw6dwLYL
        ev/je8llUYDPi7lxTzBhVaU/ulVLukv8JlmkAAB3V5AjgUjzAHaVrFRNLhMmNviL/CBtLdr9j2356
        J/dmJXamotJ3+m+NcjcZVf4Gw2emP01c+OyJIykBJfMg63lt9/l3DUWmuIby0RivJUmYGgZkVm87j
        cOcl2PidqnAvsl+bz81KSOdMYx/nzx8au3T/aPiJ/7kv8eH/KS8xGACWjdIZ476MVhdSSp68RBC+m
        TCQ1Mt5MO7SQ0/WgngTlzKt2IzdVWn0qZNckkdPyHREW4ytJTLpfdbcA8iCbfDA05VAl3HaYQ0KD8
        513C/WJg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1mEulp-0006IU-Vx; Sat, 14 Aug 2021 15:36:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] libxt_ACCOUNT_cl: correct LDFLAGS variable name.
Date:   Sat, 14 Aug 2021 15:33:59 +0100
Message-Id: <20210814143359.4582-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The LT library name is libxt_ACCOUNT_cl.la, so the variable should be
`libxt_ACCOUNT_cl_la_LDFLAGS`.

Fixes: 81ab0b9586e6 ("libxt_ACCOUNT_cl: drop padding holes from struct ipt_ACCOUNT_context")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/ACCOUNT/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/ACCOUNT/Makefile.am b/extensions/ACCOUNT/Makefile.am
index e55a6b9bcbef..65a956697b20 100644
--- a/extensions/ACCOUNT/Makefile.am
+++ b/extensions/ACCOUNT/Makefile.am
@@ -9,6 +9,6 @@ sbin_PROGRAMS = iptaccount
 iptaccount_LDADD = libxt_ACCOUNT_cl.la
 
 lib_LTLIBRARIES = libxt_ACCOUNT_cl.la
-libxt_ACCOUNT_cl_LDFLAGS = -version-info 1:0:0
+libxt_ACCOUNT_cl_la_LDFLAGS = -version-info 1:0:0
 
 man_MANS = iptaccount.8
-- 
2.30.2

