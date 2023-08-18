Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C398C71147
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 12:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359638AbjHRMil (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 08:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376971AbjHRMib (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 08:38:31 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3540E3A80
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 05:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cIMw5EQOKJV6T5MMzV+OMjOEbkClR0c6h8FVgzprxA0=; b=nwRW7hMRkMZOypXnegjewxxha8
        r/S9P3j99lYYM7141dluYit0BKLTIHTpVjvG3JG4puWR0boi0OBhojh/Il/7l9h34tkYGmopjJwE5
        aYQMwjCrVEtndV+JtyugGX30001UyA3X+03ARr0GADqO3yhXcGfHZIg5JDduonYrlsVgvvYEGAddP
        uFhHMybtbfA3CTG6F7Gj72LVGg6HuhkbCV2LKiAPnAuQMIR4mQd7axw0YVrkupt75JZE94UzkiCQz
        Vow3tXcENlFgljeJWtsYBgj+e73J++sumoAaxK1IcAqWDizcyhi4cREwQwqR9ZqzkUh7QILf5TxOy
        rF0gMY/Q==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qWykC-005x0b-2X
        for netfilter-devel@vger.kernel.org;
        Fri, 18 Aug 2023 13:38:24 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/5] build: use `$(top_srcdir)` when including Makefile.extra
Date:   Fri, 18 Aug 2023 13:38:14 +0100
Message-Id: <20230818123818.2739947-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230818123818.2739947-1-jeremy@azazel.net>
References: <20230818123818.2739947-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's less fragile than using hard-coded relative paths.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/ACCOUNT/Makefile.am | 2 +-
 extensions/Makefile.am         | 2 +-
 extensions/pknock/Makefile.am  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/ACCOUNT/Makefile.am b/extensions/ACCOUNT/Makefile.am
index 65a956697b20..473a739f981a 100644
--- a/extensions/ACCOUNT/Makefile.am
+++ b/extensions/ACCOUNT/Makefile.am
@@ -3,7 +3,7 @@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
 AM_CFLAGS   = ${regular_CFLAGS} ${libxtables_CFLAGS}
 
-include ../../Makefile.extra
+include $(top_srcdir)/Makefile.extra
 
 sbin_PROGRAMS = iptaccount
 iptaccount_LDADD = libxt_ACCOUNT_cl.la
diff --git a/extensions/Makefile.am b/extensions/Makefile.am
index a487fd8c141a..eebb82fd2f22 100644
--- a/extensions/Makefile.am
+++ b/extensions/Makefile.am
@@ -26,4 +26,4 @@ install-exec-local: modules_install
 
 clean-local: clean_modules
 
-include ../Makefile.extra
+include $(top_srcdir)/Makefile.extra
diff --git a/extensions/pknock/Makefile.am b/extensions/pknock/Makefile.am
index 35528709aa15..5fcae4794230 100644
--- a/extensions/pknock/Makefile.am
+++ b/extensions/pknock/Makefile.am
@@ -3,7 +3,7 @@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
 AM_CFLAGS   = ${regular_CFLAGS} ${libxtables_CFLAGS}
 
-include ../../Makefile.extra
+include $(top_srcdir)/Makefile.extra
 
 sbin_PROGRAMS = pknlusr
 dist_man_MANS = pknlusr.8
-- 
2.40.1

