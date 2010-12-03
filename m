From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] iptables: reset options at the start of each command
Date: Fri,  3 Dec 2010 22:58:39 +0100
Message-ID: <1291413524-15016-2-git-send-email-jengelh@medozas.de>
References: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44579 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab0LCV6r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:58:47 -0500
In-Reply-To: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For each new command, iptables is supposed to start afresh with a
blank option set (opts) that only contains the program-specific
options (orig_opts), without any extension options. We failed to
restore this pointer (in function do_command) after the previous free
call in xtables_free_opts.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    2 +-
 iptables.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 8318f91..9b1629e 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -147,7 +147,6 @@ void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 };
@@ -1335,6 +1334,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
            demand-load a protocol. */
 	opterr = 0;
 
+	opts = xt_params->orig_opts;
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
diff --git a/iptables.c b/iptables.c
index c800fff..1127bdd 100644
--- a/iptables.c
+++ b/iptables.c
@@ -147,7 +147,6 @@ void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __a
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 };
@@ -1358,6 +1357,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
            demand-load a protocol. */
 	opterr = 0;
 
+	opts = xt_params->orig_opts;
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
-- 
1.7.1

