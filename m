From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH] ebtables-compat: fix counter listing
Date: Tue, 23 Dec 2014 13:24:26 +0100
Message-ID: <20141223122426.22985.47607.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47148 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753380AbaLWMYi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:24:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch:

% sudo ebtables-compat -L --Lc
Bridge table: filter

Bridge chain: INPUT, entries: 0, policy: ACCEPT
-j ACCEPT , pcnt = 123 -- bcnt = 123

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |    5 +++++
 iptables/xtables-eb.c |   12 +++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index a1bd906..98f8a4e 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <netinet/ether.h>
+#include <inttypes.h>
 
 #include <xtables.h>
 #include <libiptc/libxtc.h>
@@ -464,6 +465,10 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 		}
 	}
 
+	if (!(format & FMT_NOCOUNTS))
+		printf(" , pcnt = %"PRIu64" -- bcnt = %"PRIu64"",
+		       (uint64_t)cs.counters.pcnt, (uint64_t)cs.counters.bcnt);
+
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
 }
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index b924daf..9d13868 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -443,14 +443,12 @@ static void print_help(const struct xtables_target *t,
 /* Execute command L */
 static int list_rules(struct nft_handle *h, const char *chain, const char *table,
 		      int rule_nr, int verbose, int numeric, int expanded,
-		      int linenumbers)
+		      int linenumbers, int counters)
 {
 	unsigned int format;
 
 	format = FMT_OPTIONS;
-	if (!verbose)
-		format |= FMT_NOCOUNTS;
-	else
+	if (verbose)
 		format |= FMT_VIA;
 
 	if (numeric)
@@ -462,6 +460,9 @@ static int list_rules(struct nft_handle *h, const char *chain, const char *table
 	if (linenumbers)
 		format |= FMT_LINENUMBERS;
 
+	if (!counters)
+		format |= FMT_NOCOUNTS;
+
 	return nft_rule_list(h, chain, table, rule_nr, format);
 }
 
@@ -1179,7 +1180,8 @@ check_extension: */
 				 flags&OPT_VERBOSE,
 				 flags&OPT_NUMERIC,
 				 /*flags&OPT_EXPANDED*/0,
-				 flags&LIST_N);
+				 flags&LIST_N,
+				 flags & LIST_C);
 		if (!(flags & OPT_ZERO) && exec_style == EXEC_STYLE_PRG)
 			exit(0);
 	}

