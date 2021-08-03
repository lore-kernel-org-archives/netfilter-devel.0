Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE388C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 23:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B759F60EC0
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 23:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhHCXLq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 19:11:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54448 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbhHCXLq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 19:11:46 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 957AA60044;
        Wed,  4 Aug 2021 01:10:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft,v3] mnl: revisit hook listing
Date:   Wed,  4 Aug 2021 01:11:25 +0200
Message-Id: <20210803231125.24540-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update this command to display the hook datapath for a packet depending
on its family. This includes:

- Group existing hooks based on the hook location.
- Order hooks by priority, from INT_MIN to INT_MAX.
- Do not add sign to priority zero.
- Refresh include/linux/netfilter/nfnetlink_hook.h cache copy.
- Use NFNLA_CHAIN_* attributes to print the chain family, table and name.
  If NFNLA_CHAIN_* attributes are not available, display the hookfn name.
- Update syntax: remove optional hook parameter, promote the 'device'
  argument.

The following example shows the hook datapath for IPv4 packets coming in
from netdevice 'eth0':

 # nft list hooks ip device eth0
 family ip {
        hook ingress {
                +0000000010 chain netdev x y [nf_tables]
                +0000000300 chain inet m w  [nf_tables]
        }
        hook input {
                -0000000100 chain ip a b [nf_tables]
                +0000000300 chain inet m z [nf_tables]
        }
        hook forward {
                -0000000225 selinux_ipv4_forward
                 0000000000 chain ip a c [nf_tables]
        }
        hook output {
                -0000000225 selinux_ipv4_output
        }
        hook postrouting {
                +0000000225 selinux_ipv4_postroute
        }
 }

Note that the listing above includes the existing netdev and inet
hooks/chains which might interfer in the travel of an incoming IPv4
packet.

This allows users to debug the pipeline, basically, to understand in
what order the hooks/chains are evaluated for the IPv4 packets.

If the netdevice is not specified, then the ingress hook is not shown.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_hook.h |  14 +-
 include/rule.h                           |   1 +
 src/mnl.c                                | 342 ++++++++++++++++-------
 src/parser_bison.y                       |  25 +-
 src/rule.c                               |   2 +
 5 files changed, 264 insertions(+), 120 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_hook.h b/include/linux/netfilter/nfnetlink_hook.h
index d8ac8278571b..bbcd285b22e1 100644
--- a/include/linux/netfilter/nfnetlink_hook.h
+++ b/include/linux/netfilter/nfnetlink_hook.h
@@ -8,10 +8,10 @@ enum nfnl_hook_msg_types {
 };
 
 /**
- * enum nfnl_hook_attributes - nf_tables netfilter hook netlink attributes
+ * enum nfnl_hook_attributes - netfilter hook netlink attributes
  *
  * @NFNLA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
- * @NFNLAA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
+ * @NFNLA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
  * @NFNLA_HOOK_DEV: netdevice name (NLA_STRING)
  * @NFNLA_HOOK_FUNCTION_NAME: hook function name (NLA_STRING)
  * @NFNLA_HOOK_MODULE_NAME: kernel module that registered this hook (NLA_STRING)
@@ -43,6 +43,15 @@ enum nfnl_hook_chain_info_attributes {
 };
 #define NFNLA_HOOK_INFO_MAX (__NFNLA_HOOK_INFO_MAX - 1)
 
+enum nfnl_hook_chain_desc_attributes {
+	NFNLA_CHAIN_UNSPEC,
+	NFNLA_CHAIN_TABLE,
+	NFNLA_CHAIN_FAMILY,
+	NFNLA_CHAIN_NAME,
+	__NFNLA_CHAIN_MAX,
+};
+#define NFNLA_CHAIN_MAX (__NFNLA_CHAIN_MAX - 1)
+
 /**
  * enum nfnl_hook_chaintype - chain type
  *
@@ -51,4 +60,5 @@ enum nfnl_hook_chain_info_attributes {
 enum nfnl_hook_chaintype {
 	NFNL_HOOK_TYPE_NFTABLES = 0x1,
 };
+
 #endif /* _NFNL_HOOK_H */
diff --git a/include/rule.h b/include/rule.h
index 357326a3fceb..be31695636df 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -270,6 +270,7 @@ extern struct chain *chain_binding_lookup(const struct table *table,
 					  const char *chain_name);
 
 extern const char *family2str(unsigned int family);
