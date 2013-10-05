From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: improve chain name validation
Date: Sat, 5 Oct 2013 09:33:15 -0700
Message-ID: <20131005163315.GA16881@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61082 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JEQdS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:33:18 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so5302763pbb.33
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Oct 2013 09:33:18 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As pointed out by Andrew Domaszek, iptables allows whitespace to be included in
chain names.  This causes issues with iptables-restore, and later iptables
actions on the chain.  Attached patch disallows whitespace, and also consolidates
all chain name checking into a new function.

This closes netfilter bugzilla #855.

Signed-off-by: Phil Oester <kernel@linuxace.com>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-iptables-parse_chain

diff --git a/iptables/iptables.c b/iptables/iptables.c
index d3899bc..5cd2596 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -373,6 +373,32 @@ parse_rulenumber(const char *rule)
 	return rulenum;
 }
 
+static void
+parse_chain(const char *chainname)
+{
+	const char *ptr;
+
+	if (strlen(chainname) >= XT_EXTENSION_MAXNAMELEN)
+		xtables_error(PARAMETER_PROBLEM,
+			   "chain name `%s' too long (must be under %u chars)",
+			   chainname, XT_EXTENSION_MAXNAMELEN);
+
+	if (*chainname == '-' || *chainname == '!')
+		xtables_error(PARAMETER_PROBLEM,
+			   "chain name not allowed to start "
+			   "with `%c'\n", *chainname);
+
+	if (xtables_find_target(chainname, XTF_TRY_LOAD))
+		xtables_error(PARAMETER_PROBLEM,
+			   "chain name may not clash "
+			   "with target name\n");
+
+	for (ptr = chainname; *ptr; ptr++)
+		if (isspace(*ptr))
+			xtables_error(PARAMETER_PROBLEM,
+				   "Invalid chain name `%s'", chainname);
+}
+
 static const char *
 parse_target(const char *targetname)
 {
@@ -1428,14 +1454,7 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'N':
-			if (optarg && (*optarg == '-' || *optarg == '!'))
-				xtables_error(PARAMETER_PROBLEM,
-					   "chain name not allowed to start "
-					   "with `%c'\n", *optarg);
-			if (xtables_find_target(optarg, XTF_TRY_LOAD))
-				xtables_error(PARAMETER_PROBLEM,
-					   "chain name may not clash "
-					   "with target name\n");
+			parse_chain(optarg);
 			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
@@ -1729,11 +1748,6 @@ int do_command4(int argc, char *argv[], char **table,
 
 	generic_opt_check(command, cs.options);
 
-	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name `%s' too long (must be under %u chars)",
-			   chain, XT_EXTENSION_MAXNAMELEN);
-
 	/* Attempt to acquire the xtables lock */
 	if (!restore && !xtables_lock(wait)) {
 		fprintf(stderr, "Another app is currently holding the xtables lock. "

--5vNYLRcllDrimb99--
