From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/12] libxtables: collapse double protocol parsing
Date: Fri, 13 May 2011 02:47:30 +0200
Message-ID: <1305247657-29158-7-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54332 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759033Ab1EMAt1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:27 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Un-dent xtables_parse_protocol, and make xtopt_parse_protocol make use
of it.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c   |   49 +++++++++++++++++++++----------------------------
 xtoptions.c |   14 +-------------
 2 files changed, 22 insertions(+), 41 deletions(-)

diff --git a/xtables.c b/xtables.c
index 9038f89..f10cdb7 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1797,37 +1797,30 @@ const struct xtables_pprot xtables_chain_protos[] = {
 uint16_t
 xtables_parse_protocol(const char *s)
 {
-	unsigned int proto;
+	const struct protoent *pent;
+	unsigned int proto, i;
 
-	if (!xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX)) {
-		struct protoent *pent;
+	if (xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX))
+		return proto;
 
-		/* first deal with the special case of 'all' to prevent
-		 * people from being able to redefine 'all' in nsswitch
-		 * and/or provoke expensive [not working] ldap/nis/...
-		 * lookups */
-		if (!strcmp(s, "all"))
-			return 0;
+	/* first deal with the special case of 'all' to prevent
+	 * people from being able to redefine 'all' in nsswitch
+	 * and/or provoke expensive [not working] ldap/nis/...
+	 * lookups */
+	if (strcmp(s, "all") == 0)
+		return 0;
 
-		if ((pent = getprotobyname(s)))
-			proto = pent->p_proto;
-		else {
-			unsigned int i;
-			for (i = 0; i < ARRAY_SIZE(xtables_chain_protos); ++i) {
-				if (xtables_chain_protos[i].name == NULL)
-					continue;
+	pent = getprotobyname(s);
+	if (pent != NULL)
+		return pent->p_proto;
 
-				if (strcmp(s, xtables_chain_protos[i].name) == 0) {
-					proto = xtables_chain_protos[i].num;
-					break;
-				}
-			}
-			if (i == ARRAY_SIZE(xtables_chain_protos))
-				xt_params->exit_err(PARAMETER_PROBLEM,
-					   "unknown protocol `%s' specified",
-					   s);
-		}
+	for (i = 0; i < ARRAY_SIZE(xtables_chain_protos); ++i) {
+		if (xtables_chain_protos[i].name == NULL)
+			continue;
+		if (strcmp(s, xtables_chain_protos[i].name) == 0)
+			return xtables_chain_protos[i].num;
 	}
-
-	return proto;
+	xt_params->exit_err(PARAMETER_PROBLEM,
+		"unknown protocol \"%s\" specified", s);
+	return -1;
 }
diff --git a/xtoptions.c b/xtoptions.c
index 9e19250..eb9e4e6 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -498,19 +498,7 @@ static int xtables_getportbyname(const char *name)
  */
 static void xtopt_parse_protocol(struct xt_option_call *cb)
 {
-	const struct protoent *entry;
-	unsigned int value = -1;
-
-	if (xtables_strtoui(cb->arg, NULL, &value, 0, UINT8_MAX)) {
-		cb->val.protocol = value;
-		return;
-	}
-	entry = getprotobyname(cb->arg);
-	if (entry == NULL)
-		xt_params->exit_err(PARAMETER_PROBLEM,
-			"Protocol \"%s\" does not resolve to anything.\n",
-			cb->arg);
-	cb->val.protocol = entry->p_proto;
+	cb->val.protocol = xtables_parse_protocol(cb->arg);
 	if (cb->entry->flags & XTOPT_PUT)
 		*(uint8_t *)XTOPT_MKPTR(cb) = cb->val.protocol;
 }
-- 
1.7.1

