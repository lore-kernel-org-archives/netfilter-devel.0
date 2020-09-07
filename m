Return-Path: <SRS0=Y+c4=CQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7192DC43461
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 10:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D2D20738
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 10:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="HqgfP1Wj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgIGKju (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Sep 2020 06:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgIGKjY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Sep 2020 06:39:24 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5CAC061573
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2020 03:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fJ1k0JtZ8Zhl0SUQ72gB3ju0wRHICxTvHHbpiKcccsE=; b=HqgfP1WjFRiO1uFZv4qcQ87B/u
        5uEFe4sEvp5WfAVi6xM7hdH5oRSnnITRjkWbR7DxvXciqqMIV4wCT6PqzSonqmVMrTnEgOo21Tfry
        IB3luvf287VB3/BhOrA8hAFQMLMwzUa1IMFdiHfZxzlwG1GzBue8znReoSPBy8K1+W0dl2jsRAU0/
        68TqJOEZQZ8KF3/1cPF+FYijV2btB/dmtOUKo7rltPcDBqmKIvrtEPo2uJdlEDbz1mectw35JRhou
        mr5VLS0co2WoDk5/Y9gjjQIfD2LlrSoV2338z6w7/5A5YPwwZtlXVsf+kbdOiPOYhG9PG0lDoknHf
        TV9iXG2w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kFEYF-0007bS-74; Mon, 07 Sep 2020 11:39:07 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_queue] build: check whether dot is available when configuring doxygen.
Date:   Mon,  7 Sep 2020 11:39:04 +0100
Message-Id: <20200907103904.238656-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907012255.GC6585@dimstar.local.net>
References: <20200907012255.GC6585@dimstar.local.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac   | 4 ++++
 doxygen.cfg.in | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index d8d1d387c773..32e499071b26 100644
--- a/configure.ac
+++ b/configure.ac
@@ -41,6 +41,10 @@ AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
 	    [], [with_doxygen=no])
 AS_IF([test "x$with_doxygen" = xyes], [
 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
+	AC_CHECK_PROGS([DOT], [dot], [""])
+	AS_IF([test "x$DOT" != "x"],
+	      [AC_SUBST(HAVE_DOT, YES)],
+	      [AC_SUBST(HAVE_DOT, NO)])
 ])
 
 AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 3f13f97ad8ba..c54f534ada3f 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -161,7 +161,7 @@ PERL_PATH              = /usr/bin/perl
 CLASS_DIAGRAMS         = YES
 MSCGEN_PATH            =
 HIDE_UNDOC_RELATIONS   = YES
-HAVE_DOT               = YES
+HAVE_DOT               = @HAVE_DOT@
 CLASS_GRAPH            = YES
 COLLABORATION_GRAPH    = YES
 GROUP_GRAPHS           = YES
-- 
2.28.0

