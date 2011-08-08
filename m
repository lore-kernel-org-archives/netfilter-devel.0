From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/7] libxt_string: define _GNU_SOURCE for strnlen
Date: Mon,  8 Aug 2011 02:42:19 +0200
Message-ID: <1312764144-23849-4-git-send-email-jengelh@medozas.de>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44407 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab1HHAma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:30 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On RHEL-5.6 and clones with its gcc-4.1.2 and glibc-2.5:

libxt_string.c: In function "parse_string":
libxt_string.c:84: warning: implicit declaration of function "strnlen"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index eef0b08..8cee335 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -20,6 +20,7 @@
  *             updated to work with slightly modified
  *             ipt_string_info.
  */
+#define _GNU_SOURCE 1 /* strnlen for older glibcs */
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-- 
1.7.3.4

