From: Felix Janda <felix.janda@posteo.de>
Subject: [conntrack-tools PATCH 1/6] configure: Add AM_PROG_AR to silence
 automake warning
Date: Sat, 16 May 2015 11:19:02 +0200
Message-ID: <20150516083153.GC14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:37363 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbbEPJTR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 05:19:17 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id E52B725A3DEA
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 11:19:16 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpgz85f7Gz5vND
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 11:19:16 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

/usr/share/automake-1.13/am/ltlibrary.am: warning: 'ct_helper_tns.la': linking libtool libraries using a non-POSIX
/usr/share/automake-1.13/am/ltlibrary.am: archiver requires 'AM_PROG_AR' in 'configure.ac'
src/helpers/Makefile.am:3:   while processing Libtool library 'ct_helper_tns.la'

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 configure.ac | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index f0800d6..523a192 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,6 +14,7 @@ AC_SUBST([libdl_LIBS])
 
 AC_PROG_CC
 AC_DISABLE_STATIC
+AM_PROG_AR
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 AC_PROG_LN_S
-- 
2.3.6
