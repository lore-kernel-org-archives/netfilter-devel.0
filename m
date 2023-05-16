Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFD6C77B7F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 16:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjEPQZ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 12:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjEPQZZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 12:25:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F047A267
        for <netfilter-devel@vger.kernel.org>; Tue, 16 May 2023 09:25:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pyxTW-0003YB-US; Tue, 16 May 2023 18:24:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] mnl: support bpf id decode in nft list hooks
Date:   Tue, 16 May 2023 18:24:29 +0200
Message-Id: <20230516162429.22821-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows 'nft list hooks' to also display the bpf program id
attached.  Example:

hook input {
  -0000000128 nf_hook_run_bpf id 6
  ..

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nfnetlink_hook.h | 24 ++++++++++++--
 src/mnl.c                                | 40 ++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_hook.h b/include/linux/netfilter/nfnetlink_hook.h
index bbcd285b22e1..84a561a74b98 100644
--- a/include/linux/netfilter/nfnetlink_hook.h
+++ b/include/linux/netfilter/nfnetlink_hook.h
@@ -32,8 +32,12 @@ enum nfnl_hook_attributes {
 /**
  * enum nfnl_hook_chain_info_attributes - chain description
  *
- * NFNLA_HOOK_INFO_DESC: nft chain and table name (enum nft_table_attributes) (NLA_NESTED)
- * NFNLA_HOOK_INFO_TYPE: chain type (enum nfnl_hook_chaintype) (NLA_U32)
+ * @NFNLA_HOOK_INFO_DESC: nft chain and table name (NLA_NESTED)
+ * @NFNLA_HOOK_INFO_TYPE: chain type (enum nfnl_hook_chaintype) (NLA_U32)
+ *
+ * NFNLA_HOOK_INFO_DESC depends on NFNLA_HOOK_INFO_TYPE value:
+ *   NFNL_HOOK_TYPE_NFTABLES: enum nft_table_attributes
+ *   NFNL_HOOK_TYPE_BPF: enum nfnl_hook_bpf_attributes
  */
 enum nfnl_hook_chain_info_attributes {
 	NFNLA_HOOK_INFO_UNSPEC,
@@ -55,10 +59,24 @@ enum nfnl_hook_chain_desc_attributes {
 /**
  * enum nfnl_hook_chaintype - chain type
  *
- * @NFNL_HOOK_TYPE_NFTABLES nf_tables base chain
+ * @NFNL_HOOK_TYPE_NFTABLES: nf_tables base chain
+ * @NFNL_HOOK_TYPE_BPF: bpf program
  */
 enum nfnl_hook_chaintype {
 	NFNL_HOOK_TYPE_NFTABLES = 0x1,
+	NFNL_HOOK_TYPE_BPF,
+};
+
+/**
+ * enum nfnl_hook_bpf_attributes - bpf prog description
+ *
+ * @NFNLA_HOOK_BPF_ID: bpf program id (NLA_U32)
+ */
+enum nfnl_hook_bpf_attributes {
+	NFNLA_HOOK_BPF_UNSPEC,
+	NFNLA_HOOK_BPF_ID,
+	__NFNLA_HOOK_BPF_MAX,
 };
+#define NFNLA_HOOK_BPF_MAX (__NFNLA_HOOK_BPF_MAX - 1)
 
 #endif /* _NFNL_HOOK_H */
diff --git a/src/mnl.c b/src/mnl.c
index adc0bd3d61cf..91775c41b246 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2273,6 +2273,27 @@ static int dump_nf_attr_chain_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int dump_nf_attr_bpf_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, NFNLA_HOOK_BPF_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFNLA_HOOK_BPF_ID:
+                if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
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
 struct dump_nf_hook_data {
 	struct list_head *hook_list;
 	int family;
@@ -2332,6 +2353,23 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *_data)
 				hook->chain = xstrdup(chainname);
 			}
 			hook->chain_family = mnl_attr_get_u8(info[NFNLA_CHAIN_FAMILY]);
+		} else if (type == NFNL_HOOK_TYPE_BPF) {
+			struct nlattr *info[NFNLA_HOOK_BPF_MAX + 1] = {};
+
+			if (mnl_attr_parse_nested(nested[NFNLA_HOOK_INFO_DESC],
+						  dump_nf_attr_bpf_cb, info) < 0) {
+				basehook_free(hook);
+				return -1;
+			}
+
+			if (info[NFNLA_HOOK_BPF_ID]) {
+				char tmpbuf[16];
+
+				snprintf(tmpbuf, sizeof(tmpbuf), "id %u",
+					 ntohl(mnl_attr_get_u32(info[NFNLA_HOOK_BPF_ID])));
+
+				hook->chain = xstrdup(tmpbuf);
+			}
 		}
 	}
 	if (tb[NFNLA_HOOK_HOOKNUM])
@@ -2453,6 +2491,8 @@ static void print_hooks(struct netlink_ctx *ctx, int family, struct list_head *h
 
 		if (hook->table && hook->chain)
 			fprintf(fp, " chain %s %s %s", family2str(hook->chain_family), hook->table, hook->chain);
+		else if (hook->hookfn && hook->chain)
+			fprintf(fp, " %s %s", hook->hookfn, hook->chain);
 		else if (hook->hookfn) {
 			fprintf(fp, " %s", hook->hookfn);
 		}
-- 
2.39.3

