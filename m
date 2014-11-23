From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: restore nft --debug
Date: Sun, 23 Nov 2014 21:11:02 +0100
Message-ID: <1416773463-8583-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, bjornar.ness@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37078 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaKWUJE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:09:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add -DDEBUG to enable --debug option by default as it used to be before
the autotools conversion.

Fixes: 5fa8e49 ("build: autotools conversion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 0a67810..e8afd46 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,7 +3,7 @@ sbin_PROGRAMS = nft
 CLEANFILES = scanner.c parser_bison.c
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\""
+AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" -DDEBUG
 		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
 
 AM_CFLAGS = -Wall								\
-- 
1.7.10.4

