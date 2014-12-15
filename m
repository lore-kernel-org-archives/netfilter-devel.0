From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: resolve build failure on systems with old glibc-linux headers
Date: Tue, 16 Dec 2014 00:54:47 +0100
Message-ID: <1418687687-9124-1-git-send-email-jengelh@inai.de>
Cc: jengelh@inai.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:56433 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaLOXys (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:54:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fails to build on a SUSE Linux Enterprise 11 system where the
linux-glibc-devel headers (/usr/include/linux) are of version 2.6.32.

The reason for that is that x_tables.h is only present in the git
repository, but not the tarball as produced by `make dist`. Add the
missing file to the file list.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/linux/netfilter/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
index a349b91..dc09d97 100644
--- a/include/linux/netfilter/Makefile.am
+++ b/include/linux/netfilter/Makefile.am
@@ -1 +1 @@
-noinst_HEADERS = nfnetlink.h nf_tables.h nf_tables_compat.h xt_LOG.h
+noinst_HEADERS = nfnetlink.h nf_tables.h nf_tables_compat.h x_tables.h xt_LOG.h
-- 
2.1.2