+#define __NF_ARP_INGRESS	255
 extern const char *hooknum2str(unsigned int family, unsigned int hooknum);
 extern const char *chain_policy2str(uint32_t policy);
 extern void chain_print_plain(const struct chain *chain,
diff --git a/src/mnl.c b/src/mnl.c
index f28d6605835f..b30c27aab84a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -44,6 +44,9 @@ struct basehook {
 	const char *hookfn;
 	const char *table;
 	const char *chain;
+	int family;
+	int chain_family;
+	uint32_t num;
 	int prio;
 };
 
@@ -1948,6 +1951,20 @@ static void basehook_free(struct basehook *b)
 
 static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
 {
+	struct basehook *hook;
+
+	list_for_each_entry(hook, head, list) {
+		if (hook->family != b->family)
+			continue;
+		if (hook->num != b->num)
+			continue;
+		if (hook->prio < b->prio)
+			continue;
+
+		list_add(&b->list, &hook->list);
+		return;
+	}
+
 	list_add_tail(&b->list, head);
 }
 
@@ -2016,15 +2033,19 @@ static int dump_nf_attr_chain_cb(const struct nlattr *attr, void *data)
 	int type = mnl_attr_get_type(attr);
 	const struct nlattr **tb = data;
 
-	if (mnl_attr_type_valid(attr, NFTA_CHAIN_MAX) < 0)
+	if (mnl_attr_type_valid(attr, NFNLA_CHAIN_MAX) < 0)
 		return MNL_CB_OK;
 
 	switch(type) {
-	case NFTA_CHAIN_TABLE:
-	case NFTA_CHAIN_NAME:
+	case NFNLA_CHAIN_TABLE:
+	case NFNLA_CHAIN_NAME:
                 if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
                         return MNL_CB_ERROR;
 		break;
+	case NFNLA_CHAIN_FAMILY:
+                if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+                        return MNL_CB_ERROR;
+		break;
 	default:
 		return MNL_CB_OK;
 	}
@@ -2033,11 +2054,16 @@ static int dump_nf_attr_chain_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int dump_nf_hooks(const struct nlmsghdr *nlh, void *data)
+struct dump_nf_hook_data {
+	struct list_head *hook_list;
+	int family;
+};
+
+static int dump_nf_hooks(const struct nlmsghdr *nlh, void *_data)
 {
 	const struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
 	struct nlattr *tb[NFNLA_HOOK_MAX + 1] = {};
-	struct list_head *head = data;
+	struct dump_nf_hook_data *data = _data;
 	struct basehook *hook;
 
 	/* NB: Don't check the nft generation ID, this is not
@@ -2067,22 +2093,50 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *data)
 
 		type = ntohl(mnl_attr_get_u32(nested[NFNLA_HOOK_INFO_TYPE]));
 		if (type == NFNL_HOOK_TYPE_NFTABLES) {
-			struct nlattr *info[NFTA_CHAIN_MAX + 1] = {};
+			struct nlattr *info[NFNLA_CHAIN_MAX + 1] = {};
 			const char *tablename, *chainname;
 
 			if (mnl_attr_parse_nested(nested[NFNLA_HOOK_INFO_DESC], dump_nf_attr_chain_cb, info) < 0)
 				return -1;
 
-			tablename = mnl_attr_get_str(info[NFTA_CHAIN_TABLE]);
-			chainname = mnl_attr_get_str(info[NFTA_CHAIN_NAME]);
+			tablename = mnl_attr_get_str(info[NFNLA_CHAIN_TABLE]);
+			chainname = mnl_attr_get_str(info[NFNLA_CHAIN_NAME]);
 			if (tablename && chainname) {
 				hook->table = xstrdup(tablename);
 				hook->chain = xstrdup(chainname);
 			}
+			hook->chain_family = mnl_attr_get_u8(info[NFNLA_CHAIN_FAMILY]);
 		}
 	}
+	if (tb[NFNLA_HOOK_HOOKNUM])
+		hook->num = ntohl(mnl_attr_get_u32(tb[NFNLA_HOOK_HOOKNUM]));
+
+	hook->family = nfg->nfgen_family;
+
+	/* Netdev hooks potentially interfer with this family datapath. */
+	if (hook->family == NFPROTO_NETDEV) {
+		switch (data->family) {
+		case NFPROTO_NETDEV:
+			hook->num = NF_NETDEV_INGRESS;
+			break;
+		case NFPROTO_IPV4:
+		case NFPROTO_IPV6:
+		case NFPROTO_INET:
+		case NFPROTO_BRIDGE:
+			hook->family = data->family;
+			hook->num = NF_INET_INGRESS;
+			break;
+		case NFPROTO_ARP:
+			if (hook->chain_family == NFPROTO_NETDEV) {
+				hook->family = data->family;
+				hook->num = __NF_ARP_INGRESS;
+			}
+			break;
+		}
+	}
+
+	basehook_list_add_tail(hook, data->hook_list);
 
-	basehook_list_add_tail(hook, head);
 	return MNL_CB_OK;
 }
 
@@ -2102,14 +2156,17 @@ static struct nlmsghdr *nf_hook_dump_request(char *buf, uint8_t family, uint32_t
 	return nlh;
 }
 
-static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t family, uint8_t hooknum, const char *devname)
+static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t query_family,
+				   uint8_t family, uint8_t hooknum,
+				   const char *devname,
+				   struct list_head *hook_list)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct basehook *hook, *tmp;
+	struct dump_nf_hook_data data = {
+		.hook_list	= hook_list,
+		.family		= query_family,
+	};
 	struct nlmsghdr *nlh;
