From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] build: workaround broken linux-headers on RHEL-5
Date: Mon,  8 Aug 2011 02:42:20 +0200
Message-ID: <1312764144-23849-5-git-send-email-jengelh@medozas.de>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44408 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab1HHAmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:31 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

maigc.h was not invented yet, but they do not
ship proc_fs.h either, duh.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/xtables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 1a5e568..233efa3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -37,6 +37,8 @@
 #	include <linux/magic.h> /* for PROC_SUPER_MAGIC */
 #elif defined(HAVE_LINUX_PROC_FS_H)
 #	include <linux/proc_fs.h>	/* Linux 2.4 */
+#else
+#	define PROC_SUPER_MAGIC	0x9fa0
 #endif
 
 #include <xtables.h>
-- 
1.7.3.4

