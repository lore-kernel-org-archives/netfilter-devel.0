From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/28] libxtables: XTTYPE_STRING support
Date: Tue, 12 Apr 2011 16:23:23 +0200
Message-ID: <1302618224-9449-9-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54642 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1DLOXz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:55 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    2 ++
 xtoptions.c          |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 3e596e0..c3c8da9 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -49,12 +49,14 @@ struct in_addr;
  * %XTTYPE_NONE:	option takes no argument
  * %XTTYPE_UINT*:	standard integer
  * %XTTYPE_UINT*RC:	colon-separated range of standard integers
+ * %XTTYPE_STRING:	arbitrary string
  */
 enum xt_option_type {
 	XTTYPE_NONE,
 	XTTYPE_UINT8,
 	XTTYPE_UINT32,
 	XTTYPE_UINT32RC,
+	XTTYPE_STRING,
 };
 
 /**
diff --git a/xtoptions.c b/xtoptions.c
index 03c629e..631e7a3 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -163,16 +163,41 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 	}
 }
 
+static void xtopt_parse_string(struct xt_option_call *cb)
+{
+	const struct xt_option_entry *entry = cb->entry;
+	size_t z = strlen(cb->arg);
+	char *p;
+
+	if (entry->min != 0 && z < entry->min)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"Argument must have a minimum length of "
+			"%u characters\n", entry->min);
+	if (entry->max != 0 && z > entry->max)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"Argument must have a maximum length of "
+			"%u characters\n", entry->max);
+	if (!(entry->flags & XTOPT_PUT))
+		return;
+	if (z >= entry->size)
+		z = entry->size - 1;
+	p = XTOPT_MKPTR(cb);
+	strncpy(p, cb->arg, z);
+	p[z] = '\0';
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
 	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
+	[XTTYPE_STRING]      = xtopt_parse_string,
 };
 
 static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT8]       = sizeof(uint8_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
 	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
+	[XTTYPE_STRING]      = -1,
 };
 
 /**
-- 
1.7.1

