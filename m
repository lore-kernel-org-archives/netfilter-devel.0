From: Eric Leblond <eric@regit.org>
Subject: [Ulogd2 PATCH 1/4] Add Changes to extra dist.
Date: Fri, 22 Feb 2013 11:25:55 +0100
Message-ID: <1361528758-16674-2-git-send-email-eric@regit.org>
References: <1361528758-16674-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39920 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3BVK0d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:26:33 -0500
In-Reply-To: <1361528758-16674-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index bac839a..57f74db 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@ ACLOCAL_AMFLAGS  = -I m4
 
 man_MANS = ulogd.8
 
-EXTRA_DIST = $(man_MANS) ulogd.logrotate ulogd.spec ulogd.conf.in doc
+EXTRA_DIST = $(man_MANS) ulogd.logrotate ulogd.spec ulogd.conf.in doc Changes
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
 SUBDIRS = include libipulog src input filter output
-- 
1.7.10.4

