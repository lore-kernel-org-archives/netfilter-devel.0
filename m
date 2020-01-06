Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8F5C33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 288492072E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgAFMUm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:20:42 -0500
Received: from correo.us.es ([193.147.175.20]:43740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgAFMUl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 07:20:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35549F2DFE
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FAD5DA707
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 61FD5DA720; Mon,  6 Jan 2020 13:20:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAF27DA705;
        Mon,  6 Jan 2020 13:20:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 13:20:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A832641E4800;
        Mon,  6 Jan 2020 13:20:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 2/7] nft: split parsing from netlink commands
Date:   Mon,  6 Jan 2020 13:20:13 +0100
Message-Id: <20200106122018.14090-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200106122018.14090-1-pablo@netfilter.org>
References: <20200106122018.14090-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch updates the parser to generate a list of command objects.
This list of commands is then transformed to a list of netlink jobs.
This new command object stores the rule using the nftnl representation
via nft_rule_new().

To reduce the number of updates in this patch, the nft_*_rule_find()
functions have been updated to restore the native representation to
skip the update of the rule comparison code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/Makefile.am       |   2 +-
 iptables/nft-arp.c         |   5 +-
 iptables/nft-bridge.c      |   5 +-
 iptables/nft-cmd.c         | 315 +++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-cmd.h         |  78 +++++++++++
 iptables/nft-shared.c      |   6 +-
 iptables/nft-shared.h      |   4 +-
 iptables/nft.c             | 259 +++++++++++++++++++++++++++----------
 iptables/nft.h             |  41 +++++-
 iptables/xtables-arp.c     |  26 ++--
 iptables/xtables-eb.c      |  26 ++--
 iptables/xtables-restore.c |  32 ++---
 iptables/xtables.c         |  52 ++++----
 13 files changed, 702 insertions(+), 149 deletions(-)
 create mode 100644 iptables/nft-cmd.c
 create mode 100644 iptables/nft-cmd.h

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 71b1b1d48d4b..dc66b3cc09c0 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -38,7 +38,7 @@ xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
 				xtables-monitor.c nft-cache.c \
 				xtables-arp-standalone.c xtables-arp.c \
