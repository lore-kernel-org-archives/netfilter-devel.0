Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF90C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFFA72075F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgHYWxI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHYWxF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:53:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896D5C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:53:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAhoK-00065P-4u; Wed, 26 Aug 2020 00:53:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/4] netfilter: conntrack: do not increment two error counters at same time
Date:   Wed, 26 Aug 2020 00:52:42 +0200
Message-Id: <20200825225245.8072-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825225245.8072-1-fw@strlen.de>
References: <20200825225245.8072-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The /proc interface for nf_conntrack displays the "error" counter as
"icmp_error".

It makes sense to not increment "invalid" when failing to handle an icmp
packet since those are special.

For example, its possible for conntrack to see partial and/or fragmented
packets inside icmp errors.  This should be a separate event and not get
mixed with the "invalid" counter.

Likewise, remove the "error" increment for errors from get_l4proto().
After this, the error counter will only increment for errors coming from
icmp(v6) packet handling.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5b97d233f89b..3cfbafdff941 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1725,10 +1725,8 @@ nf_conntrack_handle_icmp(struct nf_conn *tmpl,
 	else
 		return NF_ACCEPT;
 
-	if (ret <= 0) {
+	if (ret <= 0)
 		NF_CT_STAT_INC_ATOMIC(state->net, error);
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-	}
 
 	return ret;
 }
@@ -1813,7 +1811,6 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
 	if (dataoff <= 0) {
 		pr_debug("not prepared to track yet or error occurred\n");
-		NF_CT_STAT_INC_ATOMIC(state->net, error);
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		ret = NF_ACCEPT;
 		goto out;
-- 
2.26.2

