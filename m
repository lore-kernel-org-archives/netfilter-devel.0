From: jengelh@medozas.de
Subject: [PATCH 3/8] libxtables: remove unused XT_LIB_DIR macro
Date: Wed, 11 Feb 2009 16:03:31 +0100
Message-ID: <1234364616-19974-4-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48687 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZBKPDj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:39 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables/internal.h.in |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/xtables/internal.h.in b/include/xtables/internal.h.in
index 81ddb48..5e34694 100644
--- a/include/xtables/internal.h.in
+++ b/include/xtables/internal.h.in
@@ -3,10 +3,6 @@
 
 #define IPTABLES_VERSION "@PACKAGE_VERSION@"
 
-#ifndef XT_LIB_DIR
-#	define XT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
 /**
  * Program's own name and version.
  */
-- 
1.6.1.2

