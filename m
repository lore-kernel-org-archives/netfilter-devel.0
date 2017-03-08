From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/3] build: resolve build error involving libnftnl
Date: Wed,  8 Mar 2017 17:25:25 +0100
Message-ID: <20170308162526.5525-3-jengelh@inai.de>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308162526.5525-1-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:42558 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754010AbdCHQ0U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:26:20 -0500
In-Reply-To: <20170308162526.5525-1-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

make[2]: Entering directory '/home/jengelh/code/iptables/extensions'
  CC       libebt_limit.oo
In file included from ../iptables/nft.h:5:0,
                 from libebt_limit.c:21:
../iptables/nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
 #include <libnftnl/rule.h>
                           ^
compilation terminated.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 4e94bd0..181e155 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -21,7 +21,7 @@ regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 
 AM_CFLAGS       = ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@
+AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@ @libnftnl_CFLAGS@
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@
 
-- 
2.10.2

