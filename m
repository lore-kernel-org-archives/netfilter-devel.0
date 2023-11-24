Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="L4C0VWNW"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB79D6E
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CtQtsJi9gLwu/T9txZuqCh6FZphINHH/zbgHdtOUNpc=; b=L4C0VWNWQqQ0+Y6yUbRWKLAdjP
	rIjFkhwJEl0iTqyZPkP1qN43ShyYCUYMwWNSI30GsYSlKHiRK+4jQfQbH6FllB8B7yCtx2c9JkaiO
	stl0D/WD1d3wwN+Hsm1aGqAmyoRHpbjD2IOb/v442QqebfAw4EUvYPKnR+lCehZaQQe0oQtEhyqhX
	aLTPOcMSjk2AI3nDpHfS+aongh5D8+WyYmThe7vi2pVC5le7DFVHtAAs2pu9GtvgQCs5teP9xB+Yx
	G230poG5y3HKge2zBbI7Rj+GEGo5EBlFfEI+zZfj4vG9YFIN4eZNn3xaz+xllXV+PhIQZj6oPhLpy
	sSxUa8HQ==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6Tyq-0002J3-Cf
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:04:16 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] xshared: Introduce xt_cmd_parse_ops::option_name
Date: Fri, 24 Nov 2023 12:13:23 +0100
Message-ID: <20231124111325.5221-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231124111325.5221-1-phil@nwl.cc>
References: <20231124111325.5221-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old opt2char() function was flawed: Since not every field in
optflags contains a printable character, typical use of its return value
in print statements could lead to garbage on screen.

Replace this by a mechanism to retrieve an option's long name which
supports family-specific overrides. and get rid of optflags field
altogether and define NUMBER_OF_OPT similar to NUMBER_OF_CMD.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c |   1 +
 iptables/iptables.c  |   1 +
 iptables/nft-arp.c   |  18 ++++++
 iptables/nft-ipv4.c  |   1 +
 iptables/nft-ipv6.c  |   1 +
 iptables/xshared.c   | 140 +++++++++++++++++++++++--------------------
 iptables/xshared.h   |   4 ++
 7 files changed, 100 insertions(+), 66 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 9afc32c1a21ed..85cb211d2ec12 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -669,6 +669,7 @@ int do_command6(int argc, char *argv[], char **table,
 	struct xt_cmd_parse_ops cmd_parse_ops = {
 		.proto_parse	= ipv6_proto_parse,
 		.post_parse	= ipv6_post_parse,
+		.option_name	= ip46t_option_name,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 6f7b34762ea40..4bfce62dd5d86 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -663,6 +663,7 @@ int do_command4(int argc, char *argv[], char **table,
 	struct xt_cmd_parse_ops cmd_parse_ops = {
 		.proto_parse	= ipv4_proto_parse,
 		.post_parse	= ipv4_post_parse,
+		.option_name	= ip46t_option_name,
 	};
 	struct xt_cmd_parse p = {
 		.table		= *table,
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 38b2ab3993128..6f8e1952db3b8 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -815,6 +815,23 @@ static int nft_arp_xlate(const struct iptables_command_state *cs,
 	return xlate_action(cs, false, xl);
 }
 
+static const char *nft_arp_option_name(int option)
+{
+	switch (option) {
+	default:		return ip46t_option_name(option);
+	/* different name than iptables */
+	case OPT_SOURCE:	return "--source-ip";
+	case OPT_DESTINATION:	return "--destination-ip";
+	/* arptables specific ones */
+	case OPT_S_MAC:		return "--source-mac";
+	case OPT_D_MAC:		return "--destination-mac";
+	case OPT_H_LENGTH:	return "--h-length";
+	case OPT_OPCODE:	return "--opcode";
+	case OPT_H_TYPE:	return "--h-type";
+	case OPT_P_TYPE:	return "--proto-type";
+	}
+}
+
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
@@ -826,6 +843,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.rule_parse		= &nft_ruleparse_ops_arp,
 	.cmd_parse		= {
 		.post_parse	= nft_arp_post_parse,
+		.option_name	= nft_arp_option_name,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 75912847aea3e..166680b3eb07c 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -353,6 +353,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.cmd_parse		= {
 		.proto_parse	= ipv4_proto_parse,
 		.post_parse	= ipv4_post_parse,
+		.option_name	= ip46t_option_name,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 5aef365b79f2a..2cc45944f6c04 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -344,6 +344,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.cmd_parse		= {
 		.proto_parse	= ipv6_proto_parse,
 		.post_parse	= ipv6_post_parse,
+		.option_name	= ip46t_option_name,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 1b02f35a9de3a..31a3019592317 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -920,10 +920,6 @@ static int parse_rulenumber(const char *rule)
 	return rulenum;
 }
 
-#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
-static const char optflags[]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f', 2, 3, 'l', 4, 5, 6 };
-
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
  * CMD_LIST and CMD_ZERO only).
@@ -953,7 +949,8 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' ',' ',' ',' ',' ',' ',' '},
 };
 
-static void generic_opt_check(int command, int options)
+static void generic_opt_check(struct xt_cmd_parse_ops *ops,
+			      int command, int options)
 {
 	int i, j, legal = 0;
 
@@ -971,8 +968,8 @@ static void generic_opt_check(int command, int options)
 			if (!(options & (1<<i))) {
 				if (commands_v_options[j][i] == '+')
 					xtables_error(PARAMETER_PROBLEM,
-						      "You need to supply the `-%c' option for this command",
-						      optflags[i]);
+						      "You need to supply the `%s' option for this command",
+						      ops->option_name(1<<i));
 			} else {
 				if (commands_v_options[j][i] != 'x')
 					legal = 1;
@@ -982,19 +979,28 @@ static void generic_opt_check(int command, int options)
 		}
 		if (legal == -1)
 			xtables_error(PARAMETER_PROBLEM,
-				      "Illegal option `-%c' with this command",
-				      optflags[i]);
+				      "Illegal option `%s' with this command",
+				      ops->option_name(1<<i));
 	}
 }
 