-				nft-bridge.c \
+				nft-bridge.c nft-cmd.c \
 				xtables-eb-standalone.c xtables-eb.c \
 				xtables-eb-translate.c \
 				xtables-translate.c
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index d4a86610ec21..748784bc4904 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -634,14 +634,15 @@ static bool nft_arp_is_same(const void *data_a,
 }
 
 static bool nft_arp_rule_find(struct nft_handle *h, struct nftnl_rule *r,
-			      void *data)
+			      struct nftnl_rule *rule)
 {
-	const struct iptables_command_state *cs = data;
+	struct iptables_command_state _cs = {}, *cs = &_cs;
 	struct iptables_command_state this = {};
 	bool ret = false;
 
 	/* Delete by matching rule case */
 	nft_rule_to_iptables_command_state(h, r, &this);
+	nft_rule_to_iptables_command_state(h, rule, cs);
 
 	if (!nft_arp_is_same(&cs->arp, &this.arp))
 		goto out;
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 3f85cbbf5e4c..a5aaa3f87187 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -748,13 +748,14 @@ static bool nft_bridge_is_same(const void *data_a, const void *data_b)
 }
 
 static bool nft_bridge_rule_find(struct nft_handle *h, struct nftnl_rule *r,
-				 void *data)
+				 struct nftnl_rule *rule)
 {
-	struct iptables_command_state *cs = data;
+	struct iptables_command_state _cs = {}, *cs = &_cs;
 	struct iptables_command_state this = {};
 	bool ret = false;
 
 	nft_rule_to_ebtables_command_state(h, r, &this);
+	nft_rule_to_ebtables_command_state(h, rule, cs);
 
 	DEBUGP("comparing with... ");
 
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
new file mode 100644
index 000000000000..dd6672ee8015
--- /dev/null
+++ b/iptables/nft-cmd.c
@@ -0,0 +1,315 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <stdlib.h>
+#include <string.h>
+#include "nft.h"
+#include "nft-cmd.h"
+
+struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
+			    const char *table, const char *chain,
+			    struct iptables_command_state *state,
+			    int rulenum, bool verbose)
+{
+	struct nftnl_rule *rule;
+	struct nft_cmd *cmd;
+
+	cmd = calloc(1, sizeof(struct nft_cmd));
+	if (!cmd)
+		return NULL;
+
+	cmd->command = command;
+	cmd->table = strdup(table);
+	if (chain)
+		cmd->chain = strdup(chain);
+	cmd->rulenum = rulenum;
+	cmd->verbose = verbose;
+
+	if (state) {
+		rule = nft_rule_new(h, chain, table, state);
+		if (!rule)
+			return NULL;
+
+		cmd->obj.rule = rule;
+	}
+
+	list_add_tail(&cmd->head, &h->cmd_list);
+
+	return cmd;
+}
+
+void nft_cmd_free(struct nft_cmd *cmd)
+{
+	free((void *)cmd->table);
+	free((void *)cmd->chain);
+	free((void *)cmd->policy);
+	free((void *)cmd->rename);
+
+	/* cmd->obj.rule not released here. */
+
+	list_del(&cmd->head);
+	free(cmd);
+}
+
+int nft_cmd_rule_append(struct nft_handle *h, const char *chain,
+			const char *table, struct iptables_command_state *state,
+			void *ref, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_APPEND, table, chain, state, -1,
+			  verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_rule_insert(struct nft_handle *h, const char *chain,
+			const char *table, struct iptables_command_state *state,
+			int rulenum, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_INSERT, table, chain, state,
+			  rulenum, verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_rule_delete(struct nft_handle *h, const char *chain,
+			const char *table, struct iptables_command_state *state,
+			bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_DELETE, table, chain, state,
+			  -1, verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_rule_delete_num(struct nft_handle *h, const char *chain,
+			    const char *table, int rulenum, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_DELETE, table, chain, NULL,
+			  rulenum, verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_rule_flush(struct nft_handle *h, const char *chain,
+		       const char *table, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_FLUSH, table, chain, NULL, -1,
+			  verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_chain_zero_counters(struct nft_handle *h, const char *chain,
+				const char *table, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_ZERO, table, chain, NULL, -1,
+			  verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_chain_user_add(struct nft_handle *h, const char *chain,
+			   const char *table)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_USER_ADD, table, chain, NULL, -1,
+			  false);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_chain_user_del(struct nft_handle *h, const char *chain,
+			   const char *table, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_USER_DEL, table, chain, NULL, -1,
+			  verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_chain_user_rename(struct nft_handle *h,const char *chain,
+			      const char *table, const char *newname)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_RENAME, table, chain, NULL, -1,
+			  false);
+	if (!cmd)
+		return 0;
+
+	cmd->rename = strdup(newname);
+
+	return 1;
+}
+
+int nft_cmd_rule_list(struct nft_handle *h, const char *chain,
+		      const char *table, int rulenum, unsigned int format)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_LIST, table, chain, NULL, rulenum,
+			  false);
+	if (!cmd)
+		return 0;
+
+	cmd->format = format;
+
+	return 1;
+}
+
+int nft_cmd_rule_replace(struct nft_handle *h, const char *chain,
+			 const char *table, void *data, int rulenum,
+			 bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_REPLACE, table, chain, data,
+			  rulenum, verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_rule_check(struct nft_handle *h, const char *chain,
+		       const char *table, void *data, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_CHECK, table, chain, data, -1,
+			  verbose);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_chain_set(struct nft_handle *h, const char *table,
+		      const char *chain, const char *policy,
+		      const struct xt_counters *counters)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_UPDATE, table, chain, NULL, -1,
+			  false);
+	if (!cmd)
+		return 0;
+
+	cmd->policy = strdup(policy);
+	if (counters)
+		cmd->counters = *counters;
+
+	return 1;
+}
+
+int nft_cmd_table_flush(struct nft_handle *h, const char *table)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_TABLE_FLUSH, table, NULL, NULL, -1,
+			  false);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_chain_restore(struct nft_handle *h, const char *chain,
+			  const char *table)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_RESTORE, table, chain, NULL, -1,
+			  false);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_rule_zero_counters(struct nft_handle *h, const char *chain,
+			       const char *table, int rulenum)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_ZERO, table, chain, NULL, rulenum,
+			  false);
+	if (!cmd)
+		return 0;
+
+	return 1;
+}
+
+int nft_cmd_rule_list_save(struct nft_handle *h, const char *chain,
+			   const char *table, int rulenum, int counters)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_SAVE, table, chain, NULL, rulenum,
+			  false);
+	if (!cmd)
+		return 0;
+
+	cmd->counters_save = counters;
+
+	return 1;
+}
+
+int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
+                              const char *chain, const char *policy)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE, table, chain,
+			  NULL, -1, false);
+	if (!cmd)
+		return 0;
+
+	cmd->policy = strdup(policy);
+
+	return 1;
+}
+
+void nft_cmd_table_new(struct nft_handle *h, const char *table)
+{
+	nft_cmd_new(h, NFT_COMPAT_TABLE_NEW, table, NULL, NULL, -1, false);
+}
diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
new file mode 100644
index 000000000000..3b928af3893c
--- /dev/null
+++ b/iptables/nft-cmd.h
@@ -0,0 +1,78 @@
+#ifndef _NFT_CMD_H_
+#define _NFT_CMD_H_
+
+#include <libiptc/linux_list.h>
+#include <stdbool.h>
+#include "nft.h"
+
+struct nftnl_rule;
+
+struct nft_cmd {
+	struct list_head		head;
+	int				command;
+	const char			*table;
+	const char			*chain;
+	struct iptables_command_state	state;
+	int				rulenum;
+	bool				verbose;
+	unsigned int			format;
+	struct {
+		struct nftnl_rule	*rule;
+	} obj;
+	const char			*policy;
+	struct xt_counters		counters;
+	const char			*rename;
+	int				counters_save;
+};
+
+struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
+			    const char *table, const char *chain,
+			    struct iptables_command_state *state,
+			    int rulenum, bool verbose);
+void nft_cmd_free(struct nft_cmd *cmd);
+
+int nft_cmd_rule_append(struct nft_handle *h, const char *chain,
+			const char *table, struct iptables_command_state *state,
+                        void *ref, bool verbose);
+int nft_cmd_rule_insert(struct nft_handle *h, const char *chain,
+			const char *table, struct iptables_command_state *state,
+			int rulenum, bool verbose);
+int nft_cmd_rule_delete(struct nft_handle *h, const char *chain,
+                        const char *table, struct iptables_command_state *state,
+			bool verbose);
+int nft_cmd_rule_delete_num(struct nft_handle *h, const char *chain,
+			    const char *table, int rulenum, bool verbose);
+int nft_cmd_rule_flush(struct nft_handle *h, const char *chain,
+		       const char *table, bool verbose);
+int nft_cmd_zero_counters(struct nft_handle *h, const char *chain,
+			  const char *table, bool verbose);
+int nft_cmd_chain_user_add(struct nft_handle *h, const char *chain,
+			   const char *table);
+int nft_cmd_chain_user_del(struct nft_handle *h, const char *chain,
+			   const char *table, bool verbose);
+int nft_cmd_chain_zero_counters(struct nft_handle *h, const char *chain,
+				const char *table, bool verbose);
+int nft_cmd_rule_list(struct nft_handle *h, const char *chain,
+		      const char *table, int rulenum, unsigned int format);
+int nft_cmd_rule_check(struct nft_handle *h, const char *chain,
+                       const char *table, void *data, bool verbose);
+int nft_cmd_chain_set(struct nft_handle *h, const char *table,
+		      const char *chain, const char *policy,
+		      const struct xt_counters *counters);
+int nft_cmd_chain_user_rename(struct nft_handle *h,const char *chain,
+			      const char *table, const char *newname);
+int nft_cmd_rule_replace(struct nft_handle *h, const char *chain,
+			 const char *table, void *data, int rulenum,
+			 bool verbose);
+int nft_cmd_table_flush(struct nft_handle *h, const char *table);
+int nft_cmd_chain_restore(struct nft_handle *h, const char *chain,
+			  const char *table);
+int nft_cmd_rule_zero_counters(struct nft_handle *h, const char *chain,
+			       const char *table, int rulenum);
+int nft_cmd_rule_list_save(struct nft_handle *h, const char *chain,
+			   const char *table, int rulenum, int counters);
+int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
+			      const char *chain, const char *policy);
+void nft_cmd_table_new(struct nft_handle *h, const char *table);
+
+#endif /* _NFT_CMD_H_ */
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 426765641cff..0a2a53f8198a 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -989,12 +989,14 @@ void nft_ipv46_parse_target(struct xtables_target *t, void *data)
 	cs->target = t;
 }
 
-bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r, void *data)
+bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r,
+			 struct nftnl_rule *rule)
 {
-	struct iptables_command_state *cs = data, this = {};
+	struct iptables_command_state _cs = {}, this = {}, *cs = &_cs;
 	bool ret = false;
 
 	nft_rule_to_iptables_command_state(h, r, &this);
+	nft_rule_to_iptables_command_state(h, rule, cs);
 
 	DEBUGP("comparing with... ");
 #ifdef DEBUG_DEL
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index bee99a7dd0c9..89e9d0b9be33 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -110,7 +110,7 @@ struct nft_family_ops {
 			   struct iptables_command_state *cs);
 	void (*clear_cs)(struct iptables_command_state *cs);
 	bool (*rule_find)(struct nft_handle *h, struct nftnl_rule *r,
-			  void *data);
+			  struct nftnl_rule *rule);
 	int (*xlate)(const void *data, struct xt_xlate *xl);
 };
 
