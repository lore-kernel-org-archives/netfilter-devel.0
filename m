Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2343C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Dec 2021 18:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbhLMSIc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 13:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241633AbhLMSIb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 13:08:31 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A55C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Dec 2021 10:08:31 -0800 (PST)
Received: from localhost ([::1]:58966 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mwpkT-0004JL-6l; Mon, 13 Dec 2021 19:08:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 5/6] libxtables: Extend basic_exit_err()
Date:   Mon, 13 Dec 2021 19:07:46 +0100
Message-Id: <20211213180747.20707-6-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213180747.20707-1-phil@nwl.cc>
References: <20211213180747.20707-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Basically merge the function with xtables_exit_error, optionally
printing the program variant (if set) and a status-specific footer.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Do not require existence of exit_tryhelp() in libxtables, instead
  merge its code into basic_exit_error().
---
 iptables/ip6tables.c   | 22 ----------------------
 iptables/iptables.c    | 23 -----------------------
 iptables/xtables-arp.c |  2 --
 iptables/xtables-eb.c  |  2 --
 iptables/xtables.c     | 23 -----------------------
 libxtables/xtables.c   | 20 +++++++++++++++++++-
 6 files changed, 19 insertions(+), 73 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index d9fd3de69dfea..c7d2377906e0c 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -87,13 +87,11 @@ static struct option original_opts[] = {
 	{NULL},
 };
 
-void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION,
 	.program_variant = "legacy",
 	.orig_opts = original_opts,
-	.exit_err = ip6tables_exit_error,
 	.compat_rev = xtables_compatible_revision,
 };
 
@@ -108,26 +106,6 @@ exit_printhelp(const struct xtables_rule_match *matches)
 	exit(0);
 }
 
-void
-ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
-{
-	va_list args;
-
-	va_start(args, msg);
-	fprintf(stderr, "%s v%s (legacy): ", prog_name, prog_vers);
-	vfprintf(stderr, msg, args);
-	va_end(args);
-	fprintf(stderr, "\n");
-	if (status == PARAMETER_PROBLEM)
-		exit_tryhelp(status, line);
-	if (status == VERSION_PROBLEM)
-		fprintf(stderr,
-			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
-	/* On error paths, make sure that we don't leak memory */
-	xtables_free_opts(1);
-	exit(status);
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 5a634b2ef7a5d..cc17f8d4e5ce7 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -84,14 +84,11 @@ static struct option original_opts[] = {
 	{NULL},
 };
 
-void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
-
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION,
 	.program_variant = "legacy",
 	.orig_opts = original_opts,
-	.exit_err = iptables_exit_error,
 	.compat_rev = xtables_compatible_revision,
 };
 
@@ -106,26 +103,6 @@ exit_printhelp(const struct xtables_rule_match *matches)
 	exit(0);
 }
 
-void
-iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
-{
-	va_list args;
-
-	va_start(args, msg);
-	fprintf(stderr, "%s v%s (legacy): ", prog_name, prog_vers);
-	vfprintf(stderr, msg, args);
-	va_end(args);
-	fprintf(stderr, "\n");
-	if (status == PARAMETER_PROBLEM)
-		exit_tryhelp(status, line);
-	if (status == VERSION_PROBLEM)
-		fprintf(stderr,
-			"Perhaps iptables or your kernel needs to be upgraded.\n");
-	/* On error paths, make sure that we don't leak memory */
-	xtables_free_opts(1);
-	exit(status);
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 24d020de23370..479749390f8cc 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -84,7 +84,6 @@ static struct option original_opts[] = {
 
 #define opts xt_params->opts
 
-extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 static void printhelp(const struct xtables_rule_match *m);
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
@@ -92,7 +91,6 @@ struct xtables_globals arptables_globals = {
 	.program_variant	= "nf_tables",
 	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:nv" /* "m:" */,
 	.orig_opts		= original_opts,
-	.exit_err		= xtables_exit_error,
 	.compat_rev		= nft_compatible_revision,
 	.print_help		= printhelp,
 };
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index b78d5b6aa74f5..5ac122971c644 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -216,14 +216,12 @@ struct option ebt_original_options[] =
 	{ 0 }
 };
 
-extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
 	.program_version	= PACKAGE_VERSION,
 	.program_variant	= "nf_tables",
 	.optstring		= OPTSTRING_COMMON "h",
 	.orig_opts		= ebt_original_options,
-	.exit_err		= xtables_exit_error,
 	.compat_rev		= nft_compatible_revision,
 };
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index e85df75e7c1c3..adf03b9348bd3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -86,15 +86,12 @@ static struct option original_opts[] = {
 	{NULL},
 };
 
-void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
-
 struct xtables_globals xtables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION,
 	.program_variant = "nf_tables",
 	.optstring = OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x",
 	.orig_opts = original_opts,
-	.exit_err = xtables_exit_error,
 	.compat_rev = nft_compatible_revision,
 	.print_help = xtables_printhelp,
 };
@@ -103,26 +100,6 @@ struct xtables_globals xtables_globals = {
 #define prog_name xt_params->program_name
 #define prog_vers xt_params->program_version
 
-void
-xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
-{
-	va_list args;
-
-	va_start(args, msg);
-	fprintf(stderr, "%s v%s (nf_tables): ", prog_name, prog_vers);
-	vfprintf(stderr, msg, args);
-	va_end(args);
-	fprintf(stderr, "\n");
-	if (status == PARAMETER_PROBLEM)
-		exit_tryhelp(status, line);
-	if (status == VERSION_PROBLEM)
-		fprintf(stderr,
-			"Perhaps iptables or your kernel needs to be upgraded.\n");
-	/* On error paths, make sure that we don't leak memory */
-	xtables_free_opts(1);
-	exit(status);
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d670175db2236..e15c6dd1f9069 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -86,10 +86,28 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 	va_list args;
 
 	va_start(args, msg);
-	fprintf(stderr, "%s v%s: ", xt_params->program_name, xt_params->program_version);
+	fprintf(stderr, "%s v%s",
+		xt_params->program_name, xt_params->program_version);
+	if (xt_params->program_variant)
+		fprintf(stderr, " (%s)", xt_params->program_variant);
+	fprintf(stderr, ": ");
+
 	vfprintf(stderr, msg, args);
 	va_end(args);
 	fprintf(stderr, "\n");
+
+	if (status == PARAMETER_PROBLEM) {
+		if (line != -1)
+			fprintf(stderr, "Error occurred at line: %d\n", line);
+		fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
+				xt_params->program_name, xt_params->program_name);
+	} else if (status == VERSION_PROBLEM) {
+		fprintf(stderr,
+			"Perhaps %s or your kernel needs to be upgraded.\n",
+			xt_params->program_name);
+	}
+	/* On error paths, make sure that we don't leak memory */
+	xtables_free_opts(1);
 	exit(status);
 }
 
-- 
2.33.0

