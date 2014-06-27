From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: resolve build failure on systems with old glibc-linux headers
Date: Fri, 27 Jun 2014 18:13:32 +0200
Message-ID: <1403885612-22792-2-git-send-email-jengelh@inai.de>
References: <1403885612-22792-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:50545 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaF0QNg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:13:36 -0400
In-Reply-To: <1403885612-22792-1-git-send-email-jengelh@inai.de>
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
2.0.0

