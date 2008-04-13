From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/8] Install libiptc header files because xtables.h depends on it
Date: Sun, 13 Apr 2008 10:25:49 +0200
Message-ID: <0b50185dfc582434fd350a457ee71e5ecb94ee26.1208075035.git.jengelh@computergmbh.de>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36087 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYDMIZ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:25:56 -0400
In-Reply-To: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
References: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
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

