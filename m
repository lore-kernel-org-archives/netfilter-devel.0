From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_log PATCH] Make it possible to build libipulog
Date: Fri, 15 May 2015 20:40:31 +0200
Message-ID: <20150515184031.GA16749@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:45436 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbbEOSkq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 14:40:46 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 4AD8A25AF528
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2015 20:40:45 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpJTT1P16z5vNH
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2015 20:40:44 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a1b392b4156db984ab2b695a4a70d113f70cb9b8 had unintentionally
disabled building of libipulog unconditionally

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 configure.ac | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 88ff7ab..c4cc662 100644
--- a/configure.ac
+++ b/configure.ac
@@ -25,9 +25,8 @@ case "$host" in
 esac
 
 AC_ARG_WITH([ipulog],
-  AC_HELP_STRING([--without-ipulog], [don't build libipulog compat library]),
-  [ipulog_skip=1], [ipulog_skip=0])
-AM_CONDITIONAL([BUILD_IPULOG], [test $ipulog_skip = 0])
+  AC_HELP_STRING([--without-ipulog], [don't build libipulog compat library]))
+AM_CONDITIONAL([BUILD_IPULOG], [test "x$with_ipulog" != xno])
 
 dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
-- 
2.3.6
