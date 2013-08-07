From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 2/3] nft: Generalize nft_rule_list() against current family
Date: Wed,  7 Aug 2013 11:31:36 +0300
Message-ID: <1375864297-9347-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab3HGIbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:31:52 -0400
In-Reply-To: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now, firewall rule printing is done through nft_family_ops
.print_firewall function. This moves generic part for ipv4 and ipv6 into
nft-shared.c, and enables reusing nft_rule_list() for other family such
as ARP which will be useful for arptables compatibility tool.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-ipv4.c   |  39 ++++++--
 iptables/nft-ipv6.c   |  39 ++++++--
 iptables/nft-shared.c | 239 ++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |  13 ++-
 iptables/nft.c        | 249 +-------------------------------------------------
 5 files changed, 315 insertions(+), 264 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 51ee422..81be9f4 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -284,18 +284,41 @@ static void print_ipv4_addr(const struct iptables_command_state *cs,
 }
 
 
-static uint8_t nft_ipv4_print_firewall(const struct iptables_command_state *cs,
-				       const char *targname, unsigned int num,
-				       unsigned int format)
+static void nft_ipv4_print_firewall(struct nft_rule *r, unsigned int num,
+				    unsigned int format)
 {
-	print_firewall_details(cs, targname, cs->fw.ip.flags,
-			       cs->fw.ip.invflags, cs->fw.ip.proto,
-			       cs->fw.ip.iniface, cs->fw.ip.outiface,
+	struct iptables_command_state cs = {};
+	const char *targname = NULL;
+	const void *targinfo = NULL;
+	size_t target_len = 0;
+
+	nft_rule_to_iptables_command_state(r, &cs);
+
+	targname = nft_parse_target(r, &targinfo, &target_len);
+
+	print_firewall_details(&cs, targname, cs.fw.ip.flags,
+			       cs.fw.ip.invflags, cs.fw.ip.proto,
+			       cs.fw.ip.iniface, cs.fw.ip.outiface,
 			       num, format);
 
-	print_ipv4_addr(cs, format);
+	print_ipv4_addr(&cs, format);
 
-	return cs->fw.ip.flags;
+	if (format & FMT_NOTABLE)
+		fputs("  ", stdout);
+
+#ifdef IPT_F_GOTO
+	if (cs.fw.ip.flags & IPT_F_GOTO)
+		printf("[goto] ");
+#endif
+
+	if (print_matches(r, format) != 0)
+		return;
+
+	if (print_target(targname, targinfo, target_len, format) != 0)
+		return;
+
+	if (!(format & FMT_NONEWLINE))
+		fputc('\n', stdout);
 }
 
 static void nft_ipv4_post_parse(int command,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 61c660a..0214dcf 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -194,18 +194,41 @@ static void print_ipv6_addr(const struct iptables_command_state *cs,
 	}
 }
 
-static uint8_t nft_ipv6_print_firewall(const struct iptables_command_state *cs,
-				       const char *targname, unsigned int num,
-				       unsigned int format)
+static void nft_ipv6_print_firewall(struct nft_rule *r, unsigned int num,
+				    unsigned int format)
 {
-	print_firewall_details(cs, targname, cs->fw6.ipv6.flags,
-			       cs->fw6.ipv6.invflags, cs->fw6.ipv6.proto,
-			       cs->fw6.ipv6.iniface, cs->fw6.ipv6.outiface,
+	struct iptables_command_state cs = {};
+	const char *targname = NULL;
+	const void *targinfo = NULL;
+	size_t target_len = 0;
+
+	nft_rule_to_iptables_command_state(r, &cs);
+
+	targname = nft_parse_target(r, &targinfo, &target_len);
+
+	print_firewall_details(&cs, targname, cs.fw6.ipv6.flags,
+			       cs.fw6.ipv6.invflags, cs.fw6.ipv6.proto,
+			       cs.fw6.ipv6.iniface, cs.fw6.ipv6.outiface,
 			       num, format);
 
-	print_ipv6_addr(cs, format);
+	print_ipv6_addr(&cs, format);
 
-	return cs->fw6.ipv6.flags;
+	if (format & FMT_NOTABLE)
+		fputs("  ", stdout);
+
+#ifdef IPT_F_GOTO
+	if (cs.fw6.ipv6.flags & IPT_F_GOTO)
+		printf("[goto] ");
+#endif
+
+	if (print_matches(r, format) != 0)
+		return;
+
+	if (print_target(targname, targinfo, target_len, format) != 0)
+		return;
+
+	if (!(format & FMT_NONEWLINE))
+		fputc('\n', stdout);
 }
 
 /* These are invalid numbers as upper layer protocol */
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c0ee4c8..ad3e675 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -12,8 +12,12 @@
 
 #include <string.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <stdbool.h>
 #include <netdb.h>
+#include <errno.h>
+
+#include <xtables.h>
 
 #include <linux/netfilter/nf_tables.h>
 
@@ -277,6 +281,59 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 	}
 }
 
