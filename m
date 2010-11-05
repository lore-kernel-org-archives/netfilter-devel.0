From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] output/LOGEMU: resolve build warning
Date: Fri,  5 Nov 2010 19:36:19 +0100
Message-ID: <1288982184-23584-6-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44401 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0KESgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:31 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ulogd_output_LOGEMU.c:37:2: warning: #warning this libc does not
define HOST_NAME_MAX

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 output/ulogd_output_LOGEMU.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index 32b4954..d616cbf 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -23,7 +23,7 @@
  * $Id$
  *
  */
-
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-- 
1.7.1

