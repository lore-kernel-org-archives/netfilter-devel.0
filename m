From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb: adjust
 policy in user-defined chains
Date: Mon, 17 Nov 2014 13:36:23 +0100
Message-ID: <20141117123622.11349.43033.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57799 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751813AbaKQMge (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:36:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ebtables-compat tool doesn't support default policy in custom chains.
RETURN is the default policy in this case, and is mandatory (this is the
behaviour of nf_tables).

While at it, fix the error message when trying to change the default policy to
RETURN in builtin chains to match the original ebtables message.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |    7 ++++++-
 iptables/xtables-eb.c |   19 ++++++++++++-------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index b5aec00..dc26bfd 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -356,7 +356,12 @@ static void nft_bridge_print_header(unsigned int format, const char *chain,
 				    const struct xt_counters *counters,
 				    bool basechain, uint32_t refs)
 {
-	printf("Bridge chain: %s, entries: %u, policy: %s\n", chain, refs, pol);
+	if (basechain)
+		printf("Bridge chain: %s, entries: %u, policy: %s\n",
+		       chain, refs, pol);
+	else
+		printf("Bridge chain: %s, entries: %u, policy: RETURN\n",
+		       chain, refs);
 }
 
 static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 917bca2..bf9f264 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -615,11 +615,10 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 		case 'N': /* Make a user defined chain */
 		case 'E': /* Rename chain */
 		case 'X': /* Delete chain */
-			/* We allow -N chainname -P policy */
 			if (command == 'N' && c == 'P') {
-				command = c;
-				optind--; /* No table specified */
-				goto handle_P;
+				xtables_error(PARAMETER_PROBLEM,
+					      "The default policy in user-defined"
+					      " chains is RETURN (mandatory)");
 			}
 			if (OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
@@ -663,7 +662,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 					optind++;
 				}
 			} else if (c == 'P') {
-handle_P:
 				if (optind >= argc)
 					xtables_error(PARAMETER_PROBLEM,
 						      "No policy specified");
@@ -1146,9 +1144,16 @@ check_extension: */
 	cs.fw.ethproto = htons(cs.fw.ethproto);
 
 	if (command == 'P') {
-		if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, "RETURN")==0)
+		if (selected_chain < 0) {
 			xtables_error(PARAMETER_PROBLEM,
-				      "Policy RETURN only allowed for user defined chains");
+				      "Default policy in user-defined chains "
+				      "is mandatory RETURN");
+		}
+		if (strcmp(policy, "RETURN") == 0) {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Policy RETURN only allowed for user "
+				      "defined chains");
+		}
 		ret = nft_chain_set(h, *table, chain, policy, NULL);
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy");

