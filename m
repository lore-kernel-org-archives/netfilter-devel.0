From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] iptables: correctly check for too-long chain/target/match names
Date: Tue, 16 Mar 2010 20:02:19 +0100
Message-ID: <1268766140-28435-4-git-send-email-jengelh@medozas.de>
References: <1268766140-28435-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33741 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661Ab0CPTCZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:02:25 -0400
In-Reply-To: <1268766140-28435-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* iptables-restore was not checking for chain name length
* iptables was not checking for match name length
* target length was checked against 32, not 29.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=641
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    6 ++++++
 ip6tables.c         |    4 ++--
 iptables-restore.c  |    6 ++++++
 iptables.c          |    4 ++--
 xtables.c           |    5 +++++
 5 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index d0efbee..f0725d1 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -253,6 +253,12 @@ int main(int argc, char *argv[])
 				exit(1);
 			}
 
+			if (strlen(chain) > XT_FUNCTION_MAXNAMELEN - 1)
+				xtables_error(PARAMETER_PROBLEM,
+					   "Invalid chain name `%s' "
+					   "(%u chars max)",
+					   chain, XT_FUNCTION_MAXNAMELEN - 1);
+
 			if (ip6tc_builtin(chain, handle) <= 0) {
 				if (noflush && ip6tc_is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
diff --git a/ip6tables.c b/ip6tables.c
index e2359df..6ee4281 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -456,10 +456,10 @@ parse_target(const char *targetname)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name (too short)");
 
-	if (strlen(targetname)+1 > sizeof(ip6t_chainlabel))
+	if (strlen(targetname) > XT_FUNCTION_MAXNAMELEN - 1)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name `%s' (%u chars max)",
-			   targetname, (unsigned int)sizeof(ip6t_chainlabel)-1);
+			   targetname, XT_FUNCTION_MAXNAMELEN - 1);
 
 	for (ptr = targetname; *ptr; ptr++)
 		if (isspace(*ptr))
diff --git a/iptables-restore.c b/iptables-restore.c
index 86d63e2..4a74485 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -259,6 +259,12 @@ main(int argc, char *argv[])
 				exit(1);
 			}
 
+			if (strlen(chain) > XT_FUNCTION_MAXNAMELEN - 1)
+				xtables_error(PARAMETER_PROBLEM,
+					   "Invalid chain name `%s' "
+					   "(%u chars max)",
+					   chain, XT_FUNCTION_MAXNAMELEN - 1);
+
 			if (iptc_builtin(chain, handle) <= 0) {
 				if (noflush && iptc_is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
diff --git a/iptables.c b/iptables.c
index 08eb134..25bc8cc 100644
--- a/iptables.c
+++ b/iptables.c
@@ -460,10 +460,10 @@ parse_target(const char *targetname)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name (too short)");
 
-	if (strlen(targetname)+1 > sizeof(ipt_chainlabel))
+	if (strlen(targetname) > XT_FUNCTION_MAXNAMELEN - 1)
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name `%s' (%u chars max)",
-			   targetname, (unsigned int)sizeof(ipt_chainlabel)-1);
+			   targetname, XT_FUNCTION_MAXNAMELEN - 1);
 
 	for (ptr = targetname; *ptr; ptr++)
 		if (isspace(*ptr))
diff --git a/xtables.c b/xtables.c
index f3baf84..7340c87 100644
--- a/xtables.c
+++ b/xtables.c
@@ -545,6 +545,11 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
 
+	if (strlen(name) > XT_FUNCTION_MAXNAMELEN - 1)
+		xtables_error(PARAMETER_PROBLEM,
+			   "Invalid match name \"%s\" (%u chars max)",
+			   name, XT_FUNCTION_MAXNAMELEN - 1);
+
 	/* This is ugly as hell. Nonetheless, there is no way of changing
 	 * this without hurting backwards compatibility */
 	if ( (strcmp(name,"icmpv6") == 0) ||
-- 
1.7.0.2