-	LIST_HEAD(hook_list);
-	FILE *fp;
-	int ret;
 
 	nlh = nf_hook_dump_request(buf, family, ctx->seqnum);
 	if (devname)
@@ -2117,130 +2174,219 @@ static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t family, uint
 
 	mnl_attr_put_u32(nlh, NFNLA_HOOK_HOOKNUM, htonl(hooknum));
 
-	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, dump_nf_hooks, &hook_list);
-	if (ret)
-		return ret;
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, dump_nf_hooks, &data);
+}
 
-	if (list_empty(&hook_list))
-		return 0;
+static void print_hooks(struct netlink_ctx *ctx, int family, struct list_head *hook_list)
+{
+	struct basehook *hook, *tmp, *prev = NULL;
+	bool same, family_in_use = false;
+	int prio;
+	FILE *fp;
 
 	fp = ctx->nft->output.output_fp;
-	fprintf(fp, "family %s hook %s", family2str(family), hooknum2str(family, hooknum));
-	if (devname)
-		fprintf(fp, " device %s", devname);
 
-	fprintf(fp, " {\n");
+	list_for_each_entry_safe(hook, tmp, hook_list, list) {
+		if (hook->family == family) {
+			family_in_use = true;
+			break;
+		}
+	}
+
+	if (!family_in_use)
+		return;
+
+	fprintf(fp, "family %s {\n", family2str(family));
 
-	list_for_each_entry_safe(hook, tmp, &hook_list, list) {
-		int prio = hook->prio;
+	list_for_each_entry_safe(hook, tmp, hook_list, list) {
+		if (hook->family != family)
+			continue;
 
+		if (prev) {
+			if (prev->num == hook->num) {
+				fprintf(fp, "\n");
+				same = true;
+			} else {
+				same = false;
+				fprintf(fp, "\n\t}\n");
+			}
+		} else {
+			same = false;
+		}
+		prev = hook;
+
+		if (!same) {
+			fprintf(fp, "\thook %s {\n",
+				hooknum2str(family, hook->num));
+		}
+
+		prio = hook->prio;
 		if (prio < 0)
-			fprintf(fp, "\t%011d", prio); /* outputs a '-' sign */
+			fprintf(fp, "\t\t%011d", prio); /* outputs a '-' sign */
+		else if (prio == 0)
+			fprintf(fp, "\t\t %010u", prio);
 		else
-			fprintf(fp, "\t+%010u", prio);
+			fprintf(fp, "\t\t+%010u", prio);
 
-		if (hook->hookfn) {
+		if (hook->table && hook->chain)
+			fprintf(fp, " chain %s %s %s", family2str(hook->chain_family), hook->table, hook->chain);
+		else if (hook->hookfn) {
 			fprintf(fp, " %s", hook->hookfn);
-			if (hook->module_name)
-				fprintf(fp, " [%s]", hook->module_name);
 		}
+		if (hook->module_name)
+			fprintf(fp, " [%s]", hook->module_name);
+	}
 
-		if (hook->table && hook->chain)
-			fprintf(fp, "\t# nft table %s %s chain %s", family2str(family), hook->table, hook->chain);
+	fprintf(fp, "\n\t}\n");
+	fprintf(fp, "}\n");
+}
 
-		fprintf(fp, "\n");
-		basehook_free(hook);
+#define HOOK_FAMILY_MAX	5
+
+static uint8_t hook_family[HOOK_FAMILY_MAX] = {
+	NFPROTO_IPV4,
+	NFPROTO_IPV6,
+	NFPROTO_BRIDGE,
+	NFPROTO_ARP,
+};
+
+static int mnl_nft_dump_nf(struct netlink_ctx *ctx, int family, int hook,
+			   const char *devname, struct list_head *hook_list,
+			   int *ret)
+{
+	int i, err;
+
+	/* show ingress in first place in hook listing. */
+	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
+	if (err < 0)
+		*ret = err;
+
+	for (i = 0; i <= NF_INET_POST_ROUTING; i++) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, family, i, devname, hook_list);
+		if (err < 0)
+			*ret = err;
 	}
 
-	fprintf(fp, "}\n");
-	return ret;
+	return err;
+}
+
+static int mnl_nft_dump_nf_arp(struct netlink_ctx *ctx, int family, int hook,
+			       const char *devname, struct list_head *hook_list,
+			       int *ret)
+{
+	int err;
+
+	/* show ingress in first place in hook listing. */
+	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
+	if (err < 0)
+		*ret = err;
+
+	err = __mnl_nft_dump_nf_hooks(ctx, family, family, NF_ARP_IN, devname, hook_list);
+	if (err < 0)
+		*ret = err;
+	err = __mnl_nft_dump_nf_hooks(ctx, family, family, NF_ARP_OUT, devname, hook_list);
+	if (err < 0)
+		*ret = err;
+
+	return err;
+}
+
+static int mnl_nft_dump_nf_netdev(struct netlink_ctx *ctx, int family, int hook,
+				  const char *devname, struct list_head *hook_list,
+				  int *ret)
+{
+	int err;
+
+	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
+	if (err < 0)
+		*ret = err;
+
+	return err;
+}
+
+static int mnl_nft_dump_nf_decnet(struct netlink_ctx *ctx, int family, int hook,
+				  const char *devname, struct list_head *hook_list,
+				  int *ret)
+{
+	int i, err;
+
+	/* show ingress in first place in hook listing. */
+	err = __mnl_nft_dump_nf_hooks(ctx, family, NFPROTO_NETDEV, NF_NETDEV_INGRESS, devname, hook_list);
+	if (err < 0)
+		*ret = err;
+
+#define NF_DN_NUMHOOKS		7
+	for (i = 0; i < NF_DN_NUMHOOKS; i++) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, family, i, devname, hook_list);
+		if (err < 0) {
+			*ret = err;
+			return err;
+		}
+	}
+
+	return err;
+}
+
+static void release_hook_list(struct list_head *hook_list)
+{
+	struct basehook *hook, *next;
+
+	list_for_each_entry_safe(hook, next, hook_list, list)
+		basehook_free(hook);
 }
 
 int mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, int family, int hook, const char *devname)
 {
+	LIST_HEAD(hook_list);
 	unsigned int i;
-	int ret, err;
+	int ret;
 
 	errno = 0;
 	ret = 0;
 
 	switch (family) {
 	case NFPROTO_UNSPEC:
-		if (devname)
-			return mnl_nft_dump_nf_hooks(ctx, NFPROTO_NETDEV, NF_INET_INGRESS, devname);
-
-		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_INET, hook, NULL);
-		if (err < 0 && errno != EPROTONOSUPPORT)
-			ret = err;
-		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_ARP, hook, NULL);
-		if (err < 0 && errno != EPROTONOSUPPORT)
-			ret = err;
-		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_BRIDGE, hook, NULL);
-		if (err < 0 && errno != EPROTONOSUPPORT)
-			ret = err;
-		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_DECNET, hook, NULL);
-		if (err < 0 && errno != EPROTONOSUPPORT)
-			ret = err;
+		mnl_nft_dump_nf(ctx, NFPROTO_IPV4, hook, devname, &hook_list, &ret);
+		mnl_nft_dump_nf(ctx, NFPROTO_IPV6, hook, devname, &hook_list, &ret);
+		mnl_nft_dump_nf(ctx, NFPROTO_BRIDGE, hook, devname, &hook_list, &ret);
+		mnl_nft_dump_nf_decnet(ctx, NFPROTO_DECNET, hook, devname, &hook_list, &ret);
 		break;
 	case NFPROTO_INET:
