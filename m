From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/10] libxtables: XTTYPE_UINT32 support
Date: Wed,  6 Apr 2011 13:31:14 +0200
Message-ID: <1302089478-15022-8-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46500 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1DFLb2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:28 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    4 +++-
 xtoptions.c          |   26 ++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index c281fed..91a6eaa 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -47,9 +47,11 @@ struct in_addr;
 
 /**
  * %XTTYPE_NONE:	option takes no argument
+ * %XTTYPE_UINT*:	standard integer
  */
 enum xt_option_type {
 	XTTYPE_NONE,
+	XTTYPE_UINT32,
 };
 
 /**
@@ -99,7 +101,7 @@ struct xt_option_call {
 	unsigned int xflags;
 	bool invert;
 	union {
-		/* to be filled */
+		uint32_t u32;
 	} val;
 };
 
diff --git a/xtoptions.c b/xtoptions.c
index df917b6..843395b 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -80,12 +80,34 @@ xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
 	return merge;
 }
 
+/**
+ * Require a simple integer.
+ */
+static void xtopt_parse_int(struct xt_option_call *cb)
+{
+	const struct xt_option_entry *entry = cb->entry;
+	unsigned int lmin = 0, lmax = UINT32_MAX;
+	unsigned int value;
+
+	if (!xtables_strtoui(cb->arg, NULL, &value, lmin, lmax))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: bad value for option \"--%s\", "
+			"or out of range (%u-%u).\n",
+			cb->ext_name, entry->name, lmin, lmax);
+
+	if (entry->type == XTTYPE_UINT32) {
+		cb->val.u32 = value;
+		if (entry->flags & XTOPT_PUT)
+			*(uint32_t *)XTOPT_MKPTR(cb) = cb->val.u32;
+	}
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
-	[XTTYPE_NONE]        = NULL,
+	[XTTYPE_UINT32]      = xtopt_parse_int,
 };
 
 static const size_t xtopt_psize[] = {
-	[XTTYPE_NONE]        = 0,
+	[XTTYPE_UINT32]      = sizeof(uint32_t),
 };
 
 /**
-- 
1.7.1

