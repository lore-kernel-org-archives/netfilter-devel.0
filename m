From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [nf-gsoc2013] [iptables-compat PATCH] save: fix the printing of the counters
Date: Tue,  3 Jun 2014 09:46:44 +0200
Message-ID: <1401781604-3437-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64853 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaFCHow (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:44:52 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so6318322wgg.30
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 00:44:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch prints the counters of a rule before the details,
like iptables-save syntax.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c    | 14 ++++++++------
 iptables/nft-ipv4.c   | 11 +++++++++--
 iptables/nft-ipv6.c   | 12 ++++++++++--
 iptables/nft-shared.c | 18 ++++++++++--------
 iptables/nft-shared.h |  5 +++--
 iptables/nft.c        | 11 +++++++----
 6 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 562a1a2..dffdc94 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -599,12 +599,6 @@ static void nft_arp_save_firewall(const void *data,
 
 	print_fw_details((struct arpt_entry *)fw, format);
 
-	if (!(format & FMT_NOCOUNTS)) {
-		printf("-c ");
-		xtables_print_num(fw->counters.pcnt, format);
-		xtables_print_num(fw->counters.bcnt, format);
-	}
-
 	target = get_target((struct arpt_entry *)fw, format);
 
 	if (target) {
@@ -680,6 +674,13 @@ static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 	return true;
 }
 
+static void nft_arp_save_counters(const void *data, unsigned int format)
+{
+	const struct arpt_entry *fw = data;
+
+	save_counters(fw->counters.pcnt, fw->counters.bcnt, format);
+}
+
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
@@ -689,6 +690,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.parse_immediate	= nft_arp_parse_immediate,
 	.print_firewall		= nft_arp_print_firewall,
 	.save_firewall		= nft_arp_save_firewall,
+	.save_counters		= nft_arp_save_counters,
 	.post_parse		= NULL,
 	.rule_find		= nft_arp_rule_find,
 	.parse_target		= nft_arp_parse_target,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index d05e80e..c59a120 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -315,8 +315,7 @@ static void nft_ipv4_save_firewall(const void *data, unsigned int format)
 
 	save_firewall_details(cs, cs->fw.ip.invflags, cs->fw.ip.proto,
 			      cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
-			      cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
-			      format);
+			      cs->fw.ip.outiface, cs->fw.ip.outiface_mask);
 
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		if (cs->fw.ip.invflags & IPT_INV_FRAG)
@@ -409,6 +408,13 @@ static bool nft_ipv4_rule_find(struct nft_family_ops *ops,
 	return nft_ipv46_rule_find(ops, r, cs);
 }
 
+static void nft_ipv4_save_counters(const void *data, unsigned int format)
+{
+	const struct iptables_command_state *cs = data;
+
+	save_counters(cs->counters.pcnt, cs->counters.bcnt, format);
+}
+
 struct nft_family_ops nft_family_ops_ipv4 = {
 	.add			= nft_ipv4_add,
 	.is_same		= nft_ipv4_is_same,
@@ -417,6 +423,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.parse_immediate	= nft_ipv4_parse_immediate,
 	.print_firewall		= nft_ipv4_print_firewall,
 	.save_firewall		= nft_ipv4_save_firewall,
+	.save_counters		= nft_ipv4_save_counters,
 	.proto_parse		= nft_ipv4_proto_parse,
 	.post_parse		= nft_ipv4_post_parse,
 	.parse_target		= nft_ipv4_parse_target,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index f08598a..e00c1aa 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -222,8 +222,8 @@ static void nft_ipv6_save_firewall(const void *data, unsigned int format)
 
 	save_firewall_details(cs, cs->fw6.ipv6.invflags, cs->fw6.ipv6.proto,
 			      cs->fw6.ipv6.iniface, cs->fw6.ipv6.iniface_mask,
-			      cs->fw6.ipv6.outiface, cs->fw6.ipv6.outiface_mask,
-			      format);
+			      cs->fw6.ipv6.outiface,
+			      cs->fw6.ipv6.outiface_mask);
 
 	save_ipv6_addr('s', &cs->fw6.ipv6.src,
 		       cs->fw6.ipv6.invflags & IPT_INV_SRCIP);
@@ -330,6 +330,13 @@ static bool nft_ipv6_rule_find(struct nft_family_ops *ops,
 	return nft_ipv46_rule_find(ops, r, cs);
 }
 
+static void nft_ipv6_save_counters(const void *data, unsigned int format)
+{
+	const struct iptables_command_state *cs = data;
+
+	save_counters(cs->counters.pcnt, cs->counters.bcnt, format);
+}
+
 struct nft_family_ops nft_family_ops_ipv6 = {
 	.add			= nft_ipv6_add,
 	.is_same		= nft_ipv6_is_same,
@@ -338,6 +345,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.parse_immediate	= nft_ipv6_parse_immediate,
 	.print_firewall		= nft_ipv6_print_firewall,
 	.save_firewall		= nft_ipv6_save_firewall,
+	.save_counters		= nft_ipv6_save_counters,
 	.proto_parse		= nft_ipv6_proto_parse,
 	.post_parse		= nft_ipv6_post_parse,
 	.parse_target		= nft_ipv6_parse_target,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 09dd4f4..be6f276 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -601,15 +601,8 @@ void save_firewall_details(const struct iptables_command_state *cs,
 			   const char *iniface,
 			   unsigned const char *iniface_mask,
 			   const char *outiface,
-			   unsigned const char *outiface_mask,
-			   unsigned int format)
+			   unsigned const char *outiface_mask)
 {
-	if (!(format & FMT_NOCOUNTS)) {
-		printf("-c ");
-		xtables_print_num(cs->counters.pcnt, format);
-		xtables_print_num(cs->counters.bcnt, format);
-	}
-
 	if (iniface != NULL) {
 		print_iface('i', iniface, iniface_mask,
 			    invflags & IPT_INV_VIA_IN);
@@ -632,6 +625,15 @@ void save_firewall_details(const struct iptables_command_state *cs,
 	}
 }
 
+void save_counters(uint64_t pcnt, uint64_t bcnt, unsigned int format)
+{
+	printf("[");
+	xtables_print_num(pcnt, format);
+	printf(":");
+	xtables_print_num(bcnt, format);
+	printf("] ");
+}
+
 void save_matches_and_target(struct xtables_rule_match *m,
 			     struct xtables_target *target,
 			     const char *jumpto, uint8_t flags, const void *fw)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index ea11745..71fc8ae 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -50,6 +50,7 @@ struct nft_family_ops {
 	void (*print_firewall)(struct nft_rule *r, unsigned int num,
 			       unsigned int format);
 	void (*save_firewall)(const void *data, unsigned int format);
+	void (*save_counters)(const void *data, unsigned int format);
 	void (*proto_parse)(struct iptables_command_state *cs,
 			    struct xtables_args *args);
 	void (*post_parse)(int command, struct iptables_command_state *cs,
@@ -117,8 +118,8 @@ void save_firewall_details(const struct iptables_command_state *cs,
 			   const char *iniface,
 			   unsigned const char *iniface_mask,
 			   const char *outiface,
-			   unsigned const char *outiface_mask,
-			   unsigned int format);
+			   unsigned const char *outiface_mask);
+void save_counters(uint64_t pcnt, uint64_t bcnt, unsigned int format);
 void save_matches_and_target(struct xtables_rule_match *m,
 			     struct xtables_target *target,
 			     const char *jumpto,
diff --git a/iptables/nft.c b/iptables/nft.c
index 26942d8..1157646 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -939,8 +939,8 @@ int add_counters(struct nft_rule *r, uint64_t packets, uint64_t bytes)
 	if (expr == NULL)
 		return -ENOMEM;
 
-	nft_rule_expr_set_u64(expr, NFT_EXPR_CTR_BYTES, packets);
-	nft_rule_expr_set_u64(expr, NFT_EXPR_CTR_PACKETS, bytes);
+	nft_rule_expr_set_u64(expr, NFT_EXPR_CTR_PACKETS, packets);
+	nft_rule_expr_set_u64(expr, NFT_EXPR_CTR_BYTES, bytes);
 
 	nft_rule_add_expr(r, expr);
 
@@ -1048,6 +1048,11 @@ nft_rule_print_save(const void *data,
 	int family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 	struct nft_family_ops *ops;
 
+	ops = nft_family_ops_lookup(family);
+
+	if (!(format & FMT_NOCOUNTS) && ops->save_counters)
+		ops->save_counters(data, format);
+
 	/* print chain name */
 	switch(type) {
 	case NFT_RULE_APPEND:
@@ -1058,8 +1063,6 @@ nft_rule_print_save(const void *data,
 		break;
 	}
 
-	ops = nft_family_ops_lookup(family);
-
 	if (ops->save_firewall)
 		ops->save_firewall(data, format);
 
-- 
1.8.3.2

