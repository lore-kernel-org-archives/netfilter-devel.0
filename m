Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D42FC433C1
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 20:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044E8619A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 20:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCVUuI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 16:50:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231398AbhCVUto (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 16:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616446183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=M8vaWLUVTf+tJZc4wm2LtjlsoBZnOWPK6rBR1omJuV0=;
        b=T/7r3ymGro9pLo6nq5zFbAjF1/CDflYoLuj062Byhf7g80oa/qDSTtDIDHudqCgaK4FbbQ
        ItHXplgzfo+BiITy/4GhJlJOrTzTEhChzv9+SYbXB3jW7eSsyUpvUzTsIhzPhc/VSn85dx
        +tVR96rrJtbtpBIZtVIP2zZmVtpphqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-FLW4g6ytOSugM95iW7muqA-1; Mon, 22 Mar 2021 16:49:39 -0400
X-MC-Unique: FLW4g6ytOSugM95iW7muqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB73E801817;
        Mon, 22 Mar 2021 20:49:37 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AF0C19D61;
        Mon, 22 Mar 2021 20:49:27 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: [PATCH v2] audit: log nftables configuration change events once per table
Date:   Mon, 22 Mar 2021 16:49:04 -0400
Message-Id: <2a6d8eb6058a6961cfb6439b31dcfadcce9596a8.1616445965.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reduce logging of nftables events to a level similar to iptables.
Restore the table field to list the table, adding the generation.

Indicate the op as the most significant operation in the event.

A couple of sample events:

type=PROCTITLE msg=audit(2021-03-18 09:30:49.801:143) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
type=SYSCALL msg=audit(2021-03-18 09:30:49.801:143) : arch=x86_64 syscall=sendmsg success=yes exit=172 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=roo
t sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv6 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv4 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=inet entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld

type=PROCTITLE msg=audit(2021-03-18 09:30:49.839:144) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
type=SYSCALL msg=audit(2021-03-18 09:30:49.839:144) : arch=x86_64 syscall=sendmsg success=yes exit=22792 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=r
oot sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv6 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv4 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=inet entries=165 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld

The issue was originally documented in
https://github.com/linux-audit/audit-kernel/issues/124

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Changelog
v2:
- convert NFT ops to array indicies in nft2audit_op[]
- use linux lists
- use functions for each of collection and logging of audit data
---
 include/linux/audit.h         |  28 +++++++
 net/netfilter/nf_tables_api.c | 136 +++++++++++++---------------------
 2 files changed, 81 insertions(+), 83 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 82b7c1116a85..5fafcf4c13de 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -118,6 +118,34 @@ enum audit_nfcfgop {
 	AUDIT_NFT_OP_INVALID,
 };
 
+static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
+	[NFT_MSG_NEWTABLE]	= AUDIT_NFT_OP_TABLE_REGISTER,
+	[NFT_MSG_GETTABLE]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELTABLE]	= AUDIT_NFT_OP_TABLE_UNREGISTER,
+	[NFT_MSG_NEWCHAIN]	= AUDIT_NFT_OP_CHAIN_REGISTER,
+	[NFT_MSG_GETCHAIN]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELCHAIN]	= AUDIT_NFT_OP_CHAIN_UNREGISTER,
+	[NFT_MSG_NEWRULE]	= AUDIT_NFT_OP_RULE_REGISTER,
+	[NFT_MSG_GETRULE]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELRULE]	= AUDIT_NFT_OP_RULE_UNREGISTER,
+	[NFT_MSG_NEWSET]	= AUDIT_NFT_OP_SET_REGISTER,
+	[NFT_MSG_GETSET]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELSET]	= AUDIT_NFT_OP_SET_UNREGISTER,
+	[NFT_MSG_NEWSETELEM]	= AUDIT_NFT_OP_SETELEM_REGISTER,
+	[NFT_MSG_GETSETELEM]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELSETELEM]	= AUDIT_NFT_OP_SETELEM_UNREGISTER,
+	[NFT_MSG_NEWGEN]	= AUDIT_NFT_OP_GEN_REGISTER,
+	[NFT_MSG_GETGEN]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_TRACE]		= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_NEWOBJ]	= AUDIT_NFT_OP_OBJ_REGISTER,
+	[NFT_MSG_GETOBJ]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELOBJ]	= AUDIT_NFT_OP_OBJ_UNREGISTER,
+	[NFT_MSG_GETOBJ_RESET]	= AUDIT_NFT_OP_OBJ_RESET,
+	[NFT_MSG_NEWFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_REGISTER,
+	[NFT_MSG_GETFLOWTABLE]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+};
+
 extern int is_audit_feature_set(int which);
 
 extern int __init audit_register_class(int class, unsigned *list);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c1eb5cdb3033..42ba44890523 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -66,6 +66,13 @@ static const struct rhashtable_params nft_objname_ht_params = {
 	.automatic_shrinking	= true,
 };
 
