From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 11/16] nft: Refactor firewall printing so it reuses already parsed cs struct
Date: Fri,  9 Aug 2013 16:31:25 +0300
Message-ID: <1376055090-26551-12-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINb4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:56 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we parse properly, in one place and at once, the rule back into
a command structure, it's now easier to print the rule from that command
structure.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-ipv4.c   |  13 +----
 iptables/nft-ipv6.c   |  13 +----
 iptables/nft-shared.c | 152 ++++++--------------------------------------------
 iptables/nft-shared.h |   7 +--
 4 files changed, 24 insertions(+), 161 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 038d04f..02b52df 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -301,15 +301,10 @@ static void nft_ipv4_print_firewall(struct nft_rule *r, unsigned int num,
 				    unsigned int format)
 {
 	struct iptables_command_state cs = {};
-	const char *targname = NULL;
-	const void *targinfo = NULL;
-	size_t target_len = 0;
 
 	nft_rule_to_iptables_command_state(r, &cs);
 
-	targname = nft_parse_target(r, &targinfo, &target_len);
-
-	print_firewall_details(&cs, targname, cs.fw.ip.flags,
+	print_firewall_details(&cs, cs.jumpto, cs.fw.ip.flags,
 			       cs.fw.ip.invflags, cs.fw.ip.proto,
 			       cs.fw.ip.iniface, cs.fw.ip.outiface,
 			       num, format);
@@ -324,11 +319,7 @@ static void nft_ipv4_print_firewall(struct nft_rule *r, unsigned int num,
 		printf("[goto] ");
 #endif
 
-	if (print_matches(r, format) != 0)
-		return;
-
-	if (print_target(targname, targinfo, target_len, format) != 0)
-		return;
+	print_matches_and_target(&cs, format);
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 5c79912..15c37f6 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -199,15 +199,10 @@ static void nft_ipv6_print_firewall(struct nft_rule *r, unsigned int num,
 				    unsigned int format)
 {
 	struct iptables_command_state cs = {};
-	const char *targname = NULL;
-	const void *targinfo = NULL;
-	size_t target_len = 0;
 
 	nft_rule_to_iptables_command_state(r, &cs);
 
-	targname = nft_parse_target(r, &targinfo, &target_len);
-
-	print_firewall_details(&cs, targname, cs.fw6.ipv6.flags,
+	print_firewall_details(&cs, cs.jumpto, cs.fw6.ipv6.flags,
 			       cs.fw6.ipv6.invflags, cs.fw6.ipv6.proto,
 			       cs.fw6.ipv6.iniface, cs.fw6.ipv6.outiface,
 			       num, format);
@@ -222,11 +217,7 @@ static void nft_ipv6_print_firewall(struct nft_rule *r, unsigned int num,
 		printf("[goto] ");
 #endif
 
-	if (print_matches(r, format) != 0)
-		return;
-
-	if (print_target(targname, targinfo, target_len, format) != 0)
-		return;
+	print_matches_and_target(&cs, format);
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 8bef696..4eba145 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -284,59 +284,6 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 	}
 }
 
-const char *nft_parse_target(struct nft_rule *r, const void **targinfo,
-			     size_t *target_len)
-{
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	const char *targname = NULL;
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return NULL;
-
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "target") == 0) {
-			targname = nft_rule_expr_get_str(expr,
-							NFT_EXPR_TG_NAME);
-			*targinfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO,
-								target_len);
-			break;
-		} else if (strcmp(name, "immediate") == 0) {
-			uint32_t verdict =
-			nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_VERDICT);
-
-			switch(verdict) {
-			case NF_ACCEPT:
-				targname = "ACCEPT";
-				break;
-			case NF_DROP:
-				targname = "DROP";
-				break;
-			case NFT_RETURN:
-				targname = "RETURN";
-				break;
-			case NFT_GOTO:
-				targname = nft_rule_expr_get_str(expr,
-							NFT_EXPR_IMM_CHAIN);
-				break;
-			case NFT_JUMP:
-				targname = nft_rule_expr_get_str(expr,
-							NFT_EXPR_IMM_CHAIN);
-			break;
-			}
-		}
-		expr = nft_rule_expr_iter_next(iter);
-	}
-	nft_rule_expr_iter_destroy(iter);
-
-	return targname;
-}
-
 void print_proto(uint16_t proto, int invert)
 {
 	const struct protoent *pent = getprotobynumber(proto);
@@ -524,87 +471,6 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 		i2cs.cs->jumpto = "";
 }
 
