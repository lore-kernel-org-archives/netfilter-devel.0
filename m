Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89728C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244080AbiAKPFY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbiAKPFY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:05:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486EDC06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:05:24 -0800 (PST)
Received: from localhost ([::1]:59136 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7IiA-0007Xp-KM; Tue, 11 Jan 2022 16:05:22 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 06/11] xtables: Do not pass nft_handle to do_parse()
Date:   Tue, 11 Jan 2022 16:04:24 +0100
Message-Id: <20220111150429.29110-7-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make it fit for sharing with legacy iptables, drop nft-specific
parameter. This requires to mirror proto_parse and post_parse callbacks
from family_ops somewhere reachable - use xt_cmd_parse, it holds other
"parser setup data" as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Introduce struct xt_cmd_parse_ops holding the commandline parsing
  callbacks.
---
 iptables/nft-arp.c           |  2 +-
 iptables/nft-bridge.c        |  1 -
 iptables/nft-ipv4.c          |  6 ++++--
 iptables/nft-ipv6.c          |  6 ++++--
 iptables/nft-shared.h        | 40 ++--------------------------------
 iptables/xshared.h           | 42 ++++++++++++++++++++++++++++++++++++
 iptables/xtables-translate.c |  3 ++-
 iptables/xtables.c           | 12 ++++++-----
 8 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index b211a30937db3..ba696c6a6a123 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -802,7 +802,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.print_rule		= nft_arp_print_rule,
 	.save_rule		= nft_arp_save_rule,
 	.save_chain		= nft_arp_save_chain,
-	.post_parse		= nft_arp_post_parse,
+	.cmd_parse.post_parse	= nft_arp_post_parse,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
 	.clear_cs		= nft_clear_iptables_command_state,
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 5cde302c4f189..90d55e441ab95 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -900,7 +900,6 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.print_rule		= nft_bridge_print_rule,
 	.save_rule		= nft_bridge_save_rule,
 	.save_chain		= nft_bridge_save_chain,
-	.post_parse		= NULL,
 	.rule_to_cs		= nft_rule_to_ebtables_command_state,
 	.clear_cs		= ebt_cs_clean,
 	.xlate			= nft_bridge_xlate,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index f36260980e829..07da0a7edb3ac 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -510,8 +510,10 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.print_rule		= nft_ipv4_print_rule,
 	.save_rule		= nft_ipv4_save_rule,
 	.save_chain		= nft_ipv46_save_chain,
-	.proto_parse		= nft_ipv4_proto_parse,
-	.post_parse		= nft_ipv4_post_parse,
+	.cmd_parse		= {
+		.proto_parse	= nft_ipv4_proto_parse,
+		.post_parse	= nft_ipv4_post_parse,
+	},
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 132130880a43a..4f80ed841f95c 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -495,8 +495,10 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.print_rule		= nft_ipv6_print_rule,
 	.save_rule		= nft_ipv6_save_rule,
 	.save_chain		= nft_ipv46_save_chain,
-	.proto_parse		= nft_ipv6_proto_parse,
-	.post_parse		= nft_ipv6_post_parse,
+	.cmd_parse		= {
+		.proto_parse	= nft_ipv6_proto_parse,
+		.post_parse	= nft_ipv6_post_parse,
+	},
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 4948aef761d10..195e5fed43075 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -100,10 +100,7 @@ struct nft_family_ops {
 			   unsigned int num, unsigned int format);
 	void (*save_rule)(const void *data, unsigned int format);
 	void (*save_chain)(const struct nftnl_chain *c, const char *policy);
-	void (*proto_parse)(struct iptables_command_state *cs,
-			    struct xtables_args *args);
-	void (*post_parse)(int command, struct iptables_command_state *cs,
-			   struct xtables_args *args);
+	struct xt_cmd_parse_ops cmd_parse;
 	void (*parse_match)(struct xtables_match *m, void *data);
 	void (*parse_target)(struct xtables_target *t, void *data);
 	void (*init_cs)(struct iptables_command_state *cs);
@@ -177,40 +174,7 @@ void nft_ipv46_parse_target(struct xtables_target *t, void *data);
 bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
 
