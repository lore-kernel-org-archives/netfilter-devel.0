From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH 1/1 v4] nft: refactoring parse operations for more genericity
Date: Wed,  4 Sep 2013 14:36:41 +0200
Message-ID: <1378298201-10814-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37475 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3IDMgm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:36:42 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so140281ead.30
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Sep 2013 05:36:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will allow reusing nft_parse_* function for other family than IPv4
or IPv6.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-ipv4.c   |   27 ++++++++++++++++++++++-----
 iptables/nft-ipv6.c   |   26 +++++++++++++++++++++-----
 iptables/nft-shared.c |   43 +++++++++++++++++++++++++------------------
 iptables/nft-shared.h |    8 ++++----
 4 files changed, 72 insertions(+), 32 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index a08df71..b7a6095 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -148,17 +148,20 @@ static const char *mask_to_str(uint32_t mask)
 }
 
 static void nft_ipv4_parse_meta(struct nft_rule_expr *e, uint8_t key,
-				struct iptables_command_state *cs)
+				void *data)
 {
+	struct iptables_command_state *cs = data;
+
 	parse_meta(e, key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
 		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
 		   &cs->fw.ip.invflags);
 }
 
 static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
-				   struct iptables_command_state *cs,
-				   uint32_t offset)
+				   uint32_t offset, void *data)
 {
+	struct iptables_command_state *cs = data;
+
 	switch(offset) {
 	struct in_addr addr;
 	uint8_t proto;
@@ -196,9 +199,15 @@ static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
 	}
 }
 
-static void nft_ipv4_parse_immediate(struct iptables_command_state *cs)
+static void nft_ipv4_parse_immediate(const char *jumpto, bool nft_goto,
+				     void *data)
 {
-	cs->fw.ip.flags |= IPT_F_GOTO;
+	struct iptables_command_state *cs = data;
+
+	cs->jumpto = jumpto;
+
+	if (nft_goto)
+		cs->fw.ip.flags |= IPT_F_GOTO;
 }
 
 static void print_ipv4_addr(const struct iptables_command_state *cs,
@@ -351,6 +360,13 @@ static void nft_ipv4_post_parse(int command,
 			      " source or destination IP addresses");
 }
 
+static void nft_ipv4_parse_target(struct xtables_target *t, void *data)
+{
+	struct iptables_command_state *cs = data;
+
+	cs->target = t;
+}
+
 struct nft_family_ops nft_family_ops_ipv4 = {
 	.add			= nft_ipv4_add,
 	.is_same		= nft_ipv4_is_same,
@@ -360,4 +376,5 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.print_firewall		= nft_ipv4_print_firewall,
 	.save_firewall		= nft_ipv4_save_firewall,
 	.post_parse		= nft_ipv4_post_parse,
+	.parse_target		= nft_ipv4_parse_target,
 };
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 9bb5798..27e63a4 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -70,17 +70,19 @@ static bool nft_ipv6_is_same(const struct iptables_command_state *a,
 }
 
 static void nft_ipv6_parse_meta(struct nft_rule_expr *e, uint8_t key,
-				struct iptables_command_state *cs)
+				void *data)
 {
+	struct iptables_command_state *cs = data;
+
 	parse_meta(e, key, cs->fw6.ipv6.iniface,
 		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
 		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags);
 }
 
 static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
-				   struct iptables_command_state *cs,
-				   uint32_t offset)
+				   uint32_t offset, void *data)
 {
+	struct iptables_command_state *cs = data;
 	switch (offset) {
 	struct in6_addr addr;
 	uint8_t proto;
@@ -110,9 +112,15 @@ static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
 	}
 }
 
-static void nft_ipv6_parse_immediate(struct iptables_command_state *cs)
+static void nft_ipv6_parse_immediate(const char *jumpto, bool nft_goto,
+				     void *data)
 {
-	cs->fw6.ipv6.flags |= IPT_F_GOTO;
+	struct iptables_command_state *cs = data;
+
+	cs->jumpto = jumpto;
+
+	if (nft_goto)
+		cs->fw6.ipv6.flags |= IPT_F_GOTO;
 }
 
 static void print_ipv6_addr(const struct iptables_command_state *cs,
@@ -274,6 +282,13 @@ static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
 			      " source or destination IP addresses");
 }
 
