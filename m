Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471FAC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Dec 2021 18:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhLMSIE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 13:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbhLMSID (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 13:08:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D571C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Dec 2021 10:08:03 -0800 (PST)
Received: from localhost ([::1]:58956 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mwpk1-0004Hd-Ht; Mon, 13 Dec 2021 19:08:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 3/6] xshared: Share exit_tryhelp()
Date:   Mon, 13 Dec 2021 19:07:44 +0100
Message-Id: <20211213180747.20707-4-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213180747.20707-1-phil@nwl.cc>
References: <20211213180747.20707-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function existed three times in identical form. Avoid having to
declare extern int line in xshared.c by making it a parameter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 19 ++++---------------
 iptables/iptables.c  | 19 ++++---------------
 iptables/xshared.c   | 10 ++++++++++
 iptables/xshared.h   |  1 +
 iptables/xtables.c   | 21 +++++----------------
 5 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 46f7785b8a9c5..788966d6b68af 100644
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
+		exit_tryhelp(status, line);
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
@@ -1106,7 +1095,7 @@ int do_command6(int argc, char *argv[], char **table,
 			if (line != -1)
 				return 1; /* success: line ignored */
 			fprintf(stderr, "This is the IPv6 version of ip6tables.\n");
-			exit_tryhelp(2);
+			exit_tryhelp(2, line);
 
 		case '6':
 			/* This is indeed the IPv6 ip6tables */
@@ -1123,7 +1112,7 @@ int do_command6(int argc, char *argv[], char **table,
 				continue;
 			}
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
-			exit_tryhelp(2);
+			exit_tryhelp(2, line);
 
 		default:
 			if (command_default(&cs, &ip6tables_globals, invert))
@@ -1372,7 +1361,7 @@ int do_command6(int argc, char *argv[], char **table,
 		break;
 	default:
 		/* We should never reach this... */
-		exit_tryhelp(2);
+		exit_tryhelp(2, line);
 	}
 
 	if (verbose > 1)
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 7b4503498865d..78fff9ef77b81 100644
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
+		exit_tryhelp(status, line);
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
@@ -1093,7 +1082,7 @@ int do_command4(int argc, char *argv[], char **table,
 			if (line != -1)
 				return 1; /* success: line ignored */
 			fprintf(stderr, "This is the IPv4 version of iptables.\n");
-			exit_tryhelp(2);
+			exit_tryhelp(2, line);
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -1106,7 +1095,7 @@ int do_command4(int argc, char *argv[], char **table,
 				continue;
 			}
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
-			exit_tryhelp(2);
+			exit_tryhelp(2, line);
 
 		default:
 			if (command_default(&cs, &iptables_globals, invert))
@@ -1353,7 +1342,7 @@ int do_command4(int argc, char *argv[], char **table,
 		break;
 	default:
 		/* We should never reach this... */
-		exit_tryhelp(2);
+		exit_tryhelp(2, line);
 	}
 
 	if (verbose > 1)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 9b32610772ba5..efee7a30b39fd 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1252,3 +1252,13 @@ xtables_printhelp(const struct xtables_rule_match *matches)
 
 	print_extension_helps(xtables_targets, matches);
 }
+
+void exit_tryhelp(int status, int line)
+{
+	if (line != -1)
+		fprintf(stderr, "Error occurred at line: %d\n", line);
+	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
+			xt_params->program_name, xt_params->program_name);
+	xtables_free_opts(1);
+	exit(status);
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 3310954c1f441..2c05b0d7c4ace 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -260,5 +260,6 @@ void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
 int print_match_save(const struct xt_entry_match *e, const void *ip);
 
 void xtables_printhelp(const struct xtables_rule_match *matches);
+void exit_tryhelp(int status, int line) __attribute__((noreturn));
 
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 36324a5de22a8..d53fd758ac72d 100644
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
+		exit_tryhelp(status, line);
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
@@ -631,7 +620,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (p->restore && args->family == AF_INET6)
 				return;
 
-			exit_tryhelp(2);
+			exit_tryhelp(2, line);
 
 		case '6':
 			if (args->family == AF_INET6)
@@ -640,7 +629,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (p->restore && args->family == AF_INET)
 				return;
 
-			exit_tryhelp(2);
+			exit_tryhelp(2, line);
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -653,7 +642,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				continue;
 			}
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
-			exit_tryhelp(2);
+			exit_tryhelp(2, line);
 
 		default:
 			if (command_default(cs, xt_params, invert))
@@ -849,7 +838,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		break;
 	default:
 		/* We should never reach this... */
-		exit_tryhelp(2);
+		exit_tryhelp(2, line);
 	}
 
 	*table = p.table;
-- 
2.33.0

