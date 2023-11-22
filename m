Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380B5C61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343913AbjKVMyy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbjKVMys (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978F7D66
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/CvMweAWHl3mluHxRudeEvjVrIfDxtGNTjzYOiTZbAE=; b=VckdxIL8OxIThQA+N2ni/RzgKg
        tMHSoGfIX9cJEzfD2hyPHbDkOtDt8gjn4Gygcn3ULDoRjbmeVX9OGVbcyWK58fSczbhrxZzn0aiYK
        2CvamsmeDE0Hs6riWqSI+4xpvlHgQs4z7kqoFqENSBm+WJvRfCgzmmzfnBP3I/vM4DmNdTJgtPcXy
        pJwqpXlOy7TU/L7BDYB0NRIbM60N+KUSAp78IJRgz5p8TX96djpUUahy9lZJ5/d38pu607vcwf/8e
        itv2me0OAvmLojeP9gMbjwZeTo0QfkiRlbPdUNJhzsHFEngG4s6PsIIQCuU9fxDcwtjT/Ebe1XxO5
        rGwTuK1g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkV-0005SS-VK
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 12/12] ebtables: Implement --change-counters command
Date:   Wed, 22 Nov 2023 14:02:22 +0100
Message-ID: <20231122130222.29453-13-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Treat it like --replace against the same rule with changed counters.
The operation is obviously not atomic, so rule counters may change in
kernel while the rule is fetched, modified and replaced.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c                            | 20 +++++
 iptables/nft-cmd.h                            | 12 +++
 iptables/nft.c                                | 65 ++++++++++++++++
 iptables/nft.h                                |  1 +
 .../testcases/ebtables/0010-change-counters_0 | 45 +++++++++++
 iptables/xtables-eb.c                         | 74 ++++++++++++++-----
 6 files changed, 197 insertions(+), 20 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0010-change-counters_0

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 8a824586ad8c3..8372d171b00c4 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -400,3 +400,23 @@ int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
 
 	return 1;
 }
+
+int nft_cmd_rule_change_counters(struct nft_handle *h,
+				 const char *chain, const char *table,
+				 struct iptables_command_state *cs,
+				 int rule_nr, uint8_t counter_op, bool verbose)
+{
+	struct nft_cmd *cmd;
+
+	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_CHANGE_COUNTERS, table, chain,
+			  rule_nr == -1 ? cs : NULL, rule_nr, verbose);
+	if (!cmd)
+		return 0;
+
+	cmd->counter_op = counter_op;
+	cmd->counters = cs->counters;
+
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
+
+	return 1;
+}
diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
index ae5908d8d596b..8163b82c3511f 100644
--- a/iptables/nft-cmd.h
+++ b/iptables/nft-cmd.h
@@ -7,6 +7,13 @@
 
 struct nftnl_rule;
 
