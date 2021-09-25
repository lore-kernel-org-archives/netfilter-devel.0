Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E489C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F30EF60EE9
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343947AbhIYPQL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343799AbhIYPQK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:16:10 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97338C061604
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I0P73IMB6xuv2xGHhq17aI3z8drkLMt0kyph5yUpODA=; b=MJJLaxoTfO55S5UKC0YD9BkSSb
        lNtNhYFViNIUXDDbvGTaCvQNhQIKd1p0RrK5IDhVbsHXTRB6iWIdSJ8c3Q0m0a9dBaJ3h21+mU5MD
        JF5zoG8DdjxBoxaj434iYQX290O7IlxdLsaNlAQDChefF7AxV6On4R+AQQ8Y5EQE2Dn2IKmoZO0la
        gbMQV3FmFkmZ9ImTM+l+Jb+Nw9oxm7P8tcS18Of1WVkHZjXMDpaivCTdOTDAPnzyWt28ZnljY/PMl
        akdHHn0/k68QAeG9k+oH1EMFZZmORlHBUy18Ekhdft2pcrITmDXFWepUBLS6hPhIVb28bkiETj3BY
        5QPqa8iA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mU9Nk-00Cses-L1; Sat, 25 Sep 2021 16:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools 1/6] build: remove commented-out macros from configure.ac
Date:   Sat, 25 Sep 2021 16:10:30 +0100
Message-Id: <20210925151035.850310-2-jeremy@azazel.net>
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

This code has been commented out since at least 2007.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/configure.ac b/configure.ac
index d0565bed3532..5ff8921b6fc8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -75,37 +75,12 @@ AM_CONDITIONAL([HAVE_SYSTEMD], [test "x$enable_systemd" = "xyes"])
 
 AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabibility.h])])
 
-# Checks for libraries.
-# FIXME: Replace `main' with a function in `-lc':
-dnl AC_CHECK_LIB([c], [main])
-# FIXME: Replace `main' with a function in `-ldl':
-
 AC_CHECK_HEADERS(arpa/inet.h)
-dnl check for inet_pton
 AC_CHECK_FUNCS(inet_pton)
 
-# Checks for header files.
-dnl AC_HEADER_STDC
-dnl AC_CHECK_HEADERS([netinet/in.h stdlib.h])
-
-# Checks for typedefs, structures, and compiler characteristics.
-dnl AC_C_CONST
-dnl AC_C_INLINE
-
 # Let nfct use dlopen() on helper libraries without resolving all symbols.
 AX_CHECK_LINK_FLAG([-Wl,-z,lazy], [AC_SUBST([LAZY_LDFLAGS], [-Wl,-z,lazy])])
 
-# Checks for library functions.
-dnl AC_FUNC_MALLOC
-dnl AC_FUNC_VPRINTF
-dnl AC_CHECK_FUNCS([memset])
-
-dnl AC_CONFIG_FILES([Makefile
-dnl                  debug/Makefile
-dnl                  debug/src/Makefile
-dnl                  extensions/Makefile
-dnl                  src/Makefile])
-
 if test ! -z "$libdir"; then
 	MODULE_DIR="\\\"$libdir/conntrack-tools/\\\""
 	CFLAGS="$CFLAGS -DCONNTRACKD_LIB_DIR=$MODULE_DIR"
-- 
2.33.0

