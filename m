Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE5BC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4781B611C0
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 22:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhEEWmX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 18:42:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45966 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhEEWmW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 18:42:22 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 325EF6412C;
        Thu,  6 May 2021 00:40:40 +0200 (CEST)
Date:   Thu, 6 May 2021 00:41:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pallavi Prabhu <rpallaviprabhu@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: netfilter.c: fix missing line after declaration
Message-ID: <20210505224121.GA23510@salvia>
References: <20210505192007.GA12080@pallavi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210505192007.GA12080@pallavi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pallavi,

On Thu, May 06, 2021 at 12:50:07AM +0530, Pallavi Prabhu wrote:
> Fixed a missing line after a declaration for proper coding style.

I'd probably suggest to use Coccinelle or similar to make a Netfilter
tree wide patch to add line after a declaration.

Probably there are more spots in the Netfilter codebase that can
benefit from this cleanup.

> Signed-off-by: Pallavi Prabhu <rpallaviprabhu@gmail.com>
> ---
>  net/ipv6/netfilter.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index ab9a279dd6d4..7b1671f48593 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c
> @@ -81,6 +81,7 @@ static int nf_ip6_reroute(struct sk_buff *skb,
>  
>  	if (entry->state.hook == NF_INET_LOCAL_OUT) {
>  		const struct ipv6hdr *iph = ipv6_hdr(skb);
> +
>  		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
>  		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
>  		    skb->mark != rt_info->mark)
> -- 
> 2.25.1
> 
