From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/10] libxtables: min-max option support
Date: Wed,  6 Apr 2011 13:31:16 +0200
Message-ID: <1302089478-15022-10-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46500 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1DFLba (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:30 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 +++
 xtoptions.c          |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 91a6eaa..14d7b04 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -76,6 +76,8 @@ enum xt_option_flags {
  * @flags:	bitmask of option flags, see %XTOPT_*
  * @ptroff:	offset into private structure for member
  * @size:	size of the item pointed to by @ptroff; this is a safeguard
+ * @min:	lowest allowed value (for singular integral types)
+ * @max:	highest allowed value (for singular integral types)
  */
 struct xt_option_entry {
 	const char *name;
@@ -83,6 +85,7 @@ struct xt_option_entry {
 	unsigned int id, excl, also, flags;
 	unsigned int ptroff;
 	size_t size;
+	unsigned int min, max;
 };
 
 /**
diff --git a/xtoptions.c b/xtoptions.c
index 843395b..6a119ec 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -89,6 +89,11 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	unsigned int lmin = 0, lmax = UINT32_MAX;
 	unsigned int value;
 
+	if (cb->entry->min != 0)
+		lmin = cb->entry->min;
+	if (cb->entry->max != 0)
+		lmax = cb->entry->max;
+
 	if (!xtables_strtoui(cb->arg, NULL, &value, lmin, lmax))
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
-- 
1.7.1

