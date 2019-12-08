Return-Path: <SRS0=ZPzN=Z6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95181C2D0BF
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Dec 2019 23:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 747A5206DB
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Dec 2019 23:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfLHXcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Dec 2019 18:32:06 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36832 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbfLHXcF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Dec 2019 18:32:05 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ie61r-0004Ux-1X; Mon, 09 Dec 2019 00:31:55 +0100
Date:   Mon, 9 Dec 2019 00:31:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH netfilter] netfilter: bridge: make sure to pull arp
 header in br_nf_forward_arp()
Message-ID: <20191208233155.GH795@breakpoint.cc>
References: <20191207224339.91704-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207224339.91704-1-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> syzbot is kind enough to remind us we need to call skb_may_pull()

[..]

> Fixes: c4e70a87d975 ("netfilter: bridge: rename br_netfilter.c to br_netfilter_hooks.c")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
> 
> Note: Fixes: tag does not point to real bug origin, but is old enough
>      to cover all stable versions.

Indeed, looks like a day0 bug.  We don't have this problem for ipv4/6
because the prerouting hook does pskb_may_pull() as part of ipv4/6
header checks.  Arp doesn't have anything like it.

>  		nf_bridge_pull_encap_header(skb);
>  	}
>  
> +	if (unlikely(!pskb_may_pull(skb, sizeof(struct arphdr))))
> +		return NF_DROP;
> +
>  	if (arp_hdr(skb)->ar_pln != 4) {

Thats indeed the only location where we call NFPROTO_ARP hooks,
so this looks like the proper fix/location.

Thanks Eric!

Reviewed-by: Florian Westphal <fw@strlen.de>
