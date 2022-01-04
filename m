Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72FDC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jan 2022 19:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiADT5b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jan 2022 14:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiADT5b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jan 2022 14:57:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5344C061761;
        Tue,  4 Jan 2022 11:57:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n4pw0-0006TJ-9v; Tue, 04 Jan 2022 20:57:28 +0100
Date:   Tue, 4 Jan 2022 20:57:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     etkaar <lists.netfilter.org@prvy.eu>
Cc:     netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        sbrivio@redhat.com
Subject: Re: nftables >= 0.9.8: atomic update (nft -f ...) of a set not
 possible any more
Message-ID: <20220104195728.GB938@breakpoint.cc>
References: <5tg3b13w5.PCaY2G@prvy.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5tg3b13w5.PCaY2G@prvy.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

etkaar <lists.netfilter.org@prvy.eu> wrote:

[ CC Stefano ]

> Dear colleagues,
> 
> given is following perfectly working ruleset (nft list ruleset), which drops almost all of the IPv4 traffic, but grants access to port 22 (SSH) for two IPv4 addresses provided by the set named 'whitelist_ipv4_tcp':

Thanks for reporting, I can reproduce this.

> +++
> table inet filter {
> 	set whitelist_ipv4_tcp {
> 		type inet_service . ipv4_addr
> 		flags interval
> 		elements = { 22 . 111.222.333.444,
> 			     22 . 555.666.777.888 }
> 	}

I can repro this, looks like missing scratchpad cloning in the set
backend.

I can see that after second 'nft -f', avx2_lookup takes the 'if (unlikely(!scratch)) {' branch.

Can you try this (kernel) patch below?

As a workaround, you could try removing the 'interval' flag so that
kernel uses a hash table as set backend instead.

Stefano, does that patch make sense to you?
Thanks!

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1271,7 +1271,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 {
 	struct nft_pipapo_field *dst, *src;
 	struct nft_pipapo_match *new;
-	int i;
+	int i, err;
 
 	new = kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
 		      GFP_KERNEL);
@@ -1291,6 +1291,14 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		goto out_scratch;
 #endif
 
+	err = pipapo_realloc_scratch(new, old->bsize_max);
+	if (err) {
+#ifdef NFT_PIPAPO_ALIGN
+		free_percpu(new->scratch_aligned);
+#endif
+		goto out_scratch;
+	}
+
 	rcu_head_init(&new->rcu);
 
 	src = old->f;
