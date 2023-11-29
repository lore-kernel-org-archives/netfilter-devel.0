Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TZNufhOU"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D144183
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MXhZiKWs9aEGuU+Hm2AHA6xKwhX6CWZQjFa2POpo/KE=; b=TZNufhOUNkCZCl08LhPfeq1mZ6
	Ov9pbYGInfaUPM547qMB0G/gFWUEJx9kHt8ebM7SUjs2cZRHBeyYkFAmlsGt/EN9QnE6qDxHHYRrQ
	X2RIxvnu11OoVC9w8oOUS3MKE0/94AKrZ7wvachN8ortENA7lVzRl+FAzdvzzY9bLexmH/65nPEro
	kNwhMipUocQdLc9Z9zNsccYjpnfYkhuIdt/6SU6caYKhnOZe/utsQoeWEIArECfdGVfWabPGBn6AH
	wQDWAJIvMvxzOlPZJwyZ1h9VUI0qsPUZKV5jzQC+Vj2hYOut2bTvLSH5qQJUWy2q5bsqbrsYqALLT
	/lWSUtWQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPg-0001ih-M0
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 13/13] ebtables: Use do_parse() from xshared
Date: Wed, 29 Nov 2023 14:28:27 +0100
Message-ID: <20231129132827.18166-14-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the custom commandline parsers from ebtables and
ebtables-translate, extend and use the shared one instead.

ebtables gains a few new features from doing this:

- Rule counters may be specified in the '-c N,M' syntax
- Support for --replace command
- Support for --list-rules command
- Zero individual rules

There is one known regression in this patch, namely maximum chain name
length shrinks to 28 characters (from 32). Since this limit changed for
iptables in the past as well (e.g. with commit 5429b41c2bb4a), assume
nobody really relies upon it anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c           | 121 ++++++
 iptables/nft-bridge.h           |  13 +-
 iptables/nft.h                  |   1 -
 iptables/xshared.c              |  71 +++-
 iptables/xshared.h              |  17 +-
 iptables/xtables-eb-translate.c | 477 +++------------------
 iptables/xtables-eb.c           | 720 ++++----------------------------
 7 files changed, 341 insertions(+), 1079 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 1fcdeaf2cad68..60d5f4d0ba1b1 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -571,11 +571,132 @@ static int nft_bridge_xlate(const struct iptables_command_state *cs,
 	return ret;
 }
 
+static const char *nft_bridge_option_name(int option)
+{
+	switch (option) {
+	/* ebtables specific ones */
+	case OPT_LOGICALIN:	return "--logical-in";
+	case OPT_LOGICALOUT:	return "--logical-out";
+	case OPT_LINENUMBERS:	return "--Ln";
+	case OPT_LIST_C:	return "--Lc";
+	case OPT_LIST_X:	return "--Lx";
+	case OPT_LIST_MAC2:	return "--Lmac2";
+	default:		return ip46t_option_name(option);
+	}
+}
+
+static int nft_bridge_option_invert(int option)
+{
+	switch (option) {
+	case OPT_SOURCE:	return EBT_ISOURCE;
+	case OPT_DESTINATION:	return EBT_IDEST;
+	case OPT_PROTOCOL:	return EBT_IPROTO;
+	case OPT_VIANAMEIN:	return EBT_IIN;
+	case OPT_VIANAMEOUT:	return EBT_IOUT;
+	case OPT_LOGICALIN:	return EBT_ILOGICALIN;
+	case OPT_LOGICALOUT:	return EBT_ILOGICALOUT;
+	default:		return -1;
+	}
+}
+
+static void nft_bridge_proto_parse(struct iptables_command_state *cs,
+				   struct xtables_args *args)
+{
+	char *buffer;
+	int i;
+
+	cs->eb.bitmask &= ~((unsigned int)EBT_NOPROTO);
+
+	i = strtol(cs->protocol, &buffer, 16);
+	if (*buffer == '\0' && (i < 0 || i > 0xFFFF))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Problem with the specified protocol");
+	if (*buffer != '\0') {
+		struct xt_ethertypeent *ent;
+
+		if (!strcmp(cs->protocol, "length")) {
+			cs->eb.bitmask |= EBT_802_3;
+			return;
+		}
+		ent = xtables_getethertypebyname(cs->protocol);
+		if (!ent)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with the specified Ethernet protocol '%s', perhaps "XT_PATH_ETHERTYPES " is missing",
+				      cs->protocol);
+		cs->eb.ethproto = ent->e_ethertype;
+	} else
+		cs->eb.ethproto = i;
+
+	if (cs->eb.ethproto < 0x0600)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Sorry, protocols have values above or equal to 0x0600");
+}
+
+static void nft_bridge_post_parse(int command,
+				  struct iptables_command_state *cs,
+				  struct xtables_args *args)
+{
+	struct ebt_match *match;
+
+	cs->eb.invflags = args->invflags;
+
+	memcpy(cs->eb.in, args->iniface, IFNAMSIZ);
+	memcpy(cs->eb.out, args->outiface, IFNAMSIZ);
+	memcpy(cs->eb.logical_in, args->bri_iniface, IFNAMSIZ);
+	memcpy(cs->eb.logical_out, args->bri_outiface, IFNAMSIZ);
+
+	cs->counters.pcnt = args->pcnt_cnt;
+	cs->counters.bcnt = args->bcnt_cnt;
+
+	if (args->shostnetworkmask) {
+		if (xtables_parse_mac_and_mask(args->shostnetworkmask,
+					       cs->eb.sourcemac,
+					       cs->eb.sourcemsk))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with specified source mac '%s'",
+				      args->shostnetworkmask);
+		cs->eb.bitmask |= EBT_SOURCEMAC;
+	}
+	if (args->dhostnetworkmask) {
+		if (xtables_parse_mac_and_mask(args->dhostnetworkmask,
+					       cs->eb.destmac,
+					       cs->eb.destmsk))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with specified destination mac '%s'",
+				      args->dhostnetworkmask);
+		cs->eb.bitmask |= EBT_DESTMAC;
+	}
+
+	if ((cs->options & (OPT_LIST_X | OPT_LINENUMBERS)) ==
+			(OPT_LIST_X | OPT_LINENUMBERS))
+		xtables_error(PARAMETER_PROBLEM,
+			      "--Lx is not compatible with --Ln");
+
+	/* So, the extensions can work with the host endian.
+	 * The kernel does not have to do this of course */
+	cs->eb.ethproto = htons(cs->eb.ethproto);
+
+	for (match = cs->match_list; match; match = match->next) {
+		if (match->ismatch)
+			continue;
+
+		xtables_option_tfcall(match->u.watcher);
+	}
+}
+
 struct nft_family_ops nft_family_ops_bridge = {
 	.add			= nft_bridge_add,
 	.is_same		= nft_bridge_is_same,
 	.print_payload		= NULL,
 	.rule_parse		= &nft_ruleparse_ops_bridge,
+	.cmd_parse		= {
+		.proto_parse	= nft_bridge_proto_parse,
+		.post_parse	= nft_bridge_post_parse,
+		.option_name	= nft_bridge_option_name,
+		.option_invert	= nft_bridge_option_invert,
+		.command_default = ebt_command_default,
+		.print_help	= nft_bridge_print_help,
+	},
 	.print_table_header	= nft_bridge_print_table_header,
 	.print_header		= nft_bridge_print_header,
 	.print_rule		= nft_bridge_print_rule,
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index 0e6a29650acca..13b077fc4fbf3 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -8,13 +8,6 @@
 #include <net/ethernet.h>
 #include <libiptc/libxtc.h>
 
-/* We use replace->flags, so we can't use the following values:
- * 0x01 == OPT_COMMAND, 0x02 == OPT_TABLE, 0x100 == OPT_ZERO */
-#define LIST_N	  0x04
-#define LIST_C	  0x08
-#define LIST_X	  0x10
-#define LIST_MAC2 0x20
-
 extern unsigned char eb_mac_type_unicast[ETH_ALEN];
 extern unsigned char eb_msk_type_unicast[ETH_ALEN];
 extern unsigned char eb_mac_type_multicast[ETH_ALEN];
@@ -119,7 +112,8 @@ void ebt_add_match(struct xtables_match *m,
 			  struct iptables_command_state *cs);
 void ebt_add_watcher(struct xtables_target *watcher,
                      struct iptables_command_state *cs);
-int ebt_command_default(struct iptables_command_state *cs);
+int ebt_command_default(struct iptables_command_state *cs,
+			struct xtables_globals *unused, bool ebt_invert);
 
 struct nft_among_pair {
 	struct ether_addr ether;
@@ -177,4 +171,7 @@ nft_among_insert_pair(struct nft_among_pair *pairs,
 	(*pcount)++;
 }
 
+/* from xtables-eb.c */
+void nft_bridge_print_help(struct iptables_command_state *cs);
+
 #endif
diff --git a/iptables/nft.h b/iptables/nft.h
index 79f1e037cd6d3..57533b6529f5b 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -234,7 +234,6 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table, bo
 /* For xtables-eb.c */
 int nft_init_eb(struct nft_handle *h, const char *pname);
 void nft_fini_eb(struct nft_handle *h);
-int ebt_get_current_chain(const char *chain);
 int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table, bool restore);
 
 /*
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ebe172223486e..5cae62b45cdf4 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -957,6 +957,11 @@ static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
 /*OPT_OPCODE*/		CMD_IDRAC,
 /*OPT_H_TYPE*/		CMD_IDRAC,
 /*OPT_P_TYPE*/		CMD_IDRAC,
+/*OPT_LOGICALIN*/	CMD_IDRAC,
+/*OPT_LOGICALOUT*/	CMD_IDRAC,
+/*OPT_LIST_C*/		CMD_LIST,
+/*OPT_LIST_X*/		CMD_LIST,
+/*OPT_LIST_MAC2*/	CMD_LIST,
 };
 #undef CMD_IDRAC
 
