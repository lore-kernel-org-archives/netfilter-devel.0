Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BA2C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 16:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiDYQJn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243227AbiDYQJe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 12:09:34 -0400
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Apr 2022 09:06:23 PDT
Received: from libero.it (smtp-36.italiaonline.it [213.209.10.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6BB3D4A7
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 09:06:23 -0700 (PDT)
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it ([87.0.15.73])
        by smtp-36.iol.local with ESMTPA
        id j1DAnY5LYc2f5j1DCnWD0B; Mon, 25 Apr 2022 18:05:20 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1650902720; bh=Nkzut8c/W6FNE00YRIeA2Cc38PFcpFrdNTkD0TmbD10=;
        h=From;
        b=IYnbAJ7SgnCin2UfEBJYLLsa2VqmGMluDDRHqi9/dEE/H5d33sBCDmxqGbwX2Atds
         u7+PWCIE6KudOueRhvhfw9CfLKK2nyLDHr2woD837JKip63Sjqdj4EK8Uk4GwJE4Ex
         27al8IlyyDtSjTeSrMu8VbPoaNGM19geRrRblkNlWlT4K6b5V8klpCcFPioevxpESS
         yHptFDvbDvsZZ0dWh4DCn//LUaaXgN8t6VlHJjG/gratMVFmS1/9573X16D5ozUw2+
         JOg6KhDIcs3e5Tk/D5m6stmWAQv5vzhlLZiiYo2wh0WQzl/6gCjEuLIBVXoUI92EZs
         3R9iAW8/4PY5g==
X-CNFS-Analysis: v=2.4 cv=Z6kpoFdA c=1 sm=1 tr=0 ts=6266c6c0 cx=a_exe
 a=h5x6SpL9bzIPZN26QICeQA==:117 a=h5x6SpL9bzIPZN26QICeQA==:17
 a=pr8dxubn3bouKgSiyaYA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Dario Binacchi <dariobin@libero.it>
Subject: [PATCH 1/1] configure: add an option to compile the examples
Date:   Mon, 25 Apr 2022 18:05:13 +0200
Message-Id: <20220425160513.5343-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfHgx1aWRzD5VaZTRAReieRGBOcLQ6hersizRd0CQ/g/fvT8ewhoseq14UxgS4QasqYtqJRY/xl9IZUuYN3C7UkH53ghcD3rSFNliorS076LwktYwkYR8
 q7NDn5u326UFDf3oSk9IvATPh0h+ffJ9zI1qTXJgv7m+XsILcncZg8G8YDkA42qTImIDsmO/j1HsiS0nzYYNnlHy3yisQi5PggIpVOo4q/M14StAUIcHGwfy
 +tnaZ3A8TVBtiUnaL0mp+tk80JLz2W+co8sZ/vjvB6/rM4Yeb5Fy2ve83fOXsB7g
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Using a configure option to compile the examples is a more common
practice. This can also increase library usage (e.g. buildroot would
now be able to install such applications on the created rootfs).

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---
 Makefile.am               | 7 ++++++-
 README                    | 2 +-
 configure.ac              | 8 +++++++-
 examples/rtnl/Makefile.am | 2 +-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 94e6935..7f8ae56 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,9 +2,14 @@ include $(top_srcdir)/Make_global.am
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = src include examples doxygen
+SUBDIRS = src include doxygen
 DIST_SUBDIRS = src include examples doxygen
 
+if ENABLE_EXAMPLES
+SUBDIRS += examples
+DIST_SUBDIRS += examples
+endif
+
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libmnl.pc
 
diff --git a/README b/README
index fbac9d2..b5f917e 100644
--- a/README
+++ b/README
@@ -21,7 +21,7 @@ forced to use them.
 = Example files =
 
 You can find several example files under examples/ that you can compile by
-invoking `make check'.
+invoking `./configure --enable-examples && make'.
 
 --
 08/sep/2010
diff --git a/configure.ac b/configure.ac
index 314481d..8c88c9b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -21,6 +21,11 @@ case "$host" in
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
+AC_ARG_ENABLE([examples],
+	AS_HELP_STRING([--enable-examples], [Build examples]),
+	[enable_examples="$enableval"], [enable_examples="no"])
+AM_CONDITIONAL([ENABLE_EXAMPLES], [test "$enable_examples" = "yes"])
+
 regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wshadow -Wstrict-prototypes \
@@ -53,4 +58,5 @@ AC_OUTPUT
 
 echo "
 libmnl configuration:
-  doxygen:          ${with_doxygen}"
+  doxygen:          ${with_doxygen}
+  examples:         ${enable_examples}"
diff --git a/examples/rtnl/Makefile.am b/examples/rtnl/Makefile.am
index dd8a77d..017468f 100644
--- a/examples/rtnl/Makefile.am
+++ b/examples/rtnl/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-check_PROGRAMS = rtnl-addr-add \
+bin_PROGRAMS = rtnl-addr-add \
 		 rtnl-addr-dump \
 		 rtnl-link-dump rtnl-link-dump2 rtnl-link-dump3 \
 		 rtnl-link-event \
-- 
2.17.1

