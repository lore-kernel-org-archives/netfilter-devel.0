From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 16/24] Install libiptc header files because xtables.h depends on it
Date: Sun,  6 Apr 2008 17:27:13 +0200
Message-ID: <c7c56b1972a89a38bb34507f2a388749e58abd50.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56490 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYDFP10 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:26 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 Makefile.am |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 8137c93..bb7dc4f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -75,6 +75,9 @@ man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
 CLEANFILES       := iptables.8 ip6tables.8
 if ENABLE_DEVEL
 include_HEADERS  := include/xtables.h include/iptables.h include/ip6tables.h
+iptcdir          := ${includedir}/libiptc
+iptc_HEADERS     := include/libiptc/libxtc.h \
+                    include/libiptc/ipt_kernel_headers.h
 endif
 
 if ENABLE_STATIC
-- 
1.5.5.rc3