@@ -172,7 +172,7 @@ struct nft_family_ops *nft_family_ops_lookup(int family);
 
 void nft_ipv46_parse_target(struct xtables_target *t, void *data);
 bool nft_ipv46_rule_find(struct nft_handle *h, struct nftnl_rule *r,
-			 void *data);
+			 struct nftnl_rule *rule);
 
 bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
diff --git a/iptables/nft.c b/iptables/nft.c
index 3f2a62ae12c0..0c450b26c06e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -256,24 +256,6 @@ static int mnl_batch_talk(struct nft_handle *h, int numcmds)
 	return err;
 }
 
-enum obj_update_type {
-	NFT_COMPAT_TABLE_ADD,
-	NFT_COMPAT_TABLE_FLUSH,
-	NFT_COMPAT_CHAIN_ADD,
-	NFT_COMPAT_CHAIN_USER_ADD,
-	NFT_COMPAT_CHAIN_USER_DEL,
-	NFT_COMPAT_CHAIN_USER_FLUSH,
-	NFT_COMPAT_CHAIN_UPDATE,
-	NFT_COMPAT_CHAIN_RENAME,
-	NFT_COMPAT_CHAIN_ZERO,
-	NFT_COMPAT_RULE_APPEND,
-	NFT_COMPAT_RULE_INSERT,
-	NFT_COMPAT_RULE_REPLACE,
-	NFT_COMPAT_RULE_DELETE,
-	NFT_COMPAT_RULE_FLUSH,
-	NFT_COMPAT_SET_ADD,
-};
-
 enum obj_action {
 	NFT_COMPAT_COMMIT,
 	NFT_COMPAT_ABORT,
@@ -362,6 +344,15 @@ static int mnl_append_error(const struct nft_handle *h,
 		snprintf(tcr, sizeof(tcr), "set %s",
 			 nftnl_set_get_str(o->set, NFTNL_SET_NAME));
 		break;
+	case NFT_COMPAT_RULE_LIST:
+	case NFT_COMPAT_RULE_CHECK:
+	case NFT_COMPAT_CHAIN_RESTORE:
+	case NFT_COMPAT_RULE_SAVE:
+	case NFT_COMPAT_RULE_ZERO:
+	case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
+	case NFT_COMPAT_TABLE_NEW:
+		assert(0);
+		break;
 	}
 
 	return snprintf(buf, len, "%s: %s", errmsg, tcr);
@@ -806,12 +797,18 @@ int nft_init(struct nft_handle *h, const struct builtin_table *t)
 
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
+	INIT_LIST_HEAD(&h->cmd_list);
 
 	return 0;
 }
 
 void nft_fini(struct nft_handle *h)
 {
+	struct nft_cmd *cmd, *next;
+
+	list_for_each_entry_safe(cmd, next, &h->cmd_list, head)
+		nft_cmd_free(cmd);
+
 	flush_chain_cache(h, NULL);
 	mnl_socket_close(h->nl);
 }
@@ -1302,7 +1299,7 @@ void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv)
 			      inv ? NFT_RULE_COMPAT_F_INV : 0);
 }
 
-static struct nftnl_rule *
+struct nftnl_rule *
 nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 	     void *data)
 {
@@ -1330,10 +1327,9 @@ nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
 
 int
 nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
-		void *data, struct nftnl_rule *ref, bool verbose)
+		struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose)
 {
 	struct nftnl_chain *c;
-	struct nftnl_rule *r;
 	int type;
 
 	nft_xt_builtin_init(h, table);
@@ -1348,10 +1344,6 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_fn = nft_rule_append;
 
-	r = nft_rule_new(h, chain, table, data);
-	if (r == NULL)
-		return 0;
-
 	if (ref) {
 		nftnl_rule_set_u64(r, NFTNL_RULE_HANDLE,
 				   nftnl_rule_get_u64(ref, NFTNL_RULE_HANDLE));
@@ -1359,10 +1351,8 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	} else
 		type = NFT_COMPAT_RULE_APPEND;
 
-	if (batch_rule_add(h, type, r) == NULL) {
-		nftnl_rule_free(r);
+	if (batch_rule_add(h, type, r) == NULL)
 		return 0;
-	}
 
 	if (verbose)
 		h->ops->print_rule(h, r, 0, FMT_PRINT_RULE);
@@ -1722,7 +1712,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	} else {
 		c = nftnl_chain_alloc();
 		if (!c)
-			return -1;
+			return 0;
 
 		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
 		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
@@ -1733,7 +1723,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, NF_ACCEPT);
 
 	if (!created)
-		return 0;
+		return 1;
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
@@ -1741,7 +1731,8 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	if (list)
 		nftnl_chain_list_add(c, list);
 
-	return ret;
+	/* the core expects 1 for success and 0 for error */
+	return ret == 0 ? 1 : 0;
 }
 
 /* From linux/netlink.h */
@@ -2048,7 +2039,8 @@ static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule *r)
 }
 
 static struct nftnl_rule *
-nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulenum)
+nft_rule_find(struct nft_handle *h, struct nftnl_chain *c,
+	      struct nftnl_rule *rule, int rulenum)
 {
 	struct nftnl_rule *r;
 	struct nftnl_rule_iter *iter;
@@ -2066,7 +2058,7 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		found = h->ops->rule_find(h, r, data);
+		found = h->ops->rule_find(h, r, rule);
 		if (found)
 			break;
 		r = nftnl_rule_iter_next(iter);
@@ -2078,7 +2070,7 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 }
 
 int nft_rule_check(struct nft_handle *h, const char *chain,
-		   const char *table, void *data, bool verbose)
+		   const char *table, struct nftnl_rule *rule, bool verbose)
 {
 	struct nftnl_chain *c;
 	struct nftnl_rule *r;
@@ -2089,7 +2081,7 @@ int nft_rule_check(struct nft_handle *h, const char *chain,
 	if (!c)
 		goto fail_enoent;
 
-	r = nft_rule_find(h, c, data, -1);
+	r = nft_rule_find(h, c, rule, -1);
 	if (r == NULL)
 		goto fail_enoent;
 
@@ -2103,7 +2095,7 @@ fail_enoent:
 }
 
 int nft_rule_delete(struct nft_handle *h, const char *chain,
-		    const char *table, void *data, bool verbose)
+		    const char *table, struct nftnl_rule *rule, bool verbose)
 {
 	int ret = 0;
 	struct nftnl_chain *c;
@@ -2117,7 +2109,7 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 		return 0;
 	}
 
