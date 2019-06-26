Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B974BC48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 13:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95509214DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 13:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfFZNPI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 09:15:08 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56178 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZNPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 09:15:08 -0400
Received: from localhost ([::1]:41036 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hg7lT-0006ir-5P; Wed, 26 Jun 2019 15:15:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH] Drop ebtables-config from repository
Date:   Wed, 26 Jun 2019 15:15:06 +0200
Message-Id: <20190626131506.30198-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This config was used by sysv init script, so is a leftover.

Fixes: b43f3ff0a6180 ("ebtables: drop sysvinit script")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .gitignore         |  1 -
 Makefile.am        |  5 +----
 ebtables-config.in | 37 -------------------------------------
 3 files changed, 1 insertion(+), 42 deletions(-)
 delete mode 100644 ebtables-config.in

diff --git a/.gitignore b/.gitignore
index 9940c85762fa0..19ee9627b0c8e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,7 +18,6 @@ Makefile.in
 /stamp-h1
 
 /ebtables-legacy
-/ebtables-config
 /ebtables-legacy-restore
 /ebtables-legacy-save
 /ebtables-legacy.8
diff --git a/Makefile.am b/Makefile.am
index 904de12773a84..b879941cfdd50 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -58,14 +58,11 @@ examples_ulog_test_ulog_SOURCES = examples/ulog/test_ulog.c getethertype.c
 daemon: ebtablesd ebtablesu
 exec: ebtables-legacy ebtables-legacy-restore
 
-CLEANFILES = ebtables-legacy-save ebtables-config ebtables-legacy.8
+CLEANFILES = ebtables-legacy-save ebtables-legacy.8
 
 ebtables-legacy-save: ebtables-save.in ${top_builddir}/config.status
 	${AM_V_GEN}sed -e 's![@]sbindir@!${sbindir}!g' <$< >$@
 
-ebtables-config: ebtables-config.in ${top_builddir}/config.status
-	${AM_V_GEN}sed -e 's![@]sysconfigdir@!${sysconfigdir}!g' <$< >$@
-
 ebtables-legacy.8: ebtables-legacy.8.in ${top_builddir}/config.status
 	${AM_V_GEN}sed -e 's![@]PACKAGE_VERSION!${PACKAGE_VERSION}!g' \
 		-e 's![@]PACKAGE_DATE@!${PROGDATE}!g' \
diff --git a/ebtables-config.in b/ebtables-config.in
deleted file mode 100644
index 3a8990260a9c4..0000000000000
--- a/ebtables-config.in
+++ /dev/null
@@ -1,37 +0,0 @@
-# Save (and possibly restore) in text format.
-#   Value: yes|no,  default: yes
-# Save the firewall rules in text format to __SYSCONFIG__/ebtables
-# If EBTABLES_BINARY_FORMAT="no" then restoring the firewall rules
-# is done using this text format.
-EBTABLES_TEXT_FORMAT="yes"
-
-# Save (and restore) in binary format.
-#   Value: yes|no,  default: yes
-# Save (and restore) the firewall rules in binary format to (and from)
-# __SYSCONFIG__/ebtables.<chain>. Enabling this option will make
-# firewall initialisation a lot faster.
-EBTABLES_BINARY_FORMAT="yes"
-
-# Unload modules on restart and stop
-#   Value: yes|no,  default: yes
-# This option has to be 'yes' to get to a sane state for a firewall
-# restart or stop. Only set to 'no' if there are problems unloading netfilter
-# modules.
-EBTABLES_MODULES_UNLOAD="yes"
-
-# Save current firewall rules on stop.
-#   Value: yes|no,  default: no
-# Saves all firewall rules if firewall gets stopped
-# (e.g. on system shutdown).
-EBTABLES_SAVE_ON_STOP="no"
-
-# Save current firewall rules on restart.
-#   Value: yes|no,  default: no
-# Saves all firewall rules if firewall gets restarted.
-EBTABLES_SAVE_ON_RESTART="no"
-
-# Save (and restore) rule counters.
-#   Value: yes|no,  default: no
-# Save rule counters when saving a kernel table to a file. If the
-# rule counters were saved, they will be restored when restoring the table.
-EBTABLES_SAVE_COUNTER="no"
-- 
2.21.0

