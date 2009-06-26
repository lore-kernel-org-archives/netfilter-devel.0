From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/10] xtables: add multi-registration functions
Date: Fri, 26 Jun 2009 21:19:49 +0200
Message-ID: <1246043992-379-8-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39674 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761323AbZFZTUM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:12 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to the ones that are present in the kernel.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    2 ++
 xtables.c            |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 037fae1..222e2a9 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -233,7 +233,9 @@ extern struct xtables_target *xtables_find_target(const char *name,
 
 /* Your shared library should call one of these. */
 extern void xtables_register_match(struct xtables_match *me);
+extern void xtables_register_matches(struct xtables_match *, unsigned int);
 extern void xtables_register_target(struct xtables_target *me);
+extern void xtables_register_targets(struct xtables_target *, unsigned int);
 
 extern bool xtables_strtoul(const char *, char **, unsigned long *,
 	unsigned long, unsigned long);
diff --git a/xtables.c b/xtables.c
index 05154dd..1ff6e82 100644
--- a/xtables.c
+++ b/xtables.c
@@ -794,6 +794,13 @@ void xtables_register_match(struct xtables_match *me)
 	me->mflags = 0;
 }
 
+void xtables_register_matches(struct xtables_match *match, unsigned int n)
+{
+	do {
+		xtables_register_match(&match[--n]);
+	} while (n > 0);
+}
+
 void xtables_register_target(struct xtables_target *me)
 {
 	struct xtables_target *old;
@@ -868,6 +875,13 @@ void xtables_register_target(struct xtables_target *me)
 	me->tflags = 0;
 }
 
+void xtables_register_targets(struct xtables_target *target, unsigned int n)
+{
+	do {
+		xtables_register_target(&target[--n]);
+	} while (n > 0);
+}
+
 /**
  * xtables_param_act - act on condition
  * @status:	a constant from enum xtables_exittype
-- 
1.6.3.2

