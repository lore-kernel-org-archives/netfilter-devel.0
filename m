From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: install libipset in the right place
Date: Sun,  1 Jan 2012 01:25:34 +0100
Message-ID: <1325377535-11289-2-git-send-email-jengelh@medozas.de>
References: <1325377535-11289-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51160 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab2AAAZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 19:25:38 -0500
In-Reply-To: <1325377535-11289-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The .c files used to build the plugins for ipset all use #include
<libipset/...>, so the files we install should preferably also be in a
directory called "libipset" rather than just "ipset".
---
 include/libipset/Makefile.am |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/libipset/Makefile.am b/include/libipset/Makefile.am
index 2bb353b..3b47518 100644
--- a/include/libipset/Makefile.am
+++ b/include/libipset/Makefile.am
@@ -1,3 +1,4 @@
+pkgincludedir = ${includedir}/libipset
 pkginclude_HEADERS = \
 	data.h \
 	errcode.h \
-- 
1.7.7

