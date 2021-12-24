Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D783C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 17:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353288AbhLXRSh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 12:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhLXRSh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 12:18:37 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9538C061401
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 09:18:36 -0800 (PST)
Received: from localhost ([::1]:59094 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n0oDD-0004ww-3p; Fri, 24 Dec 2021 18:18:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/11] xtables: Do not pass nft_handle to do_parse()
Date:   Fri, 24 Dec 2021 18:17:49 +0100
Message-Id: <20211224171754.14210-7-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211224171754.14210-1-phil@nwl.cc>
References: <20211224171754.14210-1-phil@nwl.cc>
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
 iptables/nft-shared.h        | 35 +--------------------------------
 iptables/xshared.h           | 38 ++++++++++++++++++++++++++++++++++++
 iptables/xtables-translate.c |  4 +++-
 iptables/xtables.c           | 13 +++++++-----
 4 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 4948aef761d10..7396fa991439f 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -177,40 +177,7 @@ void nft_ipv46_parse_target(struct xtables_target *t, void *data);
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
index dde94b7335f6a..1954168f64058 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -262,6 +262,39 @@ int print_match_save(const struct xt_entry_match *e, const void *ip);
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
 struct xt_cmd_parse {
 	unsigned int			command;
 	unsigned int			rulenum;
@@ -272,6 +305,11 @@ struct xt_cmd_parse {
 	bool				restore;
 	int				verbose;
 	bool				xlate;
+	void		(*proto_parse)(struct iptables_command_state *cs,
+				       struct xtables_args *args);
+	void		(*post_parse)(int command,
+				      struct iptables_command_state *cs,
+				      struct xtables_args *args);
 };
 
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 9d312b244657e..b0b27695cbb8c 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -252,6 +252,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		.table		= *table,
 		.restore	= restore,
 		.xlate		= true,
+		.proto_parse	= h->ops->proto_parse,
+		.post_parse	= h->ops->post_parse,
 	};
 	struct iptables_command_state cs = {
 		.jumpto = "",
@@ -265,7 +267,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	if (h->ops->init_cs)
 		h->ops->init_cs(&cs);
 
-	do_parse(h, argc, argv, &p, &cs, &args);
+	do_parse(argc, argv, &p, &cs, &args);
 
 	cs.restore = restore;
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 5e8c027b8471e..d7e22285e089e 100644
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
+			if (p->proto_parse)
+				p->proto_parse(cs, args);
 			break;
 
 		case 's':
@@ -653,7 +653,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-	h->ops->post_parse(p->command, cs, args);
+	if (p->post_parse)
+		p->post_parse(p->command, cs, args);
 
 	if (p->command == CMD_REPLACE &&
 	    (args->s.naddrs != 1 || args->d.naddrs != 1))
@@ -702,6 +703,8 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	struct xt_cmd_parse p = {
 		.table		= *table,
 		.restore	= restore,
+		.proto_parse	= h->ops->proto_parse,
+		.post_parse	= h->ops->post_parse,
 	};
 	struct iptables_command_state cs = {
 		.jumpto = "",
@@ -714,7 +717,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	if (h->ops->init_cs)
 		h->ops->init_cs(&cs);
 
-	do_parse(h, argc, argv, &p, &cs, &args);
+	do_parse(argc, argv, &p, &cs, &args);
 
 	if (!nft_table_builtin_find(h, p.table))
 		xtables_error(VERSION_PROBLEM,
-- 
2.34.1

