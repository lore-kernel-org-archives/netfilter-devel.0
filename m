Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E63C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Mar 2022 13:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiCWNYM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244259AbiCWNYL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 09:24:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90179403E1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2022 06:22:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nX0wi-00014o-3W; Wed, 23 Mar 2022 14:22:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 05/16] netfilter: conntrack: split inner loop of list dumping to own function
Date:   Wed, 23 Mar 2022 14:22:03 +0100
Message-Id: <20220323132214.6700-6-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323132214.6700-1-fw@strlen.de>
References: <20220323132214.6700-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows code re-use in the followup patch.
No functional changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 68 ++++++++++++++++++----------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4a460565f275..5f3d211a41e3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1708,6 +1708,47 @@ static int ctnetlink_done_list(struct netlink_callback *cb)
 	return 0;
 }
 
+static int ctnetlink_dump_one_entry(struct sk_buff *skb,
+				    struct netlink_callback *cb,
+				    struct nf_conn *ct,
+				    bool dying)
+{
+	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	u8 l3proto = nfmsg->nfgen_family;
+	int res;
+
+	if (l3proto && nf_ct_l3num(ct) != l3proto)
+		return 0;
+
+	if (ctx->last) {
+		if (ct != ctx->last)
+			return 0;
+
+		ctx->last = NULL;
+	}
+
+	/* We can't dump extension info for the unconfirmed
+	 * list because unconfirmed conntracks can have
+	 * ct->ext reallocated (and thus freed).
+	 *
+	 * In the dying list case ct->ext can't be free'd
+	 * until after we drop pcpu->lock.
+	 */
+	res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq,
+				  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
+				  ct, dying, 0);
+	if (res < 0) {
+		if (!refcount_inc_not_zero(&ct->ct_general.use))
+			return 0;
+
+		ctx->last = ct;
+	}
+
+	return res;
+}
+
 static int
 ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
 {
@@ -1715,12 +1756,9 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	u_int8_t l3proto = nfmsg->nfgen_family;
-	int res;
-	int cpu;
 	struct hlist_nulls_head *list;
 	struct net *net = sock_net(skb->sk);
+	int res, cpu;
 
 	if (ctx->done)
 		return 0;
@@ -1739,30 +1777,10 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 restart:
 		hlist_nulls_for_each_entry(h, n, list, hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (l3proto && nf_ct_l3num(ct) != l3proto)
-				continue;
-			if (ctx->last) {
-				if (ct != last)
-					continue;
-				ctx->last = NULL;
-			}
 
-			/* We can't dump extension info for the unconfirmed
-			 * list because unconfirmed conntracks can have
-			 * ct->ext reallocated (and thus freed).
-			 *
-			 * In the dying list case ct->ext can't be free'd
-			 * until after we drop pcpu->lock.
-			 */
-			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
-						  cb->nlh->nlmsg_seq,
-						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct, dying, 0);
+			res = ctnetlink_dump_one_entry(skb, cb, ct, dying);
 			if (res < 0) {
-				if (!refcount_inc_not_zero(&ct->ct_general.use))
-					continue;
 				ctx->cpu = cpu;
-				ctx->last = ct;
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
 			}
-- 
2.34.1

