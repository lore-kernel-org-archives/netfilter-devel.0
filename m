From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] xtables: use extern "C"
Date: Tue, 26 May 2009 13:26:23 +0200
Message-ID: <1243337187-18216-2-git-send-email-jengelh@medozas.de>
References: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34624 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZEZL03 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 07:26:29 -0400
In-Reply-To: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes linking errors for 3rd-party C++ code.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index a399f90..4d4ca0a 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -203,6 +203,10 @@ struct xtables_globals
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 extern const char *xtables_modprobe_program;
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
@@ -295,4 +299,8 @@ extern void _init(void);
 
 #endif
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 #endif /* _XTABLES_H */
-- 
1.6.3.1

