Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E2BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 13:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiCCNzf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 08:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiCCNze (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 08:55:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFBD18BA72
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 05:54:49 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nPlup-0001Vy-OC; Thu, 03 Mar 2022 14:54:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC v3 nf-next 05/15] netfilter: conntrack: split inner loop of list dumping to own function
Date:   Thu,  3 Mar 2022 14:54:09 +0100
Message-Id: <20220303135419.10837-6-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220303135419.10837-1-fw@strlen.de>
References: <20220303135419.10837-1-fw@strlen.de>
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

