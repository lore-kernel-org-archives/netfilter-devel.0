From: Keno Fischer <keno@juliacomputing.com>
Subject: [PATCH] Fix two compile errors during out-of-tree build
Date: Fri, 30 Dec 2016 00:43:37 -0500
Message-ID: <20161230054337.GA9676@juliacomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34149 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbcL3Fnl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2016 00:43:41 -0500
Received: by mail-qk0-f169.google.com with SMTP id h201so150028212qke.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2016 21:43:40 -0800 (PST)
Received: from juliacomputing.com ([2601:184:4380:e6e:801d:58a2:bb9:dc])
        by smtp.gmail.com with ESMTPSA id q88sm24161525qkq.21.2016.12.29.21.43.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Dec 2016 21:43:39 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The first:
```
iptables/extensions/libebt_limit.c:21:26: fatal error: iptables/nft.h: No such file or directory
 #include "iptables/nft.h"
```

The second:
```
/data/keno/sandbox/iptables/iptables/xtables-config-parser.y:19:32: fatal error: libiptc/linux_list.h: No such file or directory
 #include <libiptc/linux_list.h>
                                ^
```

Simply fixed by adding the relevant `-I` directives.

Signed-off-by: Keno Fischer <keno@juliacomputing.com>
---
 extensions/GNUmakefile.in | 2 +-
 iptables/Makefile.am      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 33b06ef..b7a8a83 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -22,7 +22,7 @@ regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 
 AM_CFLAGS       = ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@ @libnftnl_CFLAGS@
+AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include -I${top_srcdir} ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@ @libnftnl_CFLAGS@
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@
 
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 569a739..f92cc4f 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-
 
 AM_CFLAGS        = ${regular_CFLAGS}
-AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS} ${libnetfilter_conntrack_CFLAGS}
+AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include -I${top_srcdir} ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS} ${libnetfilter_conntrack_CFLAGS}
 AM_YFLAGS = -d
 
 BUILT_SOURCES =
-- 
2.9.3

