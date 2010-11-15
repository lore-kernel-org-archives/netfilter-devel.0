From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] iptables: fix longopt reecognition and workaround getopt(3) behavior
Date: Mon, 15 Nov 2010 13:28:16 +0100
Message-ID: <1289824097-27337-2-git-send-email-jengelh@medozas.de>
References: <1289824097-27337-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57889 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0KOM2U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:28:20 -0500
In-Reply-To: <1289824097-27337-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* On the first call to getopt, opts was NULL, so long options would
not be recognized until a match/target was loaded.

Whacky getopt behavior:

* If the longopts parameter is NULL, getopt fails to recognize unknown
options, such that `iptables-multi main --append` will print a garbage
help message ("main needs an argument").

* If the longopts parameter is NULL on the first call, but not on
subsequent calls, it completely screws up option parsing, taking
the --dport in `iptables-multi main -A INPUT -p tcp --dport 1000`
as --destination instead, but not accepting "--destination 1.2.3.4"
either.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    1 +
 iptables.c  |    1 +
 xtables.c   |    3 ++-
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 150893d..8318f91 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -147,6 +147,7 @@ void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
+	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 };
diff --git a/iptables.c b/iptables.c
index 4c8bd77..c800fff 100644
--- a/iptables.c
+++ b/iptables.c
@@ -147,6 +147,7 @@ void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __a
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
+	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 };
diff --git a/xtables.c b/xtables.c
index 7658038..d0aa868 100644
--- a/xtables.c
+++ b/xtables.c
@@ -75,7 +75,8 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 
 void xtables_free_opts(int unused)
 {
-	free(xt_params->opts);
+	if (xt_params->opts != xt_params->orig_opts)
+		free(xt_params->opts);
 }
 
 struct option *xtables_merge_options(struct option *orig_opts,
-- 
1.7.1

