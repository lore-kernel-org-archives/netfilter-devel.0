From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb:
 user-defined chains default policy is always RETURN
Date: Wed, 19 Nov 2014 14:11:47 +0100
Message-ID: <20141119131147.15524.18916.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35103 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752741AbaKSNL7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:11:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The RETURN default policy is mandatory in user-defined chains.
Builtin chains must have one of ACCEPT or DROP.

So, with this patch, ebtables-compat ends with:

Command:			Result:

-L				Always RETURN for user-defined chains
-P builtin RETURN		Policy RETURN only allowed for user defined chains
-P builtin ACCEPT|DROP		ok
-P userdefined RETURN		Default policy in user-defined chains is RETURN
-P userdefined ACCEPT|DROP	Default policy in user-defined chains is RETURN
-N userdefined			ok
-N userdefined -P RETURN	Default policy in user-defined chains is RETURN
-N userdefined -P ACCEPT|DROP	Default policy in user-defined chains is RETURN

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |    3 ++-
 iptables/xtables-eb.c |   13 +++++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index b5aec00..a1bd906 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -356,7 +356,8 @@ static void nft_bridge_print_header(unsigned int format, const char *chain,
 				    const struct xt_counters *counters,
 				    bool basechain, uint32_t refs)
 {
-	printf("Bridge chain: %s, entries: %u, policy: %s\n", chain, refs, pol);
+	printf("Bridge chain: %s, entries: %u, policy: %s\n",
+	       chain, refs, basechain ? pol : "RETURN");
 }
 
 static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 917bca2..0775ee7 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -616,6 +616,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 		case 'E': /* Rename chain */
 		case 'X': /* Delete chain */
 			/* We allow -N chainname -P policy */
+			/* XXX: Not in ebtables-compat */
 			if (command == 'N' && c == 'P') {
 				command = c;
 				optind--; /* No table specified */
@@ -1146,9 +1147,17 @@ check_extension: */
 	cs.fw.ethproto = htons(cs.fw.ethproto);
 
 	if (command == 'P') {
-		if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, "RETURN")==0)
+		if (selected_chain < 0) {
 			xtables_error(PARAMETER_PROBLEM,
-				      "Policy RETURN only allowed for user defined chains");
+				      "Default policy in user-defined"
+				      " chains is mandatory RETURN");
+		}
+		if (strcmp(policy, "ACCEPT") != 0 &&
+		    strcmp(policy, "DROP") != 0) {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Default policy in default chains"
+				      " is either ACCEPT or DROP");
+		}
 		ret = nft_chain_set(h, *table, chain, policy, NULL);
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy");