-static char opt2char(int option)
+const char *ip46t_option_name(int option)
 {
-	const char *ptr;
-
-	for (ptr = optflags; option > 1; option >>= 1, ptr++)
-		;
-
-	return *ptr;
+	switch (option) {
+	case OPT_NUMERIC:	return "--numeric";
+	case OPT_SOURCE:	return "--source";
+	case OPT_DESTINATION:	return "--destination";
+	case OPT_PROTOCOL:	return "--protocol";
+	case OPT_JUMP:		return "--jump";
+	case OPT_VERBOSE:	return "--verbose";
+	case OPT_EXPANDED:	return "--exact";
+	case OPT_VIANAMEIN:	return "--in-interface";
+	case OPT_VIANAMEOUT:	return "--out-interface";
+	case OPT_LINENUMBERS:	return "--line-numbers";
+	case OPT_COUNTERS:	return "--set-counters";
+	case OPT_FRAGMENT:	return "--fragments";
+	default:		return "unknown option";
+	}
 }
 
 static const int inverse_for_options[NUMBER_OF_OPT] =
@@ -1020,12 +1026,14 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 };
 
 static void
-set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
-	   bool invert)
+set_option(struct xt_cmd_parse_ops *ops,
+	   unsigned int *options, unsigned int option,
+	   uint16_t *invflg, bool invert)
 {
 	if (*options & option)
-		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
-			   opt2char(option));
+		xtables_error(PARAMETER_PROBLEM,
+			      "multiple %s options not allowed",
+			      ops->option_name(option));
 	*options |= option;
 
 	if (invert) {
@@ -1034,8 +1042,8 @@ set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
 
 		if (!inverse_for_options[i])
 			xtables_error(PARAMETER_PROBLEM,
-				   "cannot have ! before -%c",
-				   opt2char(option));
+				      "cannot have ! before %s",
+				      ops->option_name(option));
 		*invflg |= inverse_for_options[i];
 	}
 }
