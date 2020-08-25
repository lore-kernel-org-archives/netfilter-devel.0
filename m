Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71B8C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 898F42075F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHYWxZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHYWxZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:53:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BF2C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:53:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAhoe-000664-7v; Wed, 26 Aug 2020 00:53:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: conntrack: remove unneeded nf_ct_put
Date:   Wed, 26 Aug 2020 00:52:45 +0200
Message-Id: <20200825225245.8072-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825225245.8072-1-fw@strlen.de>
References: <20200825225245.8072-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We can delay refcount increment until we reassign the existing entry to
the current skb.

A 0 refcount can't happen while the nf_conn object is still in the
hash table and parallel mutations are impossible because we hold the
bucket lock.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 93e77ca0efad..234b7cab37c3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -908,6 +908,7 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 		tstamp->start = ktime_get_real_ns();
 }
 
+/* caller must hold locks to prevent concurrent changes */
 static int __nf_ct_resolve_clash(struct sk_buff *skb,
 				 struct nf_conntrack_tuple_hash *h)
 {
@@ -921,13 +922,12 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 	if (nf_ct_is_dying(ct))
 		return NF_DROP;
 
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
-		return NF_DROP;
-
 	if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
 	    nf_ct_match(ct, loser_ct)) {
 		struct net *net = nf_ct_net(ct);
 
+		nf_conntrack_get(&ct->ct_general);
+
 		nf_ct_acct_merge(ct, ctinfo, loser_ct);
 		nf_ct_add_to_dying_list(loser_ct);
 		nf_conntrack_put(&loser_ct->ct_general);
@@ -937,7 +937,6 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
-	nf_ct_put(ct);
 	return NF_DROP;
 }
 
-- 
2.26.2

