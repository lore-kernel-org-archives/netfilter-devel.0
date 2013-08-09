From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 16/16] xtables: Support -Z options for a given rule number
Date: Fri,  9 Aug 2013 16:31:30 +0300
Message-ID: <1376055090-26551-17-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64381 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967822Ab3HINcF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:32:05 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for such command:
xtbles-multi xtables -Z foo 4

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 946f04d..dae2500 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1194,8 +1194,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 		ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_ZERO_NUM:
-		/* FIXME */
-//		ret = iptc_zero_counter(chain, rulenum, *handle);
+		ret = nft_rule_zero_counters(h, chain, *table, rulenum - 1);
 		break;
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
@@ -1208,9 +1207,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 				   cs.options&OPT_LINENUMBERS);
 		if (ret && (command & CMD_ZERO))
 			ret = nft_chain_zero_counters(h, chain, *table);
-		/* FIXME */
-/*		if (ret && (command & CMD_ZERO_NUM))
-			ret = iptc_zero_counter(chain, rulenum, *handle); */
+		if (ret && (command & CMD_ZERO_NUM))
+			ret = nft_rule_zero_counters(h, chain,
+							*table, rulenum - 1);
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
@@ -1218,9 +1217,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 		ret = list_rules(h, chain, *table, rulenum, cs.options&OPT_VERBOSE);
 		if (ret && (command & CMD_ZERO))
 			ret = nft_chain_zero_counters(h, chain, *table);
-		/* FIXME */
-/*		if (ret && (command & CMD_ZERO_NUM))
-			ret = iptc_zero_counter(chain, rulenum, *handle); */
+		if (ret && (command & CMD_ZERO_NUM))
+			ret = nft_rule_zero_counters(h, chain,
+							*table, rulenum - 1);
 		break;
 	case CMD_NEW_CHAIN:
 		ret = nft_chain_user_add(h, chain, *table);
-- 
1.8.3.2

