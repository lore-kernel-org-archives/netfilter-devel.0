Return-Path: <SRS0=YmFf=AJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C06CC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jun 2020 03:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7353D20782
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jun 2020 03:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TjXXsA80"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgF1DZF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Jun 2020 23:25:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47441 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725880AbgF1DZF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Jun 2020 23:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593314702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=S0pvCr6xYviO/Gl4YLybPyItBDcQpJUX7Dh/ouU8HqA=;
        b=TjXXsA80Get0TWFStDr5VxSXcdsb2JLAcUbqdthqdfKDf/BzlvsLZmck60SG/YX6o3Qp3D
        +e/qn7apJHY53215yESfpDJxmT1t20PWEv+LZCO/PjalNxajBeF0xr5egmAW2Hh0x2lfdK
        +B0ZKckYHuRdODZ2CqqTnhp0xne4IRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-GCz90PWgP3OhCmIwVohPJw-1; Sat, 27 Jun 2020 23:25:00 -0400
X-MC-Unique: GCz90PWgP3OhCmIwVohPJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0A7F1800D42;
        Sun, 28 Jun 2020 03:24:58 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D83D5D9CD;
        Sun, 28 Jun 2020 03:24:49 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org,
        dan.carpenter@oracle.com, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak124 v3fix] audit: add gfp parameter to audit_log_nfcfg
Date:   Sat, 27 Jun 2020 23:24:19 -0400
Message-Id: <3eda864fb69977252a061c8c3ccd2d8fcd1f3a9b.1593278952.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixed an inconsistent use of GFP flags in nft_obj_notify() that used
GFP_KERNEL when a GFP flag was passed in to that function.  Given this
allocated memory was then used in audit_log_nfcfg() it led to an audit
of all other GFP allocations in net/netfilter/nf_tables_api.c and a
modification of audit_log_nfcfg() to accept a GFP parameter.

Reported-by: Dan Carptenter <dan.carpenter@oracle.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Passes audit-testsuite.

 include/linux/audit.h           |  8 ++++----
 kernel/auditsc.c                |  4 ++--
 net/bridge/netfilter/ebtables.c |  6 +++---
 net/netfilter/nf_tables_api.c   | 33 +++++++++++++++++++++------------
 net/netfilter/x_tables.c        |  5 +++--
 5 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 604ede630580..d93739f7a35a 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -404,7 +404,7 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 extern void __audit_tk_injoffset(struct timespec64 offset);
 extern void __audit_ntp_log(const struct audit_ntp_data *ad);
 extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
-			      enum audit_nfcfgop op);
+			      enum audit_nfcfgop op, gfp_t gfp);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -542,10 +542,10 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 
 static inline void audit_log_nfcfg(const char *name, u8 af,
 				   unsigned int nentries,
-				   enum audit_nfcfgop op)
+				   enum audit_nfcfgop op, gfp_t gfp)
 {
 	if (audit_enabled)
-		__audit_log_nfcfg(name, af, nentries, op);
+		__audit_log_nfcfg(name, af, nentries, op, gfp);
 }
 
 extern int audit_n_rules;
@@ -683,7 +683,7 @@ static inline void audit_ptrace(struct task_struct *t)
 
 static inline void audit_log_nfcfg(const char *name, u8 af,
 				   unsigned int nentries,
-				   enum audit_nfcfgop op)
+				   enum audit_nfcfgop op, gfp_t gfp)
 { }
 
 #define audit_n_rules 0
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3a9100e95fda..eae1a599ffe3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2572,12 +2572,12 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
 }
 
 void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
-		       enum audit_nfcfgop op)
+		       enum audit_nfcfgop op, gfp_t gfp)
 {
 	struct audit_buffer *ab;
 	char comm[sizeof(current->comm)];
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_NETFILTER_CFG);
+	ab = audit_log_start(audit_context(), gfp, AUDIT_NETFILTER_CFG);
 	if (!ab)
 		return;
 	audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c83ffe912163..b13b49b9f75c 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1047,7 +1047,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	vfree(counterstmp);
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
-			AUDIT_XT_OP_REPLACE);
+			AUDIT_XT_OP_REPLACE, GFP_KERNEL);
 	return ret;
 
 free_unlock:
@@ -1123,7 +1123,7 @@ static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 	list_del(&table->list);
 	mutex_unlock(&ebt_mutex);
 	audit_log_nfcfg(table->name, AF_BRIDGE, table->private->nentries,
-			AUDIT_XT_OP_UNREGISTER);
+			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
 	EBT_ENTRY_ITERATE(table->private->entries, table->private->entries_size,
 			  ebt_cleanup_entry, net, NULL);
 	if (table->private->nentries)
@@ -1218,7 +1218,7 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	}
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
-			AUDIT_XT_OP_REGISTER);
+			AUDIT_XT_OP_REGISTER, GFP_KERNEL);
 	return ret;
 free_unlock:
 	mutex_unlock(&ebt_mutex);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 164700273947..f7ff91479647 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -702,7 +702,8 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 			ctx->table->use,
 			event == NFT_MSG_NEWTABLE ?
 				AUDIT_NFT_OP_TABLE_REGISTER :