-		if (devname) {
-			err = __mnl_nft_dump_nf_hooks(ctx, family, NF_INET_INGRESS, devname);
-			if (err < 0)
-				ret = err;
-		}
-
-		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, hook, NULL);
-		if (err < 0)
-			ret = err;
-		err = mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, hook, NULL);
-		if (err < 0)
-			ret = err;
-
+		mnl_nft_dump_nf(ctx, NFPROTO_IPV4, hook, devname, &hook_list, &ret);
+		mnl_nft_dump_nf(ctx, NFPROTO_IPV6, hook, devname, &hook_list, &ret);
 		break;
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 	case NFPROTO_BRIDGE:
-		if (hook >= 0)
-			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
-
-		for (i = 0; i <= NF_INET_POST_ROUTING; i++) {
-			err = __mnl_nft_dump_nf_hooks(ctx, family, i, NULL);
-			if (err < 0)
-				err = ret;
-		}
+		mnl_nft_dump_nf(ctx, family, hook, devname, &hook_list, &ret);
 		break;
 	case NFPROTO_ARP:
-		if (hook >= 0)
-			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
-
-		err = __mnl_nft_dump_nf_hooks(ctx, family, NF_ARP_IN, devname);
-		if (err < 0)
-			ret = err;
-		err = __mnl_nft_dump_nf_hooks(ctx, family, NF_ARP_OUT, devname);
-		if (err < 0)
-			ret = err;
+		mnl_nft_dump_nf_arp(ctx, family, hook, devname, &hook_list, &ret);
 		break;
 	case NFPROTO_NETDEV:
