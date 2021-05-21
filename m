Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F82CC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C13E613DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhEUMK2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 08:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhEUMK0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 08:10:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37491C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 05:09:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lk3xd-0005f4-L8; Fri, 21 May 2021 14:09:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] src: add support for base hook dumping
Date:   Fri, 21 May 2021 14:08:45 +0200
Message-Id: <20210521120846.1140-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210521120846.1140-1-fw@strlen.de>
References: <20210521120846.1140-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Example output:
$ nft list hook ip input
family ip hook input {
        +0000000000 nft_do_chain_inet [nf_tables]       # nft table ip filter chain input
        +0000000010 nft_do_chain_inet [nf_tables]       # nft table ip firewalld chain filter_INPUT
        +0000000100 nf_nat_ipv4_local_in [nf_nat]
        +2147483647 ipv4_confirm [nf_conntrack]
}

$ nft list hooks netdev type ingress device lo
family netdev hook ingress device lo {
        +0000000000 nft_do_chain_netdev [nf_tables]
}

$ nft list hooks inet
family ip hook prerouting {
        -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
        -0000000300 iptable_raw_hook [iptable_raw]
        -0000000290 nft_do_chain_inet [nf_tables]       # nft table ip firewalld chain raw_PREROUTING
        -0000000200 ipv4_conntrack_in [nf_conntrack]
        -0000000140 nft_do_chain_inet [nf_tables]       # nft table ip firewalld chain mangle_PREROUTING
        -0000000100 nf_nat_ipv4_pre_routing [nf_nat]
}
...

'nft list hooks' will display everyting except the netdev family
via successive dump request for all family:hook combinations.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h |   4 +
 include/mnl.h                       |   3 +
 include/rule.h                      |   1 +
 src/evaluate.c                      |  10 ++
 src/mnl.c                           | 269 +++++++++++++++++++++++++++-
 src/parser_bison.y                  |  48 ++++-
 src/rule.c                          |  13 ++
 src/scanner.l                       |   1 +
 8 files changed, 346 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 75df968d231b..c53b0383ebac 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -124,6 +124,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_GETFNHOOKS,
 	NFT_MSG_MAX,
 };
 
@@ -153,6 +154,9 @@ enum nft_hook_attributes {
 	NFTA_HOOK_PRIORITY,
 	NFTA_HOOK_DEV,
 	NFTA_HOOK_DEVS,
+	NFTA_HOOK_FUNCTION_NAME,
+	NFTA_HOOK_MODULE_NAME,
+	NFTA_HOOK_NFT_CHAIN_INFO,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
diff --git a/include/mnl.h b/include/mnl.h
index 979929c31c17..68ec80cd2282 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -82,6 +82,9 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			  unsigned int flags);
 int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
+int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook,
+			  const char *devname);
+
 int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 			   struct output_ctx *octx,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
diff --git a/include/rule.h b/include/rule.h
index f469db55bf60..357326a3fceb 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -644,6 +644,7 @@ enum cmd_obj {
 	CMD_OBJ_CT_EXPECT,
 	CMD_OBJ_SYNPROXY,
 	CMD_OBJ_SYNPROXYS,
+	CMD_OBJ_HOOKS,
 };
 
 struct markup {
diff --git a/src/evaluate.c b/src/evaluate.c
index 006b04affbd7..d1c6dd84ec90 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4698,6 +4698,16 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_METERS:
 	case CMD_OBJ_MAPS:
 		return 0;
+	case CMD_OBJ_HOOKS:
+		if (cmd->handle.chain.name) {
+			int hooknum = str2hooknum(cmd->handle.family, cmd->handle.chain.name);
+
+			if (hooknum == NF_INET_NUMHOOKS)
+				return chain_not_found(ctx);
+
+			cmd->handle.chain_id = hooknum;
+		}
+		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/mnl.c b/src/mnl.c
index ef45cbd193f9..83612962c98e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -34,6 +34,17 @@
 #include <stdlib.h>
 #include <utils.h>
 #include <nftables.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_arp.h>
+
+struct basehook {
+	struct list_head list;
+	const char *module_name;
+	const char *hookfn;
+	const char *table;
+	const char *chain;
+	int prio;
+};
 
 struct mnl_socket *nft_mnl_socket_open(void)
 {
@@ -1874,7 +1885,7 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 			   void *cb_data)
 {
 	/* Set netlink socket buffer size to 16 Mbytes to reduce chances of
- 	 * message loss due to ENOBUFS.
+	 * message loss due to ENOBUFS.
 	 */
 	unsigned int bufsiz = NFTABLES_NLEVENT_BUFSIZ;
 	int fd = mnl_socket_get_fd(nf_sock);
@@ -1918,3 +1929,259 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 	}
 	return ret;
 }