-	r = nft_rule_find(h, c, data, -1);
+	r = nft_rule_find(h, c, rule, -1);
 	if (r != NULL) {
 		ret =__nft_rule_del(h, r);
 		if (ret < 0)
@@ -2132,16 +2124,11 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 
 static struct nftnl_rule *
 nft_rule_add(struct nft_handle *h, const char *chain,
-	     const char *table, struct iptables_command_state *cs,
+	     const char *table, struct nftnl_rule *r,
 	     struct nftnl_rule *ref, bool verbose)
 {
-	struct nftnl_rule *r;
 	uint64_t ref_id;
 
-	r = nft_rule_new(h, chain, table, cs);
-	if (r == NULL)
-		return NULL;
-
 	if (ref) {
 		ref_id = nftnl_rule_get_u64(ref, NFTNL_RULE_HANDLE);
 		if (ref_id > 0) {
@@ -2158,10 +2145,8 @@ nft_rule_add(struct nft_handle *h, const char *chain,
 		}
 	}
 
-	if (!batch_rule_add(h, NFT_COMPAT_RULE_INSERT, r)) {
-		nftnl_rule_free(r);
+	if (!batch_rule_add(h, NFT_COMPAT_RULE_INSERT, r))
 		return NULL;
-	}
 
 	if (verbose)
 		h->ops->print_rule(h, r, 0, FMT_PRINT_RULE);
@@ -2170,9 +2155,10 @@ nft_rule_add(struct nft_handle *h, const char *chain,
 }
 
 int nft_rule_insert(struct nft_handle *h, const char *chain,
-		    const char *table, void *data, int rulenum, bool verbose)
+		    const char *table, struct nftnl_rule *new_rule, int rulenum,
+		    bool verbose)
 {
-	struct nftnl_rule *r = NULL, *new_rule;
+	struct nftnl_rule *r = NULL;
 	struct nftnl_chain *c;
 
 	nft_xt_builtin_init(h, table);
@@ -2186,22 +2172,22 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	}
 
 	if (rulenum > 0) {
-		r = nft_rule_find(h, c, data, rulenum);
+		r = nft_rule_find(h, c, new_rule, rulenum);
 		if (r == NULL) {
 			/* special case: iptables allows to insert into
 			 * rule_count + 1 position.
 			 */
-			r = nft_rule_find(h, c, data, rulenum - 1);
+			r = nft_rule_find(h, c, new_rule, rulenum - 1);
 			if (r != NULL)
-				return nft_rule_append(h, chain, table, data,
-						       NULL, verbose);
+				return nft_rule_append(h, chain, table,
+						       new_rule, NULL, verbose);
 
 			errno = E2BIG;
 			goto err;
 		}
 	}
 
-	new_rule = nft_rule_add(h, chain, table, data, r, verbose);
+	new_rule = nft_rule_add(h, chain, table, new_rule, r, verbose);
 	if (!new_rule)
 		goto err;
 
@@ -2243,7 +2229,8 @@ int nft_rule_delete_num(struct nft_handle *h, const char *chain,
 }
 
 int nft_rule_replace(struct nft_handle *h, const char *chain,
-		     const char *table, void *data, int rulenum, bool verbose)
+		     const char *table, struct nftnl_rule *rule,
+		     int rulenum, bool verbose)
 {
 	int ret = 0;
 	struct nftnl_chain *c;
@@ -2257,13 +2244,13 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 		return 0;
 	}
 
-	r = nft_rule_find(h, c, data, rulenum);
+	r = nft_rule_find(h, c, rule, rulenum);
 	if (r != NULL) {
 		DEBUGP("replacing rule with handle=%llu\n",
 			(unsigned long long)
 			nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE));
 
-		ret = nft_rule_append(h, chain, table, data, r, verbose);
+		ret = nft_rule_append(h, chain, table, rule, r, verbose);
 	} else
 		errno = E2BIG;
 
@@ -2496,8 +2483,8 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 			   const char *table, int rulenum)
 {
 	struct iptables_command_state cs = {};
+	struct nftnl_rule *r, *new_rule;
 	struct nftnl_chain *c;
-	struct nftnl_rule *r;
 	int ret = 0;
 
 	nft_fn = nft_rule_delete;
@@ -2516,8 +2503,11 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 	nft_rule_to_iptables_command_state(h, r, &cs);
 
 	cs.counters.pcnt = cs.counters.bcnt = 0;
+	new_rule = nft_rule_new(h, chain, table, &cs);
+	if (!new_rule)
+		return 1;
 
-	ret =  nft_rule_append(h, chain, table, &cs, r, false);
+	ret = nft_rule_append(h, chain, table, new_rule, r, false);
 
 error:
 	return ret;
@@ -2619,6 +2609,15 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 	case NFT_COMPAT_SET_ADD:
 		nftnl_set_free(o->set);
 		break;
+	case NFT_COMPAT_RULE_LIST:
+	case NFT_COMPAT_RULE_CHECK:
+	case NFT_COMPAT_CHAIN_RESTORE:
+	case NFT_COMPAT_RULE_SAVE:
+	case NFT_COMPAT_RULE_ZERO:
+	case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
+	case NFT_COMPAT_TABLE_NEW:
+		assert(0);
+		break;
 	}
 	h->obj_list_num--;
 	list_del(&o->head);
@@ -2686,6 +2685,13 @@ static void nft_refresh_transaction(struct nft_handle *h)
 		case NFT_COMPAT_RULE_DELETE:
 		case NFT_COMPAT_RULE_FLUSH:
 		case NFT_COMPAT_SET_ADD:
+		case NFT_COMPAT_RULE_LIST:
+		case NFT_COMPAT_RULE_CHECK:
+		case NFT_COMPAT_CHAIN_RESTORE:
+		case NFT_COMPAT_RULE_SAVE:
+		case NFT_COMPAT_RULE_ZERO:
+		case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
+		case NFT_COMPAT_TABLE_NEW:
 			break;
 		}
 	}
@@ -2783,6 +2789,14 @@ retry:
 						     NLM_F_CREATE, &n->seq, n->set);
 			seq = n->seq;
 			break;
+		case NFT_COMPAT_RULE_LIST:
+		case NFT_COMPAT_RULE_CHECK:
+		case NFT_COMPAT_CHAIN_RESTORE:
+		case NFT_COMPAT_RULE_SAVE:
+		case NFT_COMPAT_RULE_ZERO:
+		case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
+		case NFT_COMPAT_TABLE_NEW:
+			assert(0);
 		}
 
 		mnl_nft_batch_continue(h->batch);
@@ -2945,39 +2959,152 @@ static void nft_bridge_commit_prepare(struct nft_handle *h)
 	}
 }
 
