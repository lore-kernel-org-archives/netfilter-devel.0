From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH] autoconf/ulogd: fix broken libpcap AM_CONDITIONAL
Date: Tue,  9 Oct 2012 16:27:19 -0300
Message-ID: <1349810839-5958-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([85.10.205.246]:47843 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2JITlK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:41:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The AM_CONDITIONAL lacks the opening bracket, hence it always evaluates
as true, even if there's no libpcap found thus causing build breakage.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 10b6e1f..57c596c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -21,7 +21,7 @@ AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libdl_LIBS])
 AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
 AC_SUBST([libpcap_LIBS])
-AM_CONDITIONAL([HAVE_PCAP], test -n "$libpcap_LIBS"])
+AM_CONDITIONAL([HAVE_PCAP],[test -n "$libpcap_LIBS"])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
-- 
1.7.8.6

