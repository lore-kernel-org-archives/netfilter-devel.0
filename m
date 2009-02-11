From: jengelh@medozas.de
Subject: [PATCH 1/8] libxtables: recognize IP6TABLES_LIB_DIR old-style environment variable
Date: Wed, 11 Feb 2009 16:03:29 +0100
Message-ID: <1234364616-19974-2-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48686 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZBKPDj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:39 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Commit v1.4.3-rc1-47-g300e290 tried to consolidate the environment
variable presence checking code into xtables.c, but missed
adding IP6TABLES_LIB_DIR to libxtables.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/xtables.c b/xtables.c
index 6c95475..c898889 100644
--- a/xtables.c
+++ b/xtables.c
@@ -110,6 +110,19 @@ void xtables_init(void)
 		        "use XTABLES_LIBDIR.\n");
 		return;
 	}
+	/*
+	 * Well yes, IP6TABLES_LIB_DIR is of lower priority over
+	 * IPTABLES_LIB_DIR since this moved to libxtables; I think that is ok
+	 * for these env vars are deprecated anyhow, and in light of the
+	 * (shared) libxt_*.so files, makes less sense to have
+	 * IPTABLES_LIB_DIR != IP6TABLES_LIB_DIR.
+	 */
+	xtables_libdir = getenv("IP6TABLES_LIB_DIR");
+	if (xtables_libdir != NULL) {
+		fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
+		        "use XTABLES_LIBDIR.\n");
+		return;
+	}
 	xtables_libdir = XTABLES_LIBDIR;
 }
 
-- 
1.6.1.2

