Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6714C282E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 09:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A861A213A2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 09:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfDVJfN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 05:35:13 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50622 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbfDVJfN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 05:35:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hIVLq-0008UF-HP; Mon, 22 Apr 2019 11:35:02 +0200
Date:   Mon, 22 Apr 2019 11:35:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Rundong Ge <rdong.ge@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@blackhole.kfki.hu,
        fw@strlen.de, Roopa Prabhu <roopa@cumulusnetworks.com>,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: fix dangling pointer access of fake_rtable
Message-ID: <20190422093502.36da6z3qf7zxpwny@breakpoint.cc>
References: <20190409065612.32652-1-rdong.ge@gmail.com>
 <20190422083339.ptkxqb66pombgy5g@salvia>
 <CAN1Lvyo1CVopsB7iV=e-dAN9JDFg-SmQ8g6H6RrgD7qACAd4hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1Lvyo1CVopsB7iV=e-dAN9JDFg-SmQ8g6H6RrgD7qACAd4hQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rundong Ge <rdong.ge@gmail.com> wrote:
> br_nf_pre_routing will call the NF_INET_PRE_ROUTING hooks, at this
> time both entry->state.in and entry->state.out are not bridge device.
> 
> NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> skb->dev, NULL,
> br_nf_pre_routing_finish);

skb->dev is munged in setup_prerouting() to be bridge or vlan device on
top of bridge.

That being said, I think we need this fix at least:

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -197,8 +197,15 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
+	if (skb_dst(skb)) {
+		skb_dst_force(skb);
+		if (!skb_dst(skb)) {
+			status = -EHOSTUNREACH;
+			goto err;
+		}
+	}
+
 	nf_queue_entry_get_refs(entry);
-	skb_dst_force(skb);
 
 	switch (entry->state.pf) {
 	case AF_INET:


Then, why not add, in dev_cmp:

	dst = skb_dst(skb);
	if (dst && dst->dev->index == index ...

?