@@ -1301,6 +1306,7 @@ static void check_inverse(struct xtables_args *args, const char option[],
 {
 	switch (args->family) {
 	case NFPROTO_ARP:
+	case NFPROTO_BRIDGE:
 		break;
 	default:
 		return;
@@ -1499,6 +1505,8 @@ void do_parse(int argc, char *argv[],
 				parse_change_counters_rule(argc, argv, p, args);
 				break;
 			}
+			/* fall through */
+		case 14: /* ebtables --check */
 			add_command(&p->command, CMD_CHECK, CMD_NONE, invert);
 			p->chain = optarg;
 			break;
@@ -1606,15 +1614,19 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'P':
-			add_command(&p->command, CMD_SET_POLICY, CMD_NONE,
+			add_command(&p->command, CMD_SET_POLICY,
+				    family_is_bridge ? CMD_NEW_CHAIN : CMD_NONE,
 				    invert);
-			p->chain = optarg;
-			if (xs_has_arg(argc, argv))
+			if (p->command & CMD_NEW_CHAIN) {
+				p->policy = optarg;
+			} else if (xs_has_arg(argc, argv)) {
+				p->chain = optarg;
 				p->policy = argv[optind++];
-			else
+			} else {
 				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires a chain and a policy",
 					   cmd2char(CMD_SET_POLICY));
+			}
 			break;
 
 		case 'h':
@@ -1716,6 +1728,45 @@ void do_parse(int argc, char *argv[],
 			args->arp_ptype = optarg;
 			break;
 
+		case 11: /* ebtables --init-table */
+			if (p->restore)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--init-table is not supported in daemon mode");
+			add_command(&p->command, CMD_INIT_TABLE, CMD_NONE, invert);
+			break;
+
+		case 12 : /* ebtables --Lmac2 */
+			set_option(p->ops, &cs->options, OPT_LIST_MAC2,
+				   &args->invflags, invert);
+			break;
+
+		case 13 : /* ebtables --concurrent */
+			break;
+
+		case 15 : /* ebtables --logical-in */
+			check_inverse(args, optarg, &invert, argc, argv);
+			set_option(p->ops, &cs->options, OPT_LOGICALIN,
+				   &args->invflags, invert);
+			parse_interface(optarg, args->bri_iniface);
+			break;
+
+		case 16 : /* ebtables --logical-out */
+			check_inverse(args, optarg, &invert, argc, argv);
+			set_option(p->ops, &cs->options, OPT_LOGICALOUT,
+				   &args->invflags, invert);
+			parse_interface(optarg, args->bri_outiface);
+			break;
+
+		case 17 : /* ebtables --Lc */
+			set_option(p->ops, &cs->options, OPT_LIST_C,
+				   &args->invflags, invert);
+			break;
+
+		case 19 : /* ebtables --Lx */
+			set_option(p->ops, &cs->options, OPT_LIST_X,
+				   &args->invflags, invert);
+			break;
+
 		case 'j':
 			set_option(p->ops, &cs->options, OPT_JUMP,
 				   &args->invflags, invert);
@@ -1815,6 +1866,7 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case '0':
+		case 18 : /* ebtables --Ln */
 			set_option(p->ops, &cs->options, OPT_LINENUMBERS,
 				   &args->invflags, invert);
 			break;
@@ -1880,6 +1932,7 @@ void do_parse(int argc, char *argv[],
 			exit_tryhelp(2, p->line);
 
 		default:
+			check_inverse(args, optarg, &invert, argc, argv);
 			if (p->ops->command_default(cs, xt_params, invert))
 				/* cf. ip6tables.c */
 				continue;
@@ -1888,7 +1941,8 @@ void do_parse(int argc, char *argv[],
 		invert = false;
 	}
 
-	if (strcmp(p->table, "nat") == 0 &&
+	if (!family_is_bridge &&
+	    strcmp(p->table, "nat") == 0 &&
 	    ((p->policy != NULL && strcmp(p->policy, "DROP") == 0) ||
 	    (cs->jumpto != NULL && strcmp(cs->jumpto, "DROP") == 0)))
 		xtables_error(PARAMETER_PROBLEM,
@@ -1929,17 +1983,22 @@ void do_parse(int argc, char *argv[],
 	    p->command == CMD_DELETE ||
 	    p->command == CMD_CHECK ||
 	    p->command == CMD_INSERT ||
-	    p->command == CMD_REPLACE) {
+	    p->command == CMD_REPLACE ||
+	    p->command == CMD_CHANGE_COUNTERS) {
 		if (strcmp(p->chain, "PREROUTING") == 0
 		    || strcmp(p->chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
 			option_test_and_reject(p, cs, OPT_VIANAMEOUT);
+			/* same with --logical-out */
+			option_test_and_reject(p, cs, OPT_LOGICALOUT);
 		}
 
 		if (strcmp(p->chain, "POSTROUTING") == 0
 		    || strcmp(p->chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
 			option_test_and_reject(p, cs, OPT_VIANAMEIN);
+			/* same with --logical-in */
+			option_test_and_reject(p, cs, OPT_LOGICALIN);
 		}
 	}
 }
diff --git a/iptables/xshared.h b/iptables/xshared.h
index de32198fa0b67..2a9cdf45f581a 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -47,10 +47,11 @@ enum {
 	/* below are for ebtables only */
 	OPT_LOGICALIN	= 1 << 18,
 	OPT_LOGICALOUT	= 1 << 19,
-	OPT_COMMAND	= 1 << 20,
-	OPT_ZERO	= 1 << 21,
+	OPT_LIST_C	= 1 << 20,
+	OPT_LIST_X	= 1 << 21,
+	OPT_LIST_MAC2	= 1 << 22,
 };
-#define NUMBER_OF_OPT	23
+#define NUMBER_OF_OPT	24
 
 enum {
 	CMD_NONE		= 0,
@@ -70,16 +71,17 @@ enum {
 	CMD_ZERO_NUM		= 1 << 13,
 	CMD_CHECK		= 1 << 14,
 	CMD_CHANGE_COUNTERS	= 1 << 15, /* ebtables only */
+	CMD_INIT_TABLE		= 1 << 16, /* ebtables only */
 };
-#define NUMBER_OF_CMD		17
+#define NUMBER_OF_CMD		18
 
 struct xtables_globals;
 struct xtables_rule_match;
 struct xtables_target;
 
-#define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:VX::Z::" "c:d:i:j:o:p:s:t:v"
-#define IPT_OPTSTRING	OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nw::x"
-#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nx" /* "m:" */
+#define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:R:S::VX::Z::" "c:d:i:j:o:p:s:t:v"
+#define IPT_OPTSTRING	OPTSTRING_COMMON "W::" "46bfg:h::m:nw::x"
+#define ARPT_OPTSTRING	OPTSTRING_COMMON "h::l:nx" /* "m:" */
 #define EBT_OPTSTRING	OPTSTRING_COMMON "h"
 
 /* define invflags which won't collide with IPT ones.
@@ -262,6 +264,7 @@ struct xtables_args {
 	uint16_t	invflags;
 	char		iniface[IFNAMSIZ], outiface[IFNAMSIZ];
 	unsigned char	iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
+	char		bri_iniface[IFNAMSIZ], bri_outiface[IFNAMSIZ];
 	bool		goto_set;
 	const char	*shostnetworkmask, *dhostnetworkmask;
 	const char	*pcnt, *bcnt;
diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index a2ab318cff251..fbeff74f7fbb0 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -21,61 +21,10 @@
 #include "nft-bridge.h"
 #include "nft.h"
 #include "nft-shared.h"
-/*
- * From include/ebtables_u.h
- */
-#define ebt_check_option2(flags, mask) EBT_CHECK_OPTION(flags, mask)
 
-extern int ebt_invert;
-
-static int ebt_check_inverse2(const char option[], int argc, char **argv)
-{
-	if (!option)
-		return ebt_invert;
-	if (strcmp(option, "!") == 0) {
-		if (ebt_invert == 1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Double use of '!' not allowed");
-		if (optind >= argc)
-			optarg = NULL;
-		else
-			optarg = argv[optind];
-		optind++;
-		ebt_invert = 1;
-		return 1;
-	}
-	return ebt_invert;
-}
-
-/*
- * Glue code to use libxtables
- */
-static int parse_rule_number(const char *rule)
-{
-	unsigned int rule_nr;
-
-	if (!xtables_strtoui(rule, NULL, &rule_nr, 1, INT_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			      "Invalid rule number `%s'", rule);
-
-	return rule_nr;
-}
-
-/*
- * The original ebtables parser
- */
-
-/* Checks whether a command has already been specified */
-#define OPT_COMMANDS (flags & OPT_COMMAND || flags & OPT_ZERO)
-
-/* Default command line options. Do not mess around with the already
- * assigned numbers unless you know what you are doing */
-extern struct option ebt_original_options[];
-#define opts ebtables_globals.opts
 #define prog_name ebtables_globals.program_name
-#define prog_vers ebtables_globals.program_version
 
-static void print_help(void)
+static void print_help(struct iptables_command_state *cs)
 {
 	fprintf(stderr, "%s: Translate ebtables command to nft syntax\n"
 			"no side effects occur, the translated command is written "
@@ -85,46 +34,6 @@ static void print_help(void)
 	exit(0);
 }
 
-static int parse_rule_range(const char *argv, int *rule_nr, int *rule_nr_end)
-{
-	char *colon = strchr(argv, ':'), *buffer;
-
-	if (colon) {
-		*colon = '\0';
-		if (*(colon + 1) == '\0')
-			*rule_nr_end = -1; /* Until the last rule */
-		else {
-			*rule_nr_end = strtol(colon + 1, &buffer, 10);
-			if (*buffer != '\0' || *rule_nr_end == 0)
-				return -1;
-		}
-	}
-	if (colon == argv)
-		*rule_nr = 1; /* Beginning with the first rule */
-	else {
-		*rule_nr = strtol(argv, &buffer, 10);
-		if (*buffer != '\0' || *rule_nr == 0)
-			return -1;
-	}
-	if (!colon)
-		*rule_nr_end = *rule_nr;
-	return 0;
-}
-
-static void ebtables_parse_interface(const char *arg, char *vianame)
-{
-	unsigned char mask[IFNAMSIZ];
-	char *c;
-
-	xtables_parse_interface(arg, vianame, mask);
-
-	if ((c = strchr(vianame, '+'))) {
-		if (*(c + 1) != '\0')
-			xtables_error(PARAMETER_PROBLEM,
-				      "Spurious characters after '+' wildcard");
-	}
-}
-
 static void print_ebt_cmd(int argc, char *argv[])
 {
 	int i;
@@ -158,347 +67,35 @@ static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct xt_cmd_parse
 
 static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char **table)
 {
-	char *buffer;
-	int c, i;
-	int rule_nr = 0;
-	int rule_nr_end = 0;
-	int ret = 0;
-	unsigned int flags = 0;
 	struct iptables_command_state cs = {
 		.argv		= argv,
+		.jumpto		= "",
 		.eb.bitmask	= EBT_NOPROTO,
 	};
-	char command = 'h';
-	const char *chain = NULL;
-	int selected_chain = -1;
-	struct xtables_rule_match *xtrm_i;
-	struct ebt_match *match;
 	struct xt_cmd_parse p = {
 		.table          = *table,
+		.rule_ranges	= true,
+		.ops		= &h->ops->cmd_parse,
         };
-	bool table_set = false;
-
-	/* prevent getopt to spoil our error reporting */
-	opterr = false;
-
-	printf("nft ");
-	/* Getopt saves the day */
-	while ((c = getopt_long(argc, argv,
-	   "-:A:D:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", opts, NULL)) != -1) {
-		cs.c = c;
-		switch (c) {
-		case 'A': /* Add a rule */
-		case 'D': /* Delete a rule */
-		case 'P': /* Define policy */
-		case 'I': /* Insert a rule */
-		case 'N': /* Make a user defined chain */
-		case 'E': /* Rename chain */
-		case 'X': /* Delete chain */
-			/* We allow -N chainname -P policy */
-			/* XXX: Not in ebtables-compat */
-			if (command == 'N' && c == 'P') {
-				command = c;
-				optind--; /* No table specified */
-				break;
-			}
-			if (OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple commands are not allowed");
-			command = c;
-			chain = optarg;
-			selected_chain = ebt_get_current_chain(chain);
-			p.chain = chain;
-			flags |= OPT_COMMAND;
-
-			if (c == 'N') {
-				printf("add chain bridge %s %s\n", p.table, p.chain);
-				ret = 1;
-				break;
-			} else if (c == 'X') {
-				printf("delete chain bridge %s %s\n", p.table, p.chain);
-				ret = 1;
-				break;
-			}
-
-			if (c == 'E') {
-				break;
-			} else if (c == 'D' && optind < argc && (argv[optind][0] != '-' || (argv[optind][1] >= '0' && argv[optind][1] <= '9'))) {
-				if (optind != argc - 1)
-					xtables_error(PARAMETER_PROBLEM,
-							 "No extra options allowed with -D start_nr[:end_nr]");
-				if (parse_rule_range(argv[optind], &rule_nr, &rule_nr_end))
-					xtables_error(PARAMETER_PROBLEM,
-							 "Problem with the specified rule number(s) '%s'", argv[optind]);
-				optind++;
-			} else if (c == 'I') {
-				if (optind >= argc || (argv[optind][0] == '-' && (argv[optind][1] < '0' || argv[optind][1] > '9')))
-					rule_nr = 1;
-				else {
-					rule_nr = parse_rule_number(argv[optind]);
-					optind++;
-				}
-				p.rulenum = rule_nr;
-			} else if (c == 'P') {
-				break;
-			}
-			break;
-		case 'L': /* List */
-			printf("list table bridge %s\n", p.table);
-			ret = 1;
-			break;
-		case 'F': /* Flush */
-		case 'Z': /* Zero counters */
-			if (c == 'Z') {
-				if ((flags & OPT_ZERO) || (flags & OPT_COMMAND && command != 'L'))
-print_zero:
-					xtables_error(PARAMETER_PROBLEM,
-						      "Command -Z only allowed together with command -L");
-				flags |= OPT_ZERO;
-			} else {
-				if (flags & OPT_COMMAND)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Multiple commands are not allowed");
-				command = c;
-				flags |= OPT_COMMAND;
-				if (flags & OPT_ZERO && c != 'L')
-					goto print_zero;
-			}
-			break;
-		case 'V': /* Version */
-			if (OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple commands are not allowed");
-			printf("%s %s\n", prog_name, prog_vers);
-			exit(0);
-		case 'h':
-			if (OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple commands are not allowed");
-			print_help();
-			break;
-		case 't': /* Table */
-			if (OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Please put the -t option first");
-			if (table_set)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple use of same option not allowed");
-			if (strlen(optarg) > EBT_TABLE_MAXNAMELEN - 1)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Table name length cannot exceed %d characters",
-					      EBT_TABLE_MAXNAMELEN - 1);
-			*table = optarg;
-			p.table = optarg;
-			table_set = true;
-			break;
-		case 'i': /* Input interface */
-		case 15 : /* Logical input interface */
-		case 'o': /* Output interface */
-		case 16 : /* Logical output interface */
-		case 'j': /* Target */
-		case 'p': /* Net family protocol */
-		case 's': /* Source mac */
-		case 'd': /* Destination mac */
-		case 'c': /* Set counters */
-			if (!OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "No command specified");
-			if (command != 'A' && command != 'D' && command != 'I')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Command and option do not match");
-			if (c == 'i') {
-				ebt_check_option2(&flags, OPT_VIANAMEIN);
-				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use -i only in INPUT, FORWARD, PREROUTING and BROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_IIN;
-
-				ebtables_parse_interface(optarg, cs.eb.in);
-				break;
-			} else if (c == 15) {
-				ebt_check_option2(&flags, OPT_LOGICALIN);
-				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use --logical-in only in INPUT, FORWARD, PREROUTING and BROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_ILOGICALIN;
-
-				ebtables_parse_interface(optarg, cs.eb.logical_in);
-				break;
-			} else if (c == 'o') {
-				ebt_check_option2(&flags, OPT_VIANAMEOUT);
-				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use -o only in OUTPUT, FORWARD and POSTROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_IOUT;
-
-				ebtables_parse_interface(optarg, cs.eb.out);
-				break;
-			} else if (c == 16) {
-				ebt_check_option2(&flags, OPT_LOGICALOUT);
-				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use --logical-out only in OUTPUT, FORWARD and POSTROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_ILOGICALOUT;
-
-				ebtables_parse_interface(optarg, cs.eb.logical_out);
-				break;
-			} else if (c == 'j') {
-				ebt_check_option2(&flags, OPT_JUMP);
-				if (strcmp(optarg, "CONTINUE") != 0) {
-					command_jump(&cs, optarg);
-				}
-				break;
-			} else if (c == 's') {
-				ebt_check_option2(&flags, OPT_SOURCE);
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_ISOURCE;
-
-				if (xtables_parse_mac_and_mask(optarg,
-							       cs.eb.sourcemac,
-							       cs.eb.sourcemsk))
-					xtables_error(PARAMETER_PROBLEM, "Problem with specified source mac '%s'", optarg);
-				cs.eb.bitmask |= EBT_SOURCEMAC;
-				break;
-			} else if (c == 'd') {
-				ebt_check_option2(&flags, OPT_DESTINATION);
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_IDEST;
-
-				if (xtables_parse_mac_and_mask(optarg,
-							       cs.eb.destmac,
-							       cs.eb.destmsk))
-					xtables_error(PARAMETER_PROBLEM, "Problem with specified destination mac '%s'", optarg);
-				cs.eb.bitmask |= EBT_DESTMAC;
-				break;
-			} else if (c == 'c') {
-				ebt_check_option2(&flags, OPT_COUNTERS);
-				if (ebt_check_inverse2(optarg, argc, argv))
-					xtables_error(PARAMETER_PROBLEM,
-						      "Unexpected '!' after -c");
-				if (optind >= argc || optarg[0] == '-' || argv[optind][0] == '-')
-					xtables_error(PARAMETER_PROBLEM,
-						      "Option -c needs 2 arguments");
-
-				cs.counters.pcnt = strtoull(optarg, &buffer, 10);
-				if (*buffer != '\0')
-					xtables_error(PARAMETER_PROBLEM,
-						      "Packet counter '%s' invalid",
-						      optarg);
-				cs.counters.bcnt = strtoull(argv[optind], &buffer, 10);
-				if (*buffer != '\0')
-					xtables_error(PARAMETER_PROBLEM,
-						      "Packet counter '%s' invalid",
-						      argv[optind]);
-				optind++;
-				break;
-			}
-			ebt_check_option2(&flags, OPT_PROTOCOL);
-			if (ebt_check_inverse2(optarg, argc, argv))
-				cs.eb.invflags |= EBT_IPROTO;
+	struct xtables_args args = {
+		.family	= h->family,
+	};
+	int ret = 0;
 
-			cs.eb.bitmask &= ~((unsigned int)EBT_NOPROTO);
-			i = strtol(optarg, &buffer, 16);
-			if (*buffer == '\0' && (i < 0 || i > 0xFFFF))
-				xtables_error(PARAMETER_PROBLEM,
-					      "Problem with the specified protocol");
-			if (*buffer != '\0') {
-				struct xt_ethertypeent *ent;
+	p.ops->print_help = print_help;
 
-				if (!strcasecmp(optarg, "LENGTH")) {
-					cs.eb.bitmask |= EBT_802_3;
-					break;
-				}
-				ent = xtables_getethertypebyname(optarg);
-				if (!ent)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Problem with the specified Ethernet protocol '%s', perhaps "XT_PATH_ETHERTYPES " is missing", optarg);
-				cs.eb.ethproto = ent->e_ethertype;
-			} else
-				cs.eb.ethproto = i;
+	do_parse(argc, argv, &p, &cs, &args);
 
-			if (cs.eb.ethproto < 0x0600)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Sorry, protocols have values above or equal to 0x0600");
-			break;
-		case 17 : /* Lc */
-			ebt_check_option2(&flags, LIST_C);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Use --Lc with -L");
-			flags |= LIST_C;
-			break;
-		case 18 : /* Ln */
-			ebt_check_option2(&flags, LIST_N);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Use --Ln with -L");
-			if (flags & LIST_X)
-				xtables_error(PARAMETER_PROBLEM,
-					      "--Lx is not compatible with --Ln");
-			flags |= LIST_N;
-			break;
-		case 19 : /* Lx */
-			ebt_check_option2(&flags, LIST_X);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Use --Lx with -L");
-			if (flags & LIST_N)
-				xtables_error(PARAMETER_PROBLEM,
-					      "--Lx is not compatible with --Ln");
-			flags |= LIST_X;
-			break;
-		case 12 : /* Lmac2 */
-			ebt_check_option2(&flags, LIST_MAC2);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					       "Use --Lmac2 with -L");
-			flags |= LIST_MAC2;
-			break;
-		case 1 :
-			if (!strcmp(optarg, "!"))
-				ebt_check_inverse2(optarg, argc, argv);
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					      "Bad argument : '%s'", optarg);
-			/* ebt_ebt_check_inverse2() did optind++ */
-			optind--;
-			continue;
-		default:
-			ebt_check_inverse2(optarg, argc, argv);
-			ebt_command_default(&cs);
-
-			if (command != 'A' && command != 'I' &&
-			    command != 'D')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Extensions only for -A, -I, -D");
-		}
-		ebt_invert = 0;
-	}
+	h->verbose	= p.verbose;
 
 	/* Do the final checks */
-	if (command == 'A' || command == 'I' || command == 'D') {
-		for (xtrm_i = cs.matches; xtrm_i; xtrm_i = xtrm_i->next)
-			xtables_option_mfcall(xtrm_i->match);
-
-		for (match = cs.match_list; match; match = match->next) {
-			if (match->ismatch)
-				continue;
+	if (!nft_table_builtin_find(h, p.table))
+		xtables_error(VERSION_PROBLEM,
+			      "table '%s' does not exist", p.table);
 
-			xtables_option_tfcall(match->u.watcher);
-		}
-
-		if (cs.target != NULL)
-			xtables_option_tfcall(cs.target);
-	}
-
-	cs.eb.ethproto = htons(cs.eb.ethproto);
-
-	switch (command) {
-	case 'F':
+	printf("nft ");
+	switch (p.command) {
+	case CMD_FLUSH:
 		if (p.chain) {
 			printf("flush chain bridge %s %s\n", p.table, p.chain);
 		} else {
@@ -506,16 +103,52 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 		}
 		ret = 1;
 		break;
-	case 'A':
+	case CMD_APPEND:
 		ret = nft_rule_eb_xlate_add(h, &p, &cs, true);
 		if (!ret)
 			print_ebt_cmd(argc, argv);
 		break;
-	case 'I':
+	case CMD_INSERT:
 		ret = nft_rule_eb_xlate_add(h, &p, &cs, false);
 		if (!ret)
 			print_ebt_cmd(argc, argv);
 		break;
+	case CMD_LIST:
+		printf("list table bridge %s\n", p.table);
+		ret = 1;
+		break;
+	case CMD_NEW_CHAIN:
+		printf("add chain bridge %s %s\n", p.table, p.chain);
+		ret = 1;
+		break;
+	case CMD_DELETE_CHAIN:
+		printf("delete chain bridge %s %s\n", p.table, p.chain);
+		ret = 1;
+		break;
+	case CMD_INIT_TABLE:
+		printf("flush table bridge %s\n", p.table);
+		ret = 1;
+		break;
+	case CMD_DELETE:
+	case CMD_DELETE_NUM:
+	case CMD_CHECK:
+	case CMD_REPLACE:
+	case CMD_ZERO:
+	case CMD_ZERO_NUM:
+	case CMD_LIST|CMD_ZERO:
+	case CMD_LIST|CMD_ZERO_NUM:
+	case CMD_LIST_RULES:
+	case CMD_LIST_RULES|CMD_ZERO:
+	case CMD_LIST_RULES|CMD_ZERO_NUM:
+	case CMD_NEW_CHAIN|CMD_SET_POLICY:
+	case CMD_SET_POLICY:
+	case CMD_RENAME_CHAIN:
+	case CMD_CHANGE_COUNTERS:
+		break;
+	default:
+		/* We should never reach this... */
+		printf("Unsupported command?\n");
+		exit(1);
 	}
 
 	ebt_cs_clean(&cs);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index e03b2b2510eda..c3cf1c2c74104 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -42,76 +42,6 @@
 #include "nft.h"
 #include "nft-bridge.h"
 
-/* from linux/netfilter_bridge/ebtables.h */
-#define EBT_TABLE_MAXNAMELEN 32
-#define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN
-
-/*
- * From include/ebtables_u.h
- */
-#define ebt_check_option2(flags, mask) EBT_CHECK_OPTION(flags, mask)
-
-/*
- * From useful_functions.c
- */
-
-/* 0: default
- * 1: the inverse '!' of the option has already been specified */
-int ebt_invert = 0;
-
-static int ebt_check_inverse2(const char option[], int argc, char **argv)
-{
-	if (!option)
-		return ebt_invert;
-	if (strcmp(option, "!") == 0) {
-		if (ebt_invert == 1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Double use of '!' not allowed");
-		if (optind >= argc)
-			optarg = NULL;
-		else
-			optarg = argv[optind];
-		optind++;
-		ebt_invert = 1;
-		return 1;
-	}
-	return ebt_invert;
-}
-
-/* XXX: merge with assert_valid_chain_name()? */
-static void ebt_assert_valid_chain_name(const char *chainname)
-{
-	if (strlen(chainname) >= EBT_CHAIN_MAXNAMELEN)
-		xtables_error(PARAMETER_PROBLEM,
-			      "Chain name length can't exceed %d",
-			      EBT_CHAIN_MAXNAMELEN - 1);
-
-	if (*chainname == '-' || *chainname == '!')
-		xtables_error(PARAMETER_PROBLEM, "No chain name specified");
-
-	if (xtables_find_target(chainname, XTF_TRY_LOAD))
-		xtables_error(PARAMETER_PROBLEM,
-			      "Target with name %s exists", chainname);
-
-	if (strchr(chainname, ' ') != NULL)
-		xtables_error(PARAMETER_PROBLEM,
-			      "Use of ' ' not allowed in chain names");
-}
-
-/*
- * Glue code to use libxtables
- */
-static int parse_rule_number(const char *rule)
-{
-	unsigned int rule_nr;
-
-	if (!xtables_strtoui(rule, NULL, &rule_nr, 1, INT_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			      "Invalid rule number `%s'", rule);
-
-	return rule_nr;
-}
-
 static int
 delete_entry(struct nft_handle *h,
 	     const char *chain,
@@ -159,35 +89,6 @@ change_entry_counters(struct nft_handle *h,
 	return ret;
 }
 
-int ebt_get_current_chain(const char *chain)
-{
-	if (!chain)
-		return -1;
-
-	if (strcmp(chain, "PREROUTING") == 0)
-		return NF_BR_PRE_ROUTING;
-	else if (strcmp(chain, "INPUT") == 0)
-		return NF_BR_LOCAL_IN;
-	else if (strcmp(chain, "FORWARD") == 0)
-		return NF_BR_FORWARD;
-	else if (strcmp(chain, "OUTPUT") == 0)
-		return NF_BR_LOCAL_OUT;
-	else if (strcmp(chain, "POSTROUTING") == 0)
-		return NF_BR_POST_ROUTING;
-	else if (strcmp(chain, "BROUTING") == 0)
-		return NF_BR_BROUTING;
-
-	/* placeholder for user defined chain */
-	return NF_BR_NUMHOOKS;
-}
-
-/*
- * The original ebtables parser
- */
-
-/* Checks whether a command has already been specified */
-#define OPT_COMMANDS (flags & OPT_COMMAND || flags & OPT_ZERO)
-
 /* Default command line options. Do not mess around with the already
  * assigned numbers unless you know what you are doing */
 struct option ebt_original_options[] =
@@ -244,10 +145,6 @@ struct xtables_globals ebtables_globals = {
 #define prog_name ebtables_globals.program_name
 #define prog_vers ebtables_globals.program_version
 
-/*
- * From libebtc.c
- */
-
 /* Prints all registered extensions */
 static void ebt_list_extensions(const struct xtables_target *t,
 				const struct xtables_rule_match *m)
@@ -303,7 +200,7 @@ static struct option *merge_options(struct option *oldopts,
 	return merge;
 }
 
-static void print_help(struct iptables_command_state *cs)
+void nft_bridge_print_help(struct iptables_command_state *cs)
 {
 	const struct xtables_rule_match *m = cs->matches;
 	struct xtables_target *t = cs->target;
@@ -411,107 +308,6 @@ static int list_rules(struct nft_handle *h, const char *chain, const char *table
 	return nft_cmd_rule_list(h, chain, table, rule_nr, format);
 }
 
-static int parse_rule_range(const char *argv, int *rule_nr, int *rule_nr_end)
-{
-	char *colon = strchr(argv, ':'), *buffer;
-
-	if (colon) {
-		*colon = '\0';
-		if (*(colon + 1) == '\0')
-			*rule_nr_end = -1; /* Until the last rule */
-		else {
-			*rule_nr_end = strtol(colon + 1, &buffer, 10);
-			if (*buffer != '\0' || *rule_nr_end == 0)
-				return -1;
-		}
-	}
-	if (colon == argv)
-		*rule_nr = 1; /* Beginning with the first rule */
-	else {
-		*rule_nr = strtol(argv, &buffer, 10);
-		if (*buffer != '\0' || *rule_nr == 0)
-			return -1;
-	}
-	if (!colon)
-		*rule_nr_end = *rule_nr;
-	return 0;
-}
-
-/* Incrementing or decrementing rules in daemon mode is not supported as the
- * involved code overload is not worth it (too annoying to take the increased
- * counters in the kernel into account). */
-static uint8_t parse_change_counters_rule(int argc, char **argv,
-					  int *rule_nr, int *rule_nr_end,
-					  struct iptables_command_state *cs)
-{
-	uint8_t ret = 0;
-	char *buffer;
-
-	if (optind + 1 >= argc ||
-	    (argv[optind][0] == '-' && !isdigit(argv[optind][1])) ||
-	    (argv[optind + 1][0] == '-' && !isdigit(argv[optind + 1][1])))
-		xtables_error(PARAMETER_PROBLEM,
-			      "The command -C needs at least 2 arguments");
-	if (optind + 2 < argc &&
-	    (argv[optind + 2][0] != '-' || isdigit(argv[optind + 2][1]))) {
-		if (optind + 3 != argc)
-			xtables_error(PARAMETER_PROBLEM,
-				      "No extra options allowed with -C start_nr[:end_nr] pcnt bcnt");
-		if (parse_rule_range(argv[optind], rule_nr, rule_nr_end))
-			xtables_error(PARAMETER_PROBLEM,
-				      "Something is wrong with the rule number specification '%s'",
-				      argv[optind]);
-		optind++;
-	}
-
-	if (argv[optind][0] == '+') {
-		ret |= CTR_OP_INC_PKTS;
-		cs->counters.pcnt = strtoull(argv[optind] + 1, &buffer, 10);
-	} else if (argv[optind][0] == '-') {
-		ret |= CTR_OP_DEC_PKTS;
-		cs->counters.pcnt = strtoull(argv[optind] + 1, &buffer, 10);
-	} else {
-		cs->counters.pcnt = strtoull(argv[optind], &buffer, 10);
-	}
-	if (*buffer != '\0')
-		goto invalid;
-
-	optind++;
-
-	if (argv[optind][0] == '+') {
-		ret |= CTR_OP_INC_BYTES;
-		cs->counters.bcnt = strtoull(argv[optind] + 1, &buffer, 10);
-	} else if (argv[optind][0] == '-') {
-		ret |= CTR_OP_DEC_BYTES;
-		cs->counters.bcnt = strtoull(argv[optind] + 1, &buffer, 10);
-	} else {
-		cs->counters.bcnt = strtoull(argv[optind], &buffer, 10);
-	}
-	if (*buffer != '\0')
-		goto invalid;
-
-	optind++;
-
-	return ret;
-invalid:
-	xtables_error(PARAMETER_PROBLEM,
-		      "Packet counter '%s' invalid", argv[optind]);
-}
-
-static void ebtables_parse_interface(const char *arg, char *vianame)
-{
-	unsigned char mask[IFNAMSIZ];
-	char *c;
-
-	xtables_parse_interface(arg, vianame, mask);
-
-	if ((c = strchr(vianame, '+'))) {
-		if (*(c + 1) != '\0')
-			xtables_error(PARAMETER_PROBLEM,
-				      "Spurious characters after '+' wildcard");
-	}
-}
-
 /* This code is very similar to iptables/xtables.c:command_match() */
 static void ebt_load_match(const char *name)
 {
@@ -580,6 +376,10 @@ static void ebt_load_match_extensions(void)
 
 	ebt_load_watcher("log");
 	ebt_load_watcher("nflog");
+
+	/* assign them back so do_parse() may
+	 * reset opts to orig_opts upon each call */
+	xt_params->orig_opts = opts;
 }
 
 void ebt_add_match(struct xtables_match *m,
@@ -642,7 +442,8 @@ void ebt_add_watcher(struct xtables_target *watcher,
 	*matchp = newnode;
 }
 
-int ebt_command_default(struct iptables_command_state *cs)
+int ebt_command_default(struct iptables_command_state *cs,
+			struct xtables_globals *unused, bool ebt_invert)
 {
 	struct xtables_target *t = cs->target;
 	struct xtables_match *m;
@@ -753,431 +554,43 @@ void nft_fini_eb(struct nft_handle *h)
 int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		 bool restore)
 {
-	char *buffer;
-	int c, i;
-	uint8_t chcounter = 0; /* Needed for -C */
-	int rule_nr = 0;
-	int rule_nr_end = 0;
-	int ret = 0;
-	unsigned int flags = 0;
-	struct xtables_target *t;
 	struct iptables_command_state cs = {
 		.argc = argc,
 		.argv = argv,
 		.jumpto	= "",
 		.eb.bitmask = EBT_NOPROTO,
 	};
+	const struct builtin_table *t;
+	struct xtables_args args = {
+		.family	= h->family,
+	};
 	struct xt_cmd_parse p = {
+		.table		= *table,
+		.restore	= restore,
+		.line		= line,
+		.rule_ranges	= true,
+		.ops		= &h->ops->cmd_parse,
 	};
-	char command = 'h';
-	const char *chain = NULL;
-	const char *policy = NULL;
-	int selected_chain = -1;
-	struct xtables_rule_match *xtrm_i;
-	struct ebt_match *match;
-	bool table_set = false;
+	int ret = 0;
 
-	/* avoid cumulating verbosity with ebtables-restore */
-	h->verbose = 0;
+	do_parse(argc, argv, &p, &cs, &args);
 
-	/* prevent getopt to spoil our error reporting */
-	optind = 0;
-	opterr = false;
+	h->verbose	= p.verbose;
 
-	for (t = xtables_targets; t; t = t->next) {
-		t->tflags = 0;
-		t->used = 0;
-	}
+	t = nft_table_builtin_find(h, p.table);
+	if (!t)
+		xtables_error(VERSION_PROBLEM,
+			      "table '%s' does not exist", p.table);
 
-	/* Getopt saves the day */
-	while ((c = getopt_long(argc, argv, EBT_OPTSTRING,
-					opts, NULL)) != -1) {
-		cs.c = c;
-		switch (c) {
-
-		case 'A': /* Add a rule */
-		case 'D': /* Delete a rule */
-		case 'C': /* Change counters */
-		case 'P': /* Define policy */
-		case 'I': /* Insert a rule */
-		case 'N': /* Make a user defined chain */
-		case 'E': /* Rename chain */
-		case 'X': /* Delete chain */
-		case 14:  /* check a rule */
-			/* We allow -N chainname -P policy */
-			if (command == 'N' && c == 'P') {
-				command = c;
-				optind--; /* No table specified */
-				goto handle_P;
-			}
-			if (OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple commands are not allowed");
-
-			command = c;
-			if (optarg && (optarg[0] == '-' || !strcmp(optarg, "!")))
-				xtables_error(PARAMETER_PROBLEM, "No chain name specified");
-			chain = optarg;
-			selected_chain = ebt_get_current_chain(chain);
-			flags |= OPT_COMMAND;
-
-			if (c == 'N') {
-				ebt_assert_valid_chain_name(chain);
-				ret = nft_cmd_chain_user_add(h, chain, *table);
-				break;
-			} else if (c == 'X') {
-				/* X arg is optional, optarg is NULL */
-				if (!chain && optind < argc && argv[optind][0] != '-') {
-					chain = argv[optind];
-					optind++;
-				}
-				ret = nft_cmd_chain_del(h, chain, *table, 0);
-				break;
-			}
-
-			if (c == 'E') {
-				if (!xs_has_arg(argc, argv))
-					xtables_error(PARAMETER_PROBLEM, "No new chain name specified");
-				else if (optind < argc - 1)
-					xtables_error(PARAMETER_PROBLEM, "No extra options allowed with -E");
-
-				ebt_assert_valid_chain_name(argv[optind]);
-
-				errno = 0;
-				ret = nft_cmd_chain_user_rename(h, chain, *table,
-							    argv[optind]);
-				if (ret != 0 && errno == ENOENT)
-					xtables_error(PARAMETER_PROBLEM, "Chain '%s' doesn't exists", chain);
-
-				optind++;
-				break;
-			} else if (c == 'D' && optind < argc && (argv[optind][0] != '-' || (argv[optind][1] >= '0' && argv[optind][1] <= '9'))) {
-				if (optind != argc - 1)
-					xtables_error(PARAMETER_PROBLEM,
-							 "No extra options allowed with -D start_nr[:end_nr]");
-				if (parse_rule_range(argv[optind], &rule_nr, &rule_nr_end))
-					xtables_error(PARAMETER_PROBLEM,
-							 "Problem with the specified rule number(s) '%s'", argv[optind]);
-				optind++;
-			} else if (c == 'C') {
-				if ((chcounter = parse_change_counters_rule(argc, argv, &rule_nr, &rule_nr_end, &cs)) == -1)
-					return -1;
-			} else if (c == 'I') {
-				if (optind >= argc || (argv[optind][0] == '-' && (argv[optind][1] < '0' || argv[optind][1] > '9')))
-					rule_nr = 1;
-				else {
-					rule_nr = parse_rule_number(argv[optind]);
-					optind++;
-				}
-			} else if (c == 'P') {
-handle_P:
-				if (optind >= argc)
-					xtables_error(PARAMETER_PROBLEM,
-						      "No policy specified");
-				for (i = 0; i < NUM_STANDARD_TARGETS; i++)
-					if (!strcmp(argv[optind], nft_ebt_standard_target(i))) {
-						policy = argv[optind];
-						if (-i-1 == EBT_CONTINUE)
-							xtables_error(PARAMETER_PROBLEM,
-								      "Wrong policy '%s'",
-								      argv[optind]);
-						break;
-					}
-				if (i == NUM_STANDARD_TARGETS)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Unknown policy '%s'", argv[optind]);
-				optind++;
-			}
-			break;
-		case 'L': /* List */
-		case 'F': /* Flush */
-		case 'Z': /* Zero counters */
-			if (c == 'Z') {
-				if ((flags & OPT_ZERO) || (flags & OPT_COMMAND && command != 'L'))
-print_zero:
-					xtables_error(PARAMETER_PROBLEM,
-						      "Command -Z only allowed together with command -L");
-				flags |= OPT_ZERO;
-			} else {
-				if (flags & OPT_COMMAND)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Multiple commands are not allowed");
-				command = c;
-				flags |= OPT_COMMAND;
-				if (flags & OPT_ZERO && c != 'L')
-					goto print_zero;
-			}
-
-			if (optind < argc && argv[optind][0] != '-') {
-				chain = argv[optind];
-				optind++;
-			}
-			break;
-		case 'v': /* verbose */
-			flags |= OPT_VERBOSE;
-			h->verbose++;
-			break;
-		case 'V': /* Version */
-			if (OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple commands are not allowed");
-			printf("%s %s\n", prog_name, prog_vers);
-			exit(0);
-		case 'h': /* Help */
-			if (OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple commands are not allowed");
-			print_help(&cs);
-			exit(0);
-		case 't': /* Table */
-			if (restore && table_set)
-				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option cannot be used in %s.",
-					      xt_params->program_name);
-			else if (table_set)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Multiple use of same option not allowed");
-			if (!nft_table_builtin_find(h, optarg))
-				xtables_error(VERSION_PROBLEM,
-					      "table '%s' does not exist",
-					      optarg);
-			*table = optarg;
-			table_set = true;
+	switch (p.command) {
+	case CMD_NEW_CHAIN:
+	case CMD_NEW_CHAIN | CMD_SET_POLICY:
+		ret = nft_cmd_chain_user_add(h, p.chain, p.table);
+		if (!ret || !(p.command & CMD_SET_POLICY))
 			break;
-		case 'i': /* Input interface */
-		case 15 : /* Logical input interface */
-		case 'o': /* Output interface */
-		case 16 : /* Logical output interface */
-		case 'j': /* Target */
-		case 'p': /* Net family protocol */
-		case 's': /* Source mac */
-		case 'd': /* Destination mac */
-		case 'c': /* Set counters */
-			if (!OPT_COMMANDS)
-				xtables_error(PARAMETER_PROBLEM,
-					      "No command specified");
-			if (command != 'A' && command != 'D' &&
-			    command != 'I' && command != 'C' && command != 14)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Command and option do not match");
-			if (c == 'i') {
-				ebt_check_option2(&flags, OPT_VIANAMEIN);
-				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use -i only in INPUT, FORWARD, PREROUTING and BROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_IIN;
-
-				ebtables_parse_interface(optarg, cs.eb.in);
-				break;
-			} else if (c == 15) {
-				ebt_check_option2(&flags, OPT_LOGICALIN);
-				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use --logical-in only in INPUT, FORWARD, PREROUTING and BROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_ILOGICALIN;
-
-				ebtables_parse_interface(optarg, cs.eb.logical_in);
-				break;
-			} else if (c == 'o') {
-				ebt_check_option2(&flags, OPT_VIANAMEOUT);
-				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use -o only in OUTPUT, FORWARD and POSTROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_IOUT;
-
-				ebtables_parse_interface(optarg, cs.eb.out);
-				break;
-			} else if (c == 16) {
-				ebt_check_option2(&flags, OPT_LOGICALOUT);
-				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Use --logical-out only in OUTPUT, FORWARD and POSTROUTING chains");
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_ILOGICALOUT;
-
-				ebtables_parse_interface(optarg, cs.eb.logical_out);
-				break;
-			} else if (c == 'j') {
-				ebt_check_option2(&flags, OPT_JUMP);
-				if (strcmp(optarg, "CONTINUE") != 0) {
-					command_jump(&cs, optarg);
-				}
-				break;
-			} else if (c == 's') {
-				ebt_check_option2(&flags, OPT_SOURCE);
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_ISOURCE;
-
-				if (xtables_parse_mac_and_mask(optarg,
-							       cs.eb.sourcemac,
-							       cs.eb.sourcemsk))
-					xtables_error(PARAMETER_PROBLEM, "Problem with specified source mac '%s'", optarg);
-				cs.eb.bitmask |= EBT_SOURCEMAC;
-				break;
-			} else if (c == 'd') {
-				ebt_check_option2(&flags, OPT_DESTINATION);
-				if (ebt_check_inverse2(optarg, argc, argv))
-					cs.eb.invflags |= EBT_IDEST;
-
-				if (xtables_parse_mac_and_mask(optarg,
-							       cs.eb.destmac,
-							       cs.eb.destmsk))
-					xtables_error(PARAMETER_PROBLEM, "Problem with specified destination mac '%s'", optarg);
-				cs.eb.bitmask |= EBT_DESTMAC;
-				break;
-			} else if (c == 'c') {
-				ebt_check_option2(&flags, OPT_COUNTERS);
-				if (ebt_check_inverse2(optarg, argc, argv))
-					xtables_error(PARAMETER_PROBLEM,
-						      "Unexpected '!' after -c");
-				if (optind >= argc || optarg[0] == '-' || argv[optind][0] == '-')
-					xtables_error(PARAMETER_PROBLEM,
-						      "Option -c needs 2 arguments");
-
-				cs.counters.pcnt = strtoull(optarg, &buffer, 10);
-				if (*buffer != '\0')
-					xtables_error(PARAMETER_PROBLEM,
-						      "Packet counter '%s' invalid",
-						      optarg);
-				cs.counters.bcnt = strtoull(argv[optind], &buffer, 10);
-				if (*buffer != '\0')
-					xtables_error(PARAMETER_PROBLEM,
-						      "Packet counter '%s' invalid",
-						      argv[optind]);
-				optind++;
-				break;
-			}
-			ebt_check_option2(&flags, OPT_PROTOCOL);
-			if (ebt_check_inverse2(optarg, argc, argv))
-				cs.eb.invflags |= EBT_IPROTO;
-
-			cs.eb.bitmask &= ~((unsigned int)EBT_NOPROTO);
-			i = strtol(optarg, &buffer, 16);
-			if (*buffer == '\0' && (i < 0 || i > 0xFFFF))
-				xtables_error(PARAMETER_PROBLEM,
-					      "Problem with the specified protocol");
-			if (*buffer != '\0') {
-				struct xt_ethertypeent *ent;
-
-				if (!strcasecmp(optarg, "LENGTH")) {
-					cs.eb.bitmask |= EBT_802_3;
-					break;
-				}
-				ent = xtables_getethertypebyname(optarg);
-				if (!ent)
-					xtables_error(PARAMETER_PROBLEM,
-						      "Problem with the specified Ethernet protocol '%s', perhaps "XT_PATH_ETHERTYPES " is missing", optarg);
-				cs.eb.ethproto = ent->e_ethertype;
-			} else
-				cs.eb.ethproto = i;
-
-			if (cs.eb.ethproto < 0x0600)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Sorry, protocols have values above or equal to 0x0600");
-			break;
-		case 17 : /* Lc */
-			ebt_check_option2(&flags, LIST_C);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Use --Lc with -L");
-			flags |= LIST_C;
-			break;
-		case 18 : /* Ln */
-			ebt_check_option2(&flags, LIST_N);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Use --Ln with -L");
-			if (flags & LIST_X)
-				xtables_error(PARAMETER_PROBLEM,
-					      "--Lx is not compatible with --Ln");
-			flags |= LIST_N;
-			break;
-		case 19 : /* Lx */
-			ebt_check_option2(&flags, LIST_X);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					      "Use --Lx with -L");
-			if (flags & LIST_N)
-				xtables_error(PARAMETER_PROBLEM,
-					      "--Lx is not compatible with --Ln");
-			flags |= LIST_X;
-			break;
-		case 12 : /* Lmac2 */
-			ebt_check_option2(&flags, LIST_MAC2);
-			if (command != 'L')
-				xtables_error(PARAMETER_PROBLEM,
-					       "Use --Lmac2 with -L");
-			flags |= LIST_MAC2;
-			break;
-		case 11: /* init-table */
-			if (restore)
-				xtables_error(PARAMETER_PROBLEM,
-					      "--init-table is not supported in daemon mode");
-			nft_cmd_table_flush(h, *table, false);
-			return 1;
-		case 13 :
-			break;
-		case 1 :
-			if (!strcmp(optarg, "!"))
-				ebt_check_inverse2(optarg, argc, argv);
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					      "Bad argument : '%s'", optarg);
-			/* ebt_ebt_check_inverse2() did optind++ */
-			optind--;
-			continue;
-		default:
-			ebt_check_inverse2(optarg, argc, argv);
-			ebt_command_default(&cs);
-
-			if (command != 'A' && command != 'I' &&
-			    command != 'D' && command != 'C' && command != 14)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Extensions only for -A, -I, -D and -C");
-		}
-		ebt_invert = 0;
-	}
-
-	/* Just in case we didn't catch an error */
-	/*if (ebt_errormsg[0] != '\0')
-		return -1;
-
-	if (!(table = ebt_find_table(replace->name)))
-		ebt_print_error2("Bad table name");*/
-
-	/* Do the final checks */
-	if (command == 'A' || command == 'I' ||
-	    command == 'D' || command == 'C' || command == 14) {
-		for (xtrm_i = cs.matches; xtrm_i; xtrm_i = xtrm_i->next)
-			xtables_option_mfcall(xtrm_i->match);
-
-		for (match = cs.match_list; match; match = match->next) {
-			if (match->ismatch)
-				continue;
-
-			xtables_option_tfcall(match->u.watcher);
-		}
-
-		if (cs.target != NULL)
-			xtables_option_tfcall(cs.target);
-	}
-	/* So, the extensions can work with the host endian.
-	 * The kernel does not have to do this of course */
-	cs.eb.ethproto = htons(cs.eb.ethproto);
-
-	p.table		= *table;
-	p.chain		= chain;
-	p.policy	= policy;
-	p.rulenum	= rule_nr;
-	p.rulenum_end	= rule_nr_end;
-	cs.options	= flags;
-
-	switch (command) {
-	case 'P':
-		if (selected_chain >= NF_BR_NUMHOOKS) {
+		/* fall through */
+	case CMD_SET_POLICY:
+		if (!nft_chain_builtin_find(t, p.chain)) {
 			ret = ebt_cmd_user_chain_policy(h, p.table, p.chain,
 							p.policy);
 			break;
@@ -1190,46 +603,83 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy");
 		break;
-	case 'L':
-		ret = list_rules(h, p.chain, p.table, p.rulenum,
-				 cs.options & OPT_VERBOSE,
-				 0,
-				 /*cs.options&OPT_EXPANDED*/0,
-				 cs.options&LIST_N,
-				 cs.options&LIST_C);
-		if (!(cs.options & OPT_ZERO))
-			break;
-	case 'Z':
+	case CMD_LIST:
+	case CMD_LIST | CMD_ZERO:
+	case CMD_LIST | CMD_ZERO_NUM:
+	case CMD_LIST_RULES:
+	case CMD_LIST_RULES | CMD_ZERO:
+	case CMD_LIST_RULES | CMD_ZERO_NUM:
+		if (p.command & CMD_LIST)
+			ret = list_rules(h, p.chain, p.table, p.rulenum,
+					 cs.options & OPT_VERBOSE,
+					 0,
+					 /*cs.options&OPT_EXPANDED*/0,
+					 cs.options&OPT_LINENUMBERS,
+					 cs.options&OPT_LIST_C);
+		else if (p.command & CMD_LIST_RULES)
+			ret = nft_cmd_rule_list_save(h, p.chain, p.table,
+						     p.rulenum - 1,
+						     cs.options & OPT_VERBOSE);
+		if (ret && (p.command & CMD_ZERO))
+			ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
+							  cs.options & OPT_VERBOSE);
+		if (ret && (p.command & CMD_ZERO_NUM))
+			ret = nft_cmd_rule_zero_counters(h, p.chain, p.table,
+							 p.rulenum - 1);
+		break;
+	case CMD_ZERO:
 		ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
 						  cs.options & OPT_VERBOSE);
 		break;
-	case 'F':
+	case CMD_ZERO_NUM:
+		ret = nft_cmd_rule_zero_counters(h, p.chain, p.table,
+						 p.rulenum - 1);
+		break;
+	case CMD_FLUSH:
 		ret = nft_cmd_rule_flush(h, p.chain, p.table,
 					 cs.options & OPT_VERBOSE);
 		break;
-	case 'A':
+	case CMD_APPEND:
 		ret = nft_cmd_rule_append(h, p.chain, p.table, &cs,
 					  cs.options & OPT_VERBOSE);
 		break;
-	case 'I':
+	case CMD_INSERT:
 		ret = nft_cmd_rule_insert(h, p.chain, p.table, &cs,
 					  p.rulenum - 1,
 					  cs.options & OPT_VERBOSE);
 		break;
-	case 'D':
+	case CMD_DELETE:
+	case CMD_DELETE_NUM:
 		ret = delete_entry(h, p.chain, p.table, &cs, p.rulenum - 1,
 				   p.rulenum_end, cs.options & OPT_VERBOSE);
 		break;
-	case 14:
+	case CMD_DELETE_CHAIN:
+		ret = nft_cmd_chain_del(h, p.chain, p.table, 0);
+		break;
+	case CMD_RENAME_CHAIN:
+		ret = nft_cmd_chain_user_rename(h, p.chain, p.table, p.newname);
+		break;
+	case CMD_INIT_TABLE:
+		ret = nft_cmd_table_flush(h, p.table, false);
+		break;
+	case CMD_CHECK:
 		ret = nft_cmd_rule_check(h, p.chain, p.table,
 					 &cs, cs.options & OPT_VERBOSE);
 		break;
-	case 'C':
+	case CMD_CHANGE_COUNTERS:
 		ret = change_entry_counters(h, p.chain, p.table, &cs,
 					    p.rulenum - 1, p.rulenum_end,
-					    chcounter,
+					    args.counter_op,
 					    cs.options & OPT_VERBOSE);
 		break;
+	case CMD_REPLACE:
+		ret = nft_cmd_rule_replace(h, p.chain, p.table, &cs,
+					   p.rulenum - 1,
+					   cs.options & OPT_VERBOSE);
+		break;
+	default:
+		/* We should never reach this... */
+		exit_tryhelp(2, line);
 	}
 
 	ebt_cs_clean(&cs);
-- 
2.41.0

