Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989FACE7A8A
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjIWByE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjIWByD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:54:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ABE1A7;
        Fri, 22 Sep 2023 18:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EaKFmFHbm5xmI3F54ocKFF5jRBegT8cI9v52BYDBThw=; b=KYR+ZBpOE0Ay8Y8FsYphhjZQCk
        CWgHj35hi/IPuYaE7J4UeU8AcjtavUBSyCIN1VuM6/Ev8eYCyVTMCT6Vi9rCl5M1gNN77ZcCLGa/I
        72YKQAHhXtoOaIYsXzPVsHdAk/XxG/QIaCoF9wA8fc4qblOpLAA45yLaDxg7g/P0W5bORxVUuqPlR
        Ow++CusDHshla1OsLAHH8x71KUA7yTyrkcgfsW6NlT2EO4qq7c2jry6vQ+PXz0GIlvK+VREFN8KLh
        8A+uuYFmwUjKlGh4DLP3k8rO/IcyCXcw8TEZNZ89/LNnwLaeBqaEkursuEOtMHY5hsujIc9UhCU0k
        924OrSxA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrqF-00028m-L1; Sat, 23 Sep 2023 03:53:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [nf PATCH 2/3] netfilter: nf_tables: Deduplicate nft_register_obj audit logs
Date:   Sat, 23 Sep 2023 03:53:50 +0200
Message-ID: <20230923015351.15707-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923015351.15707-1-phil@nwl.cc>
References: <20230923015351.15707-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When adding/updating an object, the transaction handler emits suitable
audit log entries already, the one in nft_obj_notify() is redundant. To
fix that (and retain the audit logging from objects' 'update' callback),
Introduce an "audit log free" variant for internal use.

Fixes: c520292f29b80 ("audit: log nftables configuration change events once per table")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c                 | 44 ++++++++++++-------
 .../testing/selftests/netfilter/nft_audit.sh  | 20 +++++++++
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e5d9bdba82b8..48d50df950a18 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8046,24 +8046,14 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -8086,13 +8076,35 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
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
index 0b3255e7b3538..bb34329e02a7f 100755
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

