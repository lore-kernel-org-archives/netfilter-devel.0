From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [iptables PATCH] configure: disable connlabel for static builds
Date: Tue, 13 Jan 2015 10:46:20 -0300
Message-ID: <1421156780-30315-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([62.210.192.172]:58827 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbAMNzq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:55:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Disable connlabel for purely static builds since it pulls in libdl which
isn't available in such cases causing build breakage.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.ac | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/configure.ac b/configure.ac
index 2521ccc..0f92c48 100644
--- a/configure.ac
+++ b/configure.ac
@@ -88,8 +88,12 @@ if test "$ac_cv_header_linux_ip_vs_h" != "yes"; then
 	blacklist_modules="$blacklist_modules ipvs";
 fi;
 
+if test "$enable_shared" = "yes"; then
 PKG_CHECK_MODULES([libnetfilter_conntrack], [libnetfilter_conntrack >= 1.0.4],
 	[nfconntrack=1], [nfconntrack=0])
+else
+	nfconntrack=0
+fi;
 AM_CONDITIONAL([HAVE_LIBNETFILTER_CONNTRACK], [test "$nfconntrack" = 1])
 
 if test "$nfconntrack" -ne 1; then
-- 
2.0.5

