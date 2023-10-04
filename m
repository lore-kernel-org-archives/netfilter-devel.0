Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325E2E7B61B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 14:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbjJDOOi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 10:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242860AbjJDOOh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 10:14:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A20DC9;
        Wed,  4 Oct 2023 07:14:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qo2dx-0002Mw-Jg; Wed, 04 Oct 2023 16:14:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH net 5/6] netfilter: nf_tables: Deduplicate nft_register_obj audit logs
Date:   Wed,  4 Oct 2023 16:13:49 +0200
Message-ID: <20231004141405.28749-6-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231004141405.28749-1-fw@strlen.de>
References: <20231004141405.28749-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

When adding/updating an object, the transaction handler emits suitable
audit log entries already, the one in nft_obj_notify() is redundant. To
fix that (and retain the audit logging from objects' 'update' callback),
Introduce an "audit log free" variant for internal use.

Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com> (Audit)
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c                 | 44 ++++++++++++-------
 .../testing/selftests/netfilter/nft_audit.sh  | 20 +++++++++
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4356189360fb..a72b6aeefb1b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7871,24 +7871,14 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 	return nft_delobj(&ctx, obj);
 }
 
-void nft_obj_notify(struct net *net, const struct nft_table *table,
-		    struct nft_object *obj, u32 portid, u32 seq, int event,
-		    u16 flags, int family, int report, gfp_t gfp)
+static void
+__nft_obj_notify(struct net *net, const struct nft_table *table,
+		 struct nft_object *obj, u32 portid, u32 seq, int event,
+		 u16 flags, int family, int report, gfp_t gfp)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(gfp, "%s:%u",
-			      table->name, nft_net->base_seq);
-
-	audit_log_nfcfg(buf,
-			family,
-			obj->handle,
-			event == NFT_MSG_NEWOBJ ?
-				 AUDIT_NFT_OP_OBJ_REGISTER :
-				 AUDIT_NFT_OP_OBJ_UNREGISTER,
-			gfp);
-	kfree(buf);
 
 	if (!report &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
@@ -7911,13 +7901,35 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
+
+void nft_obj_notify(struct net *net, const struct nft_table *table,
+		    struct nft_object *obj, u32 portid, u32 seq, int event,
+		    u16 flags, int family, int report, gfp_t gfp)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	char *buf = kasprintf(gfp, "%s:%u",
+			      table->name, nft_net->base_seq);
+
+	audit_log_nfcfg(buf,
+			family,
+			obj->handle,
+			event == NFT_MSG_NEWOBJ ?
+				 AUDIT_NFT_OP_OBJ_REGISTER :
+				 AUDIT_NFT_OP_OBJ_UNREGISTER,
+			gfp);
+	kfree(buf);
+
+	__nft_obj_notify(net, table, obj, portid, seq, event,
+			 flags, family, report, gfp);
+}
 EXPORT_SYMBOL_GPL(nft_obj_notify);
 
 static void nf_tables_obj_notify(const struct nft_ctx *ctx,
 				 struct nft_object *obj, int event)
 {
-	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
-		       ctx->flags, ctx->family, ctx->report, GFP_KERNEL);
+	__nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
+			 ctx->seq, event, ctx->flags, ctx->family,
+			 ctx->report, GFP_KERNEL);
 }
 
 /*
diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index 0b3255e7b353..bb34329e02a7 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -85,6 +85,26 @@ do_test "nft add set t1 s2 $setblock; add set t1 s3 { $settype; }" \
 do_test "nft add element t1 s3 $setelem" \
 "table=t1 family=2 entries=3 op=nft_register_setelem"
 
+# adding counters
+
+do_test 'nft add counter t1 c1' \
+'table=t1 family=2 entries=1 op=nft_register_obj'
+
+do_test 'nft add counter t2 c1; add counter t2 c2' \
+'table=t2 family=2 entries=2 op=nft_register_obj'
+
+# adding/updating quotas
+
+do_test 'nft add quota t1 q1 { 10 bytes }' \
+'table=t1 family=2 entries=1 op=nft_register_obj'
+
+do_test 'nft add quota t2 q1 { 10 bytes }; add quota t2 q2 { 10 bytes }' \
+'table=t2 family=2 entries=2 op=nft_register_obj'
+
+# changing the quota value triggers obj update path
+do_test 'nft add quota t1 q1 { 20 bytes }' \
+'table=t1 family=2 entries=1 op=nft_register_obj'
+
 # resetting rules
 
 do_test 'nft reset rules t1 c2' \
-- 
2.41.0