+static int nft_prepare(struct nft_handle *h)
+{
+	struct nft_cmd *cmd, *next;
+	int ret = 1;
+
+	list_for_each_entry_safe(cmd, next, &h->cmd_list, head) {
+		switch (cmd->command) {
+		case NFT_COMPAT_TABLE_FLUSH:
+			ret = nft_table_flush(h, cmd->table);
+			break;
+		case NFT_COMPAT_CHAIN_USER_ADD:
+			ret = nft_chain_user_add(h, cmd->chain, cmd->table);
+			break;
+		case NFT_COMPAT_CHAIN_USER_DEL:
+			ret = nft_chain_user_del(h, cmd->chain, cmd->table,
+						 cmd->verbose);
+			break;
+		case NFT_COMPAT_CHAIN_RESTORE:
+			ret = nft_chain_restore(h, cmd->chain, cmd->table);
+			break;
+		case NFT_COMPAT_CHAIN_UPDATE:
+			ret = nft_chain_set(h, cmd->table, cmd->chain,
+					    cmd->policy, &cmd->counters);
+			break;
+		case NFT_COMPAT_CHAIN_RENAME:
+			ret = nft_chain_user_rename(h, cmd->chain, cmd->table,
+						    cmd->rename);
+			break;
+		case NFT_COMPAT_CHAIN_ZERO:
+			ret = nft_chain_zero_counters(h, cmd->chain, cmd->table,
+						      cmd->verbose);
+			break;
+		case NFT_COMPAT_RULE_APPEND:
+			ret = nft_rule_append(h, cmd->chain, cmd->table,
+					      cmd->obj.rule, NULL, cmd->verbose);
+			break;
+		case NFT_COMPAT_RULE_INSERT:
+			ret = nft_rule_insert(h, cmd->chain, cmd->table,
+					      cmd->obj.rule, cmd->rulenum,
+					      cmd->verbose);
+			break;
+		case NFT_COMPAT_RULE_REPLACE:
+			ret = nft_rule_replace(h, cmd->chain, cmd->table,
+					      cmd->obj.rule, cmd->rulenum,
+					      cmd->verbose);
+			break;
+		case NFT_COMPAT_RULE_DELETE:
+			if (cmd->rulenum >= 0)
+				ret = nft_rule_delete_num(h, cmd->chain,
+							  cmd->table,
+							  cmd->rulenum,
+							  cmd->verbose);
+			else
+				ret = nft_rule_delete(h, cmd->chain, cmd->table,
+						      cmd->obj.rule, cmd->verbose);
+			break;
+		case NFT_COMPAT_RULE_FLUSH:
+			ret = nft_rule_flush(h, cmd->chain, cmd->table,
+					     cmd->verbose);
+			break;
+		case NFT_COMPAT_RULE_LIST:
+			ret = nft_rule_list(h, cmd->chain, cmd->table,
+					    cmd->rulenum, cmd->format);
+			break;
+		case NFT_COMPAT_RULE_CHECK:
+			ret = nft_rule_check(h, cmd->chain, cmd->table,
+					     cmd->obj.rule, cmd->rulenum);
+			break;
+		case NFT_COMPAT_RULE_ZERO:
+			ret = nft_rule_zero_counters(h, cmd->chain, cmd->table,
+                                                     cmd->rulenum);
+			break;
+		case NFT_COMPAT_RULE_SAVE:
+			ret = nft_rule_list_save(h, cmd->chain, cmd->table,
+						 cmd->rulenum,
+						 cmd->counters_save);
+			break;
+		case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
+			ret = ebt_set_user_chain_policy(h, cmd->table,
+							cmd->chain, cmd->policy);
+			break;
+		case NFT_COMPAT_TABLE_NEW:
+			nft_xt_builtin_init(h, cmd->table);
+			ret = 1;
+			break;
+		case NFT_COMPAT_TABLE_ADD:
+		case NFT_COMPAT_CHAIN_ADD:
+		case NFT_COMPAT_SET_ADD:
+			assert(0);
+			break;
+		}
+
+		nft_cmd_free(cmd);
+
+		if (ret == 0)
+			return 0;
+	}
+
+	return 1;
+}
+
 int nft_commit(struct nft_handle *h)
 {
+	if (!nft_prepare(h))
+		return 0;
+
 	return nft_action(h, NFT_COMPAT_COMMIT);
 }
 
 int nft_bridge_commit(struct nft_handle *h)
 {
+	if (!nft_prepare(h))
+		return 0;
+
 	nft_bridge_commit_prepare(h);
-	return nft_commit(h);
+
+	return nft_action(h, NFT_COMPAT_COMMIT);
 }
 
 int nft_abort(struct nft_handle *h)
 {
+	struct nft_cmd *cmd, *next;
+
+	list_for_each_entry_safe(cmd, next, &h->cmd_list, head)
+		nft_cmd_free(cmd);
+
 	return nft_action(h, NFT_COMPAT_ABORT);
 }
 
-int nft_abort_policy_rule(struct nft_handle *h, const char *table)
+int nft_cmd_abort_policy_rule(struct nft_handle *h, const char *table)
 {
-	struct obj_update *n, *tmp;
+	struct nft_cmd *n, *tmp;
 
 	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
-		if (n->type != NFT_COMPAT_RULE_APPEND &&
-		    n->type != NFT_COMPAT_RULE_DELETE)
+		if (n->command != NFT_COMPAT_RULE_APPEND &&
+		    n->command != NFT_COMPAT_RULE_DELETE)
 			continue;
 
 		if (strcmp(table,
-			   nftnl_rule_get_str(n->rule, NFTNL_RULE_TABLE)))
+			   nftnl_rule_get_str(n->obj.rule, NFTNL_RULE_TABLE)))
 			continue;
 
-		if (!nft_rule_is_policy_rule(n->rule))
+		if (!nft_rule_is_policy_rule(n->obj.rule))
 			continue;
 
-		batch_obj_del(h, n);
+		nft_cmd_free(n);
 	}
 	return 0;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 51b5660314c0..e98fe4db07f7 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -3,6 +3,8 @@
 
 #include "xshared.h"
 #include "nft-shared.h"
+#include "nft-cache.h"
+#include "nft-cmd.h"
 #include <libiptc/linux_list.h>
 
 enum nft_table_type {
@@ -44,6 +46,31 @@ struct nft_cache {
 	} table[NFT_TABLE_MAX];
 };
 
