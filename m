Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9061C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B133560F4B
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhHBLqJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:46:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49638 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbhHBLqI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 07:46:08 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id E963660031;
        Mon,  2 Aug 2021 13:45:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft] mnl: revisit hook listing
Date:   Mon,  2 Aug 2021 13:45:52 +0200
Message-Id: <20210802114552.29189-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A few updates on the hook listing support:

- Group hooks by family, e.g. ip
- Group hooks by number, e.g. input.
- Order hooks by priority, from INT_MIN to INT_MAX.
- Do not add sign to hook number zero.
- Ignore EPROTONOSUPPORT, on older kernels this command results in EINVAL.
  On new kernels, just list nothing on unsupported families.

 # nft list hooks
 family ip {
        hook input {
                -0000000100 nft_do_chain_ipv4 [nf_tables [nf_tables]    # nft table ip x chain z
                 0000000000 nft_do_chain_ipv4 [nf_tables [nf_tables]    # nft table ip x chain y
                +0000000100 nft_do_chain_ipv4 [nf_tables [nf_tables]    # nft table ip x chain w
                +0000000300 nft_do_chain_inet [nf_tables [nf_tables]    # nft table ip x chain y
        }
        hook forward {
                -0000000225 selinux_ipv4_forward
        }
        hook output {
                -0000000225 selinux_ipv4_output
        }
        hook postrouting {
                +0000000225 selinux_ipv4_postroute
        }
 }
 family ip6 {
        hook input {
                +0000000300 nft_do_chain_inet [nf_tables [nf_tables]    # nft table ip6 x chain y
        }
        hook forward {
                -0000000225 selinux_ipv6_forward
        }
        hook output {
                -0000000225 selinux_ipv6_output
        }
        hook postrouting {
                +0000000225 selinux_ipv6_postroute
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 333 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 246 insertions(+), 87 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index f28d6605835f..a0176443ace6 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -44,6 +44,9 @@ struct basehook {
 	const char *hookfn;
 	const char *table;
 	const char *chain;
+	const char *devname;
+	int family;
+	uint32_t num;
 	int prio;
 };
 
@@ -1942,12 +1945,27 @@ static void basehook_free(struct basehook *b)
 	xfree(b->module_name);
 	xfree(b->hookfn);
 	xfree(b->chain);
+	xfree(b->devname);
 	xfree(b->table);
 	xfree(b);
 }
 
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
 
@@ -2033,11 +2051,18 @@ static int dump_nf_attr_chain_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int dump_nf_hooks(const struct nlmsghdr *nlh, void *data)
+struct dump_nf_hook_data {
+	struct list_head *hook_list;
+	const char *devname;
+	int family;
+	uint32_t hooknum;
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
@@ -2079,10 +2104,14 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *data)
 				hook->table = xstrdup(tablename);
 				hook->chain = xstrdup(chainname);
 			}
+			if (data->devname)
+				hook->devname = xstrdup(data->devname);
 		}
 	}
+	hook->num = data->hooknum;
+	hook->family = data->family;
 
-	basehook_list_add_tail(hook, head);
+	basehook_list_add_tail(hook, data->hook_list);
 	return MNL_CB_OK;
 }
 
@@ -2102,14 +2131,17 @@ static struct nlmsghdr *nf_hook_dump_request(char *buf, uint8_t family, uint32_t
 	return nlh;
 }
 
-static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t family, uint8_t hooknum, const char *devname)
+static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t family, uint8_t hooknum, const char *devname,
+				   struct list_head *hook_list)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct basehook *hook, *tmp;
+	struct dump_nf_hook_data data = {
+		.hook_list	= hook_list,
+		.devname	= devname,
+		.family		= family,
+		.hooknum	= hooknum,
+	};
 	struct nlmsghdr *nlh;
-	LIST_HEAD(hook_list);
-	FILE *fp;
-	int ret;
 
 	nlh = nf_hook_dump_request(buf, family, ctx->seqnum);
 	if (devname)
@@ -2117,27 +2149,63 @@ static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t family, uint
 
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
 
