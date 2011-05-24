From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 15/24] libxtables: more detailed error message on multi-int parsing
Date: Wed, 25 May 2011 01:08:16 +0200
Message-ID: <1306278506-11463-16-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40973 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1EXXIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:45 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
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