+enum obj_update_type {
+	NFT_COMPAT_TABLE_ADD,
+	NFT_COMPAT_TABLE_FLUSH,
+	NFT_COMPAT_CHAIN_ADD,
+	NFT_COMPAT_CHAIN_USER_ADD,
+	NFT_COMPAT_CHAIN_USER_DEL,
+	NFT_COMPAT_CHAIN_USER_FLUSH,
+	NFT_COMPAT_CHAIN_UPDATE,
+	NFT_COMPAT_CHAIN_RENAME,
+	NFT_COMPAT_CHAIN_ZERO,
+	NFT_COMPAT_RULE_APPEND,
+	NFT_COMPAT_RULE_INSERT,
+	NFT_COMPAT_RULE_REPLACE,
+	NFT_COMPAT_RULE_DELETE,
+	NFT_COMPAT_RULE_FLUSH,
+	NFT_COMPAT_SET_ADD,
+	NFT_COMPAT_RULE_LIST,
+	NFT_COMPAT_RULE_CHECK,
+	NFT_COMPAT_CHAIN_RESTORE,
+	NFT_COMPAT_RULE_SAVE,
+	NFT_COMPAT_RULE_ZERO,
+	NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE,
+	NFT_COMPAT_TABLE_NEW,
+};
+
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
@@ -66,6 +93,7 @@ struct nft_handle {
 	bool			restore;
 	bool			noflush;
 	int8_t			config_done;
+	struct list_head	cmd_list;
 
 	/* meta data, for error reporting */
 	struct {
@@ -120,12 +148,13 @@ void nft_bridge_chain_postprocess(struct nft_handle *h,
  */
 struct nftnl_rule;
 
-int nft_rule_append(struct nft_handle *h, const char *chain, const char *table, void *data, struct nftnl_rule *ref, bool verbose);
-int nft_rule_insert(struct nft_handle *h, const char *chain, const char *table, void *data, int rulenum, bool verbose);
-int nft_rule_check(struct nft_handle *h, const char *chain, const char *table, void *data, bool verbose);
-int nft_rule_delete(struct nft_handle *h, const char *chain, const char *table, void *data, bool verbose);
+struct nftnl_rule *nft_rule_new(struct nft_handle *h, const char *chain, const char *table, void *data);
+int nft_rule_append(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose);
+int nft_rule_insert(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, int rulenum, bool verbose);
+int nft_rule_check(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, bool verbose);
+int nft_rule_delete(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, bool verbose);
 int nft_rule_delete_num(struct nft_handle *h, const char *chain, const char *table, int rulenum, bool verbose);
-int nft_rule_replace(struct nft_handle *h, const char *chain, const char *table, void *data, int rulenum, bool verbose);
+int nft_rule_replace(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, int rulenum, bool verbose);
 int nft_rule_list(struct nft_handle *h, const char *chain, const char *table, int rulenum, unsigned int format);
 int nft_rule_list_save(struct nft_handle *h, const char *chain, const char *table, int rulenum, int counters);
 int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format);
@@ -159,7 +188,7 @@ uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag);
 int nft_commit(struct nft_handle *h);
 int nft_bridge_commit(struct nft_handle *h);
 int nft_abort(struct nft_handle *h);
-int nft_abort_policy_rule(struct nft_handle *h, const char *table);
+int nft_cmd_abort_policy_rule(struct nft_handle *h, const char *table);
 
 /*
  * revision compatibility.
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 9cfad76263d3..477f41746b5b 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -400,7 +400,7 @@ list_entries(struct nft_handle *h, const char *chain, const char *table,
 	if (linenumbers)
 		format |= FMT_LINENUMBERS;
 
-	return nft_rule_list(h, chain, table, rulenum, format);
+	return nft_cmd_rule_list(h, chain, table, rulenum, format);
 }
 
 static int
@@ -427,10 +427,10 @@ append_entry(struct nft_handle *h,
 			cs->arp.arp.tgt.s_addr = daddrs[j].s_addr;
 			cs->arp.arp.tmsk.s_addr = dmasks[j].s_addr;
 			if (append) {
-				ret = nft_rule_append(h, chain, table, cs, NULL,
+				ret = nft_cmd_rule_append(h, chain, table, cs, NULL,
 						      verbose);
 			} else {
-				ret = nft_rule_insert(h, chain, table, cs,
+				ret = nft_cmd_rule_insert(h, chain, table, cs,
 						      rulenum, verbose);
 			}
 		}
@@ -455,7 +455,7 @@ replace_entry(const char *chain,
 	cs->arp.arp.smsk.s_addr = smask->s_addr;
 	cs->arp.arp.tmsk.s_addr = dmask->s_addr;
 
-	return nft_rule_replace(h, chain, table, cs, rulenum, verbose);
+	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
 static int
@@ -479,7 +479,7 @@ delete_entry(const char *chain,
 		for (j = 0; j < ndaddrs; j++) {
 			cs->arp.arp.tgt.s_addr = daddrs[j].s_addr;
 			cs->arp.arp.tmsk.s_addr = dmasks[j].s_addr;
-			ret = nft_rule_delete(h, chain, table, cs, verbose);
+			ret = nft_cmd_rule_delete(h, chain, table, cs, verbose);
 		}
 	}
 
@@ -962,7 +962,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 				   options&OPT_VERBOSE, h);
 		break;
 	case CMD_DELETE_NUM:
-		ret = nft_rule_delete_num(h, chain, *table, rulenum - 1, verbose);
+		ret = nft_cmd_rule_delete_num(h, chain, *table, rulenum - 1, verbose);
 		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, *table, &cs, rulenum - 1,
@@ -984,10 +984,10 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 				   options&OPT_LINENUMBERS);
 		break;
 	case CMD_FLUSH:
-		ret = nft_rule_flush(h, chain, *table, options & OPT_VERBOSE);
+		ret = nft_cmd_rule_flush(h, chain, *table, options & OPT_VERBOSE);
 		break;
 	case CMD_ZERO:
-		ret = nft_chain_zero_counters(h, chain, *table,
+		ret = nft_cmd_chain_zero_counters(h, chain, *table,
 					      options & OPT_VERBOSE);
 		break;
 	case CMD_LIST|CMD_ZERO:
@@ -997,21 +997,21 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 				   /*options&OPT_EXPANDED*/0,
 				   options&OPT_LINENUMBERS);
 		if (ret)