+const char *nft_parse_target(struct nft_rule *r, const void **targinfo,
+			     size_t *target_len)
+{
+	struct nft_rule_expr_iter *iter;
+	struct nft_rule_expr *expr;
+	const char *targname;
+
+	iter = nft_rule_expr_iter_create(r);
+	if (iter == NULL)
+		return NULL;
+
+	expr = nft_rule_expr_iter_next(iter);
+	while (expr != NULL) {
+		const char *name =
+			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
+
+		if (strcmp(name, "target") == 0) {
+			targname = nft_rule_expr_get_str(expr,
+							NFT_EXPR_TG_NAME);
+			*targinfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO,
+								target_len);
+			break;
+		} else if (strcmp(name, "immediate") == 0) {
+			uint32_t verdict =
+			nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_VERDICT);
+
+			switch(verdict) {
+			case NF_ACCEPT:
+				targname = "ACCEPT";
+				break;
+			case NF_DROP:
+				targname = "DROP";
+				break;
+			case NFT_RETURN:
+				targname = "RETURN";
+				break;
+			case NFT_GOTO:
+				targname = nft_rule_expr_get_str(expr,
+							NFT_EXPR_IMM_CHAIN);
+				break;
+			case NFT_JUMP:
+				targname = nft_rule_expr_get_str(expr,
+							NFT_EXPR_IMM_CHAIN);
+			break;
+			}
+		}
+		expr = nft_rule_expr_iter_next(iter);
+	}
+	nft_rule_expr_iter_destroy(iter);
+
+	return targname;
+}
+
 void print_proto(uint16_t proto, int invert)
 {
 	const struct protoent *pent = getprotobynumber(proto);
@@ -318,6 +375,188 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 		*inv = false;
 }
 
