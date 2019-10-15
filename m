Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0593ECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 13:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B151721848
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 13:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbfJONPd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 09:15:33 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43592 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729551AbfJONPd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 09:15:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iKMfj-0003kv-KU; Tue, 15 Oct 2019 15:15:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 1/2] netfilter: ctnetlink: don't dump ct extensions of unconfirmed conntracks
Date:   Tue, 15 Oct 2019 15:19:14 +0200
Message-Id: <20191015131915.28385-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191015131915.28385-1-fw@strlen.de>
References: <20191015131915.28385-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When dumping the unconfirmed lists, the cpu that is processing the ct
entry can reallocate ct->ext at any time.

Right now accessing the extensions from another CPU is ok provided
we're holding rcu read lock: extension reallocation does use rcu.

Once RCU isn't used anymore this becomes unsafe, so skip extensions for
the unconfirmed list.

Dumping the extension area for confirmed or dying conntracks is fine:
no reallocations are allowed and list iteration holds appropriate
locks that prevent ct (and this ct->ext) from getting free'd.

v2: fix compiler warnings due to misue of 'const' and missing return
    statement (kbuild robot).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 76 ++++++++++++++++++----------
 1 file changed, 50 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e2d13cd18875..d8d33ef52ce0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -506,9 +506,45 @@ static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 
+/* all these functions access ct->ext. Caller must either hold a reference
+ * on ct or prevent its deletion by holding either the bucket spinlock or
+ * pcpu dying list lock.
+ */
+static int ctnetlink_dump_extinfo(struct sk_buff *skb,
+				  struct nf_conn *ct, u32 type)
+{
+	if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
+	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
+	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
+	    ctnetlink_dump_labels(skb, ct) < 0 ||
+	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
+	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
+{
+	if (ctnetlink_dump_status(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_secctx(skb, ct) < 0 ||
+	    ctnetlink_dump_id(skb, ct) < 0 ||
+	    ctnetlink_dump_use(skb, ct) < 0 ||
+	    ctnetlink_dump_master(skb, ct) < 0)
+		return -1;
+
+	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
+	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
+	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+		return -1;
+
+	return 0;
+}
+
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
-		    struct nf_conn *ct)
+		    struct nf_conn *ct, bool extinfo)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlmsghdr *nlh;
@@ -552,23 +588,9 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 				   NF_CT_DEFAULT_ZONE_DIR) < 0)
 		goto nla_put_failure;
 
-	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_acct(skb, ct, type) < 0 ||
-	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
-	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
-	    ctnetlink_dump_secctx(skb, ct) < 0 ||
-	    ctnetlink_dump_labels(skb, ct) < 0 ||
-	    ctnetlink_dump_id(skb, ct) < 0 ||
-	    ctnetlink_dump_use(skb, ct) < 0 ||
-	    ctnetlink_dump_master(skb, ct) < 0 ||
-	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
-	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
+	if (ctnetlink_dump_info(skb, ct) < 0)
 		goto nla_put_failure;
-
-	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
-	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
-	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+	if (extinfo && ctnetlink_dump_extinfo(skb, ct, type) < 0)
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -953,13 +975,11 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (!ctnetlink_filter_match(ct, cb->data))
 				continue;
 
-			rcu_read_lock();
 			res =
 			ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-					    ct);
-			rcu_read_unlock();
+					    ct, true);
 			if (res < 0) {
 				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
@@ -1364,10 +1384,8 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 		return -ENOMEM;
 	}
 
-	rcu_read_lock();
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct);
-	rcu_read_unlock();
+				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true);
 	nf_ct_put(ct);
 	if (err <= 0)
 		goto free;
@@ -1429,12 +1447,18 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 					continue;
 				cb->args[1] = 0;
 			}
-			rcu_read_lock();
+
+			/* We can't dump extension info for the unconfirmed
+			 * list because unconfirmed conntracks can have
+			 * ct->ext reallocated (and thus freed).
+			 *
+			 * In the dying list case ct->ext can't be free'd
+			 * until after we drop pcpu->lock.
+			 */
 			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq,
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct);
-			rcu_read_unlock();
+						  ct, dying ? true : false);
 			if (res < 0) {
 				if (!atomic_inc_not_zero(&ct->ct_general.use))
 					continue;
-- 
2.21.0