-			ret = nft_chain_zero_counters(h, chain, *table,
+			ret = nft_cmd_chain_zero_counters(h, chain, *table,
 						      options & OPT_VERBOSE);
 		break;
 	case CMD_NEW_CHAIN:
-		ret = nft_chain_user_add(h, chain, *table);
+		ret = nft_cmd_chain_user_add(h, chain, *table);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = nft_chain_user_del(h, chain, *table,
+		ret = nft_cmd_chain_user_del(h, chain, *table,
 					 options & OPT_VERBOSE);
 		break;
 	case CMD_RENAME_CHAIN:
-		ret = nft_chain_user_rename(h, chain, *table, newname);
+		ret = nft_cmd_chain_user_rename(h, chain, *table, newname);
 		break;
 	case CMD_SET_POLICY:
-		ret = nft_chain_set(h, *table, chain, policy, NULL);
+		ret = nft_cmd_chain_set(h, *table, chain, policy, NULL);
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy `%s'\n",
 				      policy);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 15b971da3d42..0b002e4d5afb 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -150,9 +150,9 @@ append_entry(struct nft_handle *h,
 	int ret = 1;
 
 	if (append)
-		ret = nft_rule_append(h, chain, table, cs, NULL, verbose);
+		ret = nft_cmd_rule_append(h, chain, table, cs, NULL, verbose);
 	else
-		ret = nft_rule_insert(h, chain, table, cs, rule_nr, verbose);
+		ret = nft_cmd_rule_insert(h, chain, table, cs, rule_nr, verbose);
 
 	return ret;
 }
@@ -169,10 +169,10 @@ delete_entry(struct nft_handle *h,
 	int ret = 1;
 
 	if (rule_nr == -1)
-		ret = nft_rule_delete(h, chain, table, cs, verbose);
+		ret = nft_cmd_rule_delete(h, chain, table, cs, verbose);
 	else {
 		do {
-			ret = nft_rule_delete_num(h, chain, table,
+			ret = nft_cmd_rule_delete_num(h, chain, table,
 						  rule_nr, verbose);
 			rule_nr++;
 		} while (rule_nr < rule_nr_end);
@@ -427,7 +427,7 @@ static int list_rules(struct nft_handle *h, const char *chain, const char *table
 	if (!counters)
 		format |= FMT_NOCOUNTS;
 
-	return nft_rule_list(h, chain, table, rule_nr, format);
+	return nft_cmd_rule_list(h, chain, table, rule_nr, format);
 }
 
 static int parse_rule_range(const char *argv, int *rule_nr, int *rule_nr_end)
@@ -820,7 +820,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			flags |= OPT_COMMAND;
 
 			if (c == 'N') {
-				ret = nft_chain_user_add(h, chain, *table);
+				ret = nft_cmd_chain_user_add(h, chain, *table);
 				break;
 			} else if (c == 'X') {
 				/* X arg is optional, optarg is NULL */
@@ -828,7 +828,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 					chain = argv[optind];
 					optind++;
 				}
-				ret = nft_chain_user_del(h, chain, *table, 0);
+				ret = nft_cmd_chain_user_del(h, chain, *table, 0);
 				break;
 			}
 
@@ -842,7 +842,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 				else if (strchr(argv[optind], ' ') != NULL)
 					xtables_error(PARAMETER_PROBLEM, "Use of ' ' not allowed in chain names");
 
-				ret = nft_chain_user_rename(h, chain, *table,
+				ret = nft_cmd_chain_user_rename(h, chain, *table,
 							    argv[optind]);
 				if (ret != 0 && errno == ENOENT)
 					xtables_error(PARAMETER_PROBLEM, "Chain '%s' doesn't exists", chain);
@@ -1144,7 +1144,7 @@ print_zero:
 		/*case 7 :*/ /* atomic-init */
 		/*case 10:*/ /* atomic-save */
 		case 11: /* init-table */
-			nft_table_flush(h, *table);
+			nft_cmd_table_flush(h, *table);
 			return 1;
 		/*
 			replace->command = c;
@@ -1232,13 +1232,13 @@ print_zero:
 
 	if (command == 'P') {
 		if (selected_chain >= NF_BR_NUMHOOKS) {
-			ret = ebt_set_user_chain_policy(h, *table, chain, policy);
+			ret = ebt_cmd_user_chain_policy(h, *table, chain, policy);
 		} else {
 			if (strcmp(policy, "RETURN") == 0) {
 				xtables_error(PARAMETER_PROBLEM,
 					      "Policy RETURN only allowed for user defined chains");
 			}
-			ret = nft_chain_set(h, *table, chain, policy, NULL);
+			ret = nft_cmd_chain_set(h, *table, chain, policy, NULL);
 			if (ret < 0)
 				xtables_error(PARAMETER_PROBLEM, "Wrong policy");
 		}
@@ -1251,9 +1251,9 @@ print_zero:
 				 flags&LIST_C);
 	}
 	if (flags & OPT_ZERO) {
-		ret = nft_chain_zero_counters(h, chain, *table, 0);
+		ret = nft_cmd_chain_zero_counters(h, chain, *table, 0);
 	} else if (command == 'F') {
-		ret = nft_rule_flush(h, chain, *table, 0);
+		ret = nft_cmd_rule_flush(h, chain, *table, 0);
 	} else if (command == 'A') {
 		ret = append_entry(h, chain, *table, &cs, 0, 0, true);
 	} else if (command == 'I') {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 63cc15cee962..cc5a9056a715 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -61,11 +61,11 @@ static void print_usage(const char *name, const char *version)
 static const struct nft_xt_restore_cb restore_cb = {
 	.commit		= nft_commit,
 	.abort		= nft_abort,
-	.table_new	= nft_table_new,
-	.table_flush	= nft_table_flush,
+	.table_new	= nft_cmd_table_new,
+	.table_flush	= nft_cmd_table_flush,
 	.do_command	= do_commandx,
-	.chain_set	= nft_chain_set,
-	.chain_restore  = nft_chain_restore,
+	.chain_set	= nft_cmd_chain_set,
+	.chain_restore  = nft_cmd_chain_restore,
 };
 
 struct nft_xt_restore_state {
@@ -189,7 +189,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 				      "cannot create chain '%s' (%s)\n",
 				      chain, strerror(errno));
 		} else if (h->family == NFPROTO_BRIDGE &&
-			   !ebt_set_user_chain_policy(h, state->curtable->name,
+			   !ebt_cmd_user_chain_policy(h, state->curtable->name,
 						      chain, policy)) {
 			xtables_error(OTHER_PROBLEM,
 				      "Can't set policy `%s' on `%s' line %u: %s\n",
@@ -489,20 +489,20 @@ int xtables_ip6_restore_main(int argc, char *argv[])
 				    argc, argv);
 }
 
