From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] libxt_RATEEST: link with -lm
Date: Mon,  5 Sep 2011 20:22:50 +0200
Message-ID: <1315246974-11538-3-git-send-email-jengelh@medozas.de>
References: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33345 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1IESXF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:23:05 -0400
In-Reply-To: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$ ldd -r libxt_RATEEST.so
undefined symbol: log   (./libxt_RATEEST.so)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index dbf210c..107c9d5 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -96,6 +96,7 @@ lib%.oo: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
+xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
 
 
-- 
1.7.3.4