+static void nft_ipv6_parse_target(struct xtables_target *t, void *data)
+{
+	struct iptables_command_state *cs = data;
+
+	cs->target = t;
+}
+
 struct nft_family_ops nft_family_ops_ipv6 = {
 	.add			= nft_ipv6_add,
 	.is_same		= nft_ipv6_is_same,
@@ -283,4 +298,5 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.print_firewall		= nft_ipv6_print_firewall,
 	.save_firewall		= nft_ipv6_save_firewall,
 	.post_parse		= nft_ipv6_post_parse,
+	.parse_target		= nft_ipv6_parse_target,
 };
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 9e57b36..cdc3f83 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -283,13 +283,14 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 
 static void
 nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		 struct iptables_command_state *cs)
+		 int family, void *data)
 {
 	size_t tg_len;
 	const char *targname = nft_rule_expr_get_str(e, NFT_EXPR_TG_NAME);
 	const void *targinfo = nft_rule_expr_get(e, NFT_EXPR_TG_INFO, &tg_len);
 	struct xtables_target *target;
 	struct xt_entry_target *t;
+	struct nft_family_ops *ops;
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
 	if (target == NULL)
@@ -306,7 +307,9 @@ nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	strcpy(t->u.user.name, target->name);
 
 	target->t = t;
-	cs->target = target;
+
+	ops = nft_family_ops_lookup(family);
+	ops->parse_target(target, data);
 }
 
 static void
@@ -380,7 +383,7 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 
 static void
 nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-	       int family, struct iptables_command_state *cs)
+	       int family, void *data)
 {
 	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
 	struct nft_family_ops *ops = nft_family_ops_lookup(family);
@@ -396,19 +399,19 @@ nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		return;
 	}
 
-	ops->parse_meta(e, key, cs);
+	ops->parse_meta(e, key, data);
 }
 
 static void
 nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  int family, struct iptables_command_state *cs)
+		  int family, void *data)
 {
 	struct nft_family_ops *ops = nft_family_ops_lookup(family);
 	uint32_t offset;
 
 	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
 
-	ops->parse_payload(iter, cs, offset);
+	ops->parse_payload(iter, offset, data);
 }
 
 static void
@@ -421,30 +424,34 @@ nft_parse_counter(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 
 static void
 nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		    int family, struct iptables_command_state *cs)
+		    int family, void *data)
 {
 	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
 	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
 	struct nft_family_ops *ops;
+	const char *jumpto;
+	bool nft_goto = false;
 
 	/* Standard target? */
 	switch(verdict) {
 	case NF_ACCEPT:
-		cs->jumpto = "ACCEPT";
-		return;
+		jumpto = "ACCEPT";
+		break;
 	case NF_DROP:
-		cs->jumpto = "DROP";
-		return;
+		jumpto = "DROP";
+		break;
 	case NFT_RETURN:
-		cs->jumpto = "RETURN";
-		return;
+		jumpto = "RETURN";
+		break;;
 	case NFT_GOTO:
-		ops = nft_family_ops_lookup(family);
-		ops->parse_immediate(cs);
+		nft_goto = true;
 	case NFT_JUMP:
-		cs->jumpto = chain;
-		return;
+		jumpto = chain;
+		break;
 	}
+
+	ops = nft_family_ops_lookup(family);
+	ops->parse_immediate(jumpto, nft_goto, data);
 }
 
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
@@ -474,7 +481,7 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 		else if (strcmp(name, "match") == 0)
 			nft_parse_match(expr, iter, cs);
 		else if (strcmp(name, "target") == 0)
-			nft_parse_target(expr, iter, cs);
+			nft_parse_target(expr, iter, family, cs);
 
 		expr = nft_rule_expr_iter_next(iter);
 	}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 861b6db..ed2617c 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -43,17 +43,17 @@ struct nft_family_ops {
 	void (*print_payload)(struct nft_rule_expr *e,
 			      struct nft_rule_expr_iter *iter);
 	void (*parse_meta)(struct nft_rule_expr *e, uint8_t key,
-			   struct iptables_command_state *cs);
+			   void *data);
 	void (*parse_payload)(struct nft_rule_expr_iter *iter,
-			      struct iptables_command_state *cs,
-			      uint32_t offset);
-	void (*parse_immediate)(struct iptables_command_state *cs);
+			      uint32_t offset, void *data);
+	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
 	void (*print_firewall)(struct nft_rule *r, unsigned int num,
 			       unsigned int format);
 	uint8_t (*save_firewall)(const struct iptables_command_state *cs,
 				 unsigned int format);
 	void (*post_parse)(int command, struct iptables_command_state *cs,
 			   struct xtables_args *args);
+	void (*parse_target)(struct xtables_target *t, void *data);
 };
 
 void add_meta(struct nft_rule *r, uint32_t key);
-- 
1.7.8.6