-static void
-print_match(struct nft_rule_expr *expr, int numeric)
-{
-	size_t len;
-	const char *match_name = nft_rule_expr_get_str(expr, NFT_EXPR_MT_NAME);
-	const void *match_info = nft_rule_expr_get(expr, NFT_EXPR_MT_INFO, &len);
-	const struct xtables_match *match =
-		xtables_find_match(match_name, XTF_TRY_LOAD, NULL);
-	struct xt_entry_match *m =
-		calloc(1, sizeof(struct xt_entry_match) + len);
-
-	/* emulate struct xt_entry_match since ->print needs it */
-	memcpy((void *)&m->data, match_info, len);
-
-	if (match) {
-		if (match->print)
-			/* FIXME missing first parameter */
-			match->print(NULL, m, numeric);
-		else
-			printf("%s ", match_name);
-	} else {
-		if (match_name[0])
-			printf("UNKNOWN match `%s' ", match_name);
-	}
-
-	free(m);
-}
-
-int print_matches(struct nft_rule *r, int format)
-{
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return -ENOMEM;
-
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "match") == 0)
-			print_match(expr, format & FMT_NUMERIC);
-
-		expr = nft_rule_expr_iter_next(iter);
-	}
-	nft_rule_expr_iter_destroy(iter);
-
-	return 0;
-}
-
-int print_target(const char *targname, const void *targinfo,
-		 size_t target_len, int format)
-{
-	struct xtables_target *target;
-	struct xt_entry_target *t;
-
-	if (targname == NULL)
-		return 0;
-
-	t = calloc(1, sizeof(struct xt_entry_target) + target_len);
-	if (t == NULL)
-		return -ENOMEM;
-
-	/* emulate struct xt_entry_target since ->print needs it */
-	memcpy((void *)&t->data, targinfo, target_len);
-
-	target = xtables_find_target(targname, XTF_TRY_LOAD);
-	if (target) {
-		if (target->print)
-			/* FIXME missing first parameter */
-			target->print(NULL, t, format & FMT_NUMERIC);
-	} else if (target_len > 0)
-		printf("[%ld bytes of unknown target data] ", target_len);
-
-	free(t);
-
-	return 0;
-}
-
 void print_num(uint64_t number, unsigned int format)
 {
 	if (format & FMT_KILOMEGAGIGA) {
@@ -694,6 +560,24 @@ void print_firewall_details(const struct iptables_command_state *cs,
 	}
 }
 
+void print_matches_and_target(struct iptables_command_state *cs,
+			      unsigned int format)
+{
+	struct xtables_rule_match *matchp;
+
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		if (matchp->match->print != NULL)
+			matchp->match->print(NULL, matchp->match->m,
+							format & FMT_NUMERIC);
+	}
+
+	if (cs->target != NULL) {
+		if (cs->target->print != NULL)
+			cs->target->print(NULL, cs->target->t,
+							format & FMT_NUMERIC);
+	}
+}
+
 static enum nft_instruction nft_ipt_counters_instructions[] = {
 	NFT_INSTRUCTION_COUNTER,
 	NFT_INSTRUCTION_MAX,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 176abed..20e49bd 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -84,8 +84,6 @@ bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
 void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		unsigned char *iniface_mask, char *outiface,
 		unsigned char *outiface_mask, uint8_t *invflags);
-const char *nft_parse_target(struct nft_rule *r, const void **targinfo,
-			     size_t *target_len);
 void print_proto(uint16_t proto, int invert);
 void get_expr_cmp_data(struct nft_rule_expr *e,
 		       void *data, size_t dlen, bool *inv);
@@ -93,15 +91,14 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 		  void *data, size_t dlen, bool *inv);
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
 					struct iptables_command_state *cs);
-int print_matches(struct nft_rule *r, int format);
-int print_target(const char *targname, const void *targinfo,
-		 size_t target_len, int format);
 void print_num(uint64_t number, unsigned int format);
 void print_firewall_details(const struct iptables_command_state *cs,
 			    const char *targname, uint8_t flags,
 			    uint8_t invflags, uint8_t proto,
 			    const char *iniface, const char *outiface,
 			    unsigned int num, unsigned int format);
+void print_matches_and_target(struct iptables_command_state *cs,
+			      unsigned int format);
 int nft_initiate_translation_tree(void);
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
-- 
1.8.3.2

