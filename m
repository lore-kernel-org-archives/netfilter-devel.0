From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental5 PATCH v2] iptables: xtables-eb:
 user-defined chains default policy is always RETURN
Date: Mon, 24 Nov 2014 10:52:04 +0100
Message-ID: <20141124095149.17111.54015.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54701 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbaKXJwW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:52:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The RETURN default policy is mandatory in user-defined chains.
Builtin chains must have one of ACCEPT or DROP.

So, with this patch, ebtables-compat ends with:

Command:			Result:

-L				Always RETURN for user-defined chains
-P builtin RETURN		Policy RETURN only allowed for user defined chains
-P builtin ACCEPT|DROP		ok
-P userdefined RETURN		Default policy in user-defined chains is mandatory RETURN
-P userdefined ACCEPT|DROP	Default policy in user-defined chains is mandatory RETURN
-N userdefined			ok
-N userdefined -P RETURN	Default policy in user-defined chains is mandatory RETURN
-N userdefined -P ACCEPT|DROP	Default policy in user-defined chains is mandatory RETURN

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: change some error messages, as requested by Pablo.

 iptables/nft-bridge.c |    3 ++-
 iptables/xtables-eb.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

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
index 917bca2..e462dbf 100644
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
@@ -1146,9 +1147,15 @@ check_extension: */
 	cs.fw.ethproto = htons(cs.fw.ethproto);
 
 	if (command == 'P') {
-		if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, "RETURN")==0)
+		if (selected_chain < 0) {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Default policy in user-defined"
+				      " chains is mandatory RETURN");
+		}
+		if (strcmp(policy, "RETURN") == 0) {
 			xtables_error(PARAMETER_PROBLEM,
 				      "Policy RETURN only allowed for user defined chains");
+		}
 		ret = nft_chain_set(h, *table, chain, policy, NULL);
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy");

