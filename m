From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 06/11] netfilter: xtables2: rule entry handler
Date: Fri, 16 Nov 2012 02:23:40 +0100
Message-ID: <1353029025-31635-7-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45177 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2KPBX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:57 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You can now send the set of new rules along with a splice request.
(Currently empty rules, since matches/targets are yet to come.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    2 ++
 net/netfilter/xt_nfnetlink.c                     |   31 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 9f34b44..2ffbf60 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -15,6 +15,7 @@
  * %NFXTM_CHAIN_DUMP:	retrieve chain properties and rules in the chain
  * %NFXTM_TABLE_DUMP:	retrieve table (multiple chains) and their rules
  * %NFXTM_CHAIN_SPLICE:	start a splice transaction; modify rules of a chain
+ * %NFXTM_RULE_ENTRY:	used to convey rule data (during both splice and dump)
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
@@ -28,6 +29,7 @@ enum nfxt_msg_type {
 	NFXTM_CHAIN_DUMP,
 	NFXTM_TABLE_DUMP,
 	NFXTM_CHAIN_SPLICE,
+	NFXTM_RULE_ENTRY,
 };
 
 /**
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 1941ce6..60e883f 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -1002,6 +1002,36 @@ static int xtnetlink_table_dump(struct sock *xtnl, struct sk_buff *iskb,
 	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
 }
 
+static int xtnetlink_rule_entry(struct sock *xtnl, struct sk_buff *iskb,
+				const struct nlmsghdr *imsg,
+				const struct nlattr *const *ad)
+{
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xt2_proto_rule *rule;
+	struct xtnetlink_transact *xa;
+	int ret;
+
+	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
+				    XA_SPLICE_BUFFER);
+	if (xa == NULL)
+		return xtnetlink_error(&ref, NFXTE_TRANSACT_INACTIVE);
+
+	rule = xt2_rule_new();
+	if (rule == NULL)
+		goto out_of_mem;
+	ret = xt2_rulebuf_push(xa->splice_param->rulebuf, rule);
+	xtnetlink_transact_put(xa);
+	if (ret < 0)
+		return xtnetlink_error(&ref, ret);
+	return xtnetlink_error(&ref, NFXTE_SUCCESS);
+
+ out_of_mem:
+	ret = xtnetlink_error(&ref, -ENOMEM);
+	xtnetlink_transact_put(xa);
+	return ret;
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
@@ -1033,6 +1063,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_CHAIN_DUMP] = {.call = xtnetlink_chain_dump, pol},
 	[NFXTM_TABLE_DUMP] = {.call = xtnetlink_table_dump, pol},
 	[NFXTM_CHAIN_SPLICE] = {.call = xtnetlink_chain_splice, pol},
+	[NFXTM_RULE_ENTRY] = {.call = xtnetlink_rule_entry, pol},
 };
 #undef pol
 
-- 
1.7.10.4

