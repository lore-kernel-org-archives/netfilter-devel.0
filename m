From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/10] libxtables: use uintmax for xtables_strtoul
Date: Tue, 24 May 2011 03:21:40 +0200
Message-ID: <1306200102-12148-10-git-send-email-jengelh@medozas.de>
References: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41766 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031096Ab1EXBVy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:54 -0400
In-Reply-To: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Addendum to 2305d5fb42fc059f38fc1bdf53411dbeecdb310b.

I noticed that unsigned long long is not consistently used, for
example, min/max are still just unsigned long, and strtoul is being
called.

Instead of changing it to unsigned long long, just use uintmax
functions right away so this does not need size-related changing in
the future.

Cc: JP Abgrall <jpa@google.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    4 ++--
 xtables.c            |   11 ++++++-----
 xtoptions.c          |    6 +++---
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 90eb1b2..2565dd2 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -408,8 +408,8 @@ extern void xtables_register_matches(struct xtables_match *, unsigned int);
 extern void xtables_register_target(struct xtables_target *me);
 extern void xtables_register_targets(struct xtables_target *, unsigned int);
 
-extern bool xtables_strtoul(const char *, char **, unsigned long long *,
-	unsigned long, unsigned long);
+extern bool xtables_strtoul(const char *, char **, uintmax_t *,
+	uintmax_t, uintmax_t);
 extern bool xtables_strtoui(const char *, char **, unsigned int *,
 	unsigned int, unsigned int);
 extern int xtables_service_to_port(const char *name, const char *proto);
diff --git a/xtables.c b/xtables.c
index e11a77e..acfcf8b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -18,6 +18,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <inttypes.h>
 #include <netdb.h>
 #include <stdarg.h>
 #include <stdbool.h>
@@ -426,10 +427,10 @@ int xtables_load_ko(const char *modprobe, bool quiet)
  * Returns true/false whether number was accepted. On failure, *value has
  * undefined contents.
  */
-bool xtables_strtoul(const char *s, char **end, unsigned long long *value,
-                     unsigned long min, unsigned long max)
+bool xtables_strtoul(const char *s, char **end, uintmax_t *value,
+                     uintmax_t min, uintmax_t max)
 {
-	unsigned long v;
+	uintmax_t v;
 	const char *p;
 	char *my_end;
 
@@ -439,7 +440,7 @@ bool xtables_strtoul(const char *s, char **end, unsigned long long *value,
 		;
 	if (*p == '-')
 		return false;
-	v = strtoul(s, &my_end, 0);
+	v = strtoumax(s, &my_end, 0);
 	if (my_end == s)
 		return false;
 	if (end != NULL)
@@ -459,7 +460,7 @@ bool xtables_strtoul(const char *s, char **end, unsigned long long *value,
 bool xtables_strtoui(const char *s, char **end, unsigned int *value,
                      unsigned int min, unsigned int max)
 {
-	unsigned long long v;
+	uintmax_t v;
 	bool ret;
 
 	ret = xtables_strtoul(s, end, &v, min, max);
diff --git a/xtoptions.c b/xtoptions.c
index 9884b7d..e9736a4 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -104,8 +104,8 @@ xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
 static void xtopt_parse_int(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
-	unsigned long long lmin = 0, lmax = UINT32_MAX;
-	unsigned long long value;
+	uintmax_t lmin = 0, lmax = UINT32_MAX;
+	uintmax_t value;
 
 	if (entry->type == XTTYPE_UINT8)
 		lmax = UINT8_MAX;
@@ -121,7 +121,7 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	if (!xtables_strtoul(cb->arg, NULL, &value, lmin, lmax))
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
-			"or out of range (%llu-%llu).\n",
+			"or out of range (%ju-%ju).\n",
 			cb->ext_name, entry->name, lmin, lmax);
 
 	if (entry->type == XTTYPE_UINT8) {
-- 
1.7.3.4