-struct addr_mask {
-	union {
-		struct in_addr	*v4;
-		struct in6_addr *v6;
-		void *ptr;
-	} addr;
-
-	unsigned int naddrs;
-
-	union {
-		struct in_addr	*v4;
-		struct in6_addr *v6;
-		void *ptr;
-	} mask;
-};
-
-struct xtables_args {
-	int		family;
-	uint16_t	proto;
-	uint8_t		flags;
-	uint16_t	invflags;
-	char		iniface[IFNAMSIZ], outiface[IFNAMSIZ];
-	unsigned char	iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
-	bool		goto_set;
-	const char	*shostnetworkmask, *dhostnetworkmask;
-	const char	*pcnt, *bcnt;
-	struct addr_mask s, d;
-	const char	*src_mac, *dst_mac;
-	const char	*arp_hlen, *arp_opcode;
-	const char	*arp_htype, *arp_ptype;
-	unsigned long long pcnt_cnt, bcnt_cnt;
-};
-
-void do_parse(struct nft_handle *h, int argc, char *argv[],
+void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args);
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index dde94b7335f6a..34730be6ce004 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -262,6 +262,47 @@ int print_match_save(const struct xt_entry_match *e, const void *ip);
 void xtables_printhelp(const struct xtables_rule_match *matches);
 void exit_tryhelp(int status, int line) __attribute__((noreturn));
 
+struct addr_mask {
+	union {
+		struct in_addr	*v4;
+		struct in6_addr *v6;
+		void *ptr;
+	} addr;
+
+	unsigned int naddrs;
+
+	union {
+		struct in_addr	*v4;
+		struct in6_addr *v6;
+		void *ptr;
+	} mask;
+};
+
+struct xtables_args {
+	int		family;
+	uint16_t	proto;
+	uint8_t		flags;
+	uint16_t	invflags;
+	char		iniface[IFNAMSIZ], outiface[IFNAMSIZ];
+	unsigned char	iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
+	bool		goto_set;
+	const char	*shostnetworkmask, *dhostnetworkmask;
+	const char	*pcnt, *bcnt;
+	struct addr_mask s, d;
+	const char	*src_mac, *dst_mac;
+	const char	*arp_hlen, *arp_opcode;
+	const char	*arp_htype, *arp_ptype;
+	unsigned long long pcnt_cnt, bcnt_cnt;
+};
+
+struct xt_cmd_parse_ops {
+	void	(*proto_parse)(struct iptables_command_state *cs,
+			       struct xtables_args *args);
+	void	(*post_parse)(int command,
+			      struct iptables_command_state *cs,
+			      struct xtables_args *args);
+};
+
 struct xt_cmd_parse {
 	unsigned int			command;
 	unsigned int			rulenum;
@@ -272,6 +313,7 @@ struct xt_cmd_parse {
 	bool				restore;
 	int				verbose;
 	bool				xlate;
+	struct xt_cmd_parse_ops		*ops;
 };
 
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 9d312b244657e..c287d3bdc75e0 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -252,6 +252,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		.table		= *table,
 		.restore	= restore,
 		.xlate		= true,
+		.ops		= &h->ops->cmd_parse,
 	};
 	struct iptables_command_state cs = {
 		.jumpto = "",
@@ -265,7 +266,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	if (h->ops->init_cs)
 		h->ops->init_cs(&cs);
 
-	do_parse(h, argc, argv, &p, &cs, &args);
+	do_parse(argc, argv, &p, &cs, &args);
 
 	cs.restore = restore;
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 5e8c027b8471e..59fc63d0fee86 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -186,7 +186,7 @@ static void check_inverse(struct xtables_args *args, const char option[],
 	}
 }
 
-void do_parse(struct nft_handle *h, int argc, char *argv[],
+void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
 {
@@ -382,8 +382,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					   "rule would never match protocol");
 
 			/* This needs to happen here to parse extensions */
-			if (h->ops->proto_parse)
-				h->ops->proto_parse(cs, args);
+			if (p->ops->proto_parse)
+				p->ops->proto_parse(cs, args);
 			break;
 
 		case 's':
@@ -653,7 +653,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-	h->ops->post_parse(p->command, cs, args);
+	if (p->ops->post_parse)
+		p->ops->post_parse(p->command, cs, args);
 
 	if (p->command == CMD_REPLACE &&
 	    (args->s.naddrs != 1 || args->d.naddrs != 1))
@@ -702,6 +703,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	struct xt_cmd_parse p = {
 		.table		= *table,
 		.restore	= restore,
+		.ops		= &h->ops->cmd_parse,
 	};
 	struct iptables_command_state cs = {
 		.jumpto = "",
@@ -714,7 +716,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	if (h->ops->init_cs)
 		h->ops->init_cs(&cs);
 
-	do_parse(h, argc, argv, &p, &cs, &args);
+	do_parse(argc, argv, &p, &cs, &args);
 
 	if (!nft_table_builtin_find(h, p.table))
 		xtables_error(VERSION_PROBLEM,
-- 
2.34.1

