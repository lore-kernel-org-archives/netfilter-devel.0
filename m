Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0CBC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 00:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiCAAWL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 19:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiCAAWK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 19:22:10 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0EF245A1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 16:21:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nOqGa-0005Zc-J7; Tue, 01 Mar 2022 01:21:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Joe Stringer <joe@cilium.io>
Subject: [PATCH v2 nf 2/2] netfilter: nf_queue: handle socket prefetch
Date:   Tue,  1 Mar 2022 01:21:08 +0100
Message-Id: <20220301002108.28338-3-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301002108.28338-1-fw@strlen.de>
References: <20220301002108.28338-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In case someone combines bpf socket assign and nf_queue, then we will
queue an skb who references a struct sock that did not have its
reference count incremented.

As we leave rcu protection, there is no guarantee that skb->sk is still
valid.

For refcount-less skb->sk case, try to increment the reference count
and then override the destructor.

In case of failure we have two choices: orphan the skb and 'delete'
preselect or let nf_queue() drop the packet.

Do the latter, it should not happen during normal operation.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Acked-by: Joe Stringer <joe@cilium.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_queue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index e39549c55945..63d1516816b1 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -180,6 +180,18 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		break;
 	}
 
+	if (skb_sk_is_prefetched(skb)) {
+		struct sock *sk = skb->sk;
+
+		if (!sk_is_refcounted(sk)) {
+			if (!refcount_inc_not_zero(&sk->sk_refcnt))
+				return -ENOTCONN;
+
+			/* drop refcount on skb_orphan */
+			skb->destructor = sock_edemux;
+		}
+	}
+
 	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
-- 
2.34.1

