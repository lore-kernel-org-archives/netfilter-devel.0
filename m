From: Markus Koetter <koetter@rrzn.uni-hannover.de>
Subject: [PATCH 4/5] trace: implement commands action
Date: Wed, 17 Jun 2015 22:07:36 +0200
Message-ID: <1434571657-20047-5-git-send-email-koetter@rrzn.uni-hannover.de>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:38458 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbbFQUO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 16:14:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailout2.uni-hannover.de (Postfix) with ESMTP id C60BB60AB
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from mailout2.uni-hannover.de ([127.0.0.1])
	by localhost (mailout2.uni-hannover.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DCEDljyDMDIh for <netfilter-devel@vger.kernel.org>;
	Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from hass1404.example.prv (p4FDA71FA.dip0.t-ipconnect.de [79.218.113.250])
	(Authenticated sender: koetter@rrzn.uni-hannover.de)
	by mailout2.uni-hannover.de (Postfix) with ESMTPSA id 9717A608A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
In-Reply-To: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


trace.c is based upon https://git.netfilter.org/libmnl/tree/examples/netfilter/nf-log.c

---
 include/Makefile.am |   1 +
 include/trace.h     |   2 +
 src/Makefile.am     |   1 +
 src/rule.c          |   1 +
 src/trace.c         | 361 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 366 insertions(+)
 create mode 100644 include/trace.h
 create mode 100644 src/trace.c

diff --git a/include/Makefile.am b/include/Makefile.am
index f22561b..c351b55 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -19,4 +19,5 @@ noinst_HEADERS = 	cli.h		\
 			parser.h	\
 			proto.h		\
 			rule.h		\
+			trace.h		\
 			utils.h
diff --git a/include/trace.h b/include/trace.h
new file mode 100644
index 0000000..8c43c86
--- /dev/null
+++ b/include/trace.h
@@ -0,0 +1,2 @@
+int nft_trace(int qnum, int family);
+
diff --git a/src/Makefile.am b/src/Makefile.am
index 2410fd3..db77e8e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -45,6 +45,7 @@ nft_SOURCES =	main.c				\
 		erec.c				\
 		mnl.c				\
 		scanner.l			\
+		trace.c				\
 		parser_bison.y
 
 if BUILD_CLI
diff --git a/src/rule.c b/src/rule.c
index dc65452..cd21de0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -18,6 +18,7 @@
 
 #include <statement.h>
 #include <rule.h>
+#include <trace.h>
 #include <utils.h>
 #include <netlink.h>
 
diff --git a/src/trace.c b/src/trace.c
new file mode 100644
index 0000000..a9c9b5f
--- /dev/null
+++ b/src/trace.c
@@ -0,0 +1,361 @@
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <time.h>
+#include <arpa/inet.h>
+
+#include <net/ethernet.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+
+#ifndef aligned_be64
+#define aligned_be64 u_int64_t __attribute__((aligned(8)))
+#endif
+
+#include <linux/netfilter/nfnetlink_log.h>
+#include <libmnl/libmnl.h>
+
+#include "trace.h"
+#include "rule.h"
+#include "statement.h"
+#include "log.h"
+
+struct prefix
+{
+	char *table;
+	char *chain;
+	char *action;
+	char *num;
+};
+
+static int parse_prefix(char *prefix, struct prefix *td)
+{
+	static const char *TRACE = "TRACE: ";
+	char *pos;
+	char *cur = NULL;
+	char *end = prefix + strlen(prefix);
+	pos = prefix;
+
+	/* "TRACE: filter:input:rule:2 " */
+	if (strncmp(prefix, TRACE, strlen(TRACE)) != 0)
+		return -1;
+
+	pos += strlen(TRACE);
+
+	if (pos >= end)
+		goto invalid_format_error;
+
+	/* "filter:input:rule:2 " */
+	/* TABLE:CHAIN:ACTION:NUM */
+	if ( (cur=strchr(pos, ':')) == NULL || cur+1 >= end)
+		goto invalid_format_error;
+	*cur = '\0';
+	td->table = pos;
+	pos = cur+1;
+
+	if ( (cur=strchr(pos, ':')) == NULL || cur+1 >= end)
+		goto invalid_format_error;
+	*cur = '\0';
+	td->chain = pos;
+	pos = cur+1;
+
+	if ( (cur=strchr(pos, ':')) == NULL || cur+1 >= end)
+		goto invalid_format_error;
+	*cur = '\0';
+	td->action = pos;
+
+	td->num = cur+1;
+	return 0;
+
+invalid_format_error:
+	return -1;
+}
+
+
+static int parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	/* skip unsupported attribute in user-space */
+	if (mnl_attr_type_valid(attr, NFULA_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFULA_MARK:
+	case NFULA_IFINDEX_INDEV:
+	case NFULA_IFINDEX_OUTDEV:
+	case NFULA_IFINDEX_PHYSINDEV:
+	case NFULA_IFINDEX_PHYSOUTDEV:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFULA_TIMESTAMP:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfulnl_msg_packet_timestamp)) < 0) {
+			perror("mnl_attr_validate2");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFULA_HWADDR:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfulnl_msg_packet_hw)) < 0) {
+			perror("mnl_attr_validate2");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFULA_PREFIX:
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFULA_PAYLOAD:
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+struct log_ctx
+{
+	int family;
+};
+
+static int log_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct log_ctx *ctx = data;
+	struct nlattr *tb[NFULA_MAX+1] = {};
+	struct nfulnl_msg_packet_hdr *ph = NULL;
+	struct prefix td;
+	char prefix[65];
+
+	struct handle h;
+	struct table *table;
+	struct chain *chain;
+	struct rule *rule = NULL;
+	const struct stmt *stmt;
+	int i;
+	uint32_t mark = 0;
+
+	mnl_attr_parse(nlh, sizeof(struct nfgenmsg), parse_attr_cb, tb);
+
+	if (!tb[NFULA_PACKET_HDR])
+		return 0;
+
+	ph = mnl_attr_get_payload(tb[NFULA_PACKET_HDR]);
+
+	if (ntohs(ph->hw_protocol) == ETHERTYPE_IP && (ctx->family != NFPROTO_IPV4 && ctx->family != NFPROTO_INET))
+		return 0;
+	if (ntohs(ph->hw_protocol) == ETHERTYPE_IPV6 && (ctx->family != NFPROTO_IPV6 && ctx->family != NFPROTO_INET))
+		return 0;
+
+
+	if (tb[NFULA_PREFIX])
+		strncpy(prefix, mnl_attr_get_str(tb[NFULA_PREFIX]), sizeof(prefix)-1);
+	else
+		goto invalid_format_error;
+
+	prefix[sizeof(prefix)-1] = '\0';
+
+	if( parse_prefix(prefix, &td) != 0)
+		return 0;
+
+	if (tb[NFULA_MARK])
+		mark = ntohl(mnl_attr_get_u32(tb[NFULA_MARK]));
+
+	h.family = ctx->family;
+	h.table = td.table;
+
+	if ( (table = table_lookup(&h)) == NULL)
+		return 0;
+
+	h.chain = td.chain;
+	if ( (chain = chain_lookup(table, &h)) ==  NULL)
+		return 0;
+
+	if (strcmp(td.action, "rule") == 0) {
+		i = atoi(td.num);
+		list_for_each_entry(rule, &chain->rules, list) {
+			if (--i != 0)
+				continue;
+			break;
+		}
+		if (rule == NULL)
+			return 0;
+		list_for_each_entry(stmt, &rule->stmts, list) {
+			if (stmt->ops->type == STMT_META &&
+				stmt->meta.key == NFT_META_NFTRACE)
+			{
+				nf_log_packet(tb);
+				break;
+			}
+		}
+	}
+
+
+	if (strcmp(td.action, "policy") == 0) {
+		char *policies[NF_MAX_VERDICT] = {
+			[NF_DROP] = "DROP",
+			[NF_ACCEPT] = "ACCEPT",
+			[NF_QUEUE] = "QUEUE",
+		};
+		printf("\t%s %s NFMARK=0x%x\n", td.table, td.chain, mark);
+		printf("\t\t%s\n", policies[chain->policy]);
+	} else
+	if (strcmp(td.action, "rule") == 0) {
+		printf("\t%s %s (#%i) NFMARK=0x%x\n", td.table, td.chain, atoi(td.num), mark);
+		printf("\t\t");
+		rule_print(rule);
+		printf("\n");
+	} else
+	if (strcmp(td.action, "return") == 0) {
+		printf("\t%s %s NFMARK=0x%x\n", td.table, td.chain, mark);
+		printf("\t\t => RETURN\n");
+	}
+
+invalid_format_error:
+	return MNL_CB_OK;
+}
+
+static struct nlmsghdr *
+nflog_build_cfg_pf_request(char *buf, uint8_t command)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+	struct nfulnl_msg_config_cmd cmd;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+
+	cmd.command = command,
+
+	mnl_attr_put(nlh, NFULA_CFG_CMD, sizeof(cmd), &cmd);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nflog_build_cfg_request(char *buf, uint8_t command, int qnum)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+	struct nfulnl_msg_config_cmd cmd;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(qnum);
+
+	cmd.command = command,
+
+	mnl_attr_put(nlh, NFULA_CFG_CMD, sizeof(cmd), &cmd);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nflog_build_cfg_params(char *buf, uint8_t mode, int range, int qnum)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+	struct nfulnl_msg_config_mode params;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(qnum);
+
+	params.copy_range = htonl(range);
+	params.copy_mode = mode;
+
+	mnl_attr_put(nlh, NFULA_CFG_MODE, sizeof(params), &params);
+
+	return nlh;
+}
+
+int nft_trace(int qnum, int family)
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int ret;
+	int portid;
+	struct log_ctx lctx = { .family = family };
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL)
+		return -1;
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
+		goto failed;
+
+	portid = mnl_socket_get_portid(nl);
+
+	nlh = nflog_build_cfg_pf_request(buf, NFULNL_CFG_CMD_PF_UNBIND);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+		goto failed;
+
+	nlh = nflog_build_cfg_pf_request(buf, NFULNL_CFG_CMD_PF_BIND);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+		goto failed;
+
+	nlh = nflog_build_cfg_request(buf, NFULNL_CFG_CMD_BIND, qnum);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+		goto failed;
+
+	nlh = nflog_build_cfg_params(buf, NFULNL_COPY_PACKET, 0xFFFF, qnum);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+		goto failed;
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret == -1)
+		goto failed;
+
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, 0, portid, log_cb, &lctx);
+		if (ret < 0){
+			perror("mnl_cb_run");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	mnl_socket_close(nl);
+
+	return 0;
+
+
+failed:
+	mnl_socket_close(nl);
+	return -1;
+}
+
-- 
1.9.1

