From: Felix Janda <felix.janda@posteo.de>
Subject: [conntrack-tools PATCH 5/6] Define _GNU_SOURCE to get members of
 tcphdr&ucphdr
Date: Sat, 16 May 2015 12:05:33 +0200
Message-ID: <20150516095218.GG14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:36587 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbbEPKGE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 06:06:04 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 16A2D25B8DEC
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:06:02 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpj163zWfz5vN7
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:06:02 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The source uses linux names for members of tcphdr. For example
"source" instead of "th_sport", ... musl libc's headers need
_GNU_SOURCE defined in order to expose these.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 src/cthelper.c     | 1 +
 src/helpers/ftp.c  | 1 +
 src/helpers/sane.c | 1 +
 src/helpers/tns.c  | 1 +
 4 files changed, 4 insertions(+)

diff --git a/src/cthelper.c b/src/cthelper.c
index fec40fb..bd8b8b7 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -31,6 +31,7 @@
 #include <netinet/in.h>
 #include <netinet/ip.h>
 #include <netinet/ip6.h>
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 #include <netinet/udp.h>
 #include <net/ethernet.h>
diff --git a/src/helpers/ftp.c b/src/helpers/ftp.c
index e7fe7f7..24ee877 100644
--- a/src/helpers/ftp.c
+++ b/src/helpers/ftp.c
@@ -25,6 +25,7 @@
 #include <ctype.h>	/* for isdigit */
 #include <errno.h>
 
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 
 #include <libmnl/libmnl.h>
diff --git a/src/helpers/sane.c b/src/helpers/sane.c
index 79ca948..c30f4ba 100644
--- a/src/helpers/sane.c
+++ b/src/helpers/sane.c
@@ -30,6 +30,7 @@
 #include "log.h"
 #include <errno.h>
 #include <netinet/ip.h>
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 #include <libmnl/libmnl.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
diff --git a/src/helpers/tns.c b/src/helpers/tns.c
index 5833fea..2b4fed4 100644
--- a/src/helpers/tns.c
+++ b/src/helpers/tns.c
@@ -18,6 +18,7 @@
 #include <ctype.h>	/* for isdigit */
 #include <errno.h>
 
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 
 #include <libmnl/libmnl.h>
-- 
2.3.6