+
+static struct basehook *basehook_alloc(void)
+{
+	return xzalloc(sizeof(struct basehook));
+}
+
+static void basehook_free(struct basehook *b)
+{
+	list_del(&b->list);
+	xfree(b->module_name);
+	xfree(b->hookfn);
+	xfree(b->chain);
+	xfree(b->table);
+	xfree(b);
+}
+
+static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
+{
+	list_add_tail(&b->list, head);
+}
+
+static int dump_nf_attr_cb(const struct nlattr *attr, void *data)
+{
+        int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+        if (mnl_attr_type_valid(attr, NFTA_HOOK_MAX) < 0)
+                return MNL_CB_OK;
+
+        switch(type) {
+	case NFTA_HOOK_HOOKNUM:
+	case NFTA_HOOK_PRIORITY:
+                if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+                        return MNL_CB_ERROR;
+		break;
+	case NFTA_HOOK_DEV:
+	case NFTA_HOOK_FUNCTION_NAME:
+	case NFTA_HOOK_MODULE_NAME:
+                if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+                        return MNL_CB_ERROR;
+		break;
+	case NFTA_HOOK_NFT_CHAIN_INFO:
+                if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+                        return MNL_CB_ERROR;
+		break;
+	default:
+		return MNL_CB_OK;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int dump_nf_attr_chain_cb(const struct nlattr *attr, void *data)
+{
+        int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+        if (mnl_attr_type_valid(attr, NFTA_CHAIN_MAX) < 0)
+                return MNL_CB_OK;
+
+        switch(type) {
+	case NFTA_CHAIN_TABLE:
+	case NFTA_CHAIN_NAME:
+                if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+                        return MNL_CB_ERROR;
+		break;
+	default:
+		return MNL_CB_OK;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int dump_nf_hooks(const struct nlmsghdr *nlh, void *data)
+{
+	const struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[NFTA_HOOK_MAX + 1] = {};
+	struct list_head *head = data;
+	struct basehook *hook;
+
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
+        if (mnl_attr_parse(nlh, sizeof(*nfg), dump_nf_attr_cb, tb) < 0)
+                return -1;
+
+	hook = basehook_alloc();
+	hook->prio = ntohl(mnl_attr_get_u32(tb[NFTA_HOOK_PRIORITY]));
+
+	if (tb[NFTA_HOOK_FUNCTION_NAME])
+		hook->hookfn = xstrdup(mnl_attr_get_str(tb[NFTA_HOOK_FUNCTION_NAME]));
+
+	if (tb[NFTA_HOOK_MODULE_NAME])
+		hook->module_name = xstrdup(mnl_attr_get_str(tb[NFTA_HOOK_MODULE_NAME]));
+
+	if (tb[NFTA_HOOK_NFT_CHAIN_INFO]) {
+		struct nlattr *nested[NFTA_CHAIN_MAX + 1] = {};
+
+		if (mnl_attr_parse_nested(tb[NFTA_HOOK_NFT_CHAIN_INFO], dump_nf_attr_chain_cb, nested) < 0)
+			return -1;
+
+		hook->table = xstrdup(mnl_attr_get_str(nested[NFTA_CHAIN_TABLE]));
+		hook->chain = xstrdup(mnl_attr_get_str(nested[NFTA_CHAIN_NAME]));
+	}
+
+	basehook_list_add_tail(hook, head);
+	return MNL_CB_OK;
+}
+
+static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t family, uint8_t hooknum, const char *devname)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct basehook *hook, *tmp;
+	struct nlmsghdr *nlh;
+	LIST_HEAD(hook_list);
+	FILE *fp;
+	int ret;
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETFNHOOKS, family,
+				    NLM_F_DUMP, ctx->seqnum);
+
+	if (devname)
+		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, devname);
+
+	mnl_attr_put_u32(nlh, NFTA_HOOK_HOOKNUM, htonl(hooknum));
+
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, dump_nf_hooks, &hook_list);
+	if (ret)
+		return ret;
+
+	if (list_empty(&hook_list))
+		return 0;
+
+	fp = ctx->nft->output.output_fp;
+	fprintf(fp, "family %s hook %s", family2str(family), hooknum2str(family, hooknum));
+	if (devname)
+		fprintf(fp, " device %s", devname);
+
+	fprintf(fp, " {\n");
+
+	list_for_each_entry_safe(hook, tmp, &hook_list, list) {
+		int prio = hook->prio;
+
+		if (prio < 0)
+			fprintf(fp, "\t%011d", prio); /* outputs a '-' sign */
+		else
+			fprintf(fp, "\t+%010u", prio);
+
+		if (hook->hookfn) {
+			fprintf(fp, " %s", hook->hookfn);
+			if (hook->module_name)
+				fprintf(fp, " [%s]", hook->module_name);
+		}
+
+		if (hook->table && hook->chain)
+			fprintf(fp, "\t# nft table %s %s chain %s", family2str(family), hook->table, hook->chain);
+
+		fprintf(fp, "\n");
+		basehook_free(hook);
+	}
+
+	fprintf(fp, "}\n");
+	return ret;
+}
+
+int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const char *devname)
+{
+	unsigned int i;
+	int ret, err;
+
+	errno = 0;
+	ret = 0;
+
+	switch (family) {
+	case NFPROTO_UNSPEC:
+		if (devname)
+			return mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, NF_INET_INGRESS, devname);
+
+		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_INET, hook, NULL);
+		if (err < 0 && errno != EPROTONOSUPPORT)
+			ret = err;
+		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_ARP, hook, NULL);
+		if (err < 0 && errno != EPROTONOSUPPORT)
+			ret = err;
+		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_BRIDGE, hook, NULL);
+		if (err < 0 && errno != EPROTONOSUPPORT)
+			ret = err;
+		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_DECNET, hook, NULL);
+		if (err < 0 && errno != EPROTONOSUPPORT)
+			ret = err;
+		ret = 0;
+		break;
+	case NFPROTO_INET:
+		if (devname) {
+			err = __mnl_nft_dump_nf_hooks(ctx, family, NF_INET_INGRESS, devname);
+			if (err < 0)
+				ret = err;
+		}
+
+		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, hook, NULL);
+		if (err < 0)
+			ret = err;
+		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, hook, NULL);
+		if (err < 0)
+			ret = err;
+
+		break;
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_BRIDGE:
+		if (hook >= 0)
+			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
+
+		for (i = 0; i <= NF_INET_POST_ROUTING; i++) {
+			err = __mnl_nft_dump_nf_hooks(ctx, family, i, NULL);
+			if (err < 0)
+				err = ret;
+		}
+		break;
+	case NFPROTO_ARP:
+		if (hook >= 0)
+			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
+
+		err = __mnl_nft_dump_nf_hooks(ctx, family, NF_ARP_IN, devname);
+		if (err < 0)
+			ret = err;
+		err = __mnl_nft_dump_nf_hooks(ctx, family, NF_ARP_OUT, devname);
+		if (err < 0)
+			ret = err;
+		break;
+	case NFPROTO_NETDEV:
+		if (hook >= 0)
+			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
+
+		err = __mnl_nft_dump_nf_hooks(ctx, family, NF_INET_INGRESS, devname);
+		if (err < 0)
+			ret = err;
+		break;
+	case NFPROTO_DECNET:
+		if (hook >= 0)
+			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
+#define NF_DN_NUMHOOKS		7
+		for (i = 0; i < NF_DN_NUMHOOKS; i++) {
+			err = __mnl_nft_dump_nf_hooks(ctx, family, i, devname);
+			if (err < 0) {
+				ret = err;
+				break;
+			}
+		}
+		break;
+	}
+
+	return ret;
+}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f6c92feb7661..136ae105f513 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -238,6 +238,7 @@ int nft_lex(void *, void *, void *);
 %token TYPEOF			"typeof"
 
 %token HOOK			"hook"
