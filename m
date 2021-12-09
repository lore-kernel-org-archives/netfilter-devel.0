Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFADFC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 00:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbhLIA04 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 19:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241471AbhLIA0z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 19:26:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B84C061746
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 16:23:23 -0800 (PST)
Received: from localhost ([::1]:58554 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mv7DV-0004tY-LM; Thu, 09 Dec 2021 01:23:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/6] libxtables: Add xtables_exit_tryhelp()
Date:   Thu,  9 Dec 2021 01:22:54 +0100
Message-Id: <20211209002257.21467-4-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211209002257.21467-1-phil@nwl.cc>
References: <20211209002257.21467-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is just the exit_tryhelp() function which existed three times in
identical form with a more suitable name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h    |  1 +
 iptables/ip6tables.c | 19 ++++---------------
 iptables/iptables.c  | 19 ++++---------------
 iptables/xtables.c   | 21 +++++----------------
 libxtables/xtables.c | 10 ++++++++++
 5 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index ca674c2663eb4..fdf77d83199d0 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -501,6 +501,7 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 extern struct xtables_globals *xt_params;
 #define xtables_error (xt_params->exit_err)
+extern void xtables_exit_tryhelp(int status) __attribute__((noreturn));
 
 extern void xtables_param_act(unsigned int, const char *, ...);
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 46f7785b8a9c5..b0ee512b83c52 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -100,17 +100,6 @@ struct xtables_globals ip6tables_globals = {
 #define prog_name ip6tables_globals.program_name
 #define prog_vers ip6tables_globals.program_version
 
-static void __attribute__((noreturn))
-exit_tryhelp(int status)
-{
-	if (line != -1)
-		fprintf(stderr, "Error occurred at line: %d\n", line);
-	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
-			prog_name, prog_name);
-	xtables_free_opts(1);
-	exit(status);
-}
-
 static void
 exit_printhelp(const struct xtables_rule_match *matches)
 {
@@ -129,7 +118,7 @@ ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_end(args);
 	fprintf(stderr, "\n");
 	if (status == PARAMETER_PROBLEM)
-		exit_tryhelp(status);
+		xtables_exit_tryhelp(status);
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
@@ -1106,7 +1095,7 @@ int do_command6(int argc, char *argv[], char **table,
 			if (line != -1)
 				return 1; /* success: line ignored */
 			fprintf(stderr, "This is the IPv6 version of ip6tables.\n");
-			exit_tryhelp(2);
+			xtables_exit_tryhelp(2);
 
 		case '6':
 			/* This is indeed the IPv6 ip6tables */
@@ -1123,7 +1112,7 @@ int do_command6(int argc, char *argv[], char **table,
 				continue;
 			}
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
-			exit_tryhelp(2);
+			xtables_exit_tryhelp(2);
 
 		default:
 			if (command_default(&cs, &ip6tables_globals, invert))
@@ -1372,7 +1361,7 @@ int do_command6(int argc, char *argv[], char **table,
 		break;
 	default:
 		/* We should never reach this... */
-		exit_tryhelp(2);
+		xtables_exit_tryhelp(2);
 	}
 
 	if (verbose > 1)
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 7b4503498865d..5bb262447fa48 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -98,17 +98,6 @@ struct xtables_globals iptables_globals = {
 #define prog_name iptables_globals.program_name
 #define prog_vers iptables_globals.program_version
 
-static void __attribute__((noreturn))
-exit_tryhelp(int status)
-{
-	if (line != -1)
-		fprintf(stderr, "Error occurred at line: %d\n", line);
-	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
-			prog_name, prog_name);
-	xtables_free_opts(1);
-	exit(status);
-}
-
 static void
 exit_printhelp(const struct xtables_rule_match *matches)
 {
@@ -127,7 +116,7 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_end(args);
 	fprintf(stderr, "\n");
 	if (status == PARAMETER_PROBLEM)
-		exit_tryhelp(status);
+		xtables_exit_tryhelp(status);
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
@@ -1093,7 +1082,7 @@ int do_command4(int argc, char *argv[], char **table,
 			if (line != -1)
 				return 1; /* success: line ignored */
 			fprintf(stderr, "This is the IPv4 version of iptables.\n");
-			exit_tryhelp(2);
+			xtables_exit_tryhelp(2);
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -1106,7 +1095,7 @@ int do_command4(int argc, char *argv[], char **table,
 				continue;
 			}
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
-			exit_tryhelp(2);
+			xtables_exit_tryhelp(2);
 
 		default:
 			if (command_default(&cs, &iptables_globals, invert))
@@ -1353,7 +1342,7 @@ int do_command4(int argc, char *argv[], char **table,
 		break;
 	default:
 		/* We should never reach this... */
-		exit_tryhelp(2);
+		xtables_exit_tryhelp(2);
 	}
 
 	if (verbose > 1)
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 36324a5de22a8..94eae958698d4 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -102,17 +102,6 @@ struct xtables_globals xtables_globals = {
 #define prog_name xt_params->program_name
 #define prog_vers xt_params->program_version
 
-static void __attribute__((noreturn))
-exit_tryhelp(int status)
-{
-	if (line != -1)
-		fprintf(stderr, "Error occurred at line: %d\n", line);
-	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
-			prog_name, prog_name);
-	xtables_free_opts(1);
-	exit(status);
-}
-
 void
 xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 {
@@ -124,7 +113,7 @@ xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_end(args);
 	fprintf(stderr, "\n");
 	if (status == PARAMETER_PROBLEM)
-		exit_tryhelp(status);
+		xtables_exit_tryhelp(status);
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
@@ -631,7 +620,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (p->restore && args->family == AF_INET6)
 				return;
 
-			exit_tryhelp(2);
+			xtables_exit_tryhelp(2);
 
 		case '6':
 			if (args->family == AF_INET6)
@@ -640,7 +629,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (p->restore && args->family == AF_INET)
 				return;
 
-			exit_tryhelp(2);
+			xtables_exit_tryhelp(2);
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -653,7 +642,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				continue;
 			}
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
-			exit_tryhelp(2);
+			xtables_exit_tryhelp(2);
 
 		default:
 			if (command_default(cs, xt_params, invert))
@@ -849,7 +838,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		break;
 	default:
 		/* We should never reach this... */
-		exit_tryhelp(2);
+		xtables_exit_tryhelp(2);
 	}
 
 	*table = p.table;
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d670175db2236..7112c76beee18 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -81,6 +81,16 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...) __attrib
 
 struct xtables_globals *xt_params = NULL;
 
+void xtables_exit_tryhelp(int status)
+{
+	if (line != -1)
+		fprintf(stderr, "Error occurred at line: %d\n", line);
+	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
+			xt_params->program_name, xt_params->program_name);
+	xtables_free_opts(1);
+	exit(status);
+}
+
 void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 {
 	va_list args;
-- 
2.33.0