-	list_for_each_entry_safe(hook, tmp, &hook_list, list) {
-		int prio = hook->prio;
+	fprintf(fp, "family %s {\n", family2str(family));
 
+	list_for_each_entry_safe(hook, tmp, hook_list, list) {
+		if (hook->family != family)
+			continue;
+
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
+			if (hook->devname)
+				fprintf(fp, "\thook %s device %s {\n",
+					hooknum2str(family, hook->num), hook->devname);
+			else
+				fprintf(fp, "\thook %s {\n",
+					hooknum2str(family, hook->num));
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
 
 		if (hook->hookfn) {
 			fprintf(fp, " %s", hook->hookfn);
@@ -2147,100 +2215,191 @@ static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t family, uint
 
 		if (hook->table && hook->chain)
 			fprintf(fp, "\t# nft table %s %s chain %s", family2str(family), hook->table, hook->chain);
-
-		fprintf(fp, "\n");
-		basehook_free(hook);
 	}
 
+	fprintf(fp, "\n\t}\n");
 	fprintf(fp, "}\n");
-	return ret;
+}
+
+#define HOOK_FAMILY_MAX	5
+
+static uint8_t hook_family[HOOK_FAMILY_MAX] = {
+	NFPROTO_IPV4,
+	NFPROTO_IPV6,
+	NFPROTO_BRIDGE,
+	NFPROTO_ARP,
+};
+
+static int mnl_nft_dump_nf_inet(struct netlink_ctx *ctx, int family, int hook,
+				const char *devname, struct list_head *hook_list,
+				int *ret)
+{
+	int err;
+
+	if (devname) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, NF_INET_INGRESS, devname, hook_list);
+		if (err < 0)
+			*ret = err;
+	}
+
+	err = __mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV4, hook, NULL, hook_list);
+	if (err < 0)
+		*ret = err;
+	err = __mnl_nft_dump_nf_hooks(ctx, NFPROTO_IPV6, hook, NULL, hook_list);
+	if (err < 0)
+		*ret = err;
+
+	return err;
+}
+
+static int mnl_nft_dump_nf(struct netlink_ctx *ctx, int family, int hook,
+			   const char *devname, struct list_head *hook_list,
+			   int *ret)
+{
+	int i, err;
+
+	if (hook >= 0) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, hook, devname, hook_list);
+		if (err < 0)
+			*ret = err;
+
+		return err;
+	}
+
+	for (i = 0; i <= NF_INET_POST_ROUTING; i++) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, i, NULL, hook_list);
+		if (err < 0)
+			*ret = err;
+	}
+
+	return err;
+}
+
+static int mnl_nft_dump_nf_arp(struct netlink_ctx *ctx, int family, int hook,
+			       const char *devname, struct list_head *hook_list,
+			       int *ret)
+{
+	int err;
+
+	if (hook >= 0) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, hook, devname, hook_list);
+		if (err < 0)
+			*ret = err;
+
+		return err;
+	}
+
+	err = __mnl_nft_dump_nf_hooks(ctx, family, NF_ARP_IN, devname, hook_list);
+	if (err < 0)
+		*ret = err;
+	err = __mnl_nft_dump_nf_hooks(ctx, family, NF_ARP_OUT, devname, hook_list);
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
+	if (hook >= 0) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, hook, devname, hook_list);
+		if (err < 0)
+			*ret = err;
+
+		return err;
+	}
+
+	err = __mnl_nft_dump_nf_hooks(ctx, family, NF_INET_INGRESS, devname, hook_list);
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
+	if (hook >= 0) {
+		err =  __mnl_nft_dump_nf_hooks(ctx, family, hook, devname, hook_list);
+		if (err < 0)
+			*ret = err;
+
+		return err;
+	}
+#define NF_DN_NUMHOOKS		7
+	for (i = 0; i < NF_DN_NUMHOOKS; i++) {
+		err = __mnl_nft_dump_nf_hooks(ctx, family, i, devname, hook_list);
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
+		mnl_nft_dump_nf_netdev(ctx, NFPROTO_NETDEV, hook, devname, &hook_list, &ret);
+		mnl_nft_dump_nf_inet(ctx, NFPROTO_INET, hook, devname, &hook_list, &ret);
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
+		mnl_nft_dump_nf_inet(ctx, family, hook, devname, &hook_list, &ret);
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
 		break;
 	}
 
+	if (family == NFPROTO_UNSPEC) {
+		for (i = 0; i < HOOK_FAMILY_MAX; i++) {
+			print_hooks(ctx, hook_family[i], &hook_list);
+		}
+	} else {
+		print_hooks(ctx, family, &hook_list);
+	}
+
+	release_hook_list(&hook_list);
+	ret = 0;
+
 	return ret;
 }
-- 
2.20.1

