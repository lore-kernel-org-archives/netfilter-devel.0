From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH] build: fail in configure on missing dependency for optional component
Date: Sun, 21 Jul 2013 20:02:38 -0400
Message-ID: <1374451358-13294-1-git-send-email-willemb@google.com>
Cc: Willem de Bruijn <willemb@google.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:33895 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3GVACm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:02:42 -0400
Received: by mail-ye0-f202.google.com with SMTP id q4so79492yen.1
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2013 17:02:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The build of utils/nfbpf_compile depends on libpcap. If configure is
run with --enable-bpf-compiler, the script succeeds, but make fails.

This small patch adds a test for the dependency (libpcap) in configure
and fails hard if not found.

---

This small patch addresses your comment when merging the original
nfbpf_compiler commit 1ac30c97c339957b6e3c5cf571de7bc38c827730.
Sorry that it took me so long. Maybe it is not relevant anymore.
---
 configure.ac | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/configure.ac b/configure.ac
index d165d52..d443706 100644
--- a/configure.ac
+++ b/configure.ac
@@ -93,6 +93,11 @@ AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" = "yes"])
 AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
 
+if test "x$enable_bpfc" = "xyes"; then
+	AC_CHECK_LIB(pcap, pcap_compile, ,
+                     AC_MSG_ERROR(pcap library required by optional component))
+fi
+
 PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
 	[nfnetlink=1], [nfnetlink=0])
 AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
-- 
1.8.3

