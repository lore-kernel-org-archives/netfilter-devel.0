From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  17/17] xtables: Support -Z options for a given rule number
Date: Thu, 25 Jul 2013 20:16:37 +0300
Message-ID: <1374772597-20548-18-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13363 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab3GYRRH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:17:07 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for such command:
xtbles-multi xtables -Z foo 4

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 7a6509a..748dc42 100644
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

