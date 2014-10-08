From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH xtables-compat 4/4] arptables-compat: allow to not specify a target
Date: Wed,  8 Oct 2014 22:17:51 +0200
Message-ID: <1412799471-7721-4-git-send-email-pablo@netfilter.org>
References: <1412799471-7721-1-git-send-email-pablo@netfilter.org>
Cc: giuseppelng@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48391 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbaJHUQg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:16:36 -0400
In-Reply-To: <1412799471-7721-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

arptables allows this:

 # arptables -I INPUT

however, arptables-compat says:

 arptables v1.4.21: No target provided or initalization failed
 Try `arptables -h' or 'arptables --help' for more information.

the compat utility must mimic the same behaviour.

Fix this by introducing the arptables_command_state abstraction that
is already available in ip{6}tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c        |  166 +++++++++++++++--------------------------
 iptables/nft-arp.h        |   16 ++++
 iptables/nft-shared.c     |    2 +-
 iptables/nft-shared.h     |   17 +----
 iptables/xtables-arp.c    |  181 +++++++++++++++++++--------------------------
 iptables/xtables-events.c |    7 +-
 6 files changed, 159 insertions(+), 230 deletions(-)
 create mode 100644 iptables/nft-arp.h

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index bb4bab2..541feeb 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -25,6 +25,7 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include "nft-shared.h"
+#include "nft-arp.h"
 #include "nft.h"
 
 /* a few names */
@@ -160,11 +161,10 @@ static uint8_t arpt_to_ipt_flags(uint16_t invflags)
 
 static int nft_arp_add(struct nft_rule *r, void *data)
 {
-	struct arpt_entry *fw = data;
+	struct arptables_command_state *cs = data;
+	struct arpt_entry *fw = &cs->fw;
 	uint8_t flags = arpt_to_ipt_flags(fw->arp.invflags);
-	struct xt_entry_target *t;
-	char *targname;
-	int ret;
+	int ret = 0;
 
 	if (fw->arp.iniface[0] != '\0')
 		add_iniface(r, fw->arp.iniface, flags);
@@ -221,20 +221,20 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 	if (add_counters(r, fw->counters.pcnt, fw->counters.bcnt) < 0)
 		return -1;
 
-	t = nft_arp_get_target(fw);
-	targname = t->u.user.name;
-
-	/* Standard target? */
-	if (strcmp(targname, XTC_LABEL_ACCEPT) == 0)
-		ret = add_verdict(r, NF_ACCEPT);
-	else if (strcmp(targname, XTC_LABEL_DROP) == 0)
-		ret = add_verdict(r, NF_DROP);
-	else if (strcmp(targname, XTC_LABEL_RETURN) == 0)
-		ret = add_verdict(r, NFT_RETURN);
-	else if (xtables_find_target(targname, XTF_TRY_LOAD) != NULL)
-		ret = add_target(r, t);
-	else
-		ret = add_jumpto(r, targname, NFT_JUMP);
+	if (cs->target != NULL) {
+		/* Standard target? */
+		if (strcmp(cs->jumpto, XTC_LABEL_ACCEPT) == 0)
+			ret = add_verdict(r, NF_ACCEPT);
+		else if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0)
+			ret = add_verdict(r, NF_DROP);
+		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
+			ret = add_verdict(r, NFT_RETURN);
+		else
+			ret = add_target(r, cs->target->t);
+	} else if (strlen(cs->jumpto) > 0) {
+		/* No goto in arptables */
+		ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
+	}
 
 	return ret;
 }
@@ -264,7 +264,8 @@ static uint16_t ipt_to_arpt_flags(uint8_t invflags)
 static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
 			       void *data)
 {
-	struct arpt_entry *fw = data;
+	struct arptables_command_state *cs = data;
+	struct arpt_entry *fw = &cs->fw;
 	uint8_t flags = 0;
 
 	parse_meta(e, ctx->meta.key, fw->arp.iniface, fw->arp.iniface_mask,
@@ -276,33 +277,17 @@ static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
 
 static void nft_arp_parse_target(struct xtables_target *target, void *data)
 {
-	struct arpt_entry *fw = data;
-	struct xt_entry_target **t;
+	struct arptables_command_state *cs = data;
 
-	fw->target_offset = offsetof(struct arpt_entry, elems);
-	fw->next_offset = fw->target_offset + target->t->u.target_size;
-
-	t = (void *) &fw->elems;
-	*t = target->t;
+	cs->target = target;
 }
 
 static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
 				    void *data)
 {
-	struct xtables_target *target;
-	size_t size;
-
-	target = xtables_find_target(XT_STANDARD_TARGET,
-				     XTF_LOAD_MUST_SUCCEED);
+	struct arptables_command_state *cs = data;
 
-	size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
-
-	target->t = xtables_calloc(1, size);
-	target->t->u.target_size = size;
-	strcpy(target->t->u.user.name, jumpto);
-	target->t->u.user.revision = target->revision;
-
-	nft_arp_parse_target(target, data);
+	cs->jumpto = jumpto;
 }
 
 static void parse_mask_ipv4(struct nft_xt_ctx *ctx, struct in_addr *mask)
@@ -313,7 +298,8 @@ static void parse_mask_ipv4(struct nft_xt_ctx *ctx, struct in_addr *mask)
 static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 				  struct nft_rule_expr *e, void *data)
 {
-	struct arpt_entry *fw = data;
+	struct arptables_command_state *cs = data;
+	struct arpt_entry *fw = &cs->fw;
 	struct in_addr addr;
 	unsigned short int ar_hrd, ar_pro, ar_op, ar_hln;
 	bool inv;
@@ -379,13 +365,14 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 	}
 }
 
-void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw)
+void nft_rule_to_arptables_command_state(struct nft_rule *r,
+					 struct arptables_command_state *cs)
 {
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
 	int family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 	struct nft_xt_ctx ctx = {
-		.state.fw = fw,
+		.state.cs_arp = cs,
 		.family = family,
 	};
 
@@ -400,7 +387,7 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw)
 			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
 
 		if (strcmp(name, "counter") == 0)
-			nft_parse_counter(expr, &ctx.state.fw->counters);
+			nft_parse_counter(expr, &ctx.state.cs_arp->fw.counters);
 		else if (strcmp(name, "payload") == 0)
 			nft_parse_payload(&ctx, expr);
 		else if (strcmp(name, "meta") == 0)
@@ -418,25 +405,13 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw)
 	}
 
 	nft_rule_expr_iter_destroy(iter);
-}
-
-static struct xtables_target
-*get_target(struct arpt_entry *fw, unsigned int format)
-{
-	const char *targname;
-	struct xtables_target *target = NULL;
-	const struct xt_entry_target *t;
 
-	if (!fw->target_offset)
-		return NULL;
-
-	t = nft_arp_get_target(fw);
-	targname = t->u.user.name;
-	target = xtables_find_target(targname, XTF_TRY_LOAD);
-	if (!(format & FMT_NOTARGET))
-		printf("-j %s ", targname);
-
-	return target;
+	if (cs->target != NULL)
+		cs->jumpto = cs->target->name;
+	else if (cs->jumpto != NULL)
+		cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
+	else
+		cs->jumpto = "";
 }
 
 static void print_fw_details(struct arpt_entry *fw, unsigned int format)
@@ -584,29 +559,27 @@ static void
 nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 		       unsigned int format)
 {
-	struct arpt_entry fw = {};
-	struct xtables_target *target = NULL;
-	const struct xt_entry_target *t = NULL;
+	struct arptables_command_state cs = {};
 
-	nft_rule_to_arpt_entry(r, &fw);
+	nft_rule_to_arptables_command_state(r, &cs);
 
 	if (format & FMT_LINENUMBERS)
 		printf("%u ", num);
 
-	target = get_target(&fw, format);
-	print_fw_details(&fw, format);
+	print_fw_details(&cs.fw, format);
 
-	if (target) {
-		if (target->print)
+	if (cs.target) {
+		if (cs.target->print)
 			/* Print the target information. */
-			target->print(&fw.arp, t, format & FMT_NUMERIC);
+			cs.target->print(&cs.fw, cs.target->t,
+					 format & FMT_NUMERIC);
 	}
 
 	if (!(format & FMT_NOCOUNTS)) {
 		printf(", pcnt=");
-		xtables_print_num(fw.counters.pcnt, format);
+		xtables_print_num(cs.fw.counters.pcnt, format);
 		printf("-- bcnt=");
-		xtables_print_num(fw.counters.bcnt, format);
+		xtables_print_num(cs.fw.counters.bcnt, format);
 	}
 
 	if (!(format & FMT_NONEWLINE))
@@ -616,18 +589,16 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 static void nft_arp_save_firewall(const void *data,
 				  unsigned int format)
 {
-	const struct arpt_entry *fw = data;
-	struct xtables_target *target = NULL;
-	const struct xt_entry_target *t = NULL;
+	const struct arptables_command_state *cs = data;
+	const struct arpt_entry *fw = &cs->fw;
 
 	print_fw_details((struct arpt_entry *)fw, format);
 
-	target = get_target((struct arpt_entry *)fw, format);
-
-	if (target) {
-		if (target->print)
+	if (cs->target) {
+		if (cs->target->print)
 			/* Print the target information. */
-			target->print(&fw->arp, t, format & FMT_NUMERIC);
+			cs->target->print(&fw->arp, cs->target->t,
+					  format & FMT_NUMERIC);
 	}
 	printf("\n");
 }
@@ -661,45 +632,28 @@ static bool nft_arp_is_same(const void *data_a,
 static bool nft_arp_rule_find(struct nft_family_ops *ops, struct nft_rule *r,
 			      void *data)
 {
-	struct arpt_entry *fw = data;
-	struct xt_entry_target *t_fw, *t_this;
-	char *targname_fw, *targname_this;
-	struct arpt_entry this = {};
+	const struct arptables_command_state *cs = data;
+	struct arptables_command_state this = {};
 
 	/* Delete by matching rule case */
-	nft_rule_to_arpt_entry(r, &this);
+	nft_rule_to_arptables_command_state(r, &this);
 
-	if (!ops->is_same(fw, &this))
+	if (!nft_arp_is_same(cs, &this))
 		return false;
 
-	t_fw = nft_arp_get_target(fw);
-	t_this = nft_arp_get_target(&this);
-
-	targname_fw = t_fw->u.user.name;
-	targname_this = t_this->u.user.name;
-
-	if (!strcmp(targname_fw, targname_this) &&
-	    (!strcmp(targname_fw, "mangle") ||
-	    !strcmp(targname_fw, "CLASSIFY"))) {
-		if (memcmp(t_fw->data, t_this->data,
-		    t_fw->u.user.target_size - sizeof(*t_fw)) != 0) {
-			DEBUGP("Different target\n");
-			return false;
-		}
-		return true;
-	}
+	if (!compare_targets(cs->target, this.target))
+		return false;
 
-	if (strcmp(targname_fw, targname_this) != 0) {
-		DEBUGP("Different verdict\n");
+	if (strcmp(cs->jumpto, this.jumpto) != 0)
 		return false;
-	}
 
 	return true;
 }
 
 static void nft_arp_save_counters(const void *data)
 {
-	const struct arpt_entry *fw = data;
+	const struct arptables_command_state *cs = data;
+	const struct arpt_entry *fw = &cs->fw;
 
 	save_counters(fw->counters.pcnt, fw->counters.bcnt);
 }
diff --git a/iptables/nft-arp.h b/iptables/nft-arp.h
new file mode 100644
index 0000000..930dae5
--- /dev/null
+++ b/iptables/nft-arp.h
@@ -0,0 +1,16 @@
+#ifndef _NFT_ARP_H_
+#define _NFT_ARP_H_
+
+extern char *opcodes[];
+#define NUMOPCODES 9
+
+struct arptables_command_state {
+	struct arpt_entry fw;
+	struct xtables_target *target;
+	const char *jumpto;
+};
+
+void nft_rule_to_arptables_command_state(struct nft_rule *r,
+					 struct arptables_command_state *cs);
+
+#endif
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c22e83d..86b7ac9 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -303,7 +303,7 @@ static void *nft_get_data(struct nft_xt_ctx *ctx)
 	case NFPROTO_IPV6:
 		return ctx->state.cs;
 	case NFPROTO_ARP:
-		return ctx->state.fw;
+		return ctx->state.cs_arp;
 	default:
 		/* Should not happen */
 		return NULL;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c383292..aa97b84 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -47,7 +47,7 @@ enum {
 struct nft_xt_ctx {
 	union {
 		struct iptables_command_state *cs;
-		struct arpt_entry *fw;
+		struct arptables_command_state *cs_arp;
 	} state;
 	struct nft_rule_expr_iter *iter;
 	int family;
@@ -204,19 +204,4 @@ struct xtables_args {
 #define CMD_ZERO_NUM		0x2000U
 #define CMD_CHECK		0x4000U
 
-/*
- * ARP
- */
-extern char *opcodes[];
-#define NUMOPCODES 9
-
-static inline struct xt_entry_target *nft_arp_get_target(struct arpt_entry *fw)
-{
-	struct xt_entry_target **target;
-
-	target = (void *) &fw->elems;
-
-	return *target;
-}
-
 #endif
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 0c79a38..c92b9e7 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -49,6 +49,7 @@
 #include "xshared.h"
 
 #include "nft.h"
+#include "nft-arp.h"
 #include <linux/netfilter_arp/arp_tables.h>
 
 typedef char arpt_chainlabel[32];
@@ -808,28 +809,6 @@ list_entries(struct nft_handle *h, const char *chain, const char *table,
 	return nft_rule_list(h, chain, table, rulenum, format);
 }
 
-static struct arpt_entry *
-generate_entry(const struct arpt_entry *fw,
-	       struct arpt_entry_target *target)
-{
-	struct arpt_entry_target **t;
-	struct arpt_entry *e;
-	unsigned int size;
-
-
-	size = sizeof(struct arpt_entry);
-
-	e = xtables_malloc(size);
-	*e = *fw;
-	e->target_offset = offsetof(struct arpt_entry, elems);
-	e->next_offset = e->target_offset + target->u.target_size;
-
-	t = (void *) &e->elems;
-	*t = target;
-
-	return e;
-}
-
 static struct xtables_target *command_jump(struct arpt_entry *fw,
 					   const char *jumpto)
 {
@@ -869,7 +848,7 @@ static int
 append_entry(struct nft_handle *h,
 	     const char *chain,
 	     const char *table,
-	     struct arpt_entry *fw,
+	     struct arptables_command_state *cs,
 	     int rulenum,
 	     unsigned int nsaddrs,
 	     const struct in_addr saddrs[],
@@ -881,14 +860,14 @@ append_entry(struct nft_handle *h,
 	int ret = 1;
 
 	for (i = 0; i < nsaddrs; i++) {
-		fw->arp.src.s_addr = saddrs[i].s_addr;
+		cs->fw.arp.src.s_addr = saddrs[i].s_addr;
 		for (j = 0; j < ndaddrs; j++) {
-			fw->arp.tgt.s_addr = daddrs[j].s_addr;
+			cs->fw.arp.tgt.s_addr = daddrs[j].s_addr;
 			if (append) {
-				ret = nft_rule_append(h, chain, table, fw, 0,
+				ret = nft_rule_append(h, chain, table, cs, 0,
 						      verbose);
 			} else {
-				ret = nft_rule_insert(h, chain, table, fw,
+				ret = nft_rule_insert(h, chain, table, cs,
 						      rulenum, verbose);
 			}
 		}
@@ -900,22 +879,22 @@ append_entry(struct nft_handle *h,
 static int
 replace_entry(const char *chain,
 	      const char *table,
-	      struct arpt_entry *fw,
+	      struct arptables_command_state *cs,
 	      unsigned int rulenum,
 	      const struct in_addr *saddr,
 	      const struct in_addr *daddr,
 	      bool verbose, struct nft_handle *h)
 {
-	fw->arp.src.s_addr = saddr->s_addr;
-	fw->arp.tgt.s_addr = daddr->s_addr;
+	cs->fw.arp.src.s_addr = saddr->s_addr;
+	cs->fw.arp.tgt.s_addr = daddr->s_addr;
 
-	return nft_rule_replace(h, chain, table, fw, rulenum, verbose);
+	return nft_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
 static int
 delete_entry(const char *chain,
 	     const char *table,
-	     struct arpt_entry *fw,
+	     struct arptables_command_state *cs,
 	     unsigned int nsaddrs,
 	     const struct in_addr saddrs[],
 	     unsigned int ndaddrs,
@@ -926,10 +905,10 @@ delete_entry(const char *chain,
 	int ret = 1;
 
 	for (i = 0; i < nsaddrs; i++) {
-		fw->arp.src.s_addr = saddrs[i].s_addr;
+		cs->fw.arp.src.s_addr = saddrs[i].s_addr;
 		for (j = 0; j < ndaddrs; j++) {
-			fw->arp.tgt.s_addr = daddrs[j].s_addr;
-			ret = nft_rule_delete(h, chain, table, fw, verbose);
+			cs->fw.arp.tgt.s_addr = daddrs[j].s_addr;
+			ret = nft_rule_delete(h, chain, table, cs, verbose);
 		}
 	}
 
@@ -938,7 +917,7 @@ delete_entry(const char *chain,
 
 int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 {
-	struct arpt_entry fw, *e = NULL;
+	struct arptables_command_state cs;
 	int invert = 0;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in_addr *saddrs = NULL, *daddrs = NULL;
@@ -950,12 +929,11 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 	unsigned int rulenum = 0, options = 0, command = 0;
 	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
-	struct xtables_target *target = NULL;
 	struct xtables_target *t;
 
-	const char *jumpto = "";
+	memset(&cs, 0, sizeof(cs));
+	cs.jumpto = "";
 
-	memset(&fw, 0, sizeof(fw));
 	opts = original_opts;
 	global_option_offset = 0;
 
@@ -1106,47 +1084,47 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			break;
 		case 's':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_S_IP, &fw.arp.invflags,
+			set_option(&options, OPT_S_IP, &cs.fw.arp.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_D_IP, &fw.arp.invflags,
+			set_option(&options, OPT_D_IP, &cs.fw.arp.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
 			break;
 
 		case 2:/* src-mac */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_S_MAC, &fw.arp.invflags,
+			set_option(&options, OPT_S_MAC, &cs.fw.arp.invflags,
 				   invert);
 			if (getmac_and_mask(argv[optind - 1],
-			    fw.arp.src_devaddr.addr, fw.arp.src_devaddr.mask))
+			    cs.fw.arp.src_devaddr.addr, cs.fw.arp.src_devaddr.mask))
 				xtables_error(PARAMETER_PROBLEM, "Problem with specified "
 						"source mac");
 			break;
 
 		case 3:/* dst-mac */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_D_MAC, &fw.arp.invflags,
+			set_option(&options, OPT_D_MAC, &cs.fw.arp.invflags,
 				   invert);
 
 			if (getmac_and_mask(argv[optind - 1],
-			    fw.arp.tgt_devaddr.addr, fw.arp.tgt_devaddr.mask))
+			    cs.fw.arp.tgt_devaddr.addr, cs.fw.arp.tgt_devaddr.mask))
 				xtables_error(PARAMETER_PROBLEM, "Problem with specified "
 						"destination mac");
 			break;
 
 		case 'l':/* hardware length */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_H_LENGTH, &fw.arp.invflags,
+			set_option(&options, OPT_H_LENGTH, &cs.fw.arp.invflags,
 				   invert);
-			getlength_and_mask(argv[optind - 1], &fw.arp.arhln,
-					   &fw.arp.arhln_mask);
+			getlength_and_mask(argv[optind - 1], &cs.fw.arp.arhln,
+					   &cs.fw.arp.arhln_mask);
 
-			if (fw.arp.arhln != 6) {
+			if (cs.fw.arp.arhln != 6) {
 				xtables_error(PARAMETER_PROBLEM,
 					      "Only harware address length of"
 					      " 6 is supported currently.");
@@ -1158,19 +1136,20 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			xtables_error(PARAMETER_PROBLEM, "not supported");
 /*
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_P_LENGTH, &fw.arp.invflags,
+			set_option(&options, OPT_P_LENGTH, &cs.fw.arp.invflags,
 				   invert);
 
-			getlength_and_mask(argv[optind - 1], &fw.arp.arpln,
-					   &fw.arp.arpln_mask);
+			getlength_and_mask(argv[optind - 1], &cs.fw.arp.arpln,
+					   &cs.fw.arp.arpln_mask);
 			break;
 */
 
 		case 4:/* opcode */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_OPCODE, &fw.arp.invflags,
+			set_option(&options, OPT_OPCODE, &cs.fw.arp.invflags,
 				   invert);
-			if (get16_and_mask(argv[optind - 1], &fw.arp.arpop, &fw.arp.arpop_mask, 10)) {
+			if (get16_and_mask(argv[optind - 1], &cs.fw.arp.arpop,
+					   &cs.fw.arp.arpop_mask, 10)) {
 				int i;
 
 				for (i = 0; i < NUMOPCODES; i++)
@@ -1178,63 +1157,65 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 						break;
 				if (i == NUMOPCODES)
 					xtables_error(PARAMETER_PROBLEM, "Problem with specified opcode");
-				fw.arp.arpop = htons(i+1);
+				cs.fw.arp.arpop = htons(i+1);
 			}
 			break;
 
 		case 5:/* h-type */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_H_TYPE, &fw.arp.invflags,
+			set_option(&options, OPT_H_TYPE, &cs.fw.arp.invflags,
 				   invert);
-			if (get16_and_mask(argv[optind - 1], &fw.arp.arhrd, &fw.arp.arhrd_mask, 16)) {
+			if (get16_and_mask(argv[optind - 1], &cs.fw.arp.arhrd,
+					   &cs.fw.arp.arhrd_mask, 16)) {
 				if (strcasecmp(argv[optind-1], "Ethernet"))
 					xtables_error(PARAMETER_PROBLEM, "Problem with specified hardware type");
-				fw.arp.arhrd = htons(1);
+				cs.fw.arp.arhrd = htons(1);
 			}
 			break;
 
 		case 6:/* proto-type */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_P_TYPE, &fw.arp.invflags,
+			set_option(&options, OPT_P_TYPE, &cs.fw.arp.invflags,
 				   invert);
-			if (get16_and_mask(argv[optind - 1], &fw.arp.arpro, &fw.arp.arpro_mask, 0)) {
+			if (get16_and_mask(argv[optind - 1], &cs.fw.arp.arpro,
+					   &cs.fw.arp.arpro_mask, 0)) {
 				if (strcasecmp(argv[optind-1], "ipv4"))
 					xtables_error(PARAMETER_PROBLEM, "Problem with specified protocol type");
-				fw.arp.arpro = htons(0x800);
+				cs.fw.arp.arpro = htons(0x800);
 			}
 			break;
 
 		case 'j':
-			set_option(&options, OPT_JUMP, &fw.arp.invflags,
+			set_option(&options, OPT_JUMP, &cs.fw.arp.invflags,
 				   invert);
-			jumpto = parse_target(optarg);
-			target = command_jump(&fw, jumpto);
+			cs.jumpto = parse_target(optarg);
+			cs.target = command_jump(&cs.fw, cs.jumpto);
 			break;
 
 		case 'i':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_VIANAMEIN, &fw.arp.invflags,
+			set_option(&options, OPT_VIANAMEIN, &cs.fw.arp.invflags,
 				   invert);
 			parse_interface(argv[optind-1],
-					fw.arp.iniface,
-					fw.arp.iniface_mask);
-/*			fw.nfcache |= NFC_IP_IF_IN; */
+					cs.fw.arp.iniface,
+					cs.fw.arp.iniface_mask);
+/*			cs.fw.nfcache |= NFC_IP_IF_IN; */
 			break;
 
 		case 'o':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_VIANAMEOUT, &fw.arp.invflags,
+			set_option(&options, OPT_VIANAMEOUT, &cs.fw.arp.invflags,
 				   invert);
 			parse_interface(argv[optind-1],
-					fw.arp.outiface,
-					fw.arp.outiface_mask);
-			/* fw.nfcache |= NFC_IP_IF_OUT; */
+					cs.fw.arp.outiface,
+					cs.fw.arp.outiface_mask);
+			/* cs.fw.nfcache |= NFC_IP_IF_OUT; */
 			break;
 
 		case 'v':
 			if (!verbose)
 				set_option(&options, OPT_VERBOSE,
-					   &fw.arp.invflags, invert);
+					   &cs.fw.arp.invflags, invert);
 			verbose++;
 			break;
 
@@ -1257,7 +1238,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 		break;
 
 		case 'n':
-			set_option(&options, OPT_NUMERIC, &fw.arp.invflags,
+			set_option(&options, OPT_NUMERIC, &cs.fw.arp.invflags,
 				   invert);
 			break;
 
@@ -1277,7 +1258,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			exit(0);
 
 		case '0':
-			set_option(&options, OPT_LINENUMBERS, &fw.arp.invflags,
+			set_option(&options, OPT_LINENUMBERS, &cs.fw.arp.invflags,
 				   invert);
 			break;
 
@@ -1287,7 +1268,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 
 		case 'c':
 
-			set_option(&options, OPT_COUNTERS, &fw.arp.invflags,
+			set_option(&options, OPT_COUNTERS, &cs.fw.arp.invflags,
 				   invert);
 			pcnt = optarg;
 			if (optind < argc && argv[optind][0] != '-'
@@ -1298,12 +1279,12 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 					      "-%c requires packet and byte counter",
 					      opt2char(OPT_COUNTERS));
 
-			if (sscanf(pcnt, "%llu", &fw.counters.pcnt) != 1)
+			if (sscanf(pcnt, "%llu", &cs.fw.counters.pcnt) != 1)
 			xtables_error(PARAMETER_PROBLEM,
 				"-%c packet counter not numeric",
 				opt2char(OPT_COUNTERS));
 
-			if (sscanf(bcnt, "%llu", &fw.counters.bcnt) != 1)
+			if (sscanf(bcnt, "%llu", &cs.fw.counters.bcnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					      "-%c byte counter not numeric",
 					      opt2char(OPT_COUNTERS));
@@ -1325,17 +1306,17 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			exit_tryhelp(2);
 
 		default:
-			if (target) {
+			if (cs.target) {
 				xtables_option_tpcall(c, argv,
-						      invert, target, &fw);
+						      invert, cs.target, &cs.fw);
 			}
 			break;
 		}
 		invert = FALSE;
 	}
 
-	if (target)
-		xtables_option_tfcall(target);
+	if (cs.target)
+		xtables_option_tfcall(cs.target);
 
 	if (optind < argc)
 		xtables_error(PARAMETER_PROBLEM,
@@ -1355,14 +1336,14 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 
 	if (shostnetworkmask)
 		parse_hostnetworkmask(shostnetworkmask, &saddrs,
-				      &(fw.arp.smsk), &nsaddrs);
+				      &(cs.fw.arp.smsk), &nsaddrs);
 
 	if (dhostnetworkmask)
 		parse_hostnetworkmask(dhostnetworkmask, &daddrs,
-				      &(fw.arp.tmsk), &ndaddrs);
+				      &(cs.fw.arp.tmsk), &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
-	    (fw.arp.invflags & (ARPT_INV_SRCIP | ARPT_INV_TGTIP)))
+	    (cs.fw.arp.invflags & (ARPT_INV_SRCIP | ARPT_INV_TGTIP)))
 		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 				" source or destination IP addresses");
 
@@ -1409,34 +1390,26 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 						chain);
 		}
 
-		if (!target && strlen(jumpto) != 0) {
+		if (!cs.target && strlen(cs.jumpto) != 0) {
 			size_t size;
 
-			target = xtables_find_target(XT_STANDARD_TARGET,
-						     XTF_LOAD_MUST_SUCCEED);
-			size = sizeof(struct arpt_entry_target) + target->size;
-			target->t = xtables_calloc(1, size);
-			target->t->u.target_size = size;
-			strcpy(target->t->u.user.name, jumpto);
-		}
-
-		if (!target) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "No target provided or"
-				      " initalization failed");
+			cs.target = xtables_find_target(XT_STANDARD_TARGET,
+							XTF_LOAD_MUST_SUCCEED);
+			size = sizeof(struct arpt_entry_target) + cs.target->size;
+			cs.target->t = xtables_calloc(1, size);
+			cs.target->t->u.target_size = size;
+			strcpy(cs.target->t->u.user.name, cs.jumpto);
 		}
-
-		e = generate_entry(&fw, target->t);
 	}
 
 	switch (command) {
 	case CMD_APPEND:
-		ret = append_entry(h, chain, *table, e, 0,
+		ret = append_entry(h, chain, *table, &cs, 0,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE, true);
 		break;
 	case CMD_DELETE:
-		ret = delete_entry(chain, *table, e,
+		ret = delete_entry(chain, *table, &cs,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE, h);
 		break;
@@ -1444,11 +1417,11 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 		ret = nft_rule_delete_num(h, chain, *table, rulenum - 1, verbose);
 		break;
 	case CMD_REPLACE:
-		ret = replace_entry(chain, *table, e, rulenum - 1,
+		ret = replace_entry(chain, *table, &cs, rulenum - 1,
 				    saddrs, daddrs, options&OPT_VERBOSE, h);
 		break;
 	case CMD_INSERT:
-		ret = append_entry(h, chain, *table, e, rulenum - 1,
+		ret = append_entry(h, chain, *table, &cs, rulenum - 1,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE, false);
 		break;
diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
index 1e0b175..5aa7c6f 100644
--- a/iptables/xtables-events.c
+++ b/iptables/xtables-events.c
@@ -27,6 +27,7 @@
 #include "iptables.h" /* for xtables_globals */
 #include "xtables-multi.h"
 #include "nft.h"
+#include "nft-arp.h"
 
 static int table_cb(const struct nlmsghdr *nlh, int type)
 {
@@ -55,7 +56,7 @@ static bool counters;
 static int rule_cb(const struct nlmsghdr *nlh, int type)
 {
 	struct iptables_command_state cs = {};
-	struct arpt_entry fw_arp = {};
+	struct arptables_command_state cs_arp = {};
 	struct nft_rule *r;
 	void *fw = NULL;
 	uint8_t family;
@@ -77,8 +78,8 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 		break;
 	case NFPROTO_ARP:
 		printf("-0 ");
-		nft_rule_to_arpt_entry(r, &fw_arp);
-		fw = &fw_arp;
+		nft_rule_to_arptables_command_state(r, &cs_arp);
+		fw = &cs_arp;
 		break;
 	default:
 		goto err_free;
-- 
1.7.10.4

