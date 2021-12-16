Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A69C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhLPM7Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhLPM7X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:59:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8A4C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:59:23 -0800 (PST)
Received: from localhost ([::1]:58982 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mxqLx-00046F-T1; Thu, 16 Dec 2021 13:59:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 4/6] xtables_globals: Embed variant name in .program_version
Date:   Thu, 16 Dec 2021 13:58:38 +0100
Message-Id: <20211216125840.385-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216125840.385-1-phil@nwl.cc>
References: <20211216125840.385-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Both are constant strings, so precompiler may concat them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c        | 6 +++---
 iptables/iptables-restore.c | 2 +-
 iptables/iptables-save.c    | 2 +-
 iptables/iptables.c         | 6 +++---
 iptables/xtables-arp.c      | 2 +-
 iptables/xtables-eb.c       | 4 ++--
 iptables/xtables-restore.c  | 2 +-
 iptables/xtables-save.c     | 2 +-
 iptables/xtables.c          | 6 +++---
 9 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 788966d6b68af..44d2c08cddc42 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -90,7 +90,7 @@ static struct option original_opts[] = {
 void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
-	.program_version = PACKAGE_VERSION,
+	.program_version = PACKAGE_VERSION " (legacy)",
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 	.compat_rev = xtables_compatible_revision,
@@ -113,7 +113,7 @@ ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_list args;
 
 	va_start(args, msg);
-	fprintf(stderr, "%s v%s (legacy): ", prog_name, prog_vers);
+	fprintf(stderr, "%s v%s: ", prog_name, prog_vers);
 	vfprintf(stderr, msg, args);
 	va_end(args);
 	fprintf(stderr, "\n");
@@ -1049,7 +1049,7 @@ int do_command6(int argc, char *argv[], char **table,
 			if (invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
-				printf("%s v%s (legacy)\n",
+				printf("%s v%s\n",
 				       prog_name, prog_vers);
 			exit(0);
 
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index cc2c2b8b10086..a3efb067d3d90 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -117,7 +117,7 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 				verbose = 1;
 				break;
 			case 'V':
-				printf("%s v%s (legacy)\n",
+				printf("%s v%s\n",
 				       xt_params->program_name,
 				       xt_params->program_version);
 				exit(0);
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 4efd66673f5de..a114e98bb62dc 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -173,7 +173,7 @@ do_iptables_save(struct iptables_save_cb *cb, int argc, char *argv[])
 			do_output(cb, tablename);
 			exit(0);
 		case 'V':
-			printf("%s v%s (legacy)\n",
+			printf("%s v%s\n",
 			       xt_params->program_name,
 			       xt_params->program_version);
 			exit(0);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 78fff9ef77b81..191877ec1bb06 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -88,7 +88,7 @@ void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __a
 
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
-	.program_version = PACKAGE_VERSION,
+	.program_version = PACKAGE_VERSION " (legacy)",
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 	.compat_rev = xtables_compatible_revision,
@@ -111,7 +111,7 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_list args;
 
 	va_start(args, msg);
-	fprintf(stderr, "%s v%s (legacy): ", prog_name, prog_vers);
+	fprintf(stderr, "%s v%s: ", prog_name, prog_vers);
 	vfprintf(stderr, msg, args);
 	va_end(args);
 	fprintf(stderr, "\n");
@@ -1032,7 +1032,7 @@ int do_command4(int argc, char *argv[], char **table,
 			if (invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
-				printf("%s v%s (legacy)\n",
+				printf("%s v%s\n",
 				       prog_name, prog_vers);
 			exit(0);
 
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index cca19438a877e..8a226330a7124 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -88,7 +88,7 @@ extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ..
 static void printhelp(const struct xtables_rule_match *m);
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
-	.program_version	= PACKAGE_VERSION,
+	.program_version	= PACKAGE_VERSION " (nf_tables)",
 	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:nv" /* "m:" */,
 	.orig_opts		= original_opts,
 	.exit_err		= xtables_exit_error,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 3f58754d14cee..604d4d39e90f7 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -219,7 +219,7 @@ struct option ebt_original_options[] =
 extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
-	.program_version	= PACKAGE_VERSION,
+	.program_version	= PACKAGE_VERSION " (nf_tables)",
 	.optstring		= OPTSTRING_COMMON "h",
 	.orig_opts		= ebt_original_options,
 	.exit_err		= xtables_exit_error,
@@ -860,7 +860,7 @@ print_zero:
 			if (OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Multiple commands are not allowed");
-			printf("%s %s (nf_tables)\n", prog_name, prog_vers);
+			printf("%s %s\n", prog_name, prog_vers);
 			exit(0);
 		case 'h': /* Help */
 			if (OPT_COMMANDS)
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index aa8b397f29ac7..8ca2abffa5d36 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -312,7 +312,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				verbose = 1;
 				break;
 			case 'V':
-				printf("%s v%s (nf_tables)\n", prog_name, prog_vers);
+				printf("%s v%s\n", prog_name, prog_vers);
 				exit(0);
 			case 't':
 				p.testing = 1;
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index c6ebb0ec94c4f..03d2b980d5371 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -184,7 +184,7 @@ xtables_save_main(int family, int argc, char *argv[],
 			dump = true;
 			break;
 		case 'V':
-			printf("%s v%s (nf_tables)\n", prog_name, prog_vers);
+			printf("%s v%s\n", prog_name, prog_vers);
 			exit(0);
 		default:
 			fprintf(stderr,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index d53fd758ac72d..a6b10cf846d58 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -90,7 +90,7 @@ void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __at
 
 struct xtables_globals xtables_globals = {
 	.option_offset = 0,
-	.program_version = PACKAGE_VERSION,
+	.program_version = PACKAGE_VERSION " (nf_tables)",
 	.optstring = OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.exit_err = xtables_exit_error,
@@ -108,7 +108,7 @@ xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_list args;
 
 	va_start(args, msg);
-	fprintf(stderr, "%s v%s (nf_tables): ", prog_name, prog_vers);
+	fprintf(stderr, "%s v%s: ", prog_name, prog_vers);
 	vfprintf(stderr, msg, args);
 	va_end(args);
 	fprintf(stderr, "\n");
@@ -554,7 +554,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
-				printf("%s v%s (nf_tables)\n",
+				printf("%s v%s\n",
 				       prog_name, prog_vers);
 			exit(0);
 
-- 
2.33.0