-		if (hook >= 0)
-			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
-
-		err = __mnl_nft_dump_nf_hooks(ctx, family, NF_INET_INGRESS, devname);
-		if (err < 0)
-			ret = err;
+		mnl_nft_dump_nf_netdev(ctx, family, hook, devname, &hook_list, &ret);
 		break;
 	case NFPROTO_DECNET:
-		if (hook >= 0)
-			return __mnl_nft_dump_nf_hooks(ctx, family, hook, devname);
-#define NF_DN_NUMHOOKS		7
-		for (i = 0; i < NF_DN_NUMHOOKS; i++) {
-			err = __mnl_nft_dump_nf_hooks(ctx, family, i, devname);
-			if (err < 0) {
-				ret = err;
-				break;
-			}
-		}
+		mnl_nft_dump_nf_decnet(ctx, family, hook, devname, &hook_list, &ret);
+		break;
+	}
+
+	switch (family) {
+	case NFPROTO_UNSPEC:
+		for (i = 0; i < HOOK_FAMILY_MAX; i++)
+			print_hooks(ctx, hook_family[i], &hook_list);
+		break;
+	case NFPROTO_INET:
+		print_hooks(ctx, NFPROTO_IPV4, &hook_list);
+		print_hooks(ctx, NFPROTO_IPV6, &hook_list);
+		break;
+	default:
+		print_hooks(ctx, family, &hook_list);
 		break;
 	}
 
+	release_hook_list(&hook_list);
+	ret = 0;
+
 	return ret;
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b83ac9a298f5..83f0250a8744 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1474,11 +1474,7 @@ list_cmd		:	TABLE		table_spec
 			}
 			;
 
-basehook_device_name	:	/* NULL */
-			{
-				$$ = NULL;
-			}
-			|	DEVICE STRING
+basehook_device_name	:	DEVICE STRING
 			{
 				$$ = $2;
 			}
@@ -1488,22 +1484,11 @@ basehook_spec		:	ruleset_spec
 			{
 				$$ = $1;
 			}
-			|	ruleset_spec    STRING  basehook_device_name
+			|	ruleset_spec    basehook_device_name
 			{
-				const char *name = chain_hookname_lookup($2);
-
-				if (name == NULL) {
-					erec_queue(error(&@2, "unknown chain hook"),
-						   state->msgs);
-					xfree($3);
-					YYERROR;
-				}
-
-				$1.chain.name = $2;
-				$1.chain.location = @2;
-				if ($3) {
-					$1.obj.name = $3;
-					$1.obj.location = @3;
+				if ($2) {
+					$1.obj.name = $2;
+					$1.obj.location = @2;
 				}
 				$$ = $1;
 			}
diff --git a/src/rule.c b/src/rule.c
index 877eae3cd85d..3e59f27c69be 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -822,6 +822,8 @@ const char *hooknum2str(unsigned int family, unsigned int hooknum)
 			return "forward";
 		case NF_ARP_OUT:
 			return "output";
+		case __NF_ARP_INGRESS:
+			return "ingress";
 		default:
 			break;
 		}
-- 
2.20.1

