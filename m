From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/8] iptables: fix error message for unknown options
Date: Fri,  4 Feb 2011 14:08:51 +0100
Message-ID: <1296824935-4606-6-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36777 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1BDNJC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:09:02 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-From: iptables v1.4.10: option "-q" requires an argument
+To:   iptables v1.4.10: unknown option "-q"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   16 +++++++---------
 iptables.c  |   16 +++++++---------
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index fb3b320..8cacf61 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1359,14 +1359,12 @@ command_default(int c, char **argv, bool invert, struct ip6t_entry *fw,
 		optind--;
 		return;
 	}
-	if (c == '?') {
-		if (optopt)
-			xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
-			              "requires an argument", argv[optind-1]);
-		else
-			xtables_error(PARAMETER_PROBLEM, "unknown option "
-				      "\"%s\"", optarg);
-	}
+	if (c == ':')
+		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+		              "requires an argument", argv[optind-1]);
+	if (c == '?')
+		xtables_error(PARAMETER_PROBLEM, "unknown option "
+			      "\"%s\"", argv[optind-1]);
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", argv[optind-1]);
 }
 
@@ -1417,7 +1415,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 	opts = xt_params->orig_opts;
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
+	   "-:A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
diff --git a/iptables.c b/iptables.c
index 9977634..504bcd8 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1382,14 +1382,12 @@ command_default(int c, char **argv, bool invert, struct ipt_entry *fw,
 		optind--;
 		return;
 	}
-	if (c == '?') {
-		if (optopt)
-			xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
-			              "requires an argument", argv[optind-1]);
-		else
-			xtables_error(PARAMETER_PROBLEM, "unknown option "
-				      "\"%s\"", argv[optind-1]);
-	}
+	if (c == ':')
+		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+		              "requires an argument", argv[optind-1]);
+	if (c == '?')
+		xtables_error(PARAMETER_PROBLEM, "unknown option "
+			      "\"%s\"", argv[optind-1]);
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
@@ -1440,7 +1438,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
+	   "-:A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
-- 
1.7.1

