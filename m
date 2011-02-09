From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/11] iptables: fix error message for unknown options
Date: Wed,  9 Feb 2011 02:48:56 +0100
Message-ID: <1297216137-18505-12-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38751 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab1BIBtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:13 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-From: iptables v1.4.10: option "-q" requires an argument
+To:   iptables v1.4.10: unknown option "-q"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   17 +++++++----------
 iptables.c  |   17 +++++++----------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 5a550bf..5561a7d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1290,15 +1290,12 @@ static void command_default(struct iptables_command_state *cs)
 		return;
 	}
 
-	if (cs->c == '?') {
-		if (optopt)
-			xtables_error(PARAMETER_PROBLEM,
-				"option \"%s\" requires an argument",
-				cs->argv[optind-1]);
-		else
-			xtables_error(PARAMETER_PROBLEM,
-				"unknown option \"%s\"", cs->argv[optind-1]);
-	}
+	if (cs->c == ':')
+		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+		              "requires an argument", cs->argv[optind-1]);
+	if (cs->c == '?')
+		xtables_error(PARAMETER_PROBLEM, "unknown option "
+			      "\"%s\"", cs->argv[optind-1]);
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
@@ -1396,7 +1393,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
+	   "-:A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
diff --git a/iptables.c b/iptables.c
index 6f5616b..33fd882 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1316,15 +1316,12 @@ static void command_default(struct iptables_command_state *cs)
 		return;
 	}
 
-	if (cs->c == '?') {
-		if (optopt)
-			xtables_error(PARAMETER_PROBLEM,
-				"option \"%s\" requires an argument",
-				cs->argv[optind-1]);
-		else
-			xtables_error(PARAMETER_PROBLEM,
-				"unknown option \"%s\"", cs->argv[optind-1]);
-	}
+	if (cs->c == ':')
+		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+		              "requires an argument", cs->argv[optind-1]);
+	if (cs->c == '?')
+		xtables_error(PARAMETER_PROBLEM, "unknown option "
+			      "\"%s\"", cs->argv[optind-1]);
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
@@ -1426,7 +1423,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
+	   "-:A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
-- 
1.7.1

