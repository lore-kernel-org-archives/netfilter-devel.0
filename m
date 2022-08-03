Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C10C3F6B0
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiHCUNr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbiHCUNq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 16:13:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9B5018E
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IMHgb2aap6gTQPn74bhjzZ4pxwf2sSjuTc8/Mp4ul1U=; b=D3000VGL3X2qS0Kvx8CqymwrOt
        2wTneSdG2n8WGYpXNvUiC39V+QVJR2NOPYQ/g5dRgP7nZMGQ/fPqdZriSiL2+Fse/XaiWJ2spOnbL
        ulSVLjFYkYD9KkxFxyb8FKfT8y+VdsCAGZCxHVNVikSR8s6tMIdcWQtN28CEhvoJe4ULqMqtsIQAd
        S9oWe+ER8VBPVP1mrjYxYxGSZIEZ21UE61elsPyZsW8dz1r3jfWBNOIhKWVZgoJUE/xkerKbcqT7z
        yyJTW6o7EzOxGqsDbjQYemeO30o4JmXmaBUtBeAWPteyvo//L0LYcKL3QRLr64iLtP4tI2c2qon3D
        qpodmUIg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJKkK-001Fnp-1T; Wed, 03 Aug 2022 21:13:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl 3/6] doc: change `INPUT` doxygen setting to `@top_srcdir@`
Date:   Wed,  3 Aug 2022 21:12:44 +0100
Message-Id: <20220803201247.3057365-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220803201247.3057365-1-jeremy@azazel.net>
References: <20220803201247.3057365-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It avoids the need to move src directories in doxygen/Makefile.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doxygen.cfg.in      |  2 +-
 doxygen/Makefile.am | 11 -----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index ae31dbe4c16c..d6db0048a1f7 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -6,7 +6,7 @@ ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
-INPUT                  = .
+INPUT                  = @top_srcdir@
 FILE_PATTERNS          = */src/*.c
 RECURSIVE              = YES
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL mnl_nlmsg_batch mnl_socket
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 29078dee122a..bca5092b4aec 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -4,18 +4,7 @@ doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
-
-# Test for running under make distcheck.
-# If so, sibling src directory will be empty:
-# move it out of the way and symlink the real one while we run doxygen.
-	[ -f ../src/Makefile.in ] || \
-{ set -x; cd ..; mv src src.distcheck; ln -s $(top_srcdir)/src; }
-
 	cd ..; doxygen doxygen.cfg >/dev/null
-
-	[ ! -d ../src.distcheck ] || \
-{ set -x; cd ..; rm src; mv src.distcheck src; }
-
 # We need to use bash for its associative array facility
 # (`bash -p` prevents import of functions from the environment).
 # The command has to be a single line so the functions work
-- 
2.35.1

