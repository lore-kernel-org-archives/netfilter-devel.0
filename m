Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79C2C432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 08:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABFFD61077
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 08:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhG2IIj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 04:08:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40712 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbhG2IIj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 04:08:39 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50C916411D;
        Thu, 29 Jul 2021 10:08:03 +0200 (CEST)
Date:   Thu, 29 Jul 2021 10:08:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nf_conntrack_bridge: Fix memory leak when
 error
Message-ID: <20210729080829.GA16912@salvia>
References: <20210729074658.8538-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210729074658.8538-1-yajun.deng@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 29, 2021 at 03:46:58PM +0800, Yajun Deng wrote:
> It should be added kfree_skb_list() when err is not equal to zero
> in nf_br_ip_fragment().
> 
> v2: keep this aligned with IPv6.
> 
> Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 8d033a75a766..3cf5457919c6 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -88,6 +88,11 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
>  
>  			skb = ip_fraglist_next(&iter);
>  		}
> +
> +		if (!err)
> +			return 0;
> +
> +		kfree_skb_list(iter.frag_list);

Actually:
		kfree_skb_list(iter.frag);

I used frag_list instead of frag in my snippet.

>  		return err;
>  	}
>  slow_path:
> -- 
> 2.32.0
> 