+static void
+nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+	       int family, struct iptables_command_state *cs)
+{
+	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
+	struct nft_family_ops *ops = nft_family_ops_lookup(family);
+	const char *name;
+
+	e = nft_rule_expr_iter_next(iter);
+	if (e == NULL)
+		return;
+
+	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
+	if (strcmp(name, "cmp") != 0) {
+		DEBUGP("skipping no cmp after meta\n");
+		return;
+	}
+
+	ops->parse_meta(e, key, cs);
+}
+
+static void
+nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+		  int family, struct iptables_command_state *cs)
+{
+	struct nft_family_ops *ops = nft_family_ops_lookup(family);
+	uint32_t offset;
+
+	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+
+	ops->parse_payload(iter, cs, offset);
+}
+
+static void
+nft_parse_counter(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+		  struct xt_counters *counters)
+{
+	counters->pcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_PACKETS);
+	counters->bcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_BYTES);
+}
+
+static void
+nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+		    int family, struct iptables_command_state *cs)
+{
+	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
+	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
+	struct nft_family_ops *ops;
+
+	/* Standard target? */
+	switch(verdict) {
+	case NF_ACCEPT:
+		cs->jumpto = "ACCEPT";
+		return;
+	case NF_DROP:
+		cs->jumpto = "DROP";
+		return;
+	case NFT_RETURN:
+		cs->jumpto = "RETURN";
+		return;
+	case NFT_GOTO:
+		ops = nft_family_ops_lookup(family);
+		ops->parse_immediate(cs);
+	case NFT_JUMP:
+		cs->jumpto = chain;
+		return;
+	}
+}
+
+void nft_rule_to_iptables_command_state(struct nft_rule *r,
+					struct iptables_command_state *cs)
+{
+	struct nft_rule_expr_iter *iter;
+	struct nft_rule_expr *expr;
+	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+
+	iter = nft_rule_expr_iter_create(r);
+	if (iter == NULL)
+		return;
+
+	expr = nft_rule_expr_iter_next(iter);
+	while (expr != NULL) {
+		const char *name =
+			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
+
+		if (strcmp(name, "counter") == 0) {
+			nft_parse_counter(expr, iter, &cs->counters);
+		} else if (strcmp(name, "payload") == 0) {
+			nft_parse_payload(expr, iter, family, cs);
+		} else if (strcmp(name, "meta") == 0) {
+			nft_parse_meta(expr, iter, family, cs);
+		} else if (strcmp(name, "immediate") == 0) {
+			nft_parse_immediate(expr, iter, family, cs);
+		}
+
+		expr = nft_rule_expr_iter_next(iter);
+	}
+
+	nft_rule_expr_iter_destroy(iter);
+}
+
+static void
+print_match(struct nft_rule_expr *expr, int numeric)
+{
+	size_t len;
+	const char *match_name = nft_rule_expr_get_str(expr, NFT_EXPR_MT_NAME);
+	const void *match_info = nft_rule_expr_get(expr, NFT_EXPR_MT_INFO, &len);
+	const struct xtables_match *match =
+		xtables_find_match(match_name, XTF_TRY_LOAD, NULL);
+	struct xt_entry_match *m =
+		calloc(1, sizeof(struct xt_entry_match) + len);
+
+	/* emulate struct xt_entry_match since ->print needs it */
+	memcpy((void *)&m->data, match_info, len);
+
+	if (match) {
+		if (match->print)
+			/* FIXME missing first parameter */
+			match->print(NULL, m, numeric);
+		else
+			printf("%s ", match_name);
+	} else {
+		if (match_name[0])
+			printf("UNKNOWN match `%s' ", match_name);
+	}
+
+	free(m);
+}
+
+int print_matches(struct nft_rule *r, int format)
+{
+	struct nft_rule_expr_iter *iter;
+	struct nft_rule_expr *expr;
+
+	iter = nft_rule_expr_iter_create(r);
+	if (iter == NULL)
+		return -ENOMEM;
+
+	expr = nft_rule_expr_iter_next(iter);
+	while (expr != NULL) {
+		const char *name =
+			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
+
+		if (strcmp(name, "match") == 0)
+			print_match(expr, format & FMT_NUMERIC);
+
+		expr = nft_rule_expr_iter_next(iter);
+	}
+	nft_rule_expr_iter_destroy(iter);
+
+	return 0;
+}
+
+int print_target(const char *targname, const void *targinfo,
+		 size_t target_len, int format)
+{
+	struct xtables_target *target;
+	struct xt_entry_target *t;
+
+	if (targname == NULL)
+		return 0;
+
+	t = calloc(1, sizeof(struct xt_entry_target) + target_len);
+	if (t == NULL)
+		return -ENOMEM;
+
+	/* emulate struct xt_entry_target since ->print needs it */
+	memcpy((void *)&t->data, targinfo, target_len);
+
+	target = xtables_find_target(targname, XTF_TRY_LOAD);
+	if (target) {
+		if (target->print)
+			/* FIXME missing first parameter */
+			target->print(NULL, t, format & FMT_NUMERIC);
+	} else
+		printf("[%ld bytes of unknown target data] ", target_len);
+
+	free(t);
+
+	return 0;
+}
+
 void print_num(uint64_t number, unsigned int format)
 {
 	if (format & FMT_KILOMEGAGIGA) {
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c59ab21..488ed63 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -48,9 +48,8 @@ struct nft_family_ops {
 			      struct iptables_command_state *cs,
 			      uint32_t offset);
 	void (*parse_immediate)(struct iptables_command_state *cs);
-	uint8_t (*print_firewall)(const struct iptables_command_state *cs,
-				  const char *targname, unsigned int num,
-				  unsigned int format);
+	void (*print_firewall)(struct nft_rule *r, unsigned int num,
+			       unsigned int format);
 	void (*post_parse)(int command, struct iptables_command_state *cs,
 			   struct xtables_args *args);
 };
@@ -80,10 +79,16 @@ bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
 void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		unsigned char *iniface_mask, char *outiface,
 		unsigned char *outiface_mask, uint8_t *invflags);
-
+const char *nft_parse_target(struct nft_rule *r, const void **targinfo,
+			     size_t *target_len);
 void print_proto(uint16_t proto, int invert);
 void get_cmp_data(struct nft_rule_expr_iter *iter,
 		  void *data, size_t dlen, bool *inv);
+void nft_rule_to_iptables_command_state(struct nft_rule *r,
+					struct iptables_command_state *cs);
+int print_matches(struct nft_rule *r, int format);
+int print_target(const char *targname, const void *targinfo,
+		 size_t target_len, int format);
 void print_num(uint64_t number, unsigned int format);
 void print_firewall_details(const struct iptables_command_state *cs,
 			    const char *targname, uint8_t flags,
diff --git a/iptables/nft.c b/iptables/nft.c
index 15c50a7..28e71d8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1661,108 +1661,6 @@ next:
 	return 0;
 }
 
