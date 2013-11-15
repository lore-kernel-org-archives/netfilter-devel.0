From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] build: relax compilation not to break on warning
Date: Fri, 15 Nov 2013 10:06:05 +0100
Message-ID: <1384506365-4342-2-git-send-email-pablo@netfilter.org>
References: <1384506365-4342-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49646 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab3KOJGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:06:13 -0500
In-Reply-To: <1384506365-4342-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove -Werror, as bison and flex generate unclean code that may
break compilation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Makefile.defs.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.defs.in b/Makefile.defs.in
index 545c4ee..502f374 100644
--- a/Makefile.defs.in
+++ b/Makefile.defs.in
@@ -28,7 +28,7 @@ CFLAGS		+= -include config.h
 CFLAGS		+= -Iinclude
 CFLAGS		+= -fno-strict-aliasing
 
-CFLAGS		+= -Wall -Werror
+CFLAGS		+= -Wall
 CFLAGS		+= -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations
 CFLAGS		+= -Wdeclaration-after-statement -Wsign-compare -Winit-self
 CFLAGS		+= -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute
-- 
1.7.10.4

