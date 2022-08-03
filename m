Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A2BC19F2C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiHCUNv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237819AbiHCUNt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 16:13:49 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5555466C
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6Nx+hzOaIiEelZVmqeVMQbT2AMLpYhtV+hxKsZG+v0k=; b=WvYYBzJWxKGo3L99DCGsRtSxtO
        VujGHrNHO6DSAZnICgeV+iQeNOzS2KUBAkvxek547A2MlrMaTQDxxfSm3wvABy1euKqWzw8wL+bW8
        HShqmOQBUP5FEvVttTcN+U2PM49o1g/zI7QkTD0+FR9e/66niDBItywsBvMVVGh5LGgWmJCNE+8ay
        7JGQVlZuga40ZiREmUmtiQQIl6eaC531K/1jHHYLytGxn51SKfBmDjPKO6I4crptl71RGeozeAbUH
        hoTvTdGzBI46ml/UfNaLdVt00gsBftDHPERT8mGJ70aBwYMYJei1AuZ8a0ED2NRzBiCbfOwwsntX7
        7VXkx+bw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJKkK-001Fnp-4Q; Wed, 03 Aug 2022 21:13:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl 4/6] doc: move doxygen config file into doxygen directory
Date:   Wed,  3 Aug 2022 21:12:45 +0100
Message-Id: <20220803201247.3057365-5-jeremy@azazel.net>
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

Now that the `INPUT` directory is correct, we can update `OUTPUT_DIRECTORY` to
`.` and we don't need to cd out of the doxygen directory to run doxygen.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore                               |  1 -
 configure.ac                             | 15 ++++++++++++++-
 doxygen/.gitignore                       |  1 +
 doxygen/Makefile.am                      |  2 +-
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  2 +-
 5 files changed, 17 insertions(+), 4 deletions(-)
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (95%)

diff --git a/.gitignore b/.gitignore
index 0276c98fb3a5..b6b8d60db5dc 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,7 +15,6 @@ Makefile.in
 /libtool
 /stamp-h1
 
-/doxygen.cfg
 /libmnl.pc
 
 /libmnl-*.tar.bz2
diff --git a/configure.ac b/configure.ac
index 314481dae87e..dcdd4245175e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -27,7 +27,20 @@ regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wformat=2 -pipe"
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
-AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libmnl/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile examples/genl/Makefile examples/kobject/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg doxygen/Makefile])
+AC_CONFIG_FILES([Makefile
+		 src/Makefile
+		 include/Makefile
+		 include/libmnl/Makefile
+		 include/linux/Makefile
+		 include/linux/netfilter/Makefile
+		 examples/Makefile
+		 examples/genl/Makefile
+		 examples/kobject/Makefile
+		 examples/netfilter/Makefile
+		 examples/rtnl/Makefile
+		 libmnl.pc
+		 doxygen/doxygen.cfg
+		 doxygen/Makefile])
 
 AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
 	    [create doxygen documentation])],
diff --git a/doxygen/.gitignore b/doxygen/.gitignore
index a23345c2c599..2196cf8c442b 100644
--- a/doxygen/.gitignore
+++ b/doxygen/.gitignore
@@ -1,3 +1,4 @@
 doxyfile.stamp
+doxygen.cfg
 html/
 man/
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index bca5092b4aec..3f0b1e9a8ab4 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -4,7 +4,7 @@ doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
-	cd ..; doxygen doxygen.cfg >/dev/null
+	doxygen doxygen.cfg >/dev/null
 # We need to use bash for its associative array facility
 # (`bash -p` prevents import of functions from the environment).
 # The command has to be a single line so the functions work
diff --git a/doxygen.cfg.in b/doxygen/doxygen.cfg.in
similarity index 95%
rename from doxygen.cfg.in
rename to doxygen/doxygen.cfg.in
index d6db0048a1f7..24089ac0cb95 100644
--- a/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -1,7 +1,7 @@
 # Difference with default Doxyfile 1.8.20
 PROJECT_NAME           = @PACKAGE@
 PROJECT_NUMBER         = @VERSION@
-OUTPUT_DIRECTORY       = doxygen
+OUTPUT_DIRECTORY       = .
 ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
-- 
2.35.1

