From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/21] print dlopen error
Date: Sat, 5 Jan 2008 15:45:21 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051545060.14194@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37245 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYAEOpW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:45:22 -0500
In-Reply-To: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the file exists but could not be loaded, print the dlerror().
Often it is a missing symbol.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 xtables.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: iptables-modules/xtables.c
===================================================================
--- iptables-modules.orig/xtables.c
+++ iptables-modules/xtables.c
@@ -309,6 +309,7 @@ struct xtables_match *find_match(const c
 {
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
+	struct stat sb;
 
 	/* This is ugly as hell. Nonetheless, there is no way of changing
 	 * this without hurting backwards compatibility */
@@ -347,12 +348,16 @@ struct xtables_match *find_match(const c
 			/* Found library.  If it didn't register itself,
 			   maybe they specified target as match. */
 			ptr = find_match(name, DONT_LOAD, NULL);
+		else if (stat(path, &sb) == 0)
+			fprintf(stderr, "%s: %s\n", path, dlerror());
 
 		if (ptr == NULL) {
 			sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
 				name);
 			if (dlopen(path, RTLD_NOW) != NULL)
 				ptr = find_match(name, DONT_LOAD, NULL);
+			else if (stat(path, &sb) == 0)
+				fprintf(stderr, "%s: %s\n", path, dlerror());
 		}
 
 		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
@@ -396,6 +401,7 @@ struct xtables_match *find_match(const c
 struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
 {
 	struct xtables_target *ptr;
+	struct stat sb;
 
 	/* Standard target? */
 	if (strcmp(name, "") == 0
@@ -420,12 +426,16 @@ struct xtables_target *find_target(const
 			/* Found library.  If it didn't register itself,
 			   maybe they specified match as a target. */
 			ptr = find_target(name, DONT_LOAD);
+		else if (stat(path, &sb) == 0)
+			fprintf(stderr, "%s: %s\n", path, dlerror());
 
 		if (ptr == NULL) {
 			sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
 				name);
 			if (dlopen(path, RTLD_NOW) != NULL)
 				ptr = find_target(name, DONT_LOAD);
+			else if (stat(path, &sb) == 0)
+				fprintf(stderr, "%s: %s\n", path, dlerror());
 		}
 		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