-static int ebt_table_flush(struct nft_handle *h, const char *table)
+static int ebt_cmd_table_flush(struct nft_handle *h, const char *table)
 {
 	/* drop any pending policy rule add/removal jobs */
-	nft_abort_policy_rule(h, table);
-	return nft_table_flush(h, table);
+	nft_cmd_abort_policy_rule(h, table);
+	return nft_cmd_table_flush(h, table);
 }
 
 static const struct nft_xt_restore_cb ebt_restore_cb = {
 	.commit		= nft_bridge_commit,
-	.table_new	= nft_table_new,
-	.table_flush	= ebt_table_flush,
+	.table_new	= nft_cmd_table_new,
+	.table_flush	= ebt_cmd_table_flush,
 	.do_command	= do_commandeb,
-	.chain_set	= nft_chain_set,
-	.chain_restore  = nft_chain_restore,
+	.chain_set	= nft_cmd_chain_set,
+	.chain_restore  = nft_cmd_chain_restore,
 };
 
 static const struct option ebt_restore_options[] = {
@@ -544,11 +544,11 @@ int xtables_eb_restore_main(int argc, char *argv[])
 
 static const struct nft_xt_restore_cb arp_restore_cb = {
 	.commit		= nft_commit,
-	.table_new	= nft_table_new,
-	.table_flush	= nft_table_flush,
+	.table_new	= nft_cmd_table_new,
+	.table_flush	= nft_cmd_table_flush,
 	.do_command	= do_commandarp,
-	.chain_set	= nft_chain_set,
-	.chain_restore  = nft_chain_restore,
+	.chain_set	= nft_cmd_chain_set,
+	.chain_restore  = nft_cmd_chain_restore,
 };
 
 int xtables_arp_restore_main(int argc, char *argv[])
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 260fb97b3b11..157bfb262816 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -361,11 +361,11 @@ add_entry(const char *chain,
 				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
 
 				if (append) {
-					ret = nft_rule_append(h, chain, table,
+					ret = nft_cmd_rule_append(h, chain, table,
 							      cs, NULL,
 							      verbose);
 				} else {
-					ret = nft_rule_insert(h, chain, table,
+					ret = nft_cmd_rule_insert(h, chain, table,
 							      cs, rulenum,
 							      verbose);
 				}
@@ -381,11 +381,11 @@ add_entry(const char *chain,
 				memcpy(&cs->fw6.ipv6.dmsk,
 				       &d.mask.v6[j], sizeof(struct in6_addr));
 				if (append) {
-					ret = nft_rule_append(h, chain, table,
+					ret = nft_cmd_rule_append(h, chain, table,
 							      cs, NULL,
 							      verbose);
 				} else {
-					ret = nft_rule_insert(h, chain, table,
+					ret = nft_cmd_rule_insert(h, chain, table,
 							      cs, rulenum,
 							      verbose);
 				}
@@ -418,7 +418,7 @@ replace_entry(const char *chain, const char *table,
 	} else
 		return 1;
 
-	return nft_rule_replace(h, chain, table, cs, rulenum, verbose);
+	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
 static int
@@ -440,7 +440,7 @@ delete_entry(const char *chain, const char *table,
 			for (j = 0; j < d.naddrs; j++) {
 				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
 				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
-				ret = nft_rule_delete(h, chain,
+				ret = nft_cmd_rule_delete(h, chain,
 						      table, cs, verbose);
 			}
 		} else if (family == AF_INET6) {
@@ -453,7 +453,7 @@ delete_entry(const char *chain, const char *table,
 				       &d.addr.v6[j], sizeof(struct in6_addr));
 				memcpy(&cs->fw6.ipv6.dmsk,
 				       &d.mask.v6[j], sizeof(struct in6_addr));
-				ret = nft_rule_delete(h, chain,
+				ret = nft_cmd_rule_delete(h, chain,
 						      table, cs, verbose);
 			}
 		}
@@ -480,7 +480,7 @@ check_entry(const char *chain, const char *table,
 			for (j = 0; j < d.naddrs; j++) {
 				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
 				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
-				ret = nft_rule_check(h, chain,
+				ret = nft_cmd_rule_check(h, chain,
 						     table, cs, verbose);
 			}
 		} else if (family == AF_INET6) {
@@ -493,7 +493,7 @@ check_entry(const char *chain, const char *table,
 				       &d.addr.v6[j], sizeof(struct in6_addr));
 				memcpy(&cs->fw6.ipv6.dmsk,
 				       &d.mask.v6[j], sizeof(struct in6_addr));
-				ret = nft_rule_check(h, chain,
+				ret = nft_cmd_rule_check(h, chain,
 						     table, cs, verbose);
 			}
 		}
@@ -524,7 +524,7 @@ list_entries(struct nft_handle *h, const char *chain, const char *table,
 	if (linenumbers)
 		format |= FMT_LINENUMBERS;
 
-	return nft_rule_list(h, chain, table, rulenum, format);
+	return nft_cmd_rule_list(h, chain, table, rulenum, format);
 }
 
 static int
@@ -534,7 +534,7 @@ list_rules(struct nft_handle *h, const char *chain, const char *table,
 	if (counters)
 	    counters = -1;		/* iptables -c format */
 
-	return nft_rule_list_save(h, chain, table, rulenum, counters);
+	return nft_cmd_rule_list_save(h, chain, table, rulenum, counters);
 }
 
 void do_parse(struct nft_handle *h, int argc, char *argv[],
@@ -1061,8 +1061,8 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				   cs.options & OPT_VERBOSE, h);
 		break;
 	case CMD_DELETE_NUM:
-		ret = nft_rule_delete_num(h, p.chain, p.table,
-					  p.rulenum - 1, p.verbose);
+		ret = nft_cmd_rule_delete_num(h, p.chain, p.table,
+					      p.rulenum - 1, p.verbose);
 		break;
 	case CMD_CHECK:
 		ret = check_entry(p.chain, p.table, &cs, h->family,
@@ -1080,15 +1080,15 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				cs.options&OPT_VERBOSE, h, false);
 		break;
 	case CMD_FLUSH:
-		ret = nft_rule_flush(h, p.chain, p.table,
-				     cs.options & OPT_VERBOSE);
+		ret = nft_cmd_rule_flush(h, p.chain, p.table,
+					 cs.options & OPT_VERBOSE);
 		break;
 	case CMD_ZERO:
-		ret = nft_chain_zero_counters(h, p.chain, p.table,
-					      cs.options & OPT_VERBOSE);
+		ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
+						  cs.options & OPT_VERBOSE);
 		break;
 	case CMD_ZERO_NUM:
-		ret = nft_rule_zero_counters(h, p.chain, p.table,
+		ret = nft_cmd_rule_zero_counters(h, p.chain, p.table,
 					     p.rulenum - 1);
 		break;
 	case CMD_LIST:
@@ -1100,11 +1100,11 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				   cs.options & OPT_EXPANDED,
 				   cs.options & OPT_LINENUMBERS);
 		if (ret && (p.command & CMD_ZERO)) {
-			ret = nft_chain_zero_counters(h, p.chain, p.table,
+			ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
 						      cs.options & OPT_VERBOSE);
 		}
 		if (ret && (p.command & CMD_ZERO_NUM)) {
-			ret = nft_rule_zero_counters(h, p.chain, p.table,
+			ret = nft_cmd_rule_zero_counters(h, p.chain, p.table,
 						     p.rulenum - 1);
 		}
 		nft_check_xt_legacy(h->family, false);
@@ -1115,27 +1115,27 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		ret = list_rules(h, p.chain, p.table, p.rulenum,
 				 cs.options & OPT_VERBOSE);
 		if (ret && (p.command & CMD_ZERO)) {
-			ret = nft_chain_zero_counters(h, p.chain, p.table,
+			ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
 						      cs.options & OPT_VERBOSE);
 		}
 		if (ret && (p.command & CMD_ZERO_NUM)) {
-			ret = nft_rule_zero_counters(h, p.chain, p.table,
+			ret = nft_cmd_rule_zero_counters(h, p.chain, p.table,
 						     p.rulenum - 1);
 		}
 		nft_check_xt_legacy(h->family, false);
 		break;
 	case CMD_NEW_CHAIN:
-		ret = nft_chain_user_add(h, p.chain, p.table);
+		ret = nft_cmd_chain_user_add(h, p.chain, p.table);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = nft_chain_user_del(h, p.chain, p.table,
+		ret = nft_cmd_chain_user_del(h, p.chain, p.table,
 					 cs.options & OPT_VERBOSE);
 		break;
 	case CMD_RENAME_CHAIN:
-		ret = nft_chain_user_rename(h, p.chain, p.table, p.newname);
+		ret = nft_cmd_chain_user_rename(h, p.chain, p.table, p.newname);
 		break;
 	case CMD_SET_POLICY:
-		ret = nft_chain_set(h, p.table, p.chain, p.policy, NULL);
+		ret = nft_cmd_chain_set(h, p.table, p.chain, p.policy, NULL);
 		break;
 	case CMD_NONE:
 	/* do_parse ignored the line (eg: -4 with ip6tables-restore) */
-- 
2.11.0