+struct nft_audit_data {
+	struct nft_table *table;
+	int entries;
+	int op;
+	struct list_head list;
+};
+
 static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 {
 	switch (net->nft.validate_state) {
@@ -717,17 +724,6 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
-			      ctx->table->name, ctx->table->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			ctx->table->use,
-			event == NFT_MSG_NEWTABLE ?
-				AUDIT_NFT_OP_TABLE_REGISTER :
-				AUDIT_NFT_OP_TABLE_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -1491,18 +1487,6 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      ctx->chain->name, ctx->chain->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			ctx->chain->use,
-			event == NFT_MSG_NEWCHAIN ?
-				AUDIT_NFT_OP_CHAIN_REGISTER :
-				AUDIT_NFT_OP_CHAIN_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -2855,18 +2839,6 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      ctx->chain->name, ctx->chain->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			rule->handle,
-			event == NFT_MSG_NEWRULE ?
-				AUDIT_NFT_OP_RULE_REGISTER :
-				AUDIT_NFT_OP_RULE_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -3901,18 +3873,6 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 	struct sk_buff *skb;
 	u32 portid = ctx->portid;
 	int err;
-	char *buf = kasprintf(gfp_flags, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      set->name, set->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			set->field_count,
-			event == NFT_MSG_NEWSET ?
-				AUDIT_NFT_OP_SET_REGISTER :
-				AUDIT_NFT_OP_SET_UNREGISTER,
-			gfp_flags);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -5097,18 +5057,6 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	u32 portid = ctx->portid;
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      set->name, set->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			set->handle,
-			event == NFT_MSG_NEWSETELEM ?
-				AUDIT_NFT_OP_SETELEM_REGISTER :
-				AUDIT_NFT_OP_SETELEM_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
@@ -6310,12 +6258,11 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 			    filter->type != NFT_OBJECT_UNSPEC &&
 			    obj->ops->type->type != filter->type)
 				goto cont;
-
 			if (reset) {
 				char *buf = kasprintf(GFP_ATOMIC,
-						      "%s:%llu;?:0",
+						      "%s:%u",
 						      table->name,
-						      table->handle);
+						      net->nft.base_seq);
 
 				audit_log_nfcfg(buf,
 						family,
@@ -6436,8 +6383,8 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 		reset = true;
 
 	if (reset) {
-		char *buf = kasprintf(GFP_ATOMIC, "%s:%llu;?:0",
-				      table->name, table->handle);
+		char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
+				      table->name, net->nft.base_seq);
 
 		audit_log_nfcfg(buf,
 				family,
@@ -6525,15 +6472,15 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(gfp, "%s:%llu;?:0",
-			      table->name, table->handle);
+	char *buf = kasprintf(gfp, "%s:%u",
+			      table->name, net->nft.base_seq);
 
 	audit_log_nfcfg(buf,
 			family,
 			obj->handle,
 			event == NFT_MSG_NEWOBJ ?
-				AUDIT_NFT_OP_OBJ_REGISTER :
-				AUDIT_NFT_OP_OBJ_UNREGISTER,
+				 AUDIT_NFT_OP_OBJ_REGISTER :
+				 AUDIT_NFT_OP_OBJ_UNREGISTER,
 			gfp);
 	kfree(buf);
 
@@ -7333,18 +7280,6 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      flowtable->table->name, flowtable->table->handle,
-			      flowtable->name, flowtable->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			flowtable->hooknum,
-			event == NFT_MSG_NEWFLOWTABLE ?
-				AUDIT_NFT_OP_FLOWTABLE_REGISTER :
-				AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -7465,9 +7400,6 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	int err;
 
-	audit_log_nfcfg("?:0;?:0", 0, net->nft.base_seq,
-			AUDIT_NFT_OP_GEN_REGISTER, GFP_KERNEL);
-
 	if (!nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
@@ -8006,12 +7938,47 @@ static void nft_commit_notify(struct net *net, u32 portid)
 	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
 }
 
+void nf_tables_commit_audit_collect(struct list_head *adl,
+				    struct nft_trans *trans) {
+	struct nft_audit_data *adp;
+
+	list_for_each_entry(adp, adl, list) {
+		if (adp->table == trans->ctx.table)
+			goto found;
+	}
+	adp = kzalloc(sizeof(*adp), GFP_KERNEL);
+	adp->table = trans->ctx.table;
+	INIT_LIST_HEAD(&adp->list);
+	list_add(&adp->list, adl);
+found:
+	adp->entries++;
+	if (!adp->op || adp->op > trans->msg_type)
+		adp->op = trans->msg_type;
+}
+
+#define AUNFTABLENAMELEN (NFT_TABLE_MAXNAMELEN + 22)
+
+void nf_tables_commit_audit_log(struct list_head *adl, u32 generation) {
+	struct nft_audit_data *adp, *adn;
+	char aubuf[AUNFTABLENAMELEN];
+
+	list_for_each_entry_safe(adp, adn, adl, list) {
+		snprintf(aubuf, AUNFTABLENAMELEN, "%s:%u", adp->table->name,
+			 generation);
+		audit_log_nfcfg(aubuf, adp->table->family, adp->entries,
+				nft2audit_op[adp->op], GFP_KERNEL);
+		list_del(&adp->list);
+		kfree(adp);
+	}
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	LIST_HEAD(adl);
 	int err;
 
 	if (list_empty(&net->nft.commit_list)) {
@@ -8206,12 +8173,15 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		}
+		nf_tables_commit_audit_collect(&adl, trans);
 	}
 
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_release(net);
 
+	nf_tables_commit_audit_log(&adl, net->nft.base_seq);
+
 	return 0;
 }
 
-- 
2.27.0

