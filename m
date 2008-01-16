From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [10/19] print warning when dlopen fails
Date: Wed, 16 Jan 2008 14:51:05 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161450440.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48702 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYAPNvG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:51:06 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the file exists but could not be loaded, print the dlerror().
Often it is a missing symbol.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 xtables.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: iptables-modules/xtables.c
===================================================================
--- iptables-modules.orig/xtables.c
+++ iptables-modules/xtables.c
@@ -307,6 +307,9 @@ void parse_interface(const char *arg, ch
 struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 				 struct xtables_rule_match **matches)
 {
+#ifndef NO_SHARED_LIBS
+	struct stat sb;
+#endif
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
 
@@ -347,12 +350,16 @@ struct xtables_match *find_match(const c
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
@@ -395,6 +402,9 @@ struct xtables_match *find_match(const c
 
 struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
 {
+#ifndef NO_SHARED_LIBS
+	struct stat sb;
+#endif
 	struct xtables_target *ptr;
 
 	/* Standard target? */
@@ -420,12 +430,16 @@ struct xtables_target *find_target(const
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