-				AUDIT_NFT_OP_TABLE_UNREGISTER);
+				AUDIT_NFT_OP_TABLE_UNREGISTER,
+			GFP_KERNEL);
 	kfree(buf);
 
 	if (!ctx->report &&
@@ -1448,7 +1449,8 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 			ctx->chain->use,
 			event == NFT_MSG_NEWCHAIN ?
 				AUDIT_NFT_OP_CHAIN_REGISTER :
-				AUDIT_NFT_OP_CHAIN_UNREGISTER);
+				AUDIT_NFT_OP_CHAIN_UNREGISTER,
+			GFP_KERNEL);
 	kfree(buf);
 
 	if (!ctx->report &&
@@ -2724,7 +2726,8 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 			rule->handle,
 			event == NFT_MSG_NEWRULE ?
 				AUDIT_NFT_OP_RULE_REGISTER :
-				AUDIT_NFT_OP_RULE_UNREGISTER);
+				AUDIT_NFT_OP_RULE_UNREGISTER,
+			GFP_KERNEL);
 	kfree(buf);
 
 	if (!ctx->report &&
@@ -3737,7 +3740,8 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 			set->field_count,
 			event == NFT_MSG_NEWSET ?
 				AUDIT_NFT_OP_SET_REGISTER :
-				AUDIT_NFT_OP_SET_UNREGISTER);
+				AUDIT_NFT_OP_SET_UNREGISTER,
+			gfp_flags);
 	kfree(buf);
 
 	if (!ctx->report &&
@@ -4864,7 +4868,8 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 			set->handle,
 			event == NFT_MSG_NEWSETELEM ?
 				AUDIT_NFT_OP_SETELEM_REGISTER :
-				AUDIT_NFT_OP_SETELEM_UNREGISTER);
+				AUDIT_NFT_OP_SETELEM_UNREGISTER,
+			GFP_KERNEL);
 	kfree(buf);
 
 	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
@@ -5956,7 +5961,8 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				audit_log_nfcfg(buf,
 						family,
 						obj->handle,
-						AUDIT_NFT_OP_OBJ_RESET);
+						AUDIT_NFT_OP_OBJ_RESET,
+						GFP_KERNEL);
 				kfree(buf);
 			}
 
@@ -6071,13 +6077,14 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 		reset = true;
 
 	if (reset) {
-		char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
+		char *buf = kasprintf(GFP_ATOMIC, "%s:%llu;?:0",
 				      table->name, table->handle);
 
 		audit_log_nfcfg(buf,
 				family,
 				obj->handle,
-				AUDIT_NFT_OP_OBJ_RESET);
+				AUDIT_NFT_OP_OBJ_RESET,
+				GFP_KERNEL);
 		kfree(buf);
 	}
 
@@ -6156,7 +6163,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
+	char *buf = kasprintf(gfp, "%s:%llu;?:0",
 			      table->name, table->handle);
 
 	audit_log_nfcfg(buf,
@@ -6164,7 +6171,8 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 			obj->handle,
 			event == NFT_MSG_NEWOBJ ?
 				AUDIT_NFT_OP_OBJ_REGISTER :
-				AUDIT_NFT_OP_OBJ_UNREGISTER);
+				AUDIT_NFT_OP_OBJ_UNREGISTER,
+			GFP_KERNEL);
 	kfree(buf);
 
 	if (!report &&
@@ -6954,7 +6962,8 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 			flowtable->hooknum,
 			event == NFT_MSG_NEWFLOWTABLE ?
 				AUDIT_NFT_OP_FLOWTABLE_REGISTER :
-				AUDIT_NFT_OP_FLOWTABLE_UNREGISTER);
+				AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+			GFP_KERNEL);
 	kfree(buf);
 
 	if (ctx->report &&
@@ -7078,7 +7087,7 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
 	int err;
 
 	audit_log_nfcfg("?:0;?:0", 0, net->nft.base_seq,
-			AUDIT_NFT_OP_GEN_REGISTER);
+			AUDIT_NFT_OP_GEN_REGISTER, GFP_KERNEL);
 
 	if (nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 99a468be4a59..9ad8f3ff66f5 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1410,7 +1410,8 @@ struct xt_table_info *
 
 	audit_log_nfcfg(table->name, table->af, private->number,
 			!private->number ? AUDIT_XT_OP_REGISTER :
-					   AUDIT_XT_OP_REPLACE);
+					   AUDIT_XT_OP_REPLACE,
+			GFP_KERNEL);
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
@@ -1473,7 +1474,7 @@ void *xt_unregister_table(struct xt_table *table)
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 	audit_log_nfcfg(table->name, table->af, private->number,
-			AUDIT_XT_OP_UNREGISTER);
+			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
 	kfree(table);
 
 	return private;
-- 
1.8.3.1

