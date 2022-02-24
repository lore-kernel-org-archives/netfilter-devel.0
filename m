Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5511AC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 19:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiBXTqm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 14:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiBXTqm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 14:46:42 -0500
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61E9227590
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 11:46:10 -0800 (PST)
From:   Sam James <sam@gentoo.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Sam James <sam@gentoo.org>
Subject: [PATCH 2/2] build: explicitly pass --version-script to linker
Date:   Thu, 24 Feb 2022 19:45:43 +0000
Message-Id: <20220224194543.59581-2-sam@gentoo.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224194543.59581-1-sam@gentoo.org>
References: <20220224194543.59581-1-sam@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--version-script is a linker option, so let's use -Wl, so that
libtool handles it properly. It seems like the previous method gets silently
ignored with GNU libtool in some cases(?) and downstream in Gentoo,
we had to apply this change to make the build work with slibtool anyway.

But it's indeed correct in any case, so let's swap.

Signed-off-by: Sam James <sam@gentoo.org>
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 4cfba0af..e96cee77 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -91,7 +91,7 @@ libparser_la_CFLAGS = ${AM_CFLAGS} \
 
 libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS} libparser.la
 libnftables_la_LDFLAGS = -version-info ${libnftables_LIBVERSION} \
-			 --version-script=$(srcdir)/libnftables.map
+			 -Wl,--version-script=$(srcdir)/libnftables.map
 
 if BUILD_MINIGMP
 noinst_LTLIBRARIES += libminigmp.la
-- 
2.35.1