@@ -1543,7 +1551,7 @@ void do_parse(int argc, char *argv[],
 			 */
 		case 'p':
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_PROTOCOL,
+			set_option(p->ops, &cs->options, OPT_PROTOCOL,
 				   &args->invflags, invert);
 
 			/* Canonicalize into lower case */
@@ -1566,22 +1574,22 @@ void do_parse(int argc, char *argv[],
 
 		case 's':
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_SOURCE,
+			set_option(p->ops, &cs->options, OPT_SOURCE,
 				   &args->invflags, invert);
 			args->shostnetworkmask = optarg;
 			break;
 
 		case 'd':
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_DESTINATION,
+			set_option(p->ops, &cs->options, OPT_DESTINATION,
 				   &args->invflags, invert);
 			args->dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
 		case 'g':
-			set_option(&cs->options, OPT_JUMP, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_JUMP,
+				   &args->invflags, invert);
 			args->goto_set = true;
 			cs->jumpto = xt_parse_target(optarg);
 			break;
@@ -1589,22 +1597,22 @@ void do_parse(int argc, char *argv[],
 
 		case 2:/* src-mac */
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_S_MAC, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_S_MAC,
+				   &args->invflags, invert);
 			args->src_mac = optarg;
 			break;
 
 		case 3:/* dst-mac */
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_D_MAC, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_D_MAC,
+				   &args->invflags, invert);
 			args->dst_mac = optarg;
 			break;
 
 		case 'l':/* hardware length */
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_H_LENGTH, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_H_LENGTH,
+				   &args->invflags, invert);
 			args->arp_hlen = optarg;
 			break;
 
@@ -1612,28 +1620,28 @@ void do_parse(int argc, char *argv[],
 			xtables_error(PARAMETER_PROBLEM, "not supported");
 		case 4:/* opcode */
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_OPCODE, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_OPCODE,
+				   &args->invflags, invert);
 			args->arp_opcode = optarg;
 			break;
 
 		case 5:/* h-type */
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_H_TYPE, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_H_TYPE,
+				   &args->invflags, invert);
 			args->arp_htype = optarg;
 			break;
 
 		case 6:/* proto-type */
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_P_TYPE, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_P_TYPE,
+				   &args->invflags, invert);
 			args->arp_ptype = optarg;
 			break;
 
 		case 'j':
-			set_option(&cs->options, OPT_JUMP, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_JUMP,
+				   &args->invflags, invert);
 			if (strcmp(optarg, "CONTINUE"))
 				command_jump(cs, optarg);
 			break;
