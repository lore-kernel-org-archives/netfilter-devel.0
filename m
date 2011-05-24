From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/10] libxtables: more detailed error message on multi-int parsing
Date: Tue, 24 May 2011 03:21:39 +0200
Message-ID: <1306200102-12148-9-git-send-email-jengelh@medozas.de>
References: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41760 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031095Ab1EXBVx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:53 -0400
In-Reply-To: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now shows where exactly the error is.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtoptions.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index ec2269b..9884b7d 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -206,13 +206,14 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 				cb->ext_name, entry->name, maxiter);
 		if (!xtables_strtoui(arg, &end, &value, 0, UINT32_MAX))
 			xt_params->exit_err(PARAMETER_PROBLEM,
-				"%s: bad value for option \"--%s\", "
-				"or out of range (0-%u).\n",
-				cb->ext_name, entry->name, UINT32_MAX);
+				"%s: bad value for option \"--%s\" near "
+				"\"%s\", or out of range (0-%u).\n",
+				cb->ext_name, entry->name, arg, UINT32_MAX);
 		if (*end != '\0' && *end != sep)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"%s: Argument to \"--%s\" has unexpected "
-				"characters.\n", cb->ext_name, entry->name);
+				"characters near \"%s\".\n",
+				cb->ext_name, entry->name, end);
 		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range)) {
 			if (entry->type == XTTYPE_UINT8RC)
 				cb->val.u8_range[cb->nvals] = value;
-- 
1.7.3.4

