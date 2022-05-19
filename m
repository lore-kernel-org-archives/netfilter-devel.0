Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A7EC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 18:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241786AbiESSHb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 14:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241349AbiESSH3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 14:07:29 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969EC941AF
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2022 11:07:26 -0700 (PDT)
Received: (Authenticated sender: ben@demerara.io)
        by mail.gandi.net (Postfix) with ESMTPSA id 15437C0004
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2022 18:07:24 +0000 (UTC)
Message-ID: <d454c825-2d43-56d9-d001-e98308d2dd1b@demerara.io>
Date:   Thu, 19 May 2022 19:07:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:100.0) Gecko/20100101
 Thunderbird/100.0a1
Content-Language: en-US
From:   Ben Brown <ben@demerara.io>
Subject: [iptables PATCH] build: Fix error during out of tree build
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From a7a2f49a53ce5487a9869cd44b647de0882c6996 Mon Sep 17 00:00:00 2001
From: Ben Brown <ben@demerara.io>
Date: Thu, 19 May 2022 18:50:25 +0100
Subject: [PATCH] build: Fix error during out of tree build

Fixes the following error:

    ../../libxtables/xtables.c:52:10: fatal error: libiptc/linux_list.h:
No such file or directory
       52 | #include <libiptc/linux_list.h>

Signed-off-by: Ben Brown <ben@demerara.io>
---
 libxtables/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxtables/Makefile.am b/libxtables/Makefile.am
index 8ff6b0ca..3bfded85 100644
--- a/libxtables/Makefile.am
+++ b/libxtables/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-

 AM_CFLAGS   = ${regular_CFLAGS}
-AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include
-I${top_srcdir}/include -I${top_srcdir}/iptables ${kinclude_CPPFLAGS}
+AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include
-I${top_srcdir}/include -I${top_srcdir}/iptables -I${top_srcdir}
${kinclude_CPPFLAGS}

 lib_LTLIBRARIES       = libxtables.la
 libxtables_la_SOURCES = xtables.c xtoptions.c getethertype.c
-- 
2.36.1

