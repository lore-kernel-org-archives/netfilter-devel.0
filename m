From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 5/5] nft: Add a function to reset the counters of an existing rule
Date: Mon, 19 Aug 2013 15:04:06 +0300
Message-ID: <1376913846-15996-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab3HSMES (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:04:18 -0400
In-Reply-To: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we parse properly, in one place and at once, the rule back into a
command structure, it's now easier to reset its counters from that command
structure which we can pass again to nft_rule_append. (Thus the rule will
be replaced since we provide it's handle.)

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c     | 35 +++++++++++++++++++++++++++++++++++
 iptables/nft.h     |  1 +
 iptables/xtables.c | 15 +++++++--------
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index c9d9e40..abfe345 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2098,6 +2098,41 @@ err:
 	return ret;
 }
 
+int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
+			   const char *table, int rulenum)
+{
+	struct iptables_command_state cs = {};
+	struct nft_rule_list *list;
+	struct nft_rule *r;
+	int ret = 0;
+
+	nft_fn = nft_rule_delete;
+
+	list = nft_rule_list_create(h);
+	if (list == NULL)
+		return 0;
+
+	r = nft_rule_find(list, chain, table, NULL, rulenum);
+	if (r == NULL) {
+		errno = ENOENT;
+		ret = 1;
+
+		goto error;
+	}
+
+	nft_rule_to_iptables_command_state(r, &cs);
+
+	cs.counters.pcnt = cs.counters.bcnt = 0;
+
+	ret =  nft_rule_append(h, chain, table, &cs,
+			nft_rule_attr_get_u64(r, NFT_RULE_ATTR_HANDLE), false);
+
+error:
+	nft_rule_list_destroy(list);
+
+	return ret;
+}
+
 static int nft_action(struct nft_handle *h, int type)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/iptables/nft.h b/iptables/nft.h
index 006c031..fe1b9c8 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -81,6 +81,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table, in
 int nft_rule_list_save(struct nft_handle *h, const char *chain, const char *table, int rulenum, int counters);
 int nft_rule_save(struct nft_handle *h, const char *table, bool counters);
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table);
+int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *table, int rulenum);
 
 enum nft_rule_print {
 	NFT_RULE_APPEND,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 3e6092f..f47f9df 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1173,8 +1173,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 		ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_ZERO_NUM:
-		/* FIXME */
-//		ret = iptc_zero_counter(chain, rulenum, *handle);
+		ret = nft_rule_zero_counters(h, chain, *table, rulenum - 1);
 		break;
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
@@ -1187,9 +1186,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
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
@@ -1197,9 +1196,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
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