+enum {
+	CTR_OP_INC_PKTS = 1 << 0,
+	CTR_OP_DEC_PKTS = 1 << 1,
+	CTR_OP_INC_BYTES = 1 << 2,
+	CTR_OP_DEC_BYTES = 1 << 3,
+};
+
 struct nft_cmd {
 	struct list_head		head;
 	int				command;
@@ -22,6 +29,7 @@ struct nft_cmd {
 	} obj;
 	const char			*policy;
 	struct xt_counters		counters;
+	uint8_t				counter_op;
 	const char			*rename;
 	int				counters_save;
 	struct {
@@ -77,6 +85,10 @@ int nft_cmd_rule_list_save(struct nft_handle *h, const char *chain,
 			   const char *table, int rulenum, int counters);
 int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
 			      const char *chain, const char *policy);
+int nft_cmd_rule_change_counters(struct nft_handle *h,
+				 const char *chain, const char *table,
+				 struct iptables_command_state *cs,
+				 int rule_nr, uint8_t counter_op, bool verbose);
 void nft_cmd_table_new(struct nft_handle *h, const char *table);
 
 #endif /* _NFT_CMD_H_ */
diff --git a/iptables/nft.c b/iptables/nft.c
index 97fd4f49fdb4c..f536857829cd2 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -337,6 +337,7 @@ static int mnl_append_error(const struct nft_handle *h,
 	case NFT_COMPAT_RULE_REPLACE:
 	case NFT_COMPAT_RULE_DELETE:
 	case NFT_COMPAT_RULE_FLUSH:
+	case NFT_COMPAT_RULE_CHANGE_COUNTERS:
 		snprintf(tcr, sizeof(tcr), "rule in chain %s",
 			 nftnl_rule_get_str(o->rule, NFTNL_RULE_CHAIN));
 #if 0
@@ -2641,6 +2642,58 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 	return ret;
 }
 
+static int nft_rule_change_counters(struct nft_handle *h, const char *table,
+				    const char *chain, struct nftnl_rule *rule,
+				    int rulenum, struct xt_counters *counters,
+				    uint8_t counter_op, bool verbose)
+{
+	struct iptables_command_state cs = {};
+	struct nftnl_rule *r, *new_rule;
+	struct nft_rule_ctx ctx = {
+		.command = NFT_COMPAT_RULE_APPEND,
+	};
+	struct nft_chain *c;
+
+	nft_fn = nft_rule_change_counters;
+
+	c = nft_chain_find(h, table, chain);
+	if (!c) {
+		errno = ENOENT;
+		return 0;
+	}
+
+	r = nft_rule_find(h, c, rule, rulenum);
+	if (!r) {
+		errno = E2BIG;
+		return 0;
+	}
+
+	DEBUGP("changing counters of rule with handle=%llu\n",
+		(unsigned long long)
+		nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE));
+
+	h->ops->rule_to_cs(h, r, &cs);
+
+	if (counter_op & CTR_OP_INC_PKTS)
+		cs.counters.pcnt += counters->pcnt;
+	else if (counter_op & CTR_OP_DEC_PKTS)
+		cs.counters.pcnt -= counters->pcnt;
+	else
+		cs.counters.pcnt = counters->pcnt;
+
+	if (counter_op & CTR_OP_INC_BYTES)
+		cs.counters.bcnt += counters->bcnt;
+	else if (counter_op & CTR_OP_DEC_BYTES)
+		cs.counters.bcnt -= counters->bcnt;
+	else
+		cs.counters.bcnt = counters->bcnt;
+
+	new_rule = nft_rule_new(h, &ctx, chain, table, &cs);
+	h->ops->clear_cs(&cs);
+
+	return nft_rule_append(h, chain, table, new_rule, r, verbose);
+}
+
 static int
 __nft_rule_list(struct nft_handle *h, struct nftnl_chain *c,
 		int rulenum, unsigned int format,
@@ -3031,6 +3084,7 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 	case NFT_COMPAT_RULE_APPEND:
 	case NFT_COMPAT_RULE_INSERT:
 	case NFT_COMPAT_RULE_REPLACE:
+	case NFT_COMPAT_RULE_CHANGE_COUNTERS:
 		break;
 	case NFT_COMPAT_RULE_DELETE:
 	case NFT_COMPAT_RULE_FLUSH:
@@ -3118,6 +3172,7 @@ static void nft_refresh_transaction(struct nft_handle *h)
 		case NFT_COMPAT_RULE_APPEND:
 		case NFT_COMPAT_RULE_INSERT:
 		case NFT_COMPAT_RULE_REPLACE:
+		case NFT_COMPAT_RULE_CHANGE_COUNTERS:
 		case NFT_COMPAT_RULE_DELETE:
 		case NFT_COMPAT_SET_ADD:
 		case NFT_COMPAT_RULE_LIST:
@@ -3208,6 +3263,7 @@ static int nft_action(struct nft_handle *h, int action)
 						  n->rule);
 			break;
 		case NFT_COMPAT_RULE_REPLACE:
+		case NFT_COMPAT_RULE_CHANGE_COUNTERS:
 			nft_compat_rule_batch_add(h, NFT_MSG_NEWRULE,
 						  NLM_F_CREATE | NLM_F_REPLACE,
 						  n->seq, n->rule);
@@ -3510,6 +3566,15 @@ static int nft_prepare(struct nft_handle *h)
 		case NFT_COMPAT_CHAIN_ADD:
 			assert(0);
 			return 0;
