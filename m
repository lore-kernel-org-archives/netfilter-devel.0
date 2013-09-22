From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH 1/2] xtables: arp: add delete operation
Date: Sun, 22 Sep 2013 10:18:55 +0200
Message-ID: <1379837936-2813-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:38174 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3IVITM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:19:12 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so1083320eae.37
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2013 01:19:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch permit to delete the rules specifying
an entry or a rule number.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/xtables-arp.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 8dfdf63..4537a58 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -911,6 +911,30 @@ replace_entry(const char *chain,
 	return nft_rule_replace(h, chain, table, fw, rulenum, verbose);
 }
 
+static int
+delete_entry(const char *chain,
+	     const char *table,
+	     struct arpt_entry *fw,
+	     unsigned int nsaddrs,
+	     const struct in_addr saddrs[],
+	     unsigned int ndaddrs,
+	     const struct in_addr daddrs[],
+	     bool verbose, struct nft_handle *h)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < nsaddrs; i++) {
+		fw->arp.src.s_addr = saddrs[i].s_addr;
+		for (j = 0; j < ndaddrs; j++) {
+			fw->arp.tgt.s_addr = daddrs[j].s_addr;
+			ret = nft_rule_delete(h, chain, table, fw, verbose);
+		}
+	}
+
+	return ret;
+}
+
 int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 {
 	struct arpt_entry fw, *e = NULL;
@@ -1402,13 +1426,12 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 				   options&OPT_VERBOSE, true);
 		break;
 	case CMD_DELETE:
-		/*ret = delete_entry(chain, e,
-					nsaddrs, saddrs, ndaddrs, daddrs,
-					options&OPT_VERBOSE,
-					handle);*/
+		ret = delete_entry(chain, *table, e,
+				   nsaddrs, saddrs, ndaddrs, daddrs,
+				   options&OPT_VERBOSE, h);
 		break;
 	case CMD_DELETE_NUM:
-		/*ret = arptc_delete_num_entry(chain, rulenum - 1, handle);*/
+		ret = nft_rule_delete_num(h, chain, *table, rulenum - 1, verbose);
 		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, *table, e, rulenum - 1,
-- 
1.7.8.6

