Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E92C43217
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFA3610F7
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhIYPQO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343922AbhIYPQL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:16:11 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9596CC061769
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EMkBEg5ANpkydGnd88o+tCojG2TO1JDiWVl5uFFeMBA=; b=KmLpgSKvhApBxXqWZOxQcikvu0
        GK6Z5V+XOh4bDbBBcJsFhcpznDQmmBGBj+SaqBZ5SzWpILjg2mabNeNJ20gMRcp1AGc5ABXqDXWTi
        QVUSGKgoKWDRIntNq1b61yrLV8nXUBshGf3xVEyKVx0XQrsCMnYFJpmqL259Hs9zj879JJqxyeal3
        GYGTBf+9oINL6zXvRBNVhk2r2eUjDey4dY/f3k7eibRH5Pk/a0CLdjzBn80u0J6ztcCVwyUvY17D9
        WvE3Vok5gOpPv1H7knXFAyTCwYdefsAZOcxE00/fWjcauJi20PBzqet4QWK/gWMCdfKxdFtA+fHNu
        XxN3OYzA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mU9Nn-00Cses-Cw; Sat, 25 Sep 2021 16:14:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools 5/6] build: clean yacc- and lex-generated files with maintainer-clean
Date:   Sat, 25 Sep 2021 16:10:34 +0100
Message-Id: <20210925151035.850310-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210925151035.850310-1-jeremy@azazel.net>
References: <20210925151035.850310-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Automake expects to distribute yacc- and lex-generated sources, so that
the user doesn't need to regenerate them.  Therefore, the appropriate
target to clean them is `maintainer-clean`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 75b16a7b6f35..85ea18888e97 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,7 +6,7 @@ endif
 
 AM_YFLAGS = -d
 
-CLEANFILES = read_config_yy.c read_config_lex.c
+MAINTAINERCLEANFILES = read_config_yy.c read_config_yy.h read_config_lex.c
 
 sbin_PROGRAMS = conntrack conntrackd nfct
 
-- 
2.33.0

