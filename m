From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/6] src: delete flowtable
Date: Tue, 23 Jan 2018 13:16:19 +0100
Message-ID: <20180123121622.16287-3-pablo@netfilter.org>
References: <20180123121622.16287-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751393AbeAWMQc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 07:16:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 168492519A6
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04FFEDA808
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0E1DDA809
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:28 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BA7F241E4817
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:28 +0100 (CET)
In-Reply-To: <20180123121622.16287-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to delete an existing flowtable:

 # nft delete flowtable x m

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h      |  3 +++
 include/netlink.h  |  3 +++
 src/evaluate.c     |  1 +
 src/mnl.c          | 16 ++++++++++++++++
 src/netlink.c      | 18 ++++++++++++++++++
 src/parser_bison.y |  4 ++++
 src/rule.c         |  3 +++
 7 files changed, 48 insertions(+)

diff --git a/include/mnl.h b/include/mnl.h
index 470b29787fa6..1b2450a9388e 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -95,6 +95,9 @@ mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table);
 int mnl_nft_flowtable_batch_add(struct nftnl_flowtable *flo,
 				struct nftnl_batch *batch, unsigned int flags,
 				uint32_t seqnum);
+int mnl_nft_flowtable_batch_del(struct nftnl_flowtable *flow,
+				struct nftnl_batch *batch, unsigned int flags,
+				uint32_t seqnum);
 
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct netlink_ctx *ctx,
 					   uint32_t family);
diff --git a/include/netlink.h b/include/netlink.h
index b80acbabe80f..9ae021a8dd49 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -188,6 +188,9 @@ extern int netlink_list_flowtables(struct netlink_ctx *ctx,
 extern int netlink_add_flowtable(struct netlink_ctx *ctx,
 				 const struct handle *h, struct flowtable *ft,
 				 uint32_t flags);
+extern int netlink_delete_flowtable(struct netlink_ctx *ctx,
+				    const struct handle *h,
+				    struct location *loc);
 
 extern void netlink_dump_chain(const struct nftnl_chain *nlc,
 			       struct netlink_ctx *ctx);
diff --git a/src/evaluate.c b/src/evaluate.c
index 70a61c72838a..892d1e0c8c5b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3118,6 +3118,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_RULE:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
+	case CMD_OBJ_FLOWTABLE:
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
diff --git a/src/mnl.c b/src/mnl.c
index be6e05da5936..f620a3bda8d5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1027,6 +1027,22 @@ int mnl_nft_flowtable_batch_add(struct nftnl_flowtable *flo,
 	return 0;
 }
 
+int mnl_nft_flowtable_batch_del(struct nftnl_flowtable *flo,
+				struct nftnl_batch *batch, unsigned int flags,
+				uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch),
+				    NFT_MSG_DELFLOWTABLE,
+				    nftnl_flowtable_get_u32(flo, NFTNL_FLOWTABLE_FAMILY),
+				    flags, seqnum);
+	nftnl_flowtable_nlmsg_build_payload(nlh, flo);
+	mnl_nft_batch_continue(batch);
+
+	return 0;
+}
+
 /*
  * ruleset
  */
diff --git a/src/netlink.c b/src/netlink.c
index 89513584a50f..56c6b6a3725e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1820,6 +1820,24 @@ int netlink_add_flowtable(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
+int netlink_delete_flowtable(struct netlink_ctx *ctx, const struct handle *h,
+			     struct location *loc)
+{
+	struct nftnl_flowtable *flo;
+	int err;
+
+	flo = alloc_nftnl_flowtable(h, NULL);
+	netlink_dump_flowtable(flo, ctx);
+
+	err = mnl_nft_flowtable_batch_del(flo, ctx->batch, 0, ctx->seqnum);
+	if (err < 0)
+		netlink_io_error(ctx, loc, "Could not delete flowtable: %s",
+				 strerror(errno));
+	nftnl_flowtable_free(flo);
+
+	return err;
+}
+
 static int list_obj_cb(struct nftnl_obj *nls, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 45cc3b4114ff..0623cd12aeb5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1023,6 +1023,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SETELEM, &$2, &@$, $3);
 			}
+			|	FLOWTABLE	flowtable_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
+			}
 			|	COUNTER		obj_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
diff --git a/src/rule.c b/src/rule.c
index 8a38bcc66a66..b06f30eb5528 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1174,6 +1174,9 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_LIMIT:
 		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
 					  NFT_OBJECT_LIMIT);
+	case CMD_OBJ_FLOWTABLE:
+		return netlink_delete_flowtable(ctx, &cmd->handle,
+						&cmd->location);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.11.0