@@ -1641,7 +1649,7 @@ void do_parse(int argc, char *argv[],
 		case 'i':
 			check_empty_interface(args, optarg);
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_VIANAMEIN,
+			set_option(p->ops, &cs->options, OPT_VIANAMEIN,
 				   &args->invflags, invert);
 			xtables_parse_interface(optarg,
 						args->iniface,
@@ -1651,7 +1659,7 @@ void do_parse(int argc, char *argv[],
 		case 'o':
 			check_empty_interface(args, optarg);
 			check_inverse(args, optarg, &invert, argc, argv);
-			set_option(&cs->options, OPT_VIANAMEOUT,
+			set_option(p->ops, &cs->options, OPT_VIANAMEOUT,
 				   &args->invflags, invert);
 			xtables_parse_interface(optarg,
 						args->outiface,
@@ -1664,14 +1672,14 @@ void do_parse(int argc, char *argv[],
 					"`-f' is not supported in IPv6, "
 					"use -m frag instead");
 			}
-			set_option(&cs->options, OPT_FRAGMENT, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_FRAGMENT,
+				   &args->invflags, invert);
 			args->flags |= IPT_F_FRAG;
 			break;
 
 		case 'v':
 			if (!p->verbose)
-				set_option(&cs->options, OPT_VERBOSE,
+				set_option(p->ops, &cs->options, OPT_VERBOSE,
 					   &args->invflags, invert);
 			p->verbose++;
 			break;
@@ -1681,8 +1689,8 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'n':
-			set_option(&cs->options, OPT_NUMERIC, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_NUMERIC,
+				   &args->invflags, invert);
 			break;
 
 		case 't':
@@ -1698,8 +1706,8 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'x':
-			set_option(&cs->options, OPT_EXPANDED, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_EXPANDED,
+				   &args->invflags, invert);
 			break;
 
 		case 'V':
@@ -1734,7 +1742,7 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case '0':
-			set_option(&cs->options, OPT_LINENUMBERS,
+			set_option(p->ops, &cs->options, OPT_LINENUMBERS,
 				   &args->invflags, invert);
 			break;
 
@@ -1743,8 +1751,8 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'c':
-			set_option(&cs->options, OPT_COUNTERS, &args->invflags,
-				   invert);
+			set_option(p->ops, &cs->options, OPT_COUNTERS,
+				   &args->invflags, invert);
 			args->pcnt = optarg;
 			args->bcnt = strchr(args->pcnt + 1, ',');
 			if (args->bcnt)
@@ -1753,18 +1761,18 @@ void do_parse(int argc, char *argv[],
 				args->bcnt = argv[optind++];
 			if (!args->bcnt)
 				xtables_error(PARAMETER_PROBLEM,
-					"-%c requires packet and byte counter",
-					opt2char(OPT_COUNTERS));
+					      "%s requires packet and byte counter",
+					      p->ops->option_name(OPT_COUNTERS));
 
 			if (sscanf(args->pcnt, "%llu", &args->pcnt_cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
-					"-%c packet counter not numeric",
-					opt2char(OPT_COUNTERS));
+					      "%s packet counter not numeric",
+					      p->ops->option_name(OPT_COUNTERS));
 
 			if (sscanf(args->bcnt, "%llu", &args->bcnt_cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
-					"-%c byte counter not numeric",
-					opt2char(OPT_COUNTERS));
+					      "%s byte counter not numeric",
+					      p->ops->option_name(OPT_COUNTERS));
 			break;
 
 		case '4':
@@ -1837,7 +1845,7 @@ void do_parse(int argc, char *argv[],
 	if (p->ops->post_parse)
 		p->ops->post_parse(p->command, cs, args);
 
-	generic_opt_check(p->command, cs->options);
+	generic_opt_check(p->ops, p->command, cs->options);
 
 	if (p->chain != NULL && strlen(p->chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
@@ -1855,9 +1863,9 @@ void do_parse(int argc, char *argv[],
 			/* -o not valid with incoming packets. */
 			if (cs->options & OPT_VIANAMEOUT)
 				xtables_error(PARAMETER_PROBLEM,
-					   "Can't use -%c with %s\n",
-					   opt2char(OPT_VIANAMEOUT),
-					   p->chain);
+					      "Can't use %s with %s\n",
+					      p->ops->option_name(OPT_VIANAMEOUT),
+					      p->chain);
 		}
 
 		if (strcmp(p->chain, "POSTROUTING") == 0
@@ -1865,9 +1873,9 @@ void do_parse(int argc, char *argv[],
 			/* -i not valid with outgoing packets */
 			if (cs->options & OPT_VIANAMEIN)
 				xtables_error(PARAMETER_PROBLEM,
-					   "Can't use -%c with %s\n",
-					   opt2char(OPT_VIANAMEIN),
-					   p->chain);
+					      "Can't use %s with %s\n",
+					      p->ops->option_name(OPT_VIANAMEIN),
+					      p->chain);
 		}
 	}
 }
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 815b9d3e98726..2470acbb46b7d 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -50,6 +50,7 @@ enum {
 	OPT_COMMAND	= 1 << 20,
 	OPT_ZERO	= 1 << 21,
 };
+#define NUMBER_OF_OPT	23
 
 enum {
 	CMD_NONE		= 0,
@@ -272,6 +273,7 @@ struct xt_cmd_parse_ops {
 	void	(*post_parse)(int command,
 			      struct iptables_command_state *cs,
 			      struct xtables_args *args);
+	const char *(*option_name)(int option);
 };
 
 struct xt_cmd_parse {
@@ -287,6 +289,8 @@ struct xt_cmd_parse {
 	struct xt_cmd_parse_ops		*ops;
 };
 
+const char *ip46t_option_name(int option);
+
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args);
-- 
2.41.0

