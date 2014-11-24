From: David Kozub <zub.272@gmail.com>
Subject: [PATCH] build: add missing \ in src/Makefile.am (AM_CPPFLAGS)
Date: Mon, 24 Nov 2014 22:17:34 +0100
Message-ID: <E1Xt1QK-0000ov-GU@humel>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36838 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKXVoA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:44:00 -0500
Received: by mail-wg0-f54.google.com with SMTP id l2so3020964wgh.27
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 13:43:58 -0800 (PST)
Received: from humel ([2002:59b0:dbd::1])
        by mx.google.com with ESMTPSA id gi5sm22731124wjd.26.2014.11.24.13.43.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Nov 2014 13:43:58 -0800 (PST)
Received: from zub by humel with local (Exim 4.84)
	(envelope-from <ef542e791568b0cd2daa261cce5fdc8f07fefc7c@zub.t05.sg>)
	id 1Xt1QK-0000ov-GU
	for netfilter-devel@vger.kernel.org; Mon, 24 Nov 2014 22:43:56 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The missing \ at the end of the line causes LIBMNL_CFLAGS and LIBNFTNL_CFLAGS
to be ignored. This causes build failure if the libmnl or libnftnl headers are
not in a path that's already searched by the C compiler.
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 0a67810..1ca06f3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,7 +3,7 @@ sbin_PROGRAMS = nft
 CLEANFILES = scanner.c parser_bison.c
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\""
+AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" \
 		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
 
 AM_CFLAGS = -Wall								\
-- 
2.1.3

