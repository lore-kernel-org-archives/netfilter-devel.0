From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: restore nft --debug and add missing \
Date: Tue, 25 Nov 2014 00:38:18 +0100
Message-ID: <1416872298-6125-1-git-send-email-pablo@netfilter.org>
Cc: zub.272@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41069 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaKXXg1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:36:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add -DDEBUG to enable --debug option by default as it used to be before
the autotools conversion.

The missing \ at the end of the line causes LIBMNL_CFLAGS and
LIBNFTNL_CFLAGS to be ignored. This causes build failure if the libmnl
or libnftnl headers are not in a path that's already searched by the C
compiler. Reported by David Kozub.

Fixes: 5fa8e49 ("build: autotools conversion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Daniel: Your patch clashes with mine:
http://patchwork.ozlabs.org/patch/413457/

So I have merged your change to mine. Please, feel free to post your
Acked-by / Signed-off-by and I'll append it to this patch. Thanks.

 src/Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 0a67810..d53c347 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,7 +3,7 @@ sbin_PROGRAMS = nft
 CLEANFILES = scanner.c parser_bison.c
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\""
+AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" -DDEBUG \
 		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
 
 AM_CFLAGS = -Wall								\
-- 
1.7.10.4

