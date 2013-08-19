From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 2/5] nft: Refactor firewall printing so it reuses already parsed cs struct
Date: Mon, 19 Aug 2013 15:04:03 +0300
Message-ID: <1376913846-15996-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22132 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab3HSMEO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:04:14 -0400
In-Reply-To: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we parse properly, in one place and at once, the rule back into
a command structure, it's now easier to print the rule from that command
structure.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-ipv4.c   |  21 +------
 iptables/nft-ipv6.c   |  13 +----
 iptables/nft-shared.c | 156 +++++++-------------------------------------------
 iptables/nft-shared.h |   7 +--
 4 files changed, 26 insertions(+), 171 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 81be9f4..a47f10b 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -121,14 +121,6 @@ static void get_frag(struct nft_rule_expr_iter *iter, bool *inv)
 		*inv = false;
 }
 
-static void print_frag(bool inv)
-{
-	if (inv)
-		printf("! -f ");
-	else
-		printf("-f ");
-}
-
 static const char *mask_to_str(uint32_t mask)
 {
 	static char mask_str[sizeof("255.255.255.255")];
@@ -288,15 +280,10 @@ static void nft_ipv4_print_firewall(struct nft_rule *r, unsigned int num,
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
@@ -311,11 +298,7 @@ static void nft_ipv4_print_firewall(struct nft_rule *r, unsigned int num,
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
index 0214dcf..deea451 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -198,15 +198,10 @@ static void nft_ipv6_print_firewall(struct nft_rule *r, unsigned int num,
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
@@ -221,11 +216,7 @@ static void nft_ipv6_print_firewall(struct nft_rule *r, unsigned int num,
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
index 842523f..87de236 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -281,61 +281,8 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
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
 static void
-_nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		 struct iptables_command_state *cs)
 {
 	size_t target_len;
@@ -520,7 +467,7 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 		else if (strcmp(name, "immediate") == 0)
 			nft_parse_immediate(expr, iter, family, cs);
 		else if (strcmp(name, "target") == 0)
-			_nft_parse_target(expr, iter, cs);
+			nft_parse_target(expr, iter, cs);
 		else if (strcmp(name, "match") == 0)
 			nft_parse_match(expr, iter, cs);
 
@@ -537,87 +484,6 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 		cs->jumpto = "";
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
@@ -707,6 +573,24 @@ void print_firewall_details(const struct iptables_command_state *cs,
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
 struct nft_family_ops *nft_family_ops_lookup(int family)
 {
 	switch (family) {
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 488ed63..a4eec04 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -79,22 +79,19 @@ bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
 void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		unsigned char *iniface_mask, char *outiface,
 		unsigned char *outiface_mask, uint8_t *invflags);
-const char *nft_parse_target(struct nft_rule *r, const void **targinfo,
-			     size_t *target_len);
 void print_proto(uint16_t proto, int invert);
 void get_cmp_data(struct nft_rule_expr_iter *iter,
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
 
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
-- 
1.8.3.2