+		case NFT_COMPAT_RULE_CHANGE_COUNTERS:
+			ret = nft_rule_change_counters(h, cmd->table,
+						       cmd->chain,
+						       cmd->obj.rule,
+						       cmd->rulenum,
+						       &cmd->counters,
+						       cmd->counter_op,
+						       cmd->verbose);
+			break;
 		}
 
 		nft_cmd_free(cmd);
diff --git a/iptables/nft.h b/iptables/nft.h
index 5acbbf82e2c29..79f1e037cd6d3 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -72,6 +72,7 @@ enum obj_update_type {
 	NFT_COMPAT_RULE_SAVE,
 	NFT_COMPAT_RULE_ZERO,
 	NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE,
+	NFT_COMPAT_RULE_CHANGE_COUNTERS,
 };
 
 struct cache_chain {
diff --git a/iptables/tests/shell/testcases/ebtables/0010-change-counters_0 b/iptables/tests/shell/testcases/ebtables/0010-change-counters_0
new file mode 100755
index 0000000000000..4f783819d10eb
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0010-change-counters_0
@@ -0,0 +1,45 @@
+#!/bin/sh
+
+case "$XT_MULTI" in
+*xtables-nft-multi)
+	;;
+*)
+	echo "skip $XT_MULTI"
+	exit 0
+	;;
+esac
+
+set -e
+set -x
+
+check_rule() { # (pcnt, bcnt)
+	$XT_MULTI ebtables -L FORWARD --Lc --Ln | \
+		grep -q "^1. -o eth0 -j CONTINUE , pcnt = $1 -- bcnt = $2$"
+}
+
+$XT_MULTI ebtables -A FORWARD -o eth0 -c 10 20
+check_rule 10 20
+
+$XT_MULTI ebtables -C FORWARD 1 100 200
+check_rule 100 200
+
+$XT_MULTI ebtables -C FORWARD 101 201 -o eth0
+check_rule 101 201
+
+$XT_MULTI ebtables -C FORWARD 1 +10 -20
+check_rule 111 181
+
+$XT_MULTI ebtables -C FORWARD -10 +20 -o eth0
+check_rule 101 201
+
+$XT_MULTI ebtables -A FORWARD -o eth1 -c 111 211
+$XT_MULTI ebtables -A FORWARD -o eth2 -c 121 221
+
+$XT_MULTI ebtables -C FORWARD 2:3 +100 -200
+
+EXPECT='1. -o eth0 -j CONTINUE , pcnt = 101 -- bcnt = 201
+2. -o eth1 -j CONTINUE , pcnt = 211 -- bcnt = 11
+3. -o eth2 -j CONTINUE , pcnt = 221 -- bcnt = 21'
+diff -u <(echo "$EXPECT") \
+	<($XT_MULTI ebtables -L FORWARD --Lc --Ln | grep -- '-o eth')
+
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index cd45e0495ebcb..ddbe1b5a3adc0 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -136,6 +136,29 @@ delete_entry(struct nft_handle *h,
 	return ret;
 }
 