+%token HOOKS			"hooks"
 %token DEVICE			"device"
 %token DEVICES			"devices"
 %token TABLE			"table"
@@ -632,11 +633,15 @@ int nft_lex(void *, void *, void *);
 
 %type <handle>			set_identifier flowtableid_spec flowtable_identifier obj_identifier
 %destructor { handle_free(&$$); } set_identifier flowtableid_spec obj_identifier
+
+%type <handle>			basehook_spec
+%destructor { handle_free(&$$); } basehook_spec
+
 %type <val>			family_spec family_spec_explicit
 %type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
-%type <string>			extended_prio_name quota_unit
-%destructor { xfree($$); }	extended_prio_name quota_unit
+%type <string>			extended_prio_name quota_unit	basehook_device_name
+%destructor { xfree($$); }	extended_prio_name quota_unit	basehook_device_name
 
 %type <expr>			dev_spec
 %destructor { xfree($$); }	dev_spec
@@ -1456,6 +1461,45 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, $2, &$4, &@$, NULL);
 			}
+			|	HOOKS	basehook_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_HOOKS, &$2, &@$, NULL);
+			}
+			;
+
+basehook_device_name	:	/* NULL */
+			{
+				$$ = NULL;
+			}
+			|	DEVICE STRING
+			{
+				$$ = $2;
+			}
+			;
+
+basehook_spec		:	ruleset_spec
+			{
+				$$ = $1;
+			}
+			|	ruleset_spec    STRING  basehook_device_name
+			{
+				const char *name = chain_hookname_lookup($2);
+
+				if (name == NULL) {
+					erec_queue(error(&@2, "unknown chain hook"),
+						   state->msgs);
+					xfree($3);
+					YYERROR;
+				}
+
+				$1.chain.name = $2;
+				$1.chain.location = @2;
+				if ($3) {
+					$1.obj.name = $3;
+					$1.obj.location = @3;
+				}
+				$$ = $1;
+			}
 			;
 
 reset_cmd		:	COUNTERS	ruleset_spec
diff --git a/src/rule.c b/src/rule.c
index dcf1646a9c7c..04b3451e917c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2364,6 +2364,17 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	return 0;
 }
 
+static int do_list_hooks(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	const char *devname = cmd->handle.obj.name;
+	int hooknum = -1;
+
+	if (cmd->handle.chain.name)
+		hooknum = cmd->handle.chain_id;
+
+	return mnl_nft_dump_nf_hooks(ctx, cmd->handle.family, hooknum, devname);
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
@@ -2424,6 +2435,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_flowtable(ctx, cmd, table);
 	case CMD_OBJ_FLOWTABLES:
 		return do_list_flowtables(ctx, cmd);
+	case CMD_OBJ_HOOKS:
+		return do_list_hooks(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index c1bc21aa7ecc..6dc1be8908cf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -354,6 +354,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"limits"		{ return LIMITS; }
 	"secmarks"		{ return SECMARKS; }
 	"synproxys"		{ return SYNPROXYS; }
+	"hooks"			{ return HOOKS; }
 }
 
 "counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
-- 
2.26.3

