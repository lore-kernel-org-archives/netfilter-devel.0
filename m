From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] build: order of dependent libs is sensitive
Date: Sat, 25 Jul 2009 22:22:39 +0200
Message-ID: <1248553363-26903-2-git-send-email-jengelh@medozas.de>
References: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55092 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZGYUWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:22:46 -0400
In-Reply-To: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libiptc.la must come after its components or `make install` won't get
things right.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index a9e3ad3..23cdedd 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,7 +14,7 @@ endif
 lib_LTLIBRARIES =
 
 # libiptc
-lib_LTLIBRARIES           += libiptc/libiptc.la libiptc/libip4tc.la libiptc/libip6tc.la
+lib_LTLIBRARIES           += libiptc/libip4tc.la libiptc/libip6tc.la libiptc/libiptc.la
 libiptc_libiptc_la_SOURCES  =
 libiptc_libiptc_la_LIBADD   = libiptc/libip4tc.la libiptc/libip6tc.la
 libiptc_libiptc_la_LDFLAGS  = -version-info 0:0:0
-- 
1.6.3.3

