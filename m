From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/9] extensions: remove unused TOS code
Date: Sun,  1 May 2011 13:50:26 +0200
Message-ID: <1304250630-6150-7-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50002 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab1EALuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:40 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/tos_values.c |   58 -----------------------------------------------
 1 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index c5efd9d..6dc4743 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -23,64 +23,6 @@ static const struct tos_symbol_info {
 	{},
 };
 
-/*
- * tos_parse_numeric - parse sth. like "15/255"
- *
- * @str:	input string
- * @tvm:	(value/mask) tuple
- * @max:	maximum allowed value (must be pow(2,some_int)-1)
- */
-static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
-                              unsigned int max)
-{
-	unsigned int value;
-	char *end;
-
-	xtables_strtoui(str, &end, &value, 0, max);
-	tvm->value = value;
-	tvm->mask  = max;
-
-	if (*end == '/') {
-		const char *p = end + 1;
-
-		if (!xtables_strtoui(p, &end, &value, 0, max))
-			xtables_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"",
-			           str);
-		tvm->mask = value;
-	}
-
-	if (*end != '\0')
-		xtables_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"", str);
-	return true;
-}
-
-/**
- * @str:	input string
- * @tvm:	(value/mask) tuple
- * @def_mask:	mask to force when a symbolic name is used
- */
-static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
-    unsigned int def_mask)
-{
-	static const unsigned int max = UINT8_MAX;
-	const struct tos_symbol_info *symbol;
-	char *tmp;
-
-	if (xtables_strtoui(str, &tmp, NULL, 0, max))
-		return tos_parse_numeric(str, tvm, max);
-
-	/* Do not consider ECN bits when using preset names */
-	tvm->mask = def_mask;
-	for (symbol = tos_symbol_names; symbol->name != NULL; ++symbol)
-		if (strcasecmp(str, symbol->name) == 0) {
-			tvm->value = symbol->value;
-			return true;
-		}
-
-	xtables_error(PARAMETER_PROBLEM, "Symbolic name \"%s\" is unknown", str);
-	return false;
-}
-
 static bool tos_try_print_symbolic(const char *prefix,
     uint8_t value, uint8_t mask)
 {
-- 
1.7.1