+static int
+change_entry_counters(struct nft_handle *h,
+		      const char *chain, const char *table,
+		      struct iptables_command_state *cs,
+		      int rule_nr, int rule_nr_end, uint8_t counter_op,
+		      bool verbose)
+{
+	int ret = 1;
+
+	if (rule_nr == -1)
+		return nft_cmd_rule_change_counters(h, chain, table, cs,
+						    rule_nr, counter_op,
+						    verbose);
+	do {
+		ret = nft_cmd_rule_change_counters(h, chain, table, cs,
+						   rule_nr, counter_op,
+						   verbose);
+		rule_nr++;
+	} while (rule_nr < rule_nr_end);
+
+	return ret;
+}
+
 int ebt_get_current_chain(const char *chain)
 {
 	if (!chain)
@@ -391,51 +414,62 @@ static int parse_rule_range(const char *argv, int *rule_nr, int *rule_nr_end)
 /* Incrementing or decrementing rules in daemon mode is not supported as the
  * involved code overload is not worth it (too annoying to take the increased
  * counters in the kernel into account). */
-static int parse_change_counters_rule(int argc, char **argv, int *rule_nr, int *rule_nr_end, struct iptables_command_state *cs)
+static uint8_t parse_change_counters_rule(int argc, char **argv,
+					  int *rule_nr, int *rule_nr_end,
+					  struct iptables_command_state *cs)
 {
+	uint8_t ret = 0;
 	char *buffer;
-	int ret = 0;
 
-	if (optind + 1 >= argc || argv[optind][0] == '-' || argv[optind + 1][0] == '-')
+	if (optind + 1 >= argc ||
+	    (argv[optind][0] == '-' && !isdigit(argv[optind][1])) ||
+	    (argv[optind + 1][0] == '-' && !isdigit(argv[optind + 1][1])))
 		xtables_error(PARAMETER_PROBLEM,
 			      "The command -C needs at least 2 arguments");
-	if (optind + 2 < argc && (argv[optind + 2][0] != '-' || (argv[optind + 2][1] >= '0' && argv[optind + 2][1] <= '9'))) {
+	if (optind + 2 < argc &&
+	    (argv[optind + 2][0] != '-' || isdigit(argv[optind + 2][1]))) {
 		if (optind + 3 != argc)
 			xtables_error(PARAMETER_PROBLEM,
 				      "No extra options allowed with -C start_nr[:end_nr] pcnt bcnt");
 		if (parse_rule_range(argv[optind], rule_nr, rule_nr_end))
 			xtables_error(PARAMETER_PROBLEM,
-				      "Something is wrong with the rule number specification '%s'", argv[optind]);
+				      "Something is wrong with the rule number specification '%s'",
+				      argv[optind]);
 		optind++;
 	}
 
 	if (argv[optind][0] == '+') {
-		ret += 1;
+		ret |= CTR_OP_INC_PKTS;
 		cs->counters.pcnt = strtoull(argv[optind] + 1, &buffer, 10);
 	} else if (argv[optind][0] == '-') {
-		ret += 2;
+		ret |= CTR_OP_DEC_PKTS;
 		cs->counters.pcnt = strtoull(argv[optind] + 1, &buffer, 10);
-	} else
+	} else {
 		cs->counters.pcnt = strtoull(argv[optind], &buffer, 10);
-
+	}
 	if (*buffer != '\0')
 		goto invalid;
+
 	optind++;
+
 	if (argv[optind][0] == '+') {
-		ret += 3;
+		ret |= CTR_OP_INC_BYTES;
 		cs->counters.bcnt = strtoull(argv[optind] + 1, &buffer, 10);
 	} else if (argv[optind][0] == '-') {
-		ret += 6;
+		ret |= CTR_OP_DEC_BYTES;
 		cs->counters.bcnt = strtoull(argv[optind] + 1, &buffer, 10);
-	} else
+	} else {
 		cs->counters.bcnt = strtoull(argv[optind], &buffer, 10);
-
+	}
 	if (*buffer != '\0')
 		goto invalid;
+
 	optind++;
+
 	return ret;
 invalid:
-	xtables_error(PARAMETER_PROBLEM,"Packet counter '%s' invalid", argv[optind]);
+	xtables_error(PARAMETER_PROBLEM,
+		      "Packet counter '%s' invalid", argv[optind]);
 }
 
 static void ebtables_parse_interface(const char *arg, char *vianame)
@@ -695,7 +729,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 {
 	char *buffer;
 	int c, i;
-	int chcounter = 0; /* Needed for -C */
+	uint8_t chcounter = 0; /* Needed for -C */
 	int rule_nr = 0;
 	int rule_nr_end = 0;
 	int ret = 0;
@@ -1171,11 +1205,11 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	} else if (command == 14) {
 		ret = nft_cmd_rule_check(h, chain, *table,
 					 &cs, flags & OPT_VERBOSE);
-	} /*else if (replace->command == 'C') {
-		ebt_change_counters(replace, new_entry, rule_nr, rule_nr_end, &(new_entry->cnt_surplus), chcounter);
-		if (ebt_errormsg[0] != '\0')
-			return -1;
-	}*/
+	} else if (command == 'C') {
+		ret = change_entry_counters(h, chain, *table, &cs,
+					    rule_nr - 1, rule_nr_end, chcounter,
+					    flags & OPT_VERBOSE);
+	}
 
 	ebt_cs_clean(&cs);
 	return ret;
-- 
2.41.0