-static void
-nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-	       int family, struct iptables_command_state *cs)
-{
-	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
-	struct nft_family_ops *ops = nft_family_ops_lookup(family);
-	const char *name;
-
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after meta\n");
-		return;
-	}
-
-	ops->parse_meta(e, key, cs);
-}
-
-static void
-nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  int family, struct iptables_command_state *cs)
-{
-	struct nft_family_ops *ops = nft_family_ops_lookup(family);
-	uint32_t offset;
-
-	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
-
-	ops->parse_payload(iter, cs, offset);
-}
-
-static void
-nft_parse_counter(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  struct xt_counters *counters)
-{
-	counters->pcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_PACKETS);
-	counters->bcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_BYTES);
-}
-
-static void
-nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		    int family, struct iptables_command_state *cs)
-{
-	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
-	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
-	struct nft_family_ops *ops;
-
-	/* Standard target? */
-	switch(verdict) {
-	case NF_ACCEPT:
-		cs->jumpto = "ACCEPT";
-		return;
-	case NF_DROP:
-		cs->jumpto = "DROP";
-		return;
-	case NFT_RETURN:
-		cs->jumpto = "RETURN";
-		return;
-	case NFT_GOTO:
-		ops = nft_family_ops_lookup(family);
-		ops->parse_immediate(cs);
-	case NFT_JUMP:
-		cs->jumpto = chain;
-		return;
-	}
-}
-
-static void
-nft_rule_to_iptables_command_state(struct nft_rule *r,
-				   struct iptables_command_state *cs)
-{
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
-
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "counter") == 0) {
-			nft_parse_counter(expr, iter, &cs->counters);
-		} else if (strcmp(name, "payload") == 0) {
-			nft_parse_payload(expr, iter, family, cs);
-		} else if (strcmp(name, "meta") == 0) {
-			nft_parse_meta(expr, iter, family, cs);
-		} else if (strcmp(name, "immediate") == 0) {
-			nft_parse_immediate(expr, iter, family, cs);
-		}
-
-		expr = nft_rule_expr_iter_next(iter);
-	}
-
-	nft_rule_expr_iter_destroy(iter);
-}
-
 static int matches_howmany(struct xtables_rule_match *matches)
 {
 	struct xtables_rule_match *matchp;
@@ -2289,146 +2187,6 @@ print_header(unsigned int format, const char *chain, const char *pol,
 	printf("\n");
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
-static void
-print_firewall(struct nft_rule *r, unsigned int num, unsigned int format)
-{
-	struct iptables_command_state cs = {};
-	const struct xtables_target *target = NULL;
-	const char *targname = NULL;
-	const void *targinfo = NULL;
-	int family;
-	struct nft_family_ops *ops;
-	uint8_t flags = 0;
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	struct xt_entry_target *t;
-	size_t target_len = 0;
-
-	nft_rule_to_iptables_command_state(r, &cs);
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
-
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "target") == 0) {
-			targname = nft_rule_expr_get_str(expr,
-							 NFT_EXPR_TG_NAME);
-			targinfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO,
-						     &target_len);
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
-	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
-	ops = nft_family_ops_lookup(family);
-
-	flags = ops->print_firewall(&cs, targname, num, format);
-
-	if (format & FMT_NOTABLE)
-		fputs("  ", stdout);
-
-#ifdef IPT_F_GOTO
-	if(flags & IPT_F_GOTO)
-		printf("[goto] ");
-#endif
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
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
-	t = calloc(1, sizeof(struct xt_entry_target) + target_len);
-	if (t == NULL)
-		return;
-
-	/* emulate struct xt_entry_match since ->print needs it */
-	memcpy((void *)&t->data, targinfo, target_len);
-
-	if (targname) {
-		target = xtables_find_target(targname, XTF_TRY_LOAD);
-		if (target) {
-			if (target->print)
-				/* FIXME missing first parameter */
-				target->print(NULL, t, format & FMT_NUMERIC);
-		} else
-			printf("[%ld bytes of unknown target data] ",
-				target_len);
-	}
-	free(t);
-
-	if (!(format & FMT_NONEWLINE))
-		fputc('\n', stdout);
-}
-
 static int
 __nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		int rulenum, unsigned int format,
@@ -2489,6 +2247,7 @@ err:
 int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		  int rulenum, unsigned int format)
 {
+	const struct nft_family_ops *ops;
 	struct nft_chain_list *list;
 	struct nft_chain_list_iter *iter;
 	struct nft_chain *c;
@@ -2498,9 +2257,11 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
 		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
 
+	ops = nft_family_ops_lookup(h->family);
+
 	if (chain && rulenum) {
 		__nft_rule_list(h, chain, table,
-				rulenum, format, print_firewall);
+				rulenum, format, ops->print_firewall);
 		return 1;
 	}
 
@@ -2541,7 +2302,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 				     &ctrs, basechain, refs);
 
 		__nft_rule_list(h, chain_name, table,
-				rulenum, format, print_firewall);
+				rulenum, format, ops->print_firewall);
 
 		/* we printed the chain we wanted, stop processing. */
 		if (chain)
-- 
1.8.3.2

