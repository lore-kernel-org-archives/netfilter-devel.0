From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] xtables: another try at chain name length checking
Date: Thu, 24 Jun 2010 10:14:03 +0200
Message-ID: <1277367245-14961-3-git-send-email-jengelh@medozas.de>
References: <1277367245-14961-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37888 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab0FXIOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:14:12 -0400
In-Reply-To: <1277367245-14961-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since XT_EXTENSION_MAXNAMELEN is now available, make use of it
and clear the confusion.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    4 ++--
 ip6tables.c         |    4 ++--
 iptables-restore.c  |    4 ++--
 iptables.c          |    4 ++--
 xtables.c           |   10 ++++------
 5 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index f0725d1..008566c 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -253,11 +253,11 @@ int main(int argc, char *argv[])
 				exit(1);
 			}
 
-			if (strlen(chain) > XT_FUNCTION_MAXNAMELEN - 1)
+			if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Invalid chain name `%s' "
 					   "(%u chars max)",
-					   chain, XT_FUNCTION_MAXNAMELEN - 1);
+					   chain, XT_EXTENSION_MAXNAMELEN - 1);
 
 			if (ip6tc_builtin(chain, handle) <= 0) {
 				if (noflush && ip6tc_is_chain(chain, handle)) {
diff --git a/ip6tables.c b/ip6tables.c
index 4e73d34..2fff21b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -456,10 +456,10 @@ parse_target(const char *targetname)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name (too short)");
 
-	if (strlen(targetname) > XT_FUNCTION_MAXNAMELEN - 1)
+	if (strlen(targetname) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name `%s' (%u chars max)",
-			   targetname, XT_FUNCTION_MAXNAMELEN - 1);
+			   targetname, XT_EXTENSION_MAXNAMELEN - 1);
 
 	for (ptr = targetname; *ptr; ptr++)
 		if (isspace(*ptr))
diff --git a/iptables-restore.c b/iptables-restore.c
index 4a74485..8c6648e 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -259,11 +259,11 @@ main(int argc, char *argv[])
 				exit(1);
 			}
 
-			if (strlen(chain) > XT_FUNCTION_MAXNAMELEN - 1)
+			if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Invalid chain name `%s' "
 					   "(%u chars max)",
-					   chain, XT_FUNCTION_MAXNAMELEN - 1);
+					   chain, XT_EXTENSION_MAXNAMELEN - 1);
 
 			if (iptc_builtin(chain, handle) <= 0) {
 				if (noflush && iptc_is_chain(chain, handle)) {
diff --git a/iptables.c b/iptables.c
index 19c2af5..efe993e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -460,10 +460,10 @@ parse_target(const char *targetname)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name (too short)");
 
-	if (strlen(targetname) > XT_FUNCTION_MAXNAMELEN - 1)
+	if (strlen(targetname) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name `%s' (%u chars max)",
-			   targetname, XT_FUNCTION_MAXNAMELEN - 1);
+			   targetname, XT_EXTENSION_MAXNAMELEN - 1);
 
 	for (ptr = targetname; *ptr; ptr++)
 		if (isspace(*ptr))
diff --git a/xtables.c b/xtables.c
index 440b2e1..b4c4f6b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -545,10 +545,10 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
 
-	if (strlen(name) > XT_FUNCTION_MAXNAMELEN - 1)
+	if (strlen(name) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid match name \"%s\" (%u chars max)",
-			   name, XT_FUNCTION_MAXNAMELEN - 1);
+			   name, XT_EXTENSION_MAXNAMELEN - 1);
 
 	/* This is ugly as hell. Nonetheless, there is no way of changing
 	 * this without hurting backwards compatibility */
@@ -741,8 +741,7 @@ void xtables_register_match(struct xtables_match *me)
 		exit(1);
 	}
 
-	/* Revision field stole a char from name. */
-	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
+	if (strlen(me->name) >= XT_EXTENSION_MAXNAMELEN) {
 		fprintf(stderr, "%s: target `%s' has invalid name\n",
 			xt_params->program_name, me->name);
 		exit(1);
@@ -827,8 +826,7 @@ void xtables_register_target(struct xtables_target *me)
 		exit(1);
 	}
 
-	/* Revision field stole a char from name. */
-	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
+	if (strlen(me->name) >= XT_EXTENSION_MAXNAMELEN) {
 		fprintf(stderr, "%s: target `%s' has invalid name\n",
 			xt_params->program_name, me->name);
 		exit(1);
-- 
1.7.1

