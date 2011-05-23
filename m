From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/13] libxt_quota: make sure uint64 is not truncated
Date: Mon, 23 May 2011 16:39:14 +0200
Message-ID: <1306161564-4370-5-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44615 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1EWOja (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:30 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: JP Abgrall <jpa@google.com>

The xtables_strtoul() would cram a long long into a long.
The parse_int would try to cram a UINT64 into a long.
---
 include/xtables.h.in |    2 +-
 xtables.c            |    4 ++--
 xtoptions.c          |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index f88813f..90eb1b2 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -408,7 +408,7 @@ extern void xtables_register_matches(struct xtables_match *, unsigned int);
 extern void xtables_register_target(struct xtables_target *me);
 extern void xtables_register_targets(struct xtables_target *, unsigned int);
 
-extern bool xtables_strtoul(const char *, char **, unsigned long *,
+extern bool xtables_strtoul(const char *, char **, unsigned long long *,
 	unsigned long, unsigned long);
 extern bool xtables_strtoui(const char *, char **, unsigned int *,
 	unsigned int, unsigned int);
diff --git a/xtables.c b/xtables.c
index f10cdb7..3c9a13f 100644
--- a/xtables.c
+++ b/xtables.c
@@ -426,7 +426,7 @@ int xtables_load_ko(const char *modprobe, bool quiet)
  * Returns true/false whether number was accepted. On failure, *value has
  * undefined contents.
  */
-bool xtables_strtoul(const char *s, char **end, unsigned long *value,
+bool xtables_strtoul(const char *s, char **end, unsigned long long *value,
                      unsigned long min, unsigned long max)
 {
 	unsigned long v;
@@ -454,7 +454,7 @@ bool xtables_strtoul(const char *s, char **end, unsigned long *value,
 bool xtables_strtoui(const char *s, char **end, unsigned int *value,
                      unsigned int min, unsigned int max)
 {
-	unsigned long v;
+	unsigned long long v;
 	bool ret;
 
 	ret = xtables_strtoul(s, end, &v, min, max);
diff --git a/xtoptions.c b/xtoptions.c
index 3c3ce5f..ec2269b 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -105,7 +105,7 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
 	unsigned long long lmin = 0, lmax = UINT32_MAX;
-	unsigned int value;
+	unsigned long long value;
 
 	if (entry->type == XTTYPE_UINT8)
 		lmax = UINT8_MAX;
@@ -118,7 +118,7 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	if (cb->entry->max != 0)
 		lmax = cb->entry->max;
 
-	if (!xtables_strtoui(cb->arg, NULL, &value, lmin, lmax))
+	if (!xtables_strtoul(cb->arg, NULL, &value, lmin, lmax))
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
 			"or out of range (%llu-%llu).\n",
-- 
1.7.3.4

