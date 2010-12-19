From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/11] build: enable parallel building
Date: Sun, 19 Dec 2010 06:18:03 +0100
Message-ID: <1292735894-17534-2-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42657 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0LSFSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:16 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$ make modules -j8
cd kernel; make -C /lib/modules/`uname -r`/build M=`pwd` V=0 \
                        IP_SET_MAX=256 \
                        NETLINK_DUMP_CONST=const \
                        NFNL_CB_CONST=const modules
make[1]: Entering directory "/usr/src/linux-2.6.36-rc8-34-obj/x86_64/default"
make[1]: warning: jobserver unavailable: using -j1.
Add '+' to parent make rule.

The "fix" here is that we have to use ${MAKE} instead of make.
(NB: The extra cd is redundant and can be appended to M=.)
---
 Makefile.am |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index aa0d64b..ab552dc 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,16 +23,16 @@ endif
 SUBDIRS		= lib src
 
 modules:
-	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` V=$V \
+	${MAKE} -C $(KBUILD_OUTPUT) M=$$PWD/kernel V=$V \
 			IP_SET_MAX=$(IP_SET_MAX) \
 			NETLINK_DUMP_CONST=$(NETLINK_DUMP_CONST) \
 			NFNL_CB_CONST=$(NFNL_CB_CONST) modules
 
 modules_install:
-	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` modules_install
+	${MAKE} -C $(KBUILD_OUTPUT) M=$$PWD/kernel modules_install
 
 modules_clean:
-	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` clean
+	${MAKE} -C $(KBUILD_OUTPUT) M=$$PWD/kernel clean
 
 update_includes:
 	./update ip_set.h
-- 
1.7.1

